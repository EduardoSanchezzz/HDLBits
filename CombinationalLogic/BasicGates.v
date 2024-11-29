// The thermostat can be in one of two modes: heating (mode = 1) and cooling (mode = 0). In heating mode, turn the heater on when it is too cold (too_cold = 1) but do not use the air conditioner. In cooling mode, turn the air conditioner on when it is too hot (too_hot = 1), but do not turn on the heater. When the heater or air conditioner are on, also turn on the fan to circulate the air. In addition, the user can also request the fan to turn on (fan_on = 1), even if the heater and air conditioner are off.

module Thermostat (
    input too_cold,
    input too_hot,
    input mode,
    input fan_on,
    output heater,
    output aircon,
    output fan
); 
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    assign fan = heater | aircon | fan_on;

endmodule

// A "population count" circuit counts the number of '1's in an input vector. Build a population count circuit for a 3-bit input vector.

module pop_count( 
    input [2:0] in,
    output [1:0] out );

    always @(*) begin
        out = 0;
      for (int i = 0; i < 3; ++i) begin
          if (in[i] == 1'b1) ++out;
      end 
    end

endmodule

// You are given a four-bit input vector in[3:0]. We want to know some relationships between each bit and its neighbour:

// out_both: Each bit of this output vector should indicate whether both the corresponding input bit and its neighbour to the left (higher index) are '1'. For example, out_both[2] should indicate if in[2] and in[3] are both 1. Since in[3] has no neighbour to the left, the answer is obvious so we don't need to know out_both[3].
// out_any: Each bit of this output vector should indicate whether any of the corresponding input bit and its neighbour to the right are '1'. For example, out_any[2] should indicate if either in[2] or in[1] are 1. Since in[0] has no neighbour to the right, the answer is obvious so we don't need to know out_any[0].
// out_different: Each bit of this output vector should indicate whether the corresponding input bit is different from its neighbour to the left. For example, out_different[2] should indicate if in[2] is different from in[3]. For this part, treat the vector as wrapping around, so in[3]'s neighbour to the left is in[0].

module gates_v( 
    input [3:0] in,
    output [2:0] out_both,
    output [3:1] out_any,
    output [3:0] out_different );
    
    always @(*) begin
        for (int i = 0; i < 4; ++i) begin
            if (i != 3) begin
                out_both[i] = in[i] & in[i+1];
                out_different[i] = (in[i] != in[i+1]) ? 1'b1: 1'b0;
            end else if (i==3) out_different[3] = (in[3] != in[0]) ? 1'b1: 1'b0;
            if (i!=0) out_any[i] = in[i] | in[i-1];
        end
    end

endmodule

module gates_v100( 
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different );
    
    assign out_both = in[99:1] & in[98:0];
    assign out_any = in[99:1] | in[98:0];
    assign out_different = in ^ {in[0], in[99:1]};
    

endmodule