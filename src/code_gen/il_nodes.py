
class ILNode():
    pass

#Operations
class BinOpIL(ILNode):
    def __init__(self, var : int, leftop : int, rightop : int, symb : str):
        self.var = var
        self.leftop = leftop
        self.rightop = rightop
        self.symb = symb

    def __str__(self):
        return "{} = {} {} {}".format(self.var, self.leftop, self.symb, self.rightop)

class UnaryOpIL(ILNode):
    def __init__(self, var : int, op: int, symb : str):
        self.var = var
        self.op = op
        self.symb = symb

    def __str__(self):
        return "{} = {} {}".format(self.var, self.symb, self.op)

# Assigments
class AssigmentNodeIL(ILNode):
    def __init__(self, left, right):
        self.left = left
        self.right = right

class VarToVarIL(AssigmentNode):
    def __init__(self, left, rigth):
        super().__init__(left, rigth)
    
    def __str__(self):
        return "{} = {}".format(self.left, self.right)

class MemoToVarIL(AssigmentNode):
    def __init__(self, left, right, offset):
        super().__init__(left, right)
        self.offset = offset
    
    def __str__(self):
        return "{} = {}".format(self.left, self.right + self.offset)

class VarToMemoIL(AssigmentNode):
    def __init__(self, left, right, offset):
        super().__init__(left, right)
        self.offset = offset
    
    def __str__(self):
        return "{} = {}".format(self.left + self.offset, self.right)

class CteToMemoIL(AssigmentNodeIL):
    def __init__(self, left, right, offset):
        super().__init__(left, right)
        self.offset = offset
    
    def __str__(self):
        return "{} = {}".format(self.left + self.offset, self.right)

        

#Allocate
class AllocateIL(ILNode):
    def __init__(self, var : int, size : int):
        self.var = var
        self.size = size
    
    def __str__(self):
        return "{} = ALLOCATE {}".format(self.var, self.size)

#Method
class LabelIL(ILNode):
    def __init__(self, fst : str, snd : str):
        self.label = fst + '.' + snd
        self.fst = fst
        self.snd = snd

    def __str__(self):
        return 'Label {}:'.format(self.label)


class PushVarIL(ILNode):
    def __init__(self, value : int, arg = False):
        self.value = value
        self.arg = arg

    def __str__(self):
        if arg:
            return 'ARG {}'.format(self.value)
        return 'Local {}'.format(self.value)

class GotoIL(ILNode):
    def __init__(self, label):
        self.label = label

    def __str__(self):
        return 'GOTO {}'.format(label)

class IfJumpIL(ILNode):
    def __init__(self, var, label):
        self.var = var
        self.label = label

    def __str__(self):
        return 'IF {} GOTO {}'.format(var, label) 
        