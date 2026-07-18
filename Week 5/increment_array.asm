#--------------------------------------
# Increment every array element
#--------------------------------------

LOADI A,0          # index = 0
LOADI B,8          # array size

LOOP:

LOADF C,A,0        # C = memory[A]

ADDI C,C,1         # C++

STOREF C,A,0       # memory[A] = C

ADDI A,A,1         # index++

CMP A,B

BRNE LOOP

NOOP