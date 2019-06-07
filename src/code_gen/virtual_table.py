class virtual_table:
    def __init__(self):     
        self.clases = {}        
        self.methods = {}
        self.attr = {}

    def add_class(self, Class : str):
        methods = list(filter(lambda m : self.methods[m][0] == Class, self.methods.keys()))
        self.clases[name] = methods

    def add_method(self, Class : str, method : str) :
        attr = list( filter )


class Variables:
    def __init__(self):
        self.variables = {}
        
    def  add_var(self, name):
        self.variables[name] = len(self.variables) + 1
    
    def get_offset(self, name):
        return len(self.variables) - variables[name]

    def rm_var(self, name):
        self.variables.pop(name)

    def add_temp(self):
        name = len(self.variables) + 1
        self.add_var(str(name))
        return name 
    
    def pop_temp(self):
        name = len(self.variables)
        self.pop(name)

    def peek_last(self):
        return len(self.variables)
    