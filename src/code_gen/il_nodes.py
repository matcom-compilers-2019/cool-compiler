
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
        return "VAR_IN {} <- VAR_IN {} {} VAR_IN {}\n".format(self.var, self.leftop, self.symb, self.rightop)

class UnaryOpIL(ILNode):
    def __init__(self, var : int, op: int, symb : str):
        self.var = var
        self.op = op
        self.symb = symb

    def __str__(self):
        return "VAR_IN {} = {} VAR_IN {}".format(self.var, self.symb, self.op)

# Assigments
class AssigmentNodeIL(ILNode):
    def __init__(self, left, right):
        self.left = left
        self.right = right

class VarToVarIL(AssigmentNodeIL):
    def __init__(self, left, rigth):
        super().__init__(left, rigth)
    
    def __str__(self):
        return "VAR_IN {} = VAR_IN {}".format(self.left, self.right)

class MemoToVarIL(AssigmentNodeIL):
    def __init__(self, left, right, offset):
        super().__init__(left, right)
        self.offset = offset
    
    def __str__(self):
        return "VAR_IN {} = ATTR {}".format(self.left, self.offset)

class VarToMemoIL(AssigmentNodeIL):
    def __init__(self, left, right, offset):
        super().__init__(left, right)
        self.offset = offset
    
    def __str__(self):
        return "ATTR {} = VAR_IN {}".format(self.offset, self.right)

class CteToMemoIL(AssigmentNodeIL):
    def __init__(self, left, right, offset):
        super().__init__(left, right)
        self.offset = offset
    
    def __str__(self):
        return "{} = {}\n".format(self.left + self.offset, self.right)

        

#Allocate
class AllocateIL(ILNode):
    def __init__(self, var : int, size : int, typ):
        self.var = var
        self.size = size
        self.typ = typ
    
    def __str__(self):
        return "ALLOCATE {}, in {}".format(self.typ, self.var)

#Method
class LabelIL(ILNode):
    def __init__(self, fst : str, snd : str, func = False):
        self.label = fst + '.' + snd
        self.fst = fst
        self.snd = snd
        self.func = func

        if self.label == "main.":
            self.label = "main"

    def __str__(self):
        return 'Label {}:\n'.format(self.label)


class GotoIL(ILNode):
    def __init__(self, label):
        self.label = label

    def __str__(self):
        return 'GOTO {}'.format(self.label)

class IfJumpIL(ILNode):
    def __init__(self, var, label):
        self.var = var
        self.label = label

    def __str__(self):
        return 'IF {} GOTO {}'.format(self.var, self.label) 
        

class HierarchyIL(ILNode):
    def __init__(self, node : str, parent : str):
        self.node = node
        self.parent = parent
    
    def __str__(self):
        return 'TYPE {} DESCENDANT OF {}\n'.format(self.node, self.parent)

class VirtualTableIL(ILNode):
    def __init__(self, name, methods):
        self.name = name
        self.methods = methods

    def __str__(self):
        result = ''
        result += self.name + "VT\n"
        result += "METHODS\n"
        for m in self.methods:
            result += m + "\n"
        return result

class PopIL(ILNode):
    def __init__(self, cant):
        self.cant = cant
    def __str__(self):
        return 'POP {}'.format(self.cant)

class PushIL(ILNode):
    def __init__(self, val = 0, case = 1):
        self.val = val
    def __str__(self):
        if self.val != 0:
            return 'PUSH {}'.format(self.val)
        return 'PUSH '

class ReturnIL(ILNode):
    
    def __str__(self):
        return "Return\n"


class DispatchIL(ILNode):
    def __init__(self, res, obj : int, offset):
        self.obj = obj
        self.offset = offset
        self.res = res
    
    def __str__(self):
        return "DISPATCH: obj_in({}).method_offset({}) to {}".format(self.obj, self.offset, self.res)

class DispatchParentIL(ILNode):
    def __init__(self, res, obj, method):
        self.method = method
        self.res = res
        self.obj = obj


    def __str__(self):
        return "DISPATCH: method {} with_obj {} in {}".format(self.method, self.obj, self.res)

class InheritIL(ILNode):
    def __init__(self, child, parent, res):
        self.child = child
        self.parent = parent
        self.res = res
    
    def __str__(self):
        return "child = {} inherits from parent = {}\n".format(self.child, self.parent)


class BranchIL(ILNode):
    def __init__(self, condition, label):
        self.condition = condition
        self.label = label

class StringIL(ILNode):
    def __init__(self, label, string):
        self.label = label
        self.string = string

    def __str__(self):
        return self.label + ": " + self.string + "\n"

class LoadLabelIL(ILNode):
    def __init__(self, var, label):
        self.var = var
        self.label = label
    
    def __str__(self):
        return "LOAD: " + self.label + ' To ' + str(self.var)

class PrintIL(ILNode):
    def __init__(self, string):
        self.string = string
    
    def __str__(self):
        return "print " + self.string + "\n"


class CommentIL(ILNode):
    def __init__(self, text):
        self.text = text
    
    def __str__(self):
        return '#' + self.text

