////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: jingpei
// 
// Create Date: 2017/2/18 21:03:29
// Design Name: 
// Module Name: AXI_width_down_chg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: AXIS���߿�����䣺��-�ͱ任
// Dependencies: 
// 
// Updata Date: 2017/3/14 22:13:15
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - ������ֵ�bug
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module AXI_width_down_chg #(
    parameter       DATA_LO_WIDTH       = 16                ,//�Ϳ�����ݿ��
    parameter       DATA_HI_WIDTH       = 32                ,//�߿�����ݿ��
    parameter       SYS_CLK_Period      = 100                //�ο�ʱ�����ڣ���nsΪ��λ
)(
    //���Զ˿�
    output [7 : 0]  t_data_count        ,
    //ȫ��
    input           i_sys_clk           ,//�ο�ʱ��
    input           i_sys_reset         ,//
    //�Ϳ��AXIS�ӿ�
    input                               mAXIS_LO_ready      ,
    output                              mAXIS_LO_valid      ,
    output                              mAXIS_LO_last       ,
    output [DATA_LO_WIDTH     -1 : 0]   mAXIS_LO_keep       ,
    output [DATA_LO_WIDTH   *8-1 : 0]   mAXIS_LO_data       ,
    //�߿��AXIS�ӿ�
    output                              sAXIS_HI_ready      ,
    input                               sAXIS_HI_valid      ,
    input                               sAXIS_HI_last       ,
    input  [DATA_HI_WIDTH     -1 : 0]   sAXIS_HI_keep       ,
    input  [DATA_HI_WIDTH   *8-1 : 0]   sAXIS_HI_data        
);
    genvar          i                   ;

    localparam BUS_REG_CLK              = DATA_HI_WIDTH / DATA_LO_WIDTH;//�������ݽ�����
    
    reg  [7 : 0]    data_reg_count      ;
    wire            data_out_en         ;
    
    wire [DATA_LO_WIDTH     -1 : 0]     AXIS_HI_keep    [0 : BUS_REG_CLK-1];
    wire [DATA_LO_WIDTH   *8-1 : 0]     AXIS_HI_data    [0 : BUS_REG_CLK-1];
    
    wire [BUS_REG_CLK-1 : 0]            AXIS_last_mask  ;
    
    assign mAXIS_LO_valid               = sAXIS_HI_valid    ;
    assign sAXIS_HI_ready               = mAXIS_LO_ready && data_out_en;
    
    assign data_out_en                  = (data_reg_count >= BUS_REG_CLK - 1) || mAXIS_LO_last;
    
    assign mAXIS_LO_last                = (AXIS_last_mask == 'b0) && sAXIS_HI_last;
    assign mAXIS_LO_keep                = AXIS_HI_keep[data_reg_count];
    assign mAXIS_LO_data                = AXIS_HI_data[data_reg_count];
    
    always @ (posedge i_sys_clk or posedge i_sys_reset)
    begin
        if (i_sys_reset)
        begin
            data_reg_count              <= 8'b0             ;
        end
        else if (mAXIS_LO_ready && mAXIS_LO_valid)
        begin
            if (data_out_en)
            begin
                data_reg_count          <= 8'b0             ;
            end 
            else
            begin
                data_reg_count          <= data_reg_count + 8'd1;
            end
        end
        else
        begin
        end 
    end
    
    generate
    for (i=0;i<BUS_REG_CLK;i=i+1)
    begin : bus_chg_gen
        assign AXIS_HI_keep[i]          = sAXIS_HI_keep[(i+1)*DATA_LO_WIDTH  -1 : i*DATA_LO_WIDTH  ];
        assign AXIS_HI_data[i]          = sAXIS_HI_data[(i+1)*DATA_LO_WIDTH*8-1 : i*DATA_LO_WIDTH*8];
        assign AXIS_last_mask[i]        = (data_reg_count < i) && (AXIS_HI_keep[i] != 'b0);
    end 
    endgenerate
    
    assign t_data_count                 = data_reg_count    ;
    
endmodule