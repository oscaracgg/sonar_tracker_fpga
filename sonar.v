`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2020 01:05:10 AM
// Design Name: 
// Module Name: sonar
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


module sonar(
input clk, rst_n, // clk 10MHz
input do_measure,
input sonar_pulse,
output reg [7:0] inches,
output reg sonar_trigger = 0,
output reg READY = 0
);

parameter s_standby = 0,
          s_startMeasure = 1,
          s_waitForPulse = 2,
          s_countPulse = 3;
          
reg[1:0] state = s_standby, next_state = s_standby;

reg[31:0] timeCount = 0;
reg rst_count = 1;

reg [31:0] timeoutCounter = 0;

always @ (negedge rst_n or posedge clk)
begin
    if(~rst_n) // priority reset
        state <= s_standby;
    else
        state <= next_state;
end


always @ (state or do_measure or sonar_pulse or timeoutCounter)
begin
    case(state)
        s_standby: begin
            sonar_trigger <= 0; // Disable the sonar sensor
            READY <= 1; //Signal that we are ready to scan/ not busy
            rst_count <= 1;
            if(do_measure)
                next_state <= s_startMeasure;
            else
                next_state <= s_standby;
        end
        
        s_startMeasure: begin
            sonar_trigger <= 1; // Tell sonar to start ranging
            READY <= 0;
            if(sonar_pulse)
                next_state <= s_countPulse;
             else
                next_state <= s_startMeasure;
        end
        
        s_countPulse: begin
            rst_count = 0;
            sonar_trigger <= 0;
            if(~sonar_pulse) begin // Pulse from sonar has ended
                // calculate the inches from the time 
                // 147uS / inch
                inches <= ((timeCount - 8300) / 1470);
                next_state <= s_standby;
            end
            else
                next_state <= s_countPulse;
        end
        
        default: // should never reach this.
            next_state <= s_standby;
    endcase
end

always @ (posedge clk)
    if(rst_count)
        timeCount <= 0;
    else
        timeCount <= timeCount + 1;

always @ (posedge clk)
    if(state == s_waitForPulse || state == s_countPulse)
        timeoutCounter <= timeoutCounter + 1;
    else
        timeoutCounter <= 0;

endmodule
