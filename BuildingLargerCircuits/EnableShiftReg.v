module top_module (
    input clk,
    input reset,      // Synchronous reset
    output shift_ena);
    
    reg [3:0] count;
    
    always @(posedge clk) begin
        if (reset) count<=0;
        else count <= count > 4 ? count : count + 1;
    end
    
    assign shift_ena = count < 4;

endmodule

// big boy dollowinfg 3 module are conncted
module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );
    
    reg seq_recog, shift;
    parameter SEQ=0, SHIFT=3, COUNT=1, DONE=2;
    reg [2:0] state, next;
    
    seq1101recognizer(clk, (state == DONE) | reset, data, seq_recog);
    enable_shift_reg(clk, (state == SEQ), shift);
    
    always @(*) begin
        case (state)
            SEQ: next = seq_recog ? SHIFT : SEQ;
            SHIFT: next = shift ? SHIFT : COUNT;
            COUNT: next = done_counting ? DONE : COUNT;
            DONE: next = ack ? SEQ : DONE;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) begin
            state<=SEQ;
        end
        else begin
            state<=next;
        end
    end
    
    assign shift_ena = state == SHIFT;
    assign counting = state == COUNT;
    assign done = state == DONE;

endmodule

module seq1101recognizer (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);
    
    parameter S0=0, S1=1, S11=2, S110=3, S1101=4;
    reg [3:0] state, next;
    
    always @(*) begin
        case (state)
            S0: next = data ? S1 : S0;
            S1: next = data ? S11 : S0;
            S11: next = data ? S11 : S110;
            S110: next = data ? S1101 : S0;
            S1101: next = S1101;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) state<=S0;
        else state<=next;
    end
    
    assign start_shifting = state == S110 & data;

endmodule

module enable_shift_reg (
    input clk,
    input reset,      // Synchronous reset
    output shift_ena);
    
    reg [3:0] count;
    
    always @(posedge clk) begin
        if (reset) count<=0;
        else count <= count > 4 ? count : count + 1;
    end
    
    assign shift_ena = count < 3;

endmodule