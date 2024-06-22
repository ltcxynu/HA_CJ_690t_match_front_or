module tb_spikep_top;

localparam CLKMGT_HPERIOD = 1000.0 / 135.0 / 2.0;
localparam CLK_HPERIOD = 1000.0 / 50.0 / 2.0;

reg clk;
reg rstn;

wire clk_p11;
wire clk_p21;
wire clk_p31;
wire clk_p41;
wire clk_n11;
wire clk_n21;
wire clk_n31;
wire clk_n41;
wire [20:0] lvds_p1;
wire [20:0] lvds_p2;
wire [20:0] lvds_p3;
wire [20:0] lvds_p4;
wire [20:0] lvds_n1;
wire [20:0] lvds_n2;
wire [20:0] lvds_n3;
wire [20:0] lvds_n4;

wire PDLU_EN;
wire PLDU_pixel_RSTN;
wire PDLU_RSTN;
wire PDRU_Mclk_20M;

wire clk_spi;
wire mosi;
wire cs1;
wire cs2;
wire cs3;
wire cs4;
wire led;
wire [1919:0] pixl_data_out;
wire 		pixl_data_out_en;
wire        AXIS_rx_ready;

reg MGT117_P;
wire MGT117_N;
//wire [3:0] QSFP1_TX_P;
//wire [3:0] QSFP1_TX_N;
//wire [3:0] QSFP1_RX_P;
//wire [3:0] QSFP1_RX_N;
//wire F_QSFP1_RESETL;
//wire F_QSFP1_INTL;
//wire F_QSFP1_LPMODE;
//wire F_QSFP1_MODPRSL;
//wire F_QSFP1_MODSELL;


always #CLK_HPERIOD clk = ~clk;
always #CLKMGT_HPERIOD MGT117_P = ~MGT117_P;
assign MGT117_N = ~MGT117_P;
//assign QSFP1_RX_P = QSFP1_TX_P;
//assign QSFP1_RX_N = QSFP1_TX_N;

virtul_top_690t dut (
  //.sys_rst(rstn),
  .F1_EMCCLK (clk),
  .lvds_p1 (lvds_p1),
  .lvds_n1 (lvds_n1),
  .clk_p11 (clk_p11),
  .clk_n11 (clk_n11),
  .lvds_p2 (lvds_p2),
  .lvds_n2 (lvds_n2),
  .clk_p21 (clk_p21),
  .clk_n21 (clk_n21),
  .lvds_p3 (lvds_p3),
  .lvds_n3 (lvds_n3),
  .clk_p31 (clk_p31),
  .clk_n31 (clk_n31),
  .lvds_p4 (lvds_p4),
  .lvds_n4 (lvds_n4),
  .clk_p41 (clk_p41),
  .clk_n41 (clk_n41),
  .PDLU_EN (PDLU_EN),
  .PDLU_pixel_RSTN (PLDU_pixel_RSTN),
  .PDLU_RSTN (PDLU_RSTN),
  .PDRU_Mclk_20M (PDRU_Mclk_20M),
  .clk_spi (clk_spi),
  .mosi (mosi),
  // .miso1 (1'b0),
  // .miso2 (1'b0),
  // .miso3 (1'b0),
  // .miso4 (1'b0),
  .cs1 (cs1),
  .cs2 (cs2),
  .cs3 (cs3),
  .cs4 (cs4),
  .led (led),
  .MGT117_P (MGT117_P),        
  .MGT117_N (MGT117_N),
  .pixl_data_out (pixl_data_out),
  .pixl_data_out_en (pixl_data_out_en),
  .AXIS_rx_ready (AXIS_rx_ready)
  
);

cisBfm #(.SEED(1)) cis0 (

  .en (PDLU_EN),
  .rstn (PDLU_RSTN),
  .mclk_20M (PDRU_Mclk_20M), 
  
  .spiClk (clk_spi),
  .miso (),
  .mosi (mosi),
  .cs (cs1),

  .data0_p (lvds_p1[0]),
  .data0_n (lvds_n1[0]),

  .data1_p (lvds_p1[1]),
  .data1_n (lvds_n1[1]),

  .data2_p (lvds_p1[2]),
  .data2_n (lvds_n1[2]),

  .data3_p (lvds_p1[3]),
  .data3_n (lvds_n1[3]),

  .data4_p (lvds_p1[4]),
  .data4_n (lvds_n1[4]),

  .data5_p (lvds_p1[5]),
  .data5_n (lvds_n1[5]),

  .data6_p (lvds_p1[6]),
  .data6_n (lvds_n1[6]),

  .data7_p (lvds_p1[7]),
  .data7_n (lvds_n1[7]),

  .data8_p (lvds_p1[8]),
  .data8_n (lvds_n1[8]),

  .data9_p (lvds_p1[9]),
  .data9_n (lvds_n1[9]),

  .data10_p (lvds_p1[10]),
  .data10_n (lvds_n1[10]),

  .data11_p (lvds_p1[11]),
  .data11_n (lvds_n1[11]),

  .data12_p (lvds_p1[12]),
  .data12_n (lvds_n1[12]),

  .data13_p (lvds_p1[13]),
  .data13_n (lvds_n1[13]),

  .data14_p (lvds_p1[14]),
  .data14_n (lvds_n1[14]),

  .data15_p (lvds_p1[15]),
  .data15_n (lvds_n1[15]),

  .data16_p (lvds_p1[16]),
  .data16_n (lvds_n1[16]),

  .data17_p (lvds_p1[17]),
  .data17_n (lvds_n1[17]),

  .data18_p (lvds_p1[18]),
  .data18_n (lvds_n1[18]),

  .data19_p (lvds_p1[19]),
  .data19_n (lvds_n1[19]),

  .clk_p (clk_p11),
  .clk_n (clk_n11),

  .frame_p (lvds_p1[20]),
  .frame_n (lvds_n1[20])

);

cisBfm #(.SEED(2)) cis1 ( 
  .en (PDLU_EN),
  .rstn (PDLU_RSTN),
  .mclk_20M (PDRU_Mclk_20M), 
  
  .spiClk (clk_spi),
  .miso (),
  .mosi (mosi),
  .cs (cs2),

  .data0_p (lvds_p2[0]),
  .data0_n (lvds_n2[0]),

  .data1_p (lvds_p2[1]),
  .data1_n (lvds_n2[1]),

  .data2_p (lvds_p2[2]),
  .data2_n (lvds_n2[2]),

  .data3_p (lvds_p2[3]),
  .data3_n (lvds_n2[3]),

  .data4_p (lvds_p2[4]),
  .data4_n (lvds_n2[4]),

  .data5_p (lvds_p2[5]),
  .data5_n (lvds_n2[5]),

  .data6_p (lvds_p2[6]),
  .data6_n (lvds_n2[6]),

  .data7_p (lvds_p2[7]),
  .data7_n (lvds_n2[7]),

  .data8_p (lvds_p2[8]),
  .data8_n (lvds_n2[8]),

  .data9_p (lvds_p2[9]),
  .data9_n (lvds_n2[9]),

  .data10_p (lvds_p2[10]),
  .data10_n (lvds_n2[10]),

  .data11_p (lvds_p2[11]),
  .data11_n (lvds_n2[11]),

  .data12_p (lvds_p2[12]),
  .data12_n (lvds_n2[12]),

  .data13_p (lvds_p2[13]),
  .data13_n (lvds_n2[13]),

  .data14_p (lvds_p2[14]),
  .data14_n (lvds_n2[14]),

  .data15_p (lvds_p2[15]),
  .data15_n (lvds_n2[15]),

  .data16_p (lvds_p2[16]),
  .data16_n (lvds_n2[16]),

  .data17_p (lvds_p2[17]),
  .data17_n (lvds_n2[17]),

  .data18_p (lvds_p2[18]),
  .data18_n (lvds_n2[18]),

  .data19_p (lvds_p2[19]),
  .data19_n (lvds_n2[19]),

  .clk_p (clk_p21),
  .clk_n (clk_n21),

  .frame_p (lvds_p2[20]),
  .frame_n (lvds_n2[20])

);

cisBfm #(.SEED(3)) cis2 (

  .en (PDLU_EN),
  .rstn (PDLU_RSTN),
  .mclk_20M (PDRU_Mclk_20M), 
  
  .spiClk (clk_spi),
  .miso (),
  .mosi (mosi),
  .cs (cs3),

  .data0_p (lvds_p3[0]),
  .data0_n (lvds_n3[0]),

  .data1_p (lvds_p3[1]),
  .data1_n (lvds_n3[1]),

  .data2_p (lvds_p3[2]),
  .data2_n (lvds_n3[2]),

  .data3_p (lvds_p3[3]),
  .data3_n (lvds_n3[3]),

  .data4_p (lvds_p3[4]),
  .data4_n (lvds_n3[4]),

  .data5_p (lvds_p3[5]),
  .data5_n (lvds_n3[5]),

  .data6_p (lvds_p3[6]),
  .data6_n (lvds_n3[6]),

  .data7_p (lvds_p3[7]),
  .data7_n (lvds_n3[7]),

  .data8_p (lvds_p3[8]),
  .data8_n (lvds_n3[8]),

  .data9_p (lvds_p3[9]),
  .data9_n (lvds_n3[9]),

  .data10_p (lvds_p3[10]),
  .data10_n (lvds_n3[10]),

  .data11_p (lvds_p3[11]),
  .data11_n (lvds_n3[11]),

  .data12_p (lvds_p3[12]),
  .data12_n (lvds_n3[12]),

  .data13_p (lvds_p3[13]),
  .data13_n (lvds_n3[13]),

  .data14_p (lvds_p3[14]),
  .data14_n (lvds_n3[14]),

  .data15_p (lvds_p3[15]),
  .data15_n (lvds_n3[15]),

  .data16_p (lvds_p3[16]),
  .data16_n (lvds_n3[16]),

  .data17_p (lvds_p3[17]),
  .data17_n (lvds_n3[17]),

  .data18_p (lvds_p3[18]),
  .data18_n (lvds_n3[18]),

  .data19_p (lvds_p3[19]),
  .data19_n (lvds_n3[19]),

  .clk_p (clk_p31),
  .clk_n (clk_n31),

  .frame_p (lvds_p3[20]),
  .frame_n (lvds_n3[20])

);

cisBfm #(.SEED(4)) cis3 (

  .en (PDLU_EN),
  .rstn (PDLU_RSTN),
  .mclk_20M (PDRU_Mclk_20M), 
  
  .spiClk (clk_spi),
  .miso (),
  .mosi (mosi),
  .cs (cs4),

  .data0_p (lvds_p4[0]),
  .data0_n (lvds_n4[0]),

  .data1_p (lvds_p4[1]),
  .data1_n (lvds_n4[1]),

  .data2_p (lvds_p4[2]),
  .data2_n (lvds_n4[2]),

  .data3_p (lvds_p4[3]),
  .data3_n (lvds_n4[3]),

  .data4_p (lvds_p4[4]),
  .data4_n (lvds_n4[4]),

  .data5_p (lvds_p4[5]),
  .data5_n (lvds_n4[5]),

  .data6_p (lvds_p4[6]),
  .data6_n (lvds_n4[6]),

  .data7_p (lvds_p4[7]),
  .data7_n (lvds_n4[7]),

  .data8_p (lvds_p4[8]),
  .data8_n (lvds_n4[8]),

  .data9_p (lvds_p4[9]),
  .data9_n (lvds_n4[9]),

  .data10_p (lvds_p4[10]),
  .data10_n (lvds_n4[10]),

  .data11_p (lvds_p4[11]),
  .data11_n (lvds_n4[11]),

  .data12_p (lvds_p4[12]),
  .data12_n (lvds_n4[12]),

  .data13_p (lvds_p4[13]),
  .data13_n (lvds_n4[13]),

  .data14_p (lvds_p4[14]),
  .data14_n (lvds_n4[14]),

  .data15_p (lvds_p4[15]),
  .data15_n (lvds_n4[15]),

  .data16_p (lvds_p4[16]),
  .data16_n (lvds_n4[16]),

  .data17_p (lvds_p4[17]),
  .data17_n (lvds_n4[17]),

  .data18_p (lvds_p4[18]),
  .data18_n (lvds_n4[18]),

  .data19_p (lvds_p4[19]),
  .data19_n (lvds_n4[19]),

  .clk_p (clk_p41),
  .clk_n (clk_n41),

  .frame_p (lvds_p4[20]),
  .frame_n (lvds_n4[20])

);

initial begin
//  $vcdpluson;
  clk = 1'b0;
  rstn = 1'b0;
  MGT117_P = 1'b0;

  #100
  rstn = 1'b1;
  //if ($test$plusargs("dump")) begin
  //  $fsdbDumpfile("spike_top.fsdb");
  //  $fsdbDumpvars;
  //end

  #1000
  ;
  //force dut.soft_resetn = 1'b1;
//  force dut.aurora_rx_ready = 1'b1;

  #100000000
  ;
  $stop;

//  $finish;
end

//initial begin
//  forever begin
//    @(negedge dut.user_clk_i);
//    if (dut.aurora_rx_valid) begin
//      $write("%064x\n", dut.aurora_rx_data);
//    end
//  end
//end

endmodule
