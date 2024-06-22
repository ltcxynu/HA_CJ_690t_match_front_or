`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/08 18:12:55
// Design Name: 
// Module Name: JDPCIE2004_top
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


module test_data_gen(

    input               i_sys_clk       ,
    input               i_sys_reset     ,
    input  [15: 0]      i_delay_param   ,
    output              o_test_valid    ,
    output [511:0]      o_test_data

    );

    /************** ≤‚ ‘ ˝æ›***************/ 
    reg  [15: 0]            delay_count  = 16'd0 ;
    reg  [15: 0]            delay_param  = 16'd0 ;
    reg                     gen_data_en  = 1'd0  ;
    
    reg                     test_valid  ;
    reg  [511: 0]           test_data   ;    


    assign o_test_valid = test_valid    ; 
    assign o_test_data  = test_data     ;


    always @ ( posedge i_sys_clk )
    begin
        if(i_delay_param  == 16'HFFFF)
        begin
            delay_param     <= 0 ;
        end
        else if(i_delay_param == 0)
        begin
            delay_param     <= 16'HFFFF ;
        end 
        else
        begin
            delay_param     <= i_delay_param ;
        end
    end

    always @ ( posedge i_sys_clk )
    begin
        if(delay_param == 16'HFFFF)
        begin
            gen_data_en     <= 1'b0     ;
            delay_count     <= 16'd0    ;
        end
        else if(delay_count >= delay_param)
        begin
            gen_data_en     <= 1'b1     ;
            delay_count     <= 16'd0    ;
        end 
        else
        begin
            gen_data_en     <= 1'b0     ;
            delay_count     <= delay_count + 16'd1  ;
        end
    end

    always @ ( posedge i_sys_clk or posedge i_sys_reset)    
    begin
        if(i_sys_reset)
        begin
            test_data               <= 512'd0   ;
            test_valid              <= 1'b0     ;
        end 
        else if(gen_data_en)
        begin
            test_valid              <= 1'b1     ;
            test_data[0*64+:64]    <= test_data[0*64+:64] + 64'd1 ;
            test_data[1*64+:64]    <= test_data[1*64+:64] + 64'd1 ;
            test_data[2*64+:64]    <= test_data[2*64+:64] + 64'd1 ;
            test_data[3*64+:64]    <= test_data[3*64+:64] + 64'd1 ;
            test_data[4*64+:64]    <= test_data[4*64+:64] + 64'd1 ;
            test_data[5*64+:64]    <= test_data[5*64+:64] + 64'd1 ;
            test_data[6*64+:64]    <= test_data[6*64+:64] + 64'd1 ;
            test_data[7*64+:64]    <= test_data[7*64+:64] + 64'd1 ;
        end
        else
        begin
            test_valid              <= 1'b0     ;
        end
    end


endmodule
