# ============================================
# Bubble Sort (8 Elements)
# ============================================

        LOADI A,0          # i = 0

OUTER:

        LOADI D,7          # last = 7

        LOADI B,0          # j = 0

        CMP A,D
        BRGE END           # if i>=7 finish

INNER:

        LOADI D,7
        SUB D,D,A          # D = 7-i

        CMP B,D
        BRGE NEXT_I        # if j>=7-i

        #-------------------------
        # C = array[j]
        #-------------------------

        LOADF C,B,0

        #-------------------------
        # D = array[j+1]
        #-------------------------

        ADDI B,B,1
        LOADF D,B,0
        SUBI B,B,1

        #-------------------------
        # compare
        #-------------------------

        CMP D,C

        BRGE NO_SWAP

        #-------------------------
        # swap
        #-------------------------

        STOREF D,B,0

        ADDI B,B,1
        STOREF C,B,0
        SUBI B,B,1

NO_SWAP:

        ADDI B,B,1
        JUMP INNER

NEXT_I:

        ADDI A,A,1
        JUMP OUTER

END:

        NOOP