// kmap 1

module top_module(
    input a,
    input b,
    input c,
    output out  ); 
    
    assign out = a|b|c;

endmodule

module top_module(
    input a,
    input b,
    input c,
    input d,
    output out  ); 
    //SOP
    //assign out = ~b&~c | ~a&~c&~d | a&c&d | b&c&d | ~a&c&~d;
    //POS
    assign out = (a|b|~c|~d)&(~b|c|~d)&(~a|~b|c)&(~a|~c|d);

endmodule



module top_module(
    input a,
    input b,
    input c,
    input d,
    output out  ); 
    //SOP
    //assign out = a | ~b&c;
    //POS
    assign out = (a|~b)&(a|c);
    

endmodule

// kmap with no simplifiatoin ossible
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out  ); 
	
    assign out = ^{a,b,c,d};
endmodule

module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
); 
    assign out_pos = (~a|b)&c&(~b|d);
    assign out_sop = c&d | ~a&~b&c;

endmodule

//https://hdlbits.01xz.net/wiki/Exams/m2014_q3
module top_module (
    input [4:1] x, 
    output f );
    
    assign f = ~x[1]&x[3] | x[2]&x[4];

endmodule

// https://hdlbits.01xz.net/wiki/Exams/2012_q1g
module top_module (
    input [4:1] x,
    output f
); 
    assign f = (x[3]|~x[4]) & (~x[2]|x[3]) & (~x[1]|x[2]|~x[4]) & (~x[1]|~x[2]|x[4]);

endmodule

// https://hdlbits.01xz.net/wiki/Exams/ece241_2014_q3
module top_module (
    input c,
    input d,
    output [3:0] mux_in
); 
    assign mux_in[0] = d ? 1'b1 : c;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = d ? 1'b0 : 1'b1;
    assign mux_in[3] = d ? c : 1'b0;

endmodule