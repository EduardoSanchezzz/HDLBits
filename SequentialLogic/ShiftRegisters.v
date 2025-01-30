// 4 bit shift reg
module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q); 
    
    always @(posedge clk, posedge areset) begin
        if (areset) q<=0;
        else if (load) q<=data;
        else if (ena) q<={1'b0, q[3:1]};
        else q<=q;
    end
        

endmodule

// 100 bit rotator left and right
module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q); 
    always @(posedge clk) begin
        if (load) q<=data;
        else if (ena == 2'b01) q<={q[0], q[99:1]};
        else if (ena == 2'b10) q<={q[98:0], q[99]};
        else q<=q;
    end

endmodule

// arithmetic shift
module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q); 
    
    always @(posedge clk) begin
        if (load) q<=data;
        else if(~ena) q<=q;
        else if (amount == 2'b00) q<={q[62:0], 1'b0};
        else if (amount == 2'b01) q<={q[55:0], 8'h00};
        else if (amount == 2'b10) q<={q[63], q[63:1]};
        else if (amount == 2'b11) q<={{8{q[63]}}, q[63:8]};
        else q<=q;
    end

endmodule

// lsfr
module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 5'h1
    output [4:0] q
); 
    always @(posedge clk) begin
        if (reset) q<={5'b1};
        else q<={q[0], q[4], q[3]^q[0], q[2:1]};
    end

endmodule

// confusing worded question
module top_module (
	input [2:0] SW,      // R
	input [1:0] KEY,     // L and clk
	output [2:0] LEDR);  // Q
    
    wire [2:0] q_next;
    always @(*) begin
        q_next[2] = (LEDR[1] ^ LEDR[2]);
        q_next[1] = LEDR[0];
        q_next[0] = LEDR[2];
    end
    
    always @(posedge KEY[0]) begin
        if(KEY[1]) LEDR<=SW;
        else LEDR<=q_next;
    end

endmodule

// lfsr with taps at 32, 22 , 2 and 1
module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 32'h1
    output [31:0] q
); 
    always @(posedge clk) begin
        if (reset) q<=1;
        else q<={q[0], q[31:23], q[22] ^ q[0], q[21:3], q[2]^q[0], q[1]^q[0]};
    end

endmodule

// shift reg
 module top_module (
    input clk,
    input resetn,   // synchronous reset
    input in,
    output out);
    reg [3:0] shift_reg;
    always @(posedge clk) begin
        if (~resetn) shift_reg = 0;
        else shift_reg<={in, shift_reg[3:1]};
    end
    assign out = shift_reg[0];

endmodule

// shift reg with mux dff
module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
); //
    MUXDFF(KEY[1], KEY[2], KEY[0], KEY[3], SW[3], LEDR[3]);
    MUXDFF(KEY[1], KEY[2], KEY[0], LEDR[3], SW[2], LEDR[2]);
    MUXDFF(KEY[1], KEY[2], KEY[0], LEDR[2], SW[1], LEDR[1]);
    MUXDFF(KEY[1], KEY[2], KEY[0], LEDR[1], SW[0], LEDR[0]);

endmodule

module MUXDFF (
	input sel0,
    input sel1,
    input clk,
    input in01,
    input in11,
    output out
);
    wire mux_out0, mux_out1;
    
    assign mux_out0 = sel0 ? in01 : out;
    assign mux_out1 = sel1 ? in11 : mux_out0;
    
    always @(posedge clk) out<=mux_out1;

endmodule


// 3 input LUT with 8 bit shift reg
module top_module (
    input clk,
    input enable,
    input S,
    input A, B, C,
    output Z ); 
    
    wire [0:7] Q;
    always @(posedge clk)
        if(enable) Q<={S, Q[0:6]};
    always @(*)
        Z = Q[{A,B,C}];
            

endmodule

module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q ); 
    
    wire [511:0] q_next;
    
    always @(*) begin
        q_next[0] = q[1];
        q_next[511] = q[510];
        for (int i = 1; i<511; ++i) begin
            q_next[i] = q[i-1] ^ q[i+1];
        end
    end
    
    always @(posedge clk) begin
        if (load) q<=data;
        else q<=q_next;
    end

endmodule

module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
); 
    wire [511:0] q_next;
    
    always @(*) begin
        q_next[0] = q[0];
        q_next[511] = q[510] | q[511];
        for (int i = 1; i<511; ++i) begin
            q_next[i] = q[i+1]&(q[i] ^ q[i-1]) | ~q[i+1]&(q[i]|q[i-1]);
        end
    end
    
    always @(posedge clk) begin
        if (load) q<=data;
        else q<=q_next;
    end

endmodule
