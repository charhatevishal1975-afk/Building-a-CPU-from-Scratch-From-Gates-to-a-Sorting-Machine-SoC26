module lemmings_1(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); //  

    // parameter LEFT=0, RIGHT=1, ...
    parameter LEFT=0, RIGHT=1;
    reg state, next_state;

    always @(*) begin
        // State transition logic
        case(state)
            LEFT: next_state <= (bump_left & bump_right) ? RIGHT : 
                                    (bump_left) ? RIGHT : LEFT;
            RIGHT: next_state <= (bump_left & bump_right) ? LEFT :
                                    (bump_right) ? LEFT : RIGHT;
            default: next_state <= LEFT;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if(areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Output logic
    // assign walk_left = (state == ...);
    // assign walk_right = (state == ...);
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

    // Lemmings 1
    // FSM States: 2
    // LEFT      : The lemming is walking to the left.
    // RIGHT     : The lemming is walking to the right.

endmodule

module lemmings_2(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah );
    reg [2:0]state,next_state;
    parameter LEFT=0, RIGHT=1,FALL_L = 2, FALL_R = 3;
    always @(*) begin
            case (state)
                LEFT: next_state <= ground ? (bump_left ? RIGHT : LEFT) : FALL_L;
                RIGHT: next_state <= ground ? (bump_right ? LEFT : RIGHT) : FALL_R;
                FALL_L: next_state <= ground ? LEFT : FALL_L;
                FALL_R: next_state <= ground ? RIGHT : FALL_R;
            endcase
    end
    always @(posedge clk or posedge areset) begin
        if(areset)
            state <= LEFT;
        else begin
            state <= next_state;
        end
    end
    
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_L | state == FALL_R);

    // Lemmings 2
    // FSM States: 4
    // LEFT      : Walking to the left.
    // RIGHT     : Walking to the right.
    // FALL_L    : Falling after previously moving left.
    // FALL_R    : Falling after previously moving right.

endmodule


module lemmings_3(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    parameter LEFT=0, RIGHT=1, FALL_L=2, FALL_R=3, DIG_L=4, DIG_R=5;
    reg [2:0] state, next_state;
    always @(*) begin
        case (state)
            LEFT:   next_state = (!ground) ? FALL_L : (dig ? DIG_L : (bump_left ? RIGHT : LEFT));
            RIGHT:  next_state = (!ground) ? FALL_R : (dig ? DIG_R : (bump_right ? LEFT : RIGHT));
            FALL_L: next_state = ground ? LEFT : FALL_L;
            FALL_R: next_state = ground ? RIGHT : FALL_R;
            DIG_L:  next_state = (!ground) ? FALL_L : DIG_L;
            DIG_R:  next_state = (!ground) ? FALL_R : DIG_R;
        endcase
    end
    always @(posedge clk or posedge areset) begin
        if (areset) state <= LEFT;
        else state <= next_state;
    end
    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALL_L || state == FALL_R);
    assign digging    = (state == DIG_L || state == DIG_R);

    // Lemmings 3
    // FSM States: 6
    // LEFT      : Walking to the left.
    // RIGHT     : Walking to the right.
    // FALL_L    : Falling after previously moving left.
    // FALL_R    : Falling after previously moving right.
    // DIG_L     : Digging while facing left.
    // DIG_R     : Digging while facing right.

endmodule

module lemmings_4(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
parameter LEFT=0, RIGHT=1, FALL_L=2, FALL_R=3, DIG_L=4, DIG_R=5, SPLAT=6;
    reg [2:0] state, next_state;
    reg [7:0] count;
    always @(*) begin
        case(state)
            LEFT:   next_state = !ground ? FALL_L : (dig ? DIG_L : (bump_left ? RIGHT : LEFT));
            RIGHT:  next_state = !ground ? FALL_R : (dig ? DIG_R : (bump_right ? LEFT : RIGHT));
            DIG_L:  next_state = !ground ? FALL_L : DIG_L;
            DIG_R:  next_state = !ground ? FALL_R : DIG_R;
            FALL_L: next_state = ground ? (count > 20 ? SPLAT : LEFT) : FALL_L;
            FALL_R: next_state = ground ? (count > 20 ? SPLAT : RIGHT) : FALL_R;
            SPLAT:  next_state = SPLAT;
            default: next_state = LEFT;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
            count <= 0;
        end else begin
            state <= next_state;
            if (next_state == FALL_L || next_state == FALL_R)
                count <= count + 1;
            else
                count <= 0;
        end
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALL_L || state == FALL_R);
    assign digging    = (state == DIG_L || state == DIG_R);

    // Lemmings 4
    // FSM States: 7
    // LEFT      : Walking to the left.
    // RIGHT     : Walking to the right.
    // FALL_L    : Falling after previously moving left.
    // FALL_R    : Falling after previously moving right.
    // DIG_L     : Digging while facing left.
    // DIG_R     : Digging while facing right.
    // SPLAT     : The lemming has fallen for too long, landed, and splatted.

endmodule
