module half_adder( 
    input a, b,
    output cout, sum );
    assign cout = a & b;
    assign sum = a ^ b;

endmodule

module full_adder( 
    input a, b, cin,
    output cout, sum );
    
    assign cout = a & b | b&cin | a&cin;
    assign sum = a ^ b ^ cin;

endmodule

module ripple_carry_adder_3bit( 
    input [2:0] a, b,
    input cin,
    output [2:0] cout,
    output [2:0] sum );
	
    full_adder(a[0], b[0], cin, cout[0], sum[0]);
    genvar i;
    generate
        for (i=1; i < 3; ++i) begin : gen_name
            full_adder(a[i], b[i], cout[i-1], cout[i], sum[i]);
        end
    endgenerate
        

endmodule

module adder_4bit (
    input [3:0] x,
    input [3:0] y, 
    output [4:0] sum);
    
    wire [3:0] cout;
    
    full_adder(x[0], y[0], 1'b0, cout[0], sum[0]);
    genvar i;
    generate
        for (i=1; i < 4; ++i) begin : gen_name
            full_adder(x[i], y[i], cout[i-1], cout[i], sum[i]);
        end
    endgenerate
    assign sum[4] = cout[3];

    // could also do assign sum = x+y;
    

endmodule

module twos_comp_adder (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s, //sum
    output overflow //flags when signed overflow has occured
);
    assign s = {a + b};
    // overflow occurs when 2 pos nums add to a negative number or 2 neg nums add to a pos number
    assign overflow = (a[7]&b[7]&~s[7] | ~a[7]&~b[7]&s[7]) ? 1'b1 : 1'b0;

endmodule

// adder for 2 100 bit numbers
module top_module( 
    input [99:0] a, b,
    input cin,
    output cout,
    output [99:0] sum );
    wire [100:0] full_sum;
    assign full_sum= a + b + cin;
    
    assign sum = {a + b + cin};
    assign cout = full_sum[100];

    // one liner
    // assign {cout, sum} = a + b + cin;

endmodule

// bcd_ ripple adder
module top_module ( 
    input [15:0] a, b,
    input cin,
    output cout,
    output [15:0] sum );
    
    wire [3:0] c_vec;
    
    bcd_fadd unit0(a[3:0], b[3:0], cin, c_vec[0], sum[3:0]);
    genvar i;
    generate
        for (i=1; i < 4; ++i) begin : loop
            bcd_fadd(a[i*4+:4], b[i*4+:4], c_vec[i-1], c_vec[i], sum[i*4+:4]);
        end
    endgenerate
    
    assign cout = c_vec[3];

endmodule

// implement bcd_fadd
