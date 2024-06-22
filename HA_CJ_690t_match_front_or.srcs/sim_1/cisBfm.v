//
//
// Bus Function Model for CMOS Image Sensor
//
//
//

module cisBfm #(
  parameter VA = 500,
  parameter LINE_WIDTH = 500,
  parameter NUM_CH = 20,
  parameter SEED = 1
) (

  input en,
  input rstn,
  input mclk_20M, 
  
  input spiClk,
  output miso,
  input mosi,
  input cs,

  output data0_p,
  output data0_n,

  output data1_p,
  output data1_n,

  output data2_p,
  output data2_n,

  output data3_p,
  output data3_n,

  output data4_p,
  output data4_n,

  output data5_p,
  output data5_n,

  output data6_p,
  output data6_n,

  output data7_p,
  output data7_n,

  output data8_p,
  output data8_n,

  output data9_p,
  output data9_n,

  output data10_p,
  output data10_n,

  output data11_p,
  output data11_n,

  output data12_p,
  output data12_n,

  output data13_p,
  output data13_n,

  output data14_p,
  output data14_n,

  output data15_p,
  output data15_n,

  output data16_p,
  output data16_n,

  output data17_p,
  output data17_n,

  output data18_p,
  output data18_n,

  output data19_p,
  output data19_n,

  output clk_p,
  output clk_n,

  output frame_p,
  output frame_n

);

localparam CLK_HPERIOD = 1000.0 / 250.0 / 2.0; // 250Mhz
//localparam CLK_HPERIOD = 1000.0 / 266.0 / 2.0; // 500Mhz

reg [31:0] cntLine;
reg [4:0] cntPix;
reg [19:0] data;
reg clk_int;
reg clk;
reg frame;
reg [3:0] spiCnt;
reg [13:0] spiReg;
reg lvds_en;

wire [LINE_WIDTH-1:0] pix;
reg [7:0] byteBuf[0:(LINE_WIDTH-1)/8];
wire [24:0] ch0; // corresponds to data channel
wire [24:0] ch1; // corresponds to data channel
wire [24:0] ch2; // corresponds to data channel
wire [24:0] ch3; // corresponds to data channel
wire [24:0] ch4; // corresponds to data channel
wire [24:0] ch5; // corresponds to data channel
wire [24:0] ch6; // corresponds to data channel
wire [24:0] ch7; // corresponds to data channel
wire [24:0] ch8; // corresponds to data channel
wire [24:0] ch9; // corresponds to data channel
wire [24:0] ch10; // corresponds to data channel
wire [24:0] ch11; // corresponds to data channel
wire [24:0] ch12; // corresponds to data channel
wire [24:0] ch13; // corresponds to data channel
wire [24:0] ch14; // corresponds to data channel
wire [24:0] ch15; // corresponds to data channel
wire [24:0] ch16; // corresponds to data channel
wire [24:0] ch17; // corresponds to data channel
wire [24:0] ch18; // corresponds to data channel
wire [24:0] ch19; // corresponds to data channel
integer i;

/*
wire [24:0] pat0 = {1'b1,{6{4'b0101}}};
wire [24:0] pat1 = {25{1'b0}};
wire [24:0] pat2 = ~pat0;
wire [24:0] pat3 = ~pat1;

assign pix = {5{pat3,pat2,pat1,pat0}};
*/

assign pix = {
  byteBuf[62],
  byteBuf[61],
  byteBuf[60],
  byteBuf[59],
  byteBuf[58],
  byteBuf[57],
  byteBuf[56],
  byteBuf[55],
  byteBuf[54],
  byteBuf[53],
  byteBuf[52],
  byteBuf[51],
  byteBuf[50],
  byteBuf[49],
  byteBuf[48],
  byteBuf[47],
  byteBuf[46],
  byteBuf[45],
  byteBuf[44],
  byteBuf[43],
  byteBuf[42],
  byteBuf[41],
  byteBuf[40],
  byteBuf[39],
  byteBuf[38],
  byteBuf[37],
  byteBuf[36],
  byteBuf[35],
  byteBuf[34],
  byteBuf[33],
  byteBuf[32],
  byteBuf[31],
  byteBuf[30],
  byteBuf[29],
  byteBuf[28],
  byteBuf[27],
  byteBuf[26],
  byteBuf[25],
  byteBuf[24],
  byteBuf[23],
  byteBuf[22],
  byteBuf[21],
  byteBuf[20],
  byteBuf[19],
  byteBuf[18],
  byteBuf[17],
  byteBuf[16],
  byteBuf[15],
  byteBuf[14],
  byteBuf[13],
  byteBuf[12],
  byteBuf[11],
  byteBuf[10],
  byteBuf[9],
  byteBuf[8],
  byteBuf[7],
  byteBuf[6],
  byteBuf[5],
  byteBuf[4],
  byteBuf[3],
  byteBuf[2],
  byteBuf[1],
  byteBuf[0]
};

assign ch0 = pix[24:0];
assign ch1 = pix[49:25];
assign ch2 = pix[74:50];
assign ch3 = pix[99:75];
assign ch4 = pix[124:100];
assign ch5 = pix[149:125];
assign ch6 = pix[174:150];
assign ch7 = pix[199:175];
assign ch8 = pix[224:200];
assign ch9 = pix[249:225];
assign ch10 = pix[274:250];
assign ch11 = pix[299:275];
assign ch12 = pix[324:300];
assign ch13 = pix[349:325];
assign ch14 = pix[374:350];
assign ch15 = pix[399:375];
assign ch16 = pix[424:400];
assign ch17 = pix[449:425];
assign ch18 = pix[474:450];
assign ch19 = pix[499:475];

assign data0_p = data[0];
assign data0_n = ~data[0];

assign data1_p = data[1];
assign data1_n = ~data[1];

assign data2_p = data[2];
assign data2_n = ~data[2];

assign data3_p = data[3];
assign data3_n = ~data[3];

assign data4_p = data[4];
assign data4_n = ~data[4];

assign data5_p = data[5];
assign data5_n = ~data[5];

assign data6_p = data[6];
assign data6_n = ~data[6];

assign data7_p = data[7];
assign data7_n = ~data[7];

assign data8_p = data[8];
assign data8_n = ~data[8];

assign data9_p = data[9];
assign data9_n = ~data[9];

assign data10_p = data[10];
assign data10_n = ~data[10];

assign data11_p = data[11];
assign data11_n = ~data[11];

assign data12_p = data[12];
assign data12_n = ~data[12];

assign data13_p = data[13];
assign data13_n = ~data[13];

assign data14_p = data[14];
assign data14_n = ~data[14];

assign data15_p = data[15];
assign data15_n = ~data[15];

assign data16_p = data[16];
assign data16_n = ~data[16];

assign data17_p = data[17];
assign data17_n = ~data[17];

assign data18_p = data[18];
assign data18_n = ~data[18];

assign data19_p = data[19];
assign data19_n = ~data[19];

//assign clk_p = clk&lvds_en;
//assign clk_n = ~(clk&lvds_en);
assign clk_p = clk;
assign clk_n = ~(clk);
assign frame_p = frame;
assign frame_n = ~frame;

// clk generation
initial begin

  clk = 1'b0;
  clk_int = 1'b0;
  spiCnt = 4'd0;
  spiReg = 14'h0;
  lvds_en = 1'b0;

  repeat (100) begin
    @(posedge mclk_20M);
  end 
  
  #CLK_HPERIOD
  clk_int = 1'b1;
  #CLK_HPERIOD
  clk_int = 1'b0;

  forever begin
    #CLK_HPERIOD
    {clk_int,clk} = 2'b11;
    #CLK_HPERIOD
    {clk_int,clk} = 2'b00;
  end
end

initial begin

  cntLine = 32'h0;
  cntPix = 5'd0;
  data = 20'h0;
  frame = 1'b0;

  for(i=0;i<=((LINE_WIDTH-1)/8);i=i+1) begin  // populate line buffer
    byteBuf[i] = i[7:0];
  end

  wait (en===1'b1); // wait for enable

  // check spi lvds enable
  begin: spi_en_loop
    forever begin
      @(posedge spiClk);
      if (cs) begin 
        spiReg <= {spiReg[12:0], mosi};
        spiCnt <= spiCnt + 1'b1;
        if (spiCnt == 4'd13) begin
            @(negedge cs);
            spiCnt <= 4'd0;
            if (spiReg[13:0] == 14'h1700) begin
                @(negedge clk); // avoid clipping clk_p which is lvds_en&clk
                lvds_en <= 1'b1;
                #0.01;
                disable spi_en_loop;
            end
        end
      end
    end
  end

  `ifdef CIS_DELAY_TEST
    fork
      begin 
        `ifdef FAST_SIM
          #10000;
        `else
          #10000000; // needs to hold low for 10ms
        `endif
        disable timingcheck_rstn;
      end

      begin: timingcheck_rstn
        wait((rstn|mclk_20M)===1'b1);
        $write("rstn or mclk_20M rise too early (<1ms after posedge(en)), stop.\n");
        $stop;
      end
    join
 
    wait (rstn===1'b1); // wait for rstn deassertion

    fork 
      begin
        `ifdef FAST_SIM
          #1000;
        `else
          #1000000; // needs to hold low for 1ms after rstn deassertion
        `endif
        disable timingcheck_mclk ;
      end

      begin: timingcheck_mclk
        wait(mclk_20M===1'b1);
        $write("mclk_20M rise too early (<10ms after poesdge (rstn)), stop.\n");
        $stop;
      end
    join
  `endif

  fork
    begin
      wait ((en&rstn)===1'b0); // monitor if en&rstn pulled low
      $write("en or rstn pulled low at %t\n", $time);
      disable dataLoop; // cut off the data output
    end

    begin: dataLoop

      //repeat ($urandom(SEED)%2500) begin
        //@(posedge clk_int);
      //end

      forever begin

        fork
          begin
            @(negedge clk_int);
            cntPix <= cntPix + 1'b1;
            if (cntPix==(LINE_WIDTH/NUM_CH)) begin // time to pull frame low cntLine <= cntLine + 1'b1;
              cntPix <= 5'd1;
              cntLine <= cntLine + 1'b1;
              for (i=0;i<=((LINE_WIDTH-1)/8);i=i+1) begin
                if (i==0) begin
                  byteBuf[i] <= byteBuf[(LINE_WIDTH-1)/8];
                end else begin
                  //byteBuf[i] <= byteBuf[i] + 1'b1; // update byteBuf upon line jump
                  byteBuf[i] <= byteBuf[i-1]; // update byteBuf upon line jump
                end
              end
              if (cntLine==(VA-1'b1)) begin
                cntLine <= 0;
                $write("re-populate line buffer at %t\n", $time);
                for(i=0;i<=((LINE_WIDTH-1)/8);i=i+1) begin  // populate line buffer again
                   byteBuf[i] <= i[7:0];
                end
              end
            end
          end

          begin
            @(posedge clk);

            if ((cntLine===32'h0)&&(cntPix===5'd1)) begin // line start, raise frame
              frame <= 1'b1;
            end else begin
              if ((cntLine==32'h1)&&(cntPix==5'd1)) begin
                frame <= 1'b0;
              end
            end

            data[0] <= ch0[cntPix-1];
            data[1] <= ch1[cntPix-1];
            data[2] <= ch2[cntPix-1];
            data[3] <= ch3[cntPix-1];
            data[4] <= ch4[cntPix-1];
            data[5] <= ch5[cntPix-1];
            data[6] <= ch6[cntPix-1];
            data[7] <= ch7[cntPix-1];
            data[8] <= ch8[cntPix-1];
            data[9] <= ch9[cntPix-1];
            data[10] <= ch10[cntPix-1];
            data[11] <= ch11[cntPix-1];
            data[12] <= ch12[cntPix-1];
            data[13] <= ch13[cntPix-1];
            data[14] <= ch14[cntPix-1];
            data[15] <= ch15[cntPix-1];
            data[16] <= ch16[cntPix-1];
            data[17] <= ch17[cntPix-1];
            data[18] <= ch18[cntPix-1];
            data[19] <= ch19[cntPix-1];
          end
        join
      end
    end
  join

end


endmodule
