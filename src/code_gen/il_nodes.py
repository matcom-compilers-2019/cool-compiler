
class ILNode():
    pass

#Operations
class BinOp(ILNode):
    def __init__(self, var : int, leftop : int, rightop : int, symb : str):
        self.var = var
        self.leftop = leftop
        self.rightop = rightop
        self.symb = symb

    def __str__(self):
        return "{} = {} {} {}".format(self.var, self.leftop, self.symb, self.rightop)

class UnaryOp(ILNode):
    def __init__(self, var : int, op: int, symb : str):
        self.var = var
        self.op = op
        self.symb = symb

    def __str__(self):
        return "{} = {} {}".format(self.var, self.symb, self.op)

# Assigments
class AssigmentNode(ILNode):
    def __init__(self, left, right):
        self.left = left
        self.right = right

class VarToVar(AssigmentNode):
    def __init__(self, left, rigth):
        super().__init__(left, rigth)
    
    def __str__(self):
        return "{} = {}".format(self.left, self.right)

class MemoToVar(AssigmentNode):
    def __init__(self, left, right, offset):
        super().__init__(left, right)
        self.offset = offset
    
    def __str__(self):
        return "{} = {}".format(self.left, self.right + self.offset)

class VarToMemo(AssigmentNode):
    def __init__(self, left, right, offset):
        super().__init__(left, right)
        self.offset = offset
    
    def __str__(self):
        return "{} = {}".format(self.left + self.offset, self.right)

# The rest of assignations types can be inherited from the previous ones

#Allocate
class Allocate(ILNode):
    def __init__(self, var : int, size : int):
        self.var = var
        self.size = size
    
    def __str__(self):
        return "{} = ALLOCATE {}".format(self.var, self.size)