`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2020 12:27:05 AM
// Design Name: 
// Module Name: top
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
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
input en, clk, CPU_RESETN, 
input detect, sonar_pulse,
output servo, sonar_trigger, LED16_B, LED17_R,
output [8:0] LED,
input duche
);
 


wire [7:0] angle_I;

SM sweeper(
    .clk(clk),
    .duche(duche),
    //    .clk_sonar(clk10),
    .do_sweep(detect),
    .rst_n(CPU_RESETN),
    .servoPwm(servo),
//    .sonar_pulse(sonar_pulse),
//    .sonar_trigger(sonar_trigger),
    .servo_angle_I(LED),
    .READY(LED16_B),
    .dbgLed(LED17_R)
);

//sonar sonar(
//    .clk(clk10),
//    .rst_n(CPU_RESETN),
//    .do_measure(detect),
//    .sonar_pulse(sonar_pulse),
//    .inches(LED),
//    .sonar_trigger(sonar_trigger),
//    .READY(LED16_B)
//);

//ila_0 ila(
//    .clk(CLK100MHZ),
//    .probe0(LED),
//    .probe1(LED16_B),
//    .probe2(sonar_trigger),
//    .probe3(sonar_pulse));

//scanner scanner(
//    .scan(angle_I),
//    .fire(fire),
//    .en(en),
//    .clk(CLK100MHZ),
//    .detect(detect)
//);

//servoDriver servoDriver(
//    .angle(angle_I),
//    .servoPwm(servo),
//    .rst_n(CPU_RESETN),
//    .clk(CLK100MHZ)
//);

endmodule
