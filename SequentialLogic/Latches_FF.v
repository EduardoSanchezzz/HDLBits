// d flip flop
module dff (
    input clk,    // Clocks are used in sequential circuits
    input d,
    output reg q );//

    // Use a clocked always block
    //   copy d to q at every positive edge of clk
    //   Clocked always blocks should use non-blocking assignments
    
    always @(posedge clk) q <= d;
    

endmodule

// wit reset
module top_module (
    input clk,
    input reset,            // Synchronous reset
    input [7:0] d,
    output [7:0] q
);
    always @(posedge clk) begin
        if (reset) q<=8'b0;
        else q<= d;
    end

endmodule

// neg edge clock, high sync reset to value
module top_module (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);
    always @(negedge clk) begin
        if (reset) q<=8'h34;
        else q<= d;
    end

endmodule

// async reset
module top_module (
    input clk,
    input areset,   // active high asynchronous reset
    input [7:0] d,
    output [7:0] q
);
    
    always @(posedge clk, posedge areset) begin
        if (areset) q<=0;
        else q<=d;
    end

endmodule

// byte  enabled ff with sync reset
module top_module (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);
    always @(posedge clk) begin
        if (~resetn) q <= 0;
        else begin
       		if (byteena[0]) q[7:0] <= d[7:0];
        	if (byteena[1]) q[15:8] <= d[15:8];
        end
    end

endmodule

// lathc
module top_module (
    input d, 
    input ena,
    output q);
    
    always @(*) begin
        if (ena) q = d;
    end

endmodule

// gate with d flop flop
module top_module (
    input clk,
    input in, 
    output out);
    
    wire d;
    assign d = in ^ out;
    
    always @(posedge clk) begin
        out<=d;
    end

endmodule

// mux with dff
module top_module (
	input clk,
	input L,
	input r_in,
	input q_in,
	output reg Q);
    
    wire d;
    assign d = L ? r_in : q_in;
    always @(posedge clk) begin
        Q<=d;
    end

endmodule

// 2 mux 3ith dff
module top_module (
    input clk,
    input w, R, E, L,
    output Q
);
    
    wire d, m_out;
    assign m_out = E ? w : Q;
    assign d = L ? R : m_out;
    always @(posedge clk) begin
        Q<=d;
    end

endmodule

// dff with gates before and after and with q and qbar
module top_module (
    input clk,
    input x,
    output z
); 
    wire d1,d2,d3;
    wire q1,q2,q2n,q3,q3n;
    
    assign d1 = q1^x;
    assign d2 = q2n & x;
    assign d3 = q3n|x;
    assign q3n = ~q3;
    assign q2n = ~q2;
    assign z = ~(q1|q2|q3);
    
    always @(posedge clk) begin
        q1<=d1;
        q2<=d2;
        q3<=d3;
    end
    

endmodule

// jk ff
module top_module (
    input clk,
    input j,
    input k,
    output Q); 
    
    always @(posedge clk) begin
        if (j == k) Q<=k ? ~Q : Q;
        else Q<=j;
    end

endmodule

// For each bit in an 8-bit vector, detect when the input signal changes from 0 in one clock cycle to 1 the next (similar to positive edge detection). The output bit should be set the cycle after a 0 to 1 transition occurs.

// Here are some examples. For clarity, in[1] and pedge[1] are shown separately.

module top_module (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);
    wire [7:0]first_clk;
    always @(posedge clk)
        for (int i = 0; i < 8; ++i) begin
            if(in[i] & first_clk[i]) begin
                pedge[i]<=1'b1;
                first_clk[i]<=1'b0;
        	end
            else if (!in[i]) begin
                first_clk[i]<=1'b1;
                pedge[i]<=1'b0;
            end
            else pedge[i]<=1'b0;
        end
        

endmodule

// edge detector

module top_module (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);
    wire [7:0] in_last;
    
    always @(posedge clk) begin
        in_last <=in;
        anyedge <= in_last^in;
    end
    

endmodule


// For each bit in a 32-bit vector, capture when the input signal changes from 1 in one clock cycle to 0 the next. "Capture" means that the output will remain 1 until the register is reset (synchronous reset).

// Each output bit behaves like a SR flip-flop: The output bit should be set (to 1) the cycle after a 1 to 0 transition occurs. The output bit should be reset (to 0) at the positive clock edge when reset is high. If both of the above events occur at the same time, reset has precedence. In the last 4 cycles of the example waveform below, the 'reset' event occurs one cycle earlier than the 'set' event, so there is no conflict here.

// In the example waveform below, reset, in[1] and out[1] are shown again separately for clarity.
module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);
    wire [31:0] in_last;
    always @(posedge clk) begin
        in_last<=in;
        if (reset) out<=0;
        // so this statement can only set out bits to 1, not to 0 bc of the or statment
        else out<=(in_last&~in) | out;
    end

endmodule

// double edge triggered ff
module top_module (
    input clk,
    input d,
    output q
);
    wire [1:0] ff;
    
    always @(posedge clk) ff[1]<=d;
    always @(negedge clk) ff[0]<=d;
    
    always @(*)
        q <= clk&ff[1] | ~clk&ff[0];

endmodule

