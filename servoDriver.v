`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yoan Andreev
// 
// Create Date: 02/16/2020 03:11:30 PM
// Design Name: 
// Module Name: servoDriver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Revision 0.2 - Fixed Rounding Error in Mapping
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////


module servoDriver  #(
    parameter minPulse = 500,
              maxPulse = 2500,
              clkDiv = 100,
              minAngle = 0,
              maxAngle = 270
    )
    (
    input wire [8:0] angle,
    output wire servoPwm,
    input wire rst_n, clk
    );
   
    localparam slope = ((maxPulse - minPulse))/((maxAngle - minAngle));
    
    reg [11:0] transVal;
    
    pulseDriver #(minPulse, maxPulse, clkDiv) pd1(.value(transVal), .clk(clk), .rst_n(rst_n), .pulse(servoPwm));
    
    always @ (posedge clk)
    begin
        if(!rst_n)
            transVal <= 0;
        else
            transVal <= 500 + (slope*angle);
    end
endmodule
