from parsing import cool_ast

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
        self.types.append(('Object', None, []))
        self.types.append(('Int', 'Object', []))
        self.types.append(('Void', 'Object', []))
        self.types.append(('Bool', 'Object', []))
        self.types.append(('String', 'Object', []))
        io_methods = [
            cool_ast.MethodNode('out_string',[cool_ast.ParamNode('x','String')],'SELF_TYPE',None),
            cool_ast.MethodNode('out_int', [cool_ast.ParamNode('x','Int')], 'SELF_TYPE',None),
            cool_ast.MethodNode('in_string', [], 'String', None),
            cool_ast.MethodNode('in_int', [], 'Int', None)
        ]
        self.types.append(('IO', 'Object', io_methods))

    def add_type(self, type_name, methods, parent = 'Object'):
        if not self.check_type(type_name) and self.check_type(parent):
            self.types.append((type_name, parent, []))
            for m in methods:
                if not self.define_method(type_name, m):
                    return False
            return True
        return False
    
    def define_method(self, type_name, method):
        curr = self.look_for_type(type_name)
        for tp in curr.types:
            if tp[0] == type_name and not curr.look_for_method(type_name, method.name) and not self.is_defined(method.name):
                tp[2].append(method)
                if method.return_type == 'SELF_TYPE':
                    self.self_type.append(method.name)
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
        return False
    
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
        if vtype == 'SELF_TYPE' or self.check_type(vtype):
            self.locals[vname] = vtype
            if vtype == 'SELF_TYPE':
                self.self_type.append(vname)
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
            if vname in [v for v in self.locals.keys()]:
                return True
            current = current.parent
        return False

    def is_local(self, vname):
        return vname in self.locals.keys()

    def is_local_feature(self, mname):
        return mname in [m.name.value for m in self.methods]
    
    def is_defined_in_type(self, t, mname):
        curr = self
        while curr:
            for _type in curr.types:
                if _type[0] == t:
                    for m in _type[2]:
                        if m.name.value == mname:
                            return m
                    if _type[1]:
                        return self.is_defined_in_type(_type[1], mname)        
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
            

    def look_for_type(self, t):
        curr = self
        while curr and not curr.local_type(t):
            curr = curr.parent
        return curr

    def inherits(self, t1, t2, level):
        
        curr = self.look_for_type(t1)

        if not curr:
            return False, -1
        if t1 == t2:
            return True, level
        p = [t[1] for t in curr.types if t[0] == t1]
        if not p:
            return False, -1
        return curr.inherits(p[0], t2, level + 1), level + 1        

    def join(self, t1, t2):
        
        if self.inherits(t1,t2,0)[0]:
            return t2
        if self.inherits(t2, t1,0)[0]:
            return t1
        curr = self.look_for_type(t1)
        p = [t[1] for t in curr.types if t[0] == t1][0]
        return self.join(p, t2)
                


