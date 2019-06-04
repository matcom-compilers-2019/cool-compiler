from parsing import cool_ast
from lark import Token

class Scope:
    def __init__(self, parent=None, inside=None):
        self.inside = inside
        self.locals = {}
        self.methods = []
        self.parent = parent
        self.children = []
        self.self_type = []
        self.types = [] 
        if not parent:
            self.basic_types()

    def basic_types(self):
        object_methods = [
            cool_ast.MethodNode(Token(None,'abort'), [], Token(None,'Object'), None),
            cool_ast.MethodNode(Token(None,'type_name',), [], Token(None,'String'), None),
            cool_ast.MethodNode(Token(None,'copy'), [], Token(None,'SELF_TYPE'), None)
        ]
        string_methods = [
            cool_ast.MethodNode(Token(None,'length'), [], Token(None,'Int'), None),
            cool_ast.MethodNode(Token(None,'concat'), [cool_ast.ParamNode(Token(None,'s'),Token(None,'String'))], Token(None,'String'), None),
            cool_ast.MethodNode(Token(None,'substr'), [cool_ast.ParamNode(Token(None,'i'),Token(None,'Int')), cool_ast.ParamNode(Token(None,'l'),Token(None,'Int'))], Token(None,'String'), None)
        ]
        io_methods = [
            cool_ast.MethodNode(Token(None,'out_string'),[cool_ast.ParamNode(Token(None,'x'),Token(None,'String'))],Token(None,'SELF_TYPE'),None),
            cool_ast.MethodNode(Token(None,'out_int'), [cool_ast.ParamNode(Token(None,'x'),Token(None,'Int'))], Token(None,'SELF_TYPE'),None),
            cool_ast.MethodNode(Token(None, 'in_string'), [], Token(None,'String'), None),
            cool_ast.MethodNode(Token(None, 'in_int',), [], Token(None,'Int'), None)
        ]
        self.types.append(('Object', None, object_methods,[]))
        self.types.append(('Int', 'Object', [],[]))
        self.types.append(('Void', 'Object', [],[]))
        self.types.append(('Bool', 'Object', [],[]))
        self.types.append(('String', 'Object', string_methods,[]))
        self.types.append(('IO', 'Object', io_methods,[]))

        self.create_child_scope(inside='Object')
        self.create_child_scope(inside='Int')
        self.create_child_scope(inside='Bool')
        self.create_child_scope(inside='String')
        self.create_child_scope(inside='IO')
        self.create_child_scope(inside='Void')

    def true_type(self, t):
        return t if t != 'SELF_TYPE' else self.inside

    def add_type(self, type_name, methods, attrs, parent = 'Object'):
        if not self.check_type(type_name):
            self.types.append((type_name, parent, [],[]))
            return True
        return False
    
    def define_method(self, type_name, method):
        curr = self.root()
        for tp in curr.types:
            if tp[0] == type_name and not curr.is_defined_in_class(type_name, method.name.value):
                prev_m = curr.look_for_method(type_name, method.name)
                if prev_m != False and not self.check_methods(prev_m.params, method.params, prev_m.return_type.value, method.return_type.value) :
                    return False
                tp[2].append(method)
                if method.return_type == 'SELF_TYPE':
                    self.self_type.append(method.name)
                return True
        return False

    def check_methods(self, params1, params2, rt1, rt2):
        if len(params1) != len(params2):
            return False
        if rt1 != rt2:
            return False
        for i in range(len(params1)):
            if params1[i].type.value != params2[i].type.value:
                return False
        return True

    def define_attr(self, type_name, attr):
        curr = self.root()
        for tp in curr.types:
            if tp[0] == type_name and not curr.look_for_attr(type_name, attr.name.value) and not self.is_defined(attr.name.value):
                tp[3].append(attr)
                return True
        return False

    def add_method(self, method):
        self.methods.append(method)
    
    def get_type(self, vname):
        if vname == 'self':
            return self.inside
        if not self.is_defined(vname):
            return False
        curr = self
        while curr != None:
            if curr.is_local(vname):
                return curr.locals[vname]
            curr = curr.parent
        return self.get_attr_type(self.inside, vname)
    
    def local_type(self, type_name):
        for t in self.types:
            if t[0] == type_name:
                return t
        return False

    def check_type(self, type_name):
        if type_name == 'SELF_TYPE':
            return self.inside
        curr = self
        while curr:
            t = curr.local_type(type_name)
            if t:
                return t
            curr = curr.parent
        return False

    def define_variable(self, vname, vtype):
        if self.is_defined(vname):
            return False
        if vtype == 'SELF_TYPE' or self.check_type(vtype):
            self.locals[vname] = vtype
            if vtype == 'SELF_TYPE':
                self.self_type.append(vname)
            return True
        return False
    
    def define_for_let(self, vname, vtype):
        self.locals[vname] = vtype
        return True
    
    def define_param(self, vname, vtype):
        if self.check_type(vtype):
            self.locals[vname] = vtype
            return True
        return False

    def create_child_scope(self, inside=None):
        child_scope = Scope(self, inside=self.inside) if not inside else Scope(self, inside)
        self.children.append(child_scope)
        return child_scope

    def is_defined(self, vname):
        if vname == 'self':
            return True
        current = self
        while current:
            if vname in [v for v in current.locals.keys()]:
                return True
            current = current.parent
        return self.search_attr(self.inside, vname)
    
    def search_attr(self, tp, aname):
        curr = self.root()
        aux = None
        for t in curr.types:
            if t[0] != tp:
                continue
            aux = t
            for attr in t[3]:
                if attr.name.value == aname:
                    return True
        return False if not aux or not aux[1] else self.search_attr(aux[1], aname)
    
    def get_attr_type(self, tp, aname):
        if not tp:
            return False
        curr = self
        parent = None
        while curr:
            for t in curr.types:
                if tp != t[0]:
                    continue
                parent = t[1]
                for attr in t[3]:
                    if attr.name.value == aname:
                        return attr.type.value
            curr = curr.parent
        return self.get_attr_type(parent, aname)

    def is_local(self, vname):
        return  vname in [v for v in self.locals.keys()]

    def is_local_feature(self, mname):
        return mname in [m.name.value for m in self.methods]
    
    def is_defined_in_type(self, t, mname):
        curr = self.root()
        for _type in curr.types:
            if _type[0] == t:
                for m in _type[2]:
                    if m.name.value == mname:
                        return m
                if _type[1]:
                    return curr.is_defined_in_type(_type[1], mname)        
        return False
    
    def is_defined_in_class(self, cls, mname):
        curr = self
        while curr:
            for _type in curr.types:
                if _type[0] == cls:
                    for m in _type[2]:
                        if m.name.value == mname:
                            return m
                    return False        
            curr = curr.parent
        return False
    
    def get_local_method(self, mname):
        for f in self.methods:
            if f.name.value == mname:
                return f
        return False

    def get_method_by_name(self, mname):
        curr = self
        while curr and not curr.get_local_method(mname):
            curr = curr.parent
        return False if not curr else curr.get_local_method(mname)

    def get_method(self, tp, mname):
        curr = self
        while curr and not curr.is_local_feature(mname):
            curr = curr.parent
        if not curr:
            return False

        
        return False

    def look_for_method(self, t, mname):
        currt = t
        curr = self

        while currt:
            tp = curr.check_type(currt)
            if not tp:
                return False
            for mn in tp[2]:
                if mn.name.value == mname:
                    return mn
            currt = tp[1]
        return False
            
    def look_for_attr(self, t, aname):
        currt = t
        curr = self

        while currt:
            tp = curr.check_type(currt)
            if not tp:
                return False
            for an in tp[3]:
                if an.name.value == aname:
                    return an
            currt = tp[1]
        return False
     
    def root(self):
        curr = self
        while curr.parent:
            curr = curr.parent
        return curr

    def inherits(self, t1, t2, level):
        
        curr = self.root()

        if not curr:
            return False, -1
        if t1 == t2:
            return True, level
        p = [t[1] for t in curr.types if t[0] == t1]
        if not p:
            return False, -1
        return curr.inherits(p[0], t2, level + 1)      

    def join(self, t1, t2):
        if t1 == 'SELF_TYPE':
            t1 = self.inside
        if t2 == 'SELF_TYPE':
            t2 = self.inside
        
        if self.inherits(t1,t2,0)[0]:
            return t2
        if self.inherits(t2, t1,0)[0]:
            return t1
        curr = self.root()
        p = [t[1] for t in curr.types if t[0] == t1][0]
        return self.join(p, t2)
                
    def get_scope_of_type(self, t):
        r = self.root()
        f = [s for s in r.children if s.inside == t]
        return f if f == [] else f[0]
