// 4 bit counter
module top_module (
    input clk,
    input reset,      // Synchronous active-high reset
    output [3:0] q);
    always @(posedge clk) begin
        if (reset) q<=0;
        else q<= q+1'b1;
    end

endmodule

// counter to 10
module top_module (
    input clk,
    input reset,        // Synchronous active-high reset
    output [3:0] q);
    
    always @(posedge clk) begin
        if (reset) q<=0;
        else if (q == 9) q<=0;
        else q<= q+1'b1;
    end

endmodule

// enable input
module top_module (
    input clk,
    input slowena,
    input reset,
    output [3:0] q);
    always @(posedge clk) begin
    if (reset) q<=0;
    else if (~slowena) q<=q;
	else if (q == 9) q<=0;
	else q<= q+1'b1;
    end

endmodule

module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
); //
	
    wire c_ena[2:0];
    assign c_enable[0] = 1;
    wire [3:0] count1, count2, count3;
    assign c_enable[1] = count1 == 9;
    assign c_enable[2] = (count2 == 9) & c_enable[1];
    bcdcount counter0 (clk, reset, c_enable[0], count1);
    bcdcount counter1 (clk, reset, c_enable[1], count2);
    bcdcount counter2 (clk, reset, c_enable[2], count3);
    
    assign OneHertz = (count3 == 9) & c_enable[2] & c_enable[1];

endmodule

module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);
    
    assign ena[1] = q[3:0] == 9;
    assign ena[2] = (q[7:4] == 9) & ena[1];
    assign ena[3] = (q[11:8] == 9) & ena[1] & ena[2];
    
    bcd(clk, reset, 1'b1, q[3:0]);
    bcd(clk, reset, ena[1], q[7:4]);
    bcd(clk, reset, ena[2], q[11:8]);
    bcd(clk, reset, ena[3], q[15:12]);

endmodule

module bcd (
    input clk,
    input reset,
    input enable,
    output [3:0] q);
    
    always @(posedge clk) begin
        if (reset | ((q == 9) & enable)) q<=0;
        else if (enable) q<= q + 1;
        else q<=q;
    end
endmodule

// bcd clock this one was hard
module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss);
    
    // map 0 hour to 12 => 0:00AM is 12:00AM
    wire [7:0] hour;
    assign hh = (hour == 0) ? 8'h12 : hour;

    // whenever 11:59 happens pm is inverted
    always @(posedge clk) begin
        if ((mm == 8'h59) & (ss == 8'h59) & (hour == 8'h11)) pm<=~pm;
        else pm<=pm;
    end
    
    // set seconds (1 for low bits and 1 for high bits), resets to 0 after reset or 59 seconds
    // high bits count up whenever low bits reach 9
    bcd(clk, reset | (ss == 8'h59), ena, ss[3:0]);
    bcd(clk, reset | (ss == 8'h59), ena & (ss[3:0] == 9), ss[7:4]);
    
    bcd(clk, reset | ((mm == 8'h59) & (ss == 8'h59)), ena & (ss == 8'h59), mm[3:0]);
    bcd(clk, reset | ((mm == 8'h59) & (ss == 8'h59)), ena & (ss == 8'h59) & (mm[3:0] == 9), mm[7:4]);
    
    // set hours resets to 0  after 11 hours 59 min and 59s,
    bcd(clk, reset | ((mm == 8'h59) & (ss == 8'h59) & (hour == 8'h11)), ena & (ss == 8'h59) & (mm==8'h59), hour[3:0]);
    bcd(clk, reset | ((mm == 8'h59) & (ss == 8'h59) & (hour == 8'h11)), ena & (ss == 8'h59) & (mm==8'h59) & (hh[3:0]==9), hour[7:4]);
    
    
endmodule


