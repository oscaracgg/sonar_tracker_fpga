`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2020 07:45:44 AM
// Design Name: 
// Module Name: sweeper
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


module SM(
input do_sweep,
input clk, rst_n, clk_sonar,
output reg READY = 0,
output servoPwm,
output reg [8:0] servo_angle_I = 0,
output reg dbgLed = 0,
input duche,
input sonar_pulse,
output sonar_trigger
);

parameter s_standby = 0,
          s_calibrate = 1,
          s_sweepUp = 2,
          s_sweepDown = 3;
          
parameter s_sweep_standby = 0,
          s_sweep_up = 1,
          s_sweep_down = 2;

reg [1:0] state = s_standby, next_state = s_standby;
reg [1:0] state_sweep = s_sweep_standby, next_state_sweep = s_sweep_standby;

//reg do_measure_I = 0;
//wire measure_READY_I = 0;
//wire [7:0] inches_I = 0;

reg sweepEnable = 0;
reg sweepDir = 0; // 0 - up,  1 - down;
//reg sweepDone = 0;

reg [31:0] clockDivR = 0;

//sonar sonar0(
//    .clk(clk_sonar),
//    .rst_n(rst_n),
//    .do_measure(do_measure_I),
//    .sonar_pulse(sonar_pulse),
//    .inches(inches_I),
//    .sonar_trigger(sonar_trigger),
//    .READY(measure_READY_I)
//);

servoDriver #(.clkDiv(100)) servo0(
    .angle(servo_angle_I),
    .servoPwm(servoPwm),
    .rst_n(rst_n),
    .clk(clk)
);

always @ (posedge clk or negedge rst_n)
begin
    if(~rst_n) begin
        state <= s_standby;
        state_sweep <= s_sweep_standby;
        clockDivR <= 0;
        end
    else begin
        state <= next_state;
        state_sweep <= next_state_sweep;
        clockDivR <= clockDivR + 1;
        end
end

always @ (posedge clockDivR[20])
begin
    dbgLed <= ~dbgLed;
    if(sweepEnable) begin
        if(sweepDir==1 && clockDivR[22])begin
         if(duche)
                   servo_angle_I <= servo_angle_I;
                   else 
                     servo_angle_I <= servo_angle_I - 3'b101;
end
        else begin
        if (sweepDir==0 && clockDivR[22])begin
              if(duche )
                   servo_angle_I <= servo_angle_I;
                   else 
                     servo_angle_I <= servo_angle_I - 3'b101;
end
       end
      end 
    else 
        servo_angle_I <= 0;
    end


//always @ (state_sweep or sonar_pulse or clockDivR[21] or sweepEnable)
//begin
//    case(state_sweep)
//        s_sweep_standby:begin
//            servo_angle_I <= 0;
//            sweepDone <= 0;
//            if(sweepEnable)
//                next_state_sweep <= s_sweep_up;
//            else
//                next_state_sweep <= s_sweep_standby;
//        end
        
//        s_sweep_up:begin
//            if(clockDivR[21])begin
//                servo_angle_I <= servo_angle_I + 3'b101; //increment angle
//                //take a measurement
//                //after measurement is done, move on
//            end
//            else
//                servo_angle_I <= servo_angle_I;
                
//            if(servo_angle_I >= 270) begin
//                next_state_sweep <= s_sweep_down;
//            end
//            else
//                next_state_sweep <= s_sweep_up;
//        end
        
//        s_sweep_down:begin
//            if(clockDivR[21])
//                servo_angle_I <= servo_angle_I - 3'b101;
//            else
//                servo_angle_I <= servo_angle_I;
                
//            if(servo_angle_I == 0 || servo_angle_I > 500) begin
//                next_state_sweep <= s_sweep_standby;
//                sweepDone <= 1;
//            end
//            else
//                next_state_sweep <= s_sweep_down;
//        end
        
//        default:
//            next_state_sweep <= s_sweep_standby;
//    endcase
//end


always @ (state or do_sweep or servo_angle_I)
begin
    case (state)
        s_standby: begin
            sweepEnable <= 0;
            if(do_sweep)
                next_state <= s_sweepUp;
            else
                next_state <= s_standby;
        end
        
//        s_sweepUp: begin
//            sweepEnable <= 1;
//            if(sweepDone)
//                next_state <= s_sweepDown;
//            else
//                next_state <= s_sweepUp;
//        end
        
        s_calibrate: begin
            sweepDir <= 0;
            sweepEnable <= 1;
            if(servo_angle_I >= 270)
                next_state <= s_sweepDown;
            else
                next_state <= s_calibrate;
        end
        
        s_sweepUp: begin
            sweepDir <= 0;
            sweepEnable <= 1;
            if(servo_angle_I == 270)
                next_state <= s_sweepDown;
            else
                next_state <= s_sweepUp;
        end
        
        s_sweepDown: begin
            sweepDir <= 1;
            sweepEnable <= 1;
            if(servo_angle_I == 0) begin
                next_state <= s_standby;
                end
            else
                next_state <= s_sweepDown;
        end
        
    endcase
end




endmodule
