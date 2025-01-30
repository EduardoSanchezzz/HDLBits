module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out);//  

    parameter A=0, B=1; 
    reg state, next_state;

    always @(*) begin    // This is a combinational always block
        // State transition logic
        if (state == B) next_state = in ? B : A;
        else if (state == A) next_state = in ? A : B;
    end

    always @(posedge clk, posedge areset) begin    // This is a sequential always block
        // State flip-flops with asynchronous reset
        if (areset) state <= B;
        else state <= next_state;
    end

    // Output logic
    assign out = (state == A) ? 1'b0 : 1'b1;

endmodule

module top_module(
    input clk,
    input areset,    // Asynchronous reset to OFF
    input j,
    input k,
    output out); //  

    parameter OFF=0, ON=1; 
    reg state, next_state;

    always @(*) begin
        // State transition logic
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON: next_state = k ? OFF : ON;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if (areset) state<=OFF;
        else state<=next_state;
    end

    // Output logic
    assign out = state&ON;

endmodule

module top_module(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out); //

    parameter A=0, B=1, C=2, D=3;

    // State transition logic: next_state = f(state, in)
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    // Output logic:  out = f(state) for a Moore state machine
    assign out = state == D;

endmodule

// ONE HOT
module top_module(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out); //

    parameter A=0, B=1, C=2, D=3;

    // State transition logic: Derive an equation for each state flip-flop.
    assign next_state[A] = ~in & (state[A] | state[C]);
    assign next_state[B] = in & (state[A] | state[B] | state[D]);
    assign next_state[C] = ~in & (state[B] | state[D]);
    assign next_state[D] = in & state[C];

    // Output logic: 
    assign out = state[D];

endmodule

module top_module(
    input clk,
    input in,
    input areset,
    output out); //
    parameter A=0, B=1, C=2, D=3;
    
    reg [3:0] next_state, state;

    // State transition logic
    always @(*) begin
 		next_state[A] = ~in & (state[A] | state[C]);
 		next_state[B] = in & (state[A] | state[B] | state[D]);
 		next_state[C] = ~in & (state[B] | state[D]);
 		next_state[D] = in & state[C];
    end
            

    // State flip-flops with asynchronous reset
    always @(posedge areset, posedge clk) begin
        if (areset) state <= 4'b0001;
        else state <= next_state;
    end

    // Output logic
    assign out = state[D];

endmodule

module top_module(
    input clk,
    input in,
    input reset,
    output out); //

    // State transition logic
    parameter A=0,B=1,C=2,D=3;
    reg [1:0] state, next_state;
    
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if(reset) state<=A;
        else state<= next_state;
    end

    // Output logic
	assign out = state == D;

endmodule

//FSM
module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
    reg [3:0] state, next_state;
    parameter A=0, B=1, C=2, D=3, E=4, F=6;
    
    always @(*) begin
        case (state)
            A: next_state = (s==1) ? B : A;
            B: next_state = (s==0) ? A : s==1 ? B : D;
            C: next_state = (s==0) ? A : s==1 ? C : D;
            D: next_state = (s==1) ? C : s==3 ? D : F;
            E: next_state = (s==1) ? C : s==3 ? E : F;
            F: next_state = (s==7) ? F : E;
        endcase
    end
        
    always @(posedge clk) begin
        if (reset) begin 
            state <= A;
        end
        else begin
            state<=next_state;
        end
    end
    always @(*) begin
        fr1 = !(state == F);
        fr2 = !(state == D | state == E) & !(state == F);
        fr3 = !(state == D | state == E) & !(state == C | state == B) & !(state == F);
        dfr = state == A | state==C | state == E;
    end

endmodule

module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); //  

    parameter LEFT=0, RIGHT=1;
    reg state, next_state;

    always @(*) begin
        // State transition logic
        case (state)
            LEFT: next_state = bump_left ? RIGHT : LEFT;
            RIGHT: next_state = bump_right ? LEFT : RIGHT;
        endcase
        
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if(areset) state <= LEFT;
        else state<=next_state;
    end

    // Output logic
            assign walk_left = (state == LEFT);
        assign walk_right = (state == RIGHT);

endmodule

module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 
    
    parameter LEFT=0, RIGHT=1, F_L=2, F_R=3;
    reg [1:0] state, next_state;

    always @(*) begin
        // State transition logic
        case (state)
            LEFT: next_state = !ground? F_L : bump_left ? RIGHT : LEFT;
            RIGHT: next_state = !ground? F_R : bump_right ? LEFT : RIGHT;
            F_L: next_state = !ground ?  F_L : LEFT;
            F_R: next_state = !ground ?  F_R : RIGHT;
        endcase
        
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if(areset) state <= LEFT;
        else begin 
            state<=next_state;
        end
    end

    // Output logic
            assign walk_left = (state == LEFT);
        assign walk_right = (state == RIGHT);
    assign aaah = (state == F_R) | (state == F_L);

endmodule

module top_module(
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
    
    parameter LEFT=0, RIGHT=1, F_L=2, F_R=3, D_L=4, D_R=5;
    reg [2:0] state, next_state;

    always @(*) begin
        // State transition logic
        case (state)
            LEFT: next_state = !ground? F_L : dig? D_L : bump_left ? RIGHT : LEFT;
            RIGHT: next_state = !ground? F_R : dig? D_R : bump_right ? LEFT : RIGHT;
            F_L: next_state = !ground ?  F_L : LEFT;
            F_R: next_state = !ground ?  F_R : RIGHT;
            D_L: next_state = !ground ? F_L : D_L;
            D_R: next_state = !ground ? F_R : D_R;
        endcase
        
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if(areset) state <= LEFT;
        else begin 
            state<=next_state;
        end
    end

    // Output logic
            assign walk_left = (state == LEFT);
        assign walk_right = (state == RIGHT);
    assign aaah = (state == F_R) | (state == F_L);
    assign digging = (state == D_R) | (state == D_L);

endmodule

module top_module(
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
    
    reg [3:0] state, next_state;
    reg [5:0] counter;
    
    parameter L=0,R=1,D_L=2,D_R=3,F_L=4,F_R=5,splat=6;
    
    always @(*) begin
        case (state)
            L: next_state = ~ground ? F_L : dig ?  D_L : bump_left ? R : L;
            R: next_state = ~ground ? F_R : dig ?  D_R : bump_right ? L : R;
            D_L : next_state = ~ground ? F_L : D_L;
            D_R : next_state = ~ground ? F_R : D_R;
            F_L: next_state = ~ground ? F_L : counter > 20 ? splat : L;
            F_R: next_state = ~ground ? F_R : counter > 20 ? splat : R;
            splat: next_state = splat;
        endcase
    end
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state = L;
            counter = 0;
        end
        else begin
            state = next_state;
            counter = (state==F_L || state == F_R) ? counter < 23 ? counter + 1 : counter : 0;
        end
    end
    
    assign walk_left = state == L;
    assign walk_right = state == R;
    assign aaah = (state==F_L || state ==F_R);
    assign digging = (state==D_L || state ==D_R);


endmodule

module top_module(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2);
    
    always @(*) begin
        next_state[0] = ~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]);
        next_state[1] = in & (state[0] | state[8] | state[9]);
        next_state[2] = in & state[1];
        next_state[3] = in & state[2];
        next_state[4] = in & state[3];
        next_state[5] = in & state[4];
        next_state[6] = in & state[5];
        next_state[7] = in & (state[6] | state[7]);
        next_state[8] = ~in & state[5];
        next_state[9] = ~in & state[6];
        
    end
    
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];
        

endmodule

module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //

    // State transition logic (combinational)
    parameter idle=0, byte1=1, byte2=2,byte3=3, finished=4;
    reg [3:0] state, next_state;
    always @(*) begin
        case (state)
            idle: next_state = in[3] ? byte1 : idle;
            byte1: next_state = byte2;
            byte2: next_state = finished;
            finished: next_state = in[3] ? byte1 : idle;
        endcase
    end

    // State flip-flops (sequential)
    always @(posedge clk) begin
        if (reset) state = idle;
        else state = next_state;
    end

 
    // Output logic
    assign done = state == finished;
endmodule

module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //
    
    // State transition logic (combinational)
    parameter idle=0, byte1=1, byte2=2,byte3=3, finished=4;
    reg [3:0] state, next_state;
    reg [23:0] data;
    always @(*) begin
        case (state)
            idle: next_state = in[3] ? byte1 : idle;
            byte1: next_state = byte2;
            byte2: next_state = finished;
            finished: next_state = in[3] ? byte1 : idle;
        endcase
    end

    // State flip-flops (sequential)
    always @(posedge clk) begin
        if (reset) begin 
            state = idle;
            data = 0;
        end
        else begin 
            state = next_state;
            data = {data[15:0], in};
        end
    end

 
    // Output logic
    assign done = state == finished;
    assign out_bytes = state == finished ? data : 0;
        


endmodule


// serial receiver
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    parameter idle=0, b0=1,b1=2,b2=3,b3=4,b4=5,b5=6,b6=7,b7=8, stop=9, done_s=10, err=11;
    reg [4:0] state, next_state;
    
    always @(*) begin
        case (state)
            idle: next_state = ~in ? b0: idle;
            b0 : next_state = b1;
            b1 : next_state = b2;
            b2 : next_state = b3;
            b3 : next_state = b4;
            b4 : next_state = b5;
            b5 : next_state = b6;
            b6 : next_state = b7;
            b7 : next_state = stop;
            stop: next_state = in ? done_s : err;
            err: next_state = in ? idle : err;
            done_s: next_state = ~in ? b0: idle;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) state = idle;
        else state = next_state;
    end
    
    assign done = state == done_s;
            

endmodule

// serial recievre

module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    // Use FSM from Fsm_serial

    // New: Datapath to latch input bits.
    
    reg [3:0] state, next_state;
    parameter IDLE=0, START=1, RECEIVE=2, STOP=3, ERR=4;
    reg [3:0] i;
    reg [8:0] data;
    
    always @(*) begin
        case (state)
            IDLE: next_state = ~in ? RECEIVE : IDLE;
            RECEIVE: next_state = (i > 7) ? (in ? STOP : ERR) : RECEIVE;
           	STOP: next_state = ~in ? RECEIVE : IDLE;
            ERR: next_state = in ? IDLE : ERR;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            i <= 0;
            state <= IDLE;
            data <= 0;
        end
        else begin
            i <= (state==RECEIVE) ? i+1 : 0;
            state <= next_state;
            data <= {in, data[8:1]};
        end
    end
    
    assign done = state==STOP;
    assign out_byte = state == STOP ? data[7:0] : 0;

endmodule

module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    // Use FSM from Fsm_serial

    // New: Datapath to latch input bits.
    
    reg [3:0] state, next_state;
    parameter IDLE=0, START=1, RECEIVE=2, STOP=3, ERR=4, PARITY=5, DONE_S=6;
    reg [3:0] i;
    reg [9:0] data;
    reg parity_bit;
    
    always @(*) begin
        case (state)
            IDLE: next_state = ~in ? RECEIVE : IDLE;
            RECEIVE: next_state = (i > 6) ? PARITY : RECEIVE;
            PARITY: next_state = in==~parity_bit ? STOP : ERR;
           	STOP: next_state = in ? DONE_S : ERR;
            DONE_S: next_state = ~in ? RECEIVE : IDLE;
            ERR: next_state = in ? IDLE : ERR;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            i <= 0;
            state <= IDLE;
            data <= 0;
        end
        else begin
            i <= (state==RECEIVE) ? i+1 : 0;
            state <= next_state;
            data <= {in, data[9:1]};
        end
    end
    
    assign done = state==DONE_S;
    assign out_byte = state == DONE_S ? data[7:0] : 0;
    parity(clk, (state==IDLE), in, parity_bit);

endmodule

module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    
    parameter IDLE=0, A1=1,A2=2,A3=3,A4=4,A5=5, DISC=6, A6=7, ERR=8, FLAG=9;
    reg [4:0] state, next;
    
    always @(*) begin
        case (state)
            IDLE: next = in ? A1 : IDLE;
            A1: next = in ? A2 : IDLE;
            A2: next = in ? A3 : IDLE;
            A3: next = in ? A4 : IDLE;
            A4: next = in ? A5 : IDLE;
            A5: next = in ? A6 : DISC;
            A6: next = in ? ERR : FLAG;
            FLAG: next = in ? A1 : IDLE;
            ERR: next = in ? ERR : IDLE;
            DISC: next = in ? A1 : IDLE;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) state = IDLE;
        else state = next;
    end
    
    assign disc = state == DISC;
    assign flag = state == FLAG;
    assign err = state == ERR;

endmodule

module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 
    
    parameter A=0, B=1, C=2;
    reg [1:0] state, next;
    
    //A is zeros, B is 1s, C is 10
    always @(*) begin
        case (state)
            A: next = x ? B : A;
            B: next = x ? B : C;
            C: next = x ? B : A;
        endcase
    end
    
    always @(posedge clk, negedge aresetn) begin
        if (~aresetn) state = A;
        else state = next;
    end
    
    assign z = state == C & x;

endmodule

module top_module (
    input clk,
    input areset,
    input x,
    output z
); 
    parameter A=0,B=1,C=2,D=3;
    reg [2:0] state, next;
    
    always @(*) begin
        case (state)
            A: next = x ? B : A;
            B: next = x ? D : C;
            C: next = x ? D : C;
            D: next = x ? D : C;
        endcase
    end
    
    always @(posedge clk, posedge areset) begin
        if (areset) state <= A;
        else state <= next;
    end
    
    assign z = state == B | state == C;

endmodule

module top_module (
    input clk,
    input areset,
    input x,
    output z
); 
    parameter A=0, B=1;
    reg [1:0] state, next;
    
    always @(*) begin
        next[0] = state[0] & ~x;
        next[1] = state[0] & x | state[1];
    end
    
    always @(posedge clk, posedge areset) begin
        if (areset) state = 2'b01;
        else state = next;
    end
    
    assign z = state[0] & x | state[1] & ~x;

endmodule

module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);
    parameter A=0, B1=1, B2=2, B3=3;
    reg [3:0] state, next;
    reg [2:0] count;
    
    always @(*) begin
        case (state)
            A: next = s ? B1 : A;
            B1: next = B2;
            B2: next = B3;
            B3: next = B1;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            state <= A;
        end
        else begin
            count <= (state != A) ? (state == B1) ? w : (w ? count + 1 : count) : 0;
            state <= next;
        end
    end
    
    assign z = (state == B1) & (count == 2);
            

endmodule

module top_module (
    input clk,
    input reset,   // Synchronous reset
    input x,
    output z
);
    parameter A=0, B=1, C=2, D=3, E=4;
    reg [3:0] state, next;
    
    always @(*) begin
        case(state)
        A: next = x ? B : A;
        B: next = x ? E : B;
        C: next = x ? B : C;
        D: next = x ? C : B;
        E: next = x ? E : D;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) state <= A;
        else state<=next;
    end
    
    assign z = (state == D) | state==E;

endmodule

module top_module (
    input clk,
    input [2:0] y,
    input x,
    output Y0,
    output z
);
    parameter A=0, B=1, C=2, D=3, E=4;
    reg [3:0] next;
    
    always @(*) begin
        case(y)
        A: next = x ? B : A;
        B: next = x ? E : B;
        C: next = x ? B : C;
        D: next = x ? C : B;
        E: next = x ? E : D;
        endcase
    end
    
    assign z = (y == D) | y==E;
    assign Y0 = next[0];

endmodule

module top_module (
    input [3:1] y,
    input w,
    output Y2);
    
    assign Y2 = (y == 3'b001) | (y == 3'b101) | (w & (y == 3'b010)) | (w & (y == 3'b100));

endmodule

module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4);
    
    assign Y2 = y[1] & ~w;
    assign Y4 = (y[2] & w) | (w & y[6]) | (w & y[3]) | (w & y[5]);

endmodule

module top_module (
    input clk,
    input reset,     // synchronous reset
    input w,
    output z);
    
    parameter A=0, B=1, C=2, D=3, E=4, F=5;
    reg [3:0] state, next;
    
    always @(*) begin
        case (state)
            A: next = w ? A : B;
            B: next = w ? D : C;
            C: next = w ? D : E;
            D: next = w ? A : F;
            E: next = w ? D : E;
            F: next = w ? D : C;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) state<=A;
        else state<=next;
    end
    
    assign z = state == E | state == F;

endmodule

module top_module (
    input clk,
    input reset,     // synchronous reset
    input w,
    output z);
    
    parameter A=0, B=1, C=2, D=3, E=4, F=5;
    reg [3:0] state, next;
    
    always @(*) begin
        case (state)
            A: next = ~w ? A : B;
            B: next = ~w ? D : C;
            C: next = ~w ? D : E;
            D: next = ~w ? A : F;
            E: next = ~w ? D : E;
            F: next = ~w ? D : C;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) state<=A;
        else state<=next;
    end
    
    assign z = state == E | state == F;

endmodule


module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    
    assign Y1 = w & y[0];
    assign Y3 = ~w & (y[1] | y[5] | y[2] | y[4]);

endmodule

module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input [3:1] r,   // request
    output [3:1] g   // grant
); 
    parameter A=0, B=1, C=2, D=3;
    reg [2:0] state, next;
    
    always @(*) begin
        case (state)
            A: next = r[1] ? B : r[2] ? C : r[3] ? D : A;
            B: next = r[1] ? B : A;
            C: next = r[2] ? C : A;
            D: next = r[3] ? D : A;
        endcase
    end
    
    always @(posedge clk) begin
        if (~resetn) state<=A;
        else state <=next;
    end
    
    assign g = {state==D, state==C, state==B};

endmodule

module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 

// MON -> monitor x input state, Y states are monitoring the y input
    parameter A=0, F=1, MON=2, S1=3, S0=4, S10=5, Y0=6, Y1=7, G0=8, G1=9;
    reg [4:0] state, next;
    
    always @(*) begin
        case (state)
            A: next = ~resetn ? A : F;
            F: next = MON;
            MON: next = x ? S1 : S0;
            S1: next = x ? S1 : S10;
            S0: next = x ? S1 : S0;
            S10: next = x ? Y0 : S0;
            Y0: next = y ? G1 : Y1;
            Y1: next = y ? G1 : G0;
            G1: next = G1;
            G0: next = G0;
        endcase
    end
    
    always @(posedge clk) begin
        if(~resetn) state<= A;
        else state <=next;
    end
    
    assign f = state == F;
    assign g = state == G1 | state == Y0 | state == Y1;
            

endmodule