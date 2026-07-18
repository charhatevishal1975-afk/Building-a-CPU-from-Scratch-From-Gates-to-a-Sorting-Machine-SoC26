        LOADI A,5
        LOADI B,0

LOOP:
        CMP A,B
        BRE DONE

        SUBI A,A,1

        JUMP LOOP

DONE:
        NOOP