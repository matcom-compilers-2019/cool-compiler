class virtual_table:
    def __init__(self):     
        self.clases = {}        
        self.methods = {}
        self.attr = {}
        
    def add_method(self, A, B, args):
        if not A in self.methods:
            self.methods[A] = [ (B + '.' + x) for x in args]
            return

        meths = self.methods[A]
        new_meths = meths.copy()
        for a in args:
            flag = True
            for i in range(len(meths)):
                m = meths[i]
                mm = m[m.find('.') + 1:]
                if mm == a:
                    new_meths[i] = (B + '.' + a)
                    flag = False
                    break
            if flag:
                new_meths.append(B + '.' + a)            
        self.methods[A] = new_meths  
    
    def add_attr(self, c, args):
        if not c in self.attr:
            self.attr[c] = []
        for a in args:
            self.attr[c].append(a)
    
    def get_size(self, c):
        return len(self.attr[c]) + 1

    def get_method_id(self, c, m):
        meths = self.methods[c]
        for i in range(len(meths)):
            mm = meths[i]
            mmm = mm[mm.find('.') + 1:]
            if mmm == m:
                return i + 1

    def get_attrs(self, c):
        return self.attr[c]

    def get_attr_id(self, c, a):
        attrs = self.attr[c]
        for i in range(len(attrs)):
            aa = attrs[i]
            if aa == a:
                return i + 1


class Variables:
    def __init__(self):
        self.variables = {}
        self.vars = []
        
    def add_var(self, name):
        self.variables[name] = len(self.variables) + 1 
        self.vars.append(name)
        return name

    def id(self, name):
        return len(self.variables) - self.variables[name] + 1

    def pop_var(self):
        self.variables.pop(self.vars[-1])
        self.vars.pop()

    def add_temp(self):
        name = len(self.variables) + 1
        self.add_var(str(name))
        return str(name)

    def peek_last(self):
        return self.vars[-1]
    
    def get_stack(self):
        stack = '|'
        for k in self.variables:
            stack += str(self.id(k)) + '-' + k + '|'
        return stack

    def get_copy(self):
        inst = Variables()
        inst.variables = self.variables.copy()
        inst.vars = self.vars.copy()
        return inst