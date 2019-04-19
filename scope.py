
class Scope:
    def __init__(self, parent=None):
        self.locals = {}
        self.types = []
        self.parent = parent
        self.children = []

    def add_type(self, type_name, features, parent = None):
        if not self.check_type(type_name) and (not parent or self.check_type(parent)):
            self.types.append((type_name, parent, features))
            return True
        return False
    
    def get_type(self, vname):
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
        curr = self
        while curr:
            t = curr.local_type(type_name)
            if t:
                return t
            curr = self.parent
        return False

    def define_variable(self, vname, vtype):
        if self.check_type(vtype):
            self.locals[vname] = vtype
            return True
        return False

    def create_child_scope(self):
        child_scope = Scope(self)
        self.children.append(child_scope)
        return child_scope

    def is_defined(self, vname):
        current = self
        while current:
            if vname in [v for v in self.locals.keys()]:
                return True
            current = current.parent
        return False

    def is_local(self, vname):
        return vname in self.locals.keys()

    def is_local_feature(self, mname):
        return mname in [name for name in [method.name.value for method in [t[2] for t in self.types]]]
    
    def is_defined_in_type(self, t, mname):
        curr = self
        while curr:
            for _type in curr.types:
                if _type[0] == t and mname in [m.name.value for m in _type[2]]:
                    return True
            curr = curr.parent
        return False
    
    def get_local_method(self, mname):
        for t in self.types:
            for f in t[2]:
                if f.name.value == mname:
                    return f
        return False

    def get_method(self, tp, mname):
        curr = self
        while curr and not curr.is_local_feature(mname):
            curr = curr.parent
        if not curr:
            return False

        for t in curr.types:
            if tp != t:
                continue
            for f in t[2]:
                if f.name.value == mname:
                    return f
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
            

    def inherits(self, t1, t2):
        curr = self
        while curr and not curr.local_type(t1):
            curr = curr.parent
        if not curr:
            return False
        if t1 == t2:
            return True
        p = [t[1] for t in curr.types if t[0] == t1]
        if not p:
            return False
        return curr.inherits(p, t2)        
        


