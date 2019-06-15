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
        return len(self.attr[c] + 1)

    def get_method_id(self, c, m):
        meths = self.methods[c]
        for i in range(meths):
            mm = meths[i]
            mmm = mm[mm.find('.') + 1:]
            if mmm == m:
                return i

    def get_attrs(self, c):
        return self.attr[c]

class Variables:
    def __init__(self):
        self.variables = {}
        
    def  add_var(self, name):
        self.variables[name] = len(self.variables) + 1 
        return str(len(self.variables))

    def id(self, name):
        return len(self.variables) - self.variables[name] + 1

    def pop_var(self):
        n = str(len(self.variables))
        if not self.variables.__contains__(n):
            for k in self.variables:
                if self.variables[k] == n:
                    n = k
                    break
        self.variables.pop(n)

    def add_temp(self):
        name = len(self.variables) + 1
        self.add_var(str(name))
        return str(len(self.variables))
    
    def pop_temp(self):
        name = len(self.variables)
        self.variables.pop(name)

    def peek_last(self):
        return len(self.variables)
    
    
