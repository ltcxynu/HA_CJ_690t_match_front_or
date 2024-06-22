`timescale 1ns / 1ps
module pixl_top_virtual #(
    parameter VA = 500
)(
	
	input rstn
	,input clk10m
	,input clk20m
	,input clk100m
	,input clk200m
	,input clk125m

	,input     fifo_wr_ready
//pixl data out
	,output wire [1919:0] pixl_data_out
	,(* mark_debug= "TRUE" *)output wire 		pixl_data_out_en
    );
//region 数据产生
//sensor capture is deleted,
// use generate data for fifo,
// then ppram,
// then statemachine!
reg [511:0] data1_to_fifo;
wire 		 data1_to_fifo_en;
wire 		data1_to_fifo_clk;
reg [511:0] data2_to_fifo;
wire 		 data2_to_fifo_en;
wire 		data2_to_fifo_clk;
reg [511:0] data3_to_fifo;
wire 		 data3_to_fifo_en;
wire 		data3_to_fifo_clk;
reg [511:0] data4_to_fifo;
wire 		 data4_to_fifo_en;
wire 		data4_to_fifo_clk;
assign data1_to_fifo_clk = clk125m;
assign data2_to_fifo_clk = clk125m;
assign data3_to_fifo_clk = clk125m;
assign data4_to_fifo_clk = clk125m;
//20000frame/s * 500line/frame = 10_000_000 line/s
//125M cycle/s / 10M line/s = 12.5 cycle/line 向上取整，选择12
reg [7:0] data_gen_cnt; //0~11
always@(posedge clk125m) begin
  if(!rstn) begin
    data_gen_cnt <= 'd0;
  end else if(data_gen_cnt == 'd11) begin
    data_gen_cnt <= 'd0;
  end else begin
    data_gen_cnt <= data_gen_cnt + 1;
  end
end
reg [8:0] lines;
always@(posedge clk125m) begin
  if(!rstn) begin
    lines <= 'd0;
  end else if(data_gen_cnt == 'd11) begin
    if(lines == 'd499)
      lines <= 'd0;
    else
      lines <= lines + 'd1;
  end
end
always@(posedge clk125m) begin
  if(!rstn) begin
    data1_to_fifo <= {2'b00,lines,{125{4'ha}}};
    data2_to_fifo <= {2'b01,lines,{125{4'hc}}};
    data3_to_fifo <= {2'b10,lines,{125{4'h5}}};
    data4_to_fifo <= {2'b11,lines,{125{4'h7}}};
  end else if(data_gen_cnt == 'd1) begin
    data1_to_fifo <= {2'b00,lines,data4_to_fifo[499:0]};
    data2_to_fifo <= {2'b01,lines,data1_to_fifo[499:0]};
    data3_to_fifo <= {2'b10,lines,data2_to_fifo[499:0]};
    data4_to_fifo <= {2'b11,lines,data3_to_fifo[499:0]};
  end
end
assign data1_to_fifo_en = data_gen_cnt == 'd3;
assign data2_to_fifo_en = data_gen_cnt == 'd5;
assign data3_to_fifo_en = data_gen_cnt == 'd7;
assign data4_to_fifo_en = data_gen_cnt == 'd9;
//region 你的错误！
wire [8:0] pix_waddr1;
wire [8:0] pix_waddr2;
wire [8:0] pix_waddr3;
wire [8:0] pix_waddr4;
//---------------------------------------------------------------
//--fifo
(* mark_debug= "TRUE" *)reg 		data1_frome_fifo_en;
wire [511:0]	data1_frome_fifo;
wire 		data1_frome_fifo_clk;
wire [09:0]	data1_rd_data_count;
(* mark_debug= "TRUE" *)reg 		data2_frome_fifo_en;
wire [511:0]	data2_frome_fifo;
wire 		data2_frome_fifo_clk;
wire [09:0]	data2_rd_data_count;
(* mark_debug= "TRUE" *)reg 		data3_frome_fifo_en;
wire [511:0]	data3_frome_fifo;
wire 		data3_frome_fifo_clk;
wire [09:0]	data3_rd_data_count;
(* mark_debug= "TRUE" *)reg 		data4_frome_fifo_en;
wire [511:0]	data4_frome_fifo;
wire 		data4_frome_fifo_clk;
wire [09:0]	data4_rd_data_count;


reg fifo_rst;
reg [7:0]	delay_cnt;

assign data1_frome_fifo_clk	=clk125m;
assign data2_frome_fifo_clk	=clk125m;
assign data3_frome_fifo_clk	=clk125m;
assign data4_frome_fifo_clk	=clk125m;

//------match---------

function [499:0] reverse_bits;
input [499:0] bits;
integer j;
begin
  for (j=0;j<500;j=j+1) begin
    reverse_bits[j] = bits[499-j];
  end
end
endfunction

reg fifo_wr;
(* mark_debug= "TRUE" *)reg [2:0] state;
reg [2:0] nstate;
(* mark_debug= "TRUE" *)wire rd_mid;
(* mark_debug= "TRUE" *)reg [8:0] cnt_rd;
(* mark_debug= "TRUE" *)reg [10:0] cnt_line;

//ppram control
(* mark_debug= "TRUE" *)wire pix_empty1;
(* mark_debug= "TRUE" *)wire pix_empty2;
(* mark_debug= "TRUE" *)wire pix_empty3;
(* mark_debug= "TRUE" *)wire pix_empty4;
wire pix_rd1;
wire pix_rd2;
wire pix_rd3;
wire pix_rd4;
(* mark_debug= "TRUE" *)wire [8:0] pix_raddr1;
wire [8:0] pix_raddr2;
wire [8:0] pix_raddr3;
wire [8:0] pix_raddr4;

(* mark_debug= "TRUE" *)reg [8:0] cnt_wr1;
(* mark_debug= "TRUE" *)wire wr_done1;
(* mark_debug= "TRUE" *)wire pp_ram_full1;
(* mark_debug= "TRUE" *)wire pix_rd_done1;
reg [8:0] cnt_wr2;
(* mark_debug= "TRUE" *)wire wr_done2;
(* mark_debug= "TRUE" *)wire pp_ram_full2;
(* mark_debug= "TRUE" *)wire pix_rd_done2;
reg [8:0] cnt_wr3;
(* mark_debug= "TRUE" *)wire wr_done3;
(* mark_debug= "TRUE" *)wire pp_ram_full3;
(* mark_debug= "TRUE" *)wire pix_rd_done3;
reg [8:0] cnt_wr4;
(* mark_debug= "TRUE" *)wire wr_done4;
(* mark_debug= "TRUE" *)wire pp_ram_full4;
(* mark_debug= "TRUE" *)wire pix_rd_done4;

//data
wire [999:0] linePix_upper; 
wire [1999:0] linePix_reorder;
reg [1919:0] linePix_out;
(* mark_debug= "TRUE" *)wire [959:0] linePix_out_high;
(* mark_debug= "TRUE" *)wire [959:0] linePix_out_low;
(* mark_debug= "TRUE" *)wire [511:0] pix_rdata1;
wire [511:0] pix_rdata2;
wire [511:0] pix_rdata3;
wire [511:0] pix_rdata4;
(* mark_debug= "TRUE" *)wire [511:0] pix_rdata2_reverse;

//fifo
(* mark_debug= "TRUE" *)wire fifo_empty1;
(* mark_debug= "TRUE" *)wire fifo_full1;
(* mark_debug= "TRUE" *)wire fifo_empty2;
(* mark_debug= "TRUE" *)wire fifo_full2;
(* mark_debug= "TRUE" *)wire fifo_empty3;
(* mark_debug= "TRUE" *)wire fifo_full3;
(* mark_debug= "TRUE" *)wire fifo_empty4;
(* mark_debug= "TRUE" *)wire fifo_full4;

localparam IDLE = 3'd0;
localparam FR = 3'd1;			//first row
localparam PRE_UPPER = 3'd2;	//40row
localparam MIDDLE = 3'd3;
localparam PRE_LOWER = 3'd4;	//40row
localparam LR = 3'd5;			//last row

always @(posedge clk125m or negedge rstn) begin		
  if (!rstn) begin
    fifo_wr <= 1'b0;
  end else begin
    fifo_wr <= (rd_mid&&(cnt_line>=11'd41)) || (cnt_line==11'd1039) || (fifo_wr_ready&&((state==FR)||(state==PRE_UPPER)||(state==PRE_LOWER)||(state==LR)));
  end
end

always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    state <= IDLE;
  end else begin
    state <= nstate;
  end
end

assign rd_mid =(state==MIDDLE)&& !(pix_empty1||pix_empty2||pix_empty3||pix_empty4)&& fifo_wr_ready;		//MIDDLE
//assign fifo_temp = fifo_rd ||((!fifo_full)&&(!(fifo_near_full && fifo_wr)));	

assign pix_rd1 = rd_mid;
assign pix_rd2 = rd_mid;
assign pix_rd3 = rd_mid;		
assign pix_rd4 = rd_mid;	

always @(*) begin
	nstate = state;
	case(state)
		IDLE: if (fifo_wr_ready) begin
				nstate = FR;
			  end
		FR: if (fifo_wr_ready) begin
				nstate = PRE_UPPER;
			  end
		PRE_UPPER: if (fifo_wr_ready &&(cnt_line==11'd39)) begin
				nstate = MIDDLE;
			  end
		MIDDLE: if (fifo_wr_ready &&(cnt_line==11'd1039)) begin
				nstate = PRE_LOWER;
			  end
		PRE_LOWER: if (fifo_wr_ready &&(cnt_line==11'd1078)) begin
				nstate = LR;
			  end
		LR: if (fifo_wr_ready &&(cnt_line==11'd1079)) begin
				nstate = IDLE;
			  end
		default: nstate = state;
	endcase
end

always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    cnt_rd <= 9'd0;
  end else begin
    if ((rd_mid&&cnt_line[0])||((state==MIDDLE)&&(cnt_line==11'd1039))) begin		//һ��������Σ�cnt_rd��+1
      if (cnt_rd == (VA-1)) begin
        cnt_rd <= 9'd0;
      end
      else
              cnt_rd <= cnt_rd + 1'b1;
    end
    else
        cnt_rd <= cnt_rd;
  end
end

always@(posedge clk125m or negedge rstn) begin
	if(!rstn)
		cnt_line <=11'd0;
	else if ((rd_mid)||((fifo_wr_ready)&&((state==FR)||(state==PRE_UPPER)||(state==PRE_LOWER)||(state==LR)))) begin		
      if (cnt_line == 11'd1079) 
        cnt_line <= 11'd0;
      else 
              cnt_line <= cnt_line + 1'b1;
    end
    else
        cnt_line <= cnt_line;
end

assign pix_raddr1 = (VA-1) - cnt_rd;		
assign pix_raddr2 = (VA-1) - cnt_rd;
assign pix_raddr3 = cnt_rd;
assign pix_raddr4 = cnt_rd;

assign pix_rdata2_reverse = {pix_rdata2[511:500],reverse_bits(pix_rdata2[499:0])};
assign linePix_upper = {pix_rdata2_reverse[499:0], pix_rdata1[499:0]};

genvar i;
for(i=0; i<1000; i=i+1)begin
	assign linePix_reorder[i*2] = linePix_upper[i];
	assign linePix_reorder[i*2+1] = linePix_upper[i];
end

always@(posedge clk125m or negedge rstn) begin
	if(!rstn)
		linePix_out <= 1920'b0;
	else begin
	case (state)
		IDLE: 		linePix_out <= 1920'b0;
		FR: 		linePix_out <= {48'hffff_ffff_ffff,1872'b0};
		PRE_UPPER: 	linePix_out <= 1920'b0;
		MIDDLE: 	linePix_out <= cnt_line[0]? linePix_reorder[40+:1920]:linePix_out;
		PRE_LOWER: 	linePix_out <= (cnt_line==11'd1039)?linePix_out:1920'b0;
		LR: 		linePix_out <= {48'hffff_ffff_ffff,1872'b0};
	endcase
	end
end

assign pixl_data_out = linePix_out;		//gt_rx_afifo��data����
assign pixl_data_out_en = fifo_wr;
assign linePix_out_high = linePix_out[1919:960];
assign linePix_out_low = linePix_out[959:0];

//------------------ppram1---------------//
//
(* mark_debug="true" *)reg down_sampling_reg1;
wire [511:0] pix_rdata1_odd;
wire [511:0] pix_rdata1_even;
(* mark_debug="true" *)wire pix_empty1_odd;
(* mark_debug="true" *)wire pix_empty1_even;
(* mark_debug="true" *)wire pp_ram_full1_odd;
(* mark_debug="true" *)wire pp_ram_full1_even;

always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    down_sampling_reg1 <= 'd1;
  end else begin
    if (data1_frome_fifo_en) begin
      if (pix_waddr1 == (VA-1)) begin
        down_sampling_reg1<=!down_sampling_reg1;
      end
    end
  end
end

pp_pix #(.VA(VA)) u_pp_pix1 (
  .clk_i (clk125m),
  .resetz_i (rstn),
  .pp_ram_wr_done_i     (wr_done1&(down_sampling_reg1=='d1)  ),
  .pp_ram_rd_done_i     (pix_rd_done1                       ),
  .pp_ram_full_o        (pp_ram_full1_odd                       ),
  .pp_ram_empty_o       (pix_empty1_odd                         ),
  .pix_raddr_i          (pix_raddr1                         ),
  .pix_rd_i             (pix_rd1                            ),
  .pix_waddr_i          (pix_waddr1),
  .pix_wdata_i          (data1_frome_fifo                          ),
  .pix_wr_i             (data1_frome_fifo_en&down_sampling_reg1    ),
  .pix_rdata_o          (pix_rdata1_odd                         )
);
pp_pix #(.VA(VA)) u_pp_pix1_downSampling (
  .clk_i (clk125m),
  .resetz_i (rstn),
  .pp_ram_wr_done_i     (wr_done1&(down_sampling_reg1=='d0)   ),
  .pp_ram_rd_done_i     (pix_rd_done1                       ),
  .pp_ram_full_o        (pp_ram_full1_even                       ),
  .pp_ram_empty_o       (pix_empty1_even                         ),
  .pix_raddr_i          (pix_raddr1                         ),
  .pix_rd_i             (pix_rd1                            ),
  .pix_waddr_i          (pix_waddr1                            ),
  .pix_wdata_i          (data1_frome_fifo                          ),
  .pix_wr_i             (data1_frome_fifo_en&(!down_sampling_reg1) ),
  .pix_rdata_o          (pix_rdata1_even                         )
);

always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    cnt_wr1 <= 9'd0;
  end else begin
    if (data1_frome_fifo_en) begin
      if (cnt_wr1 == (VA-1)) begin
        cnt_wr1 <= 9'd0;
      end
      else
        cnt_wr1 <= cnt_wr1 + 1'b1;
    end
  end
end

assign pix_rdata1 = pix_rdata1_even| pix_rdata1_odd;
assign pix_empty1 = pix_empty1_even| pix_empty1_odd;
assign pp_ram_full1 = pp_ram_full1_even | pp_ram_full1_odd;
assign wr_done1 = (data1_frome_fifo_en&&(cnt_wr1 == (VA - 1))) ? 1'b1 : 1'b0;
assign pix_waddr1 = data1_frome_fifo[508:500];
assign pix_rd_done1 = rd_mid && (cnt_rd == 9'd499);
//

//------------------ppram2---------------//
//
(* mark_debug="true" *)reg down_sampling_reg2;
wire [511:0] pix_rdata1_odd;
wire [511:0] pix_rdata1_even;
(* mark_debug="true" *)wire pix_empty2_odd;
(* mark_debug="true" *)wire pix_empty2_even;
(* mark_debug="true" *)wire pp_ram_full2_odd;
(* mark_debug="true" *)wire pp_ram_full2_even;

always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    down_sampling_reg2 <= 'd1;
  end else begin
    if (data2_frome_fifo_en) begin
      if (pix_waddr2 == (VA-1)) begin
        down_sampling_reg2<=!down_sampling_reg2;
      end
    end
  end
end

pp_pix #(.VA(VA)) u_pp_pix2 (
  .clk_i (clk125m),
  .resetz_i (rstn),
  .pp_ram_wr_done_i     (wr_done2&(down_sampling_reg2=='d1)  ),
  .pp_ram_rd_done_i     (pix_rd_done2                       ),
  .pp_ram_full_o        (pp_ram_full2_odd                       ),
  .pp_ram_empty_o       (pix_empty2_odd                         ),
  .pix_raddr_i          (pix_raddr2                         ),
  .pix_rd_i             (pix_rd2                            ),
  .pix_waddr_i          (pix_waddr2),
  .pix_wdata_i          (data2_frome_fifo                          ),
  .pix_wr_i             (data2_frome_fifo_en&down_sampling_reg2    ),
  .pix_rdata_o          (pix_rdata2_odd                         )
);
pp_pix #(.VA(VA)) u_pp_pix2_downSampling (
  .clk_i (clk125m),
  .resetz_i (rstn),
  .pp_ram_wr_done_i     (wr_done2&(down_sampling_reg2=='d0)   ),
  .pp_ram_rd_done_i     (pix_rd_done2                       ),
  .pp_ram_full_o        (pp_ram_full2_even                       ),
  .pp_ram_empty_o       (pix_empty2_even                         ),
  .pix_raddr_i          (pix_raddr2                         ),
  .pix_rd_i             (pix_rd2                            ),
  .pix_waddr_i          (pix_waddr2                            ),
  .pix_wdata_i          (data2_frome_fifo                          ),
  .pix_wr_i             (data2_frome_fifo_en&(!down_sampling_reg2) ),
  .pix_rdata_o          (pix_rdata2_even                         )
);

always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    cnt_wr2 <= 9'd0;
  end else begin
    if (data2_frome_fifo_en) begin
      if (cnt_wr2 == (VA-1)) begin
        cnt_wr2 <= 9'd0;
      end
      else
        cnt_wr2 <= cnt_wr2 + 1'b1;
    end
  end
end

assign pix_rdata2 = pix_rdata2_even| pix_rdata2_odd;
assign pix_empty2 = pix_empty2_even| pix_empty2_odd;
assign pp_ram_full2 = pp_ram_full2_even | pp_ram_full2_odd;
assign wr_done2 = (data2_frome_fifo_en&&(cnt_wr2 == (VA - 1))) ? 1'b1 : 1'b0;
assign pix_waddr2 = data2_frome_fifo[508:500];
assign pix_rd_done2 = rd_mid && (cnt_rd == 9'd499);
//

//------------------ppram3---------------//
//
(* mark_debug="true" *)reg down_sampling_reg3;
wire [511:0] pix_rdata3_odd;
wire [511:0] pix_rdata3_even;
wire pix_empty3_odd;
wire pix_empty3_even;
wire pp_ram_full3_odd;
wire pp_ram_full3_even;

always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    down_sampling_reg3 <= 'd1;
  end else begin
    if (data3_frome_fifo_en) begin
      if (pix_waddr3 == (VA-1)) begin
        down_sampling_reg3<=!down_sampling_reg3;
      end
    end
  end
end

pp_pix #(.VA(VA)) u_pp_pix3 (
  .clk_i (clk125m),
  .resetz_i (rstn),
  .pp_ram_wr_done_i     (wr_done3&(down_sampling_reg3=='d1)  ),
  .pp_ram_rd_done_i     (pix_rd_done3                       ),
  .pp_ram_full_o        (pp_ram_full3_odd                       ),
  .pp_ram_empty_o       (pix_empty3_odd                         ),
  .pix_raddr_i          (pix_raddr3                         ),
  .pix_rd_i             (pix_rd3                            ),
  .pix_waddr_i          (pix_waddr3),
  .pix_wdata_i          (data3_frome_fifo                          ),
  .pix_wr_i             (data3_frome_fifo_en&down_sampling_reg3    ),
  .pix_rdata_o          (pix_rdata3_odd                         )
);
pp_pix #(.VA(VA)) u_pp_pix3_downSampling (
  .clk_i (clk125m),
  .resetz_i (rstn),
  .pp_ram_wr_done_i     (wr_done3&(down_sampling_reg3=='d0)   ),
  .pp_ram_rd_done_i     (pix_rd_done3                      ),
  .pp_ram_full_o        (pp_ram_full3_even                       ),
  .pp_ram_empty_o       (pix_empty3_even                         ),
  .pix_raddr_i          (pix_raddr3                         ),
  .pix_rd_i             (pix_rd3                            ),
  .pix_waddr_i          (pix_waddr3                            ),
  .pix_wdata_i          (data3_frome_fifo                          ),
  .pix_wr_i             (data3_frome_fifo_en&(!down_sampling_reg3) ),
  .pix_rdata_o          (pix_rdata3_even                         )
);

always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    cnt_wr3 <= 9'd0;
  end else begin
    if (data3_frome_fifo_en) begin
      if (cnt_wr3 == (VA-1)) begin
        cnt_wr3 <= 9'd0;
      end
      else
        cnt_wr3 <= cnt_wr3 + 1'b1;
    end
  end
end

assign pix_rdata3 = pix_rdata3_even| pix_rdata3_odd;
assign pix_empty3 = pix_empty3_even| pix_empty3_odd;
assign pp_ram_full3 = pp_ram_full3_even | pp_ram_full3_odd;
assign wr_done3 = (data3_frome_fifo_en&&(cnt_wr3 == (VA - 1))) ? 1'b1 : 1'b0;
assign pix_waddr3 = data3_frome_fifo[508:500];
assign pix_rd_done3 = rd_mid && (cnt_rd == 9'd499);
//

//------------------ppram4---------------//
//
(* mark_debug="true" *)reg down_sampling_reg4;
wire [511:0] pix_rdata4_odd;
wire [511:0] pix_rdata4_even;
wire pix_empty4_odd;
wire pix_empty4_even;
wire pp_ram_full4_odd;
wire pp_ram_full4_even;

always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    down_sampling_reg4 <= 'd1;
  end else begin
    if (data4_frome_fifo_en) begin
      if (pix_waddr4 == (VA-1)) begin
        down_sampling_reg4<=!down_sampling_reg4;
      end
    end
  end
end

pp_pix #(.VA(VA)) u_pp_pix4 (
  .clk_i (clk125m),
  .resetz_i (rstn),
  .pp_ram_wr_done_i     (wr_done4&(down_sampling_reg4=='d1)  ),
  .pp_ram_rd_done_i     (pix_rd_done4                       ),
  .pp_ram_full_o        (pp_ram_full4_odd                       ),
  .pp_ram_empty_o       (pix_empty4_odd                         ),
  .pix_raddr_i          (pix_raddr4                         ),
  .pix_rd_i             (pix_rd4                            ),
  .pix_waddr_i          (pix_waddr4),
  .pix_wdata_i          (data4_frome_fifo                          ),
  .pix_wr_i             (data4_frome_fifo_en&down_sampling_reg4    ),
  .pix_rdata_o          (pix_rdata4_odd                         )
);
pp_pix #(.VA(VA)) u_pp_pix4_downSampling (
  .clk_i (clk125m),
  .resetz_i (rstn),
  .pp_ram_wr_done_i     (wr_done4&(down_sampling_reg4=='d0)   ),
  .pp_ram_rd_done_i     (pix_rd_done4                      ),
  .pp_ram_full_o        (pp_ram_full4_even                       ),
  .pp_ram_empty_o       (pix_empty4_even                         ),
  .pix_raddr_i          (pix_raddr4                         ),
  .pix_rd_i             (pix_rd4                            ),
  .pix_waddr_i          (pix_waddr4                            ),
  .pix_wdata_i          (data4_frome_fifo                          ),
  .pix_wr_i             (data4_frome_fifo_en&(!down_sampling_reg4) ),
  .pix_rdata_o          (pix_rdata4_even                         )
);

always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    cnt_wr4 <= 9'd0;
  end else begin
    if (data4_frome_fifo_en) begin
      if (cnt_wr4 == (VA-1)) begin
        cnt_wr4 <= 9'd0;
      end
      else
        cnt_wr4 <= cnt_wr4 + 1'b1;
    end
  end
end

assign pix_rdata4 = pix_rdata4_even| pix_rdata4_odd;
assign pix_empty4 = pix_empty4_even| pix_empty4_odd;
assign pp_ram_full4 = pp_ram_full4_even | pp_ram_full4_odd;
assign wr_done4 = (data4_frome_fifo_en&&(cnt_wr4 == (VA - 1))) ? 1'b1 : 1'b0;
assign pix_waddr4 = data4_frome_fifo[508:500];
assign pix_rd_done4 = rd_mid && (cnt_rd == 9'd499);
//

//------match---------//


fifo512bit_1k lvds1_fifo512bit_1k (
  .rst			(~(rstn&&fifo_rst)),                      // input wire rst

  .wr_clk		(data1_to_fifo_clk),                // input wire wr_clk
  .din			(data1_to_fifo),                      // input wire [511 : 0] din
  .wr_en		(data1_to_fifo_en),                  // input wire wr_en

  .rd_clk		(data1_frome_fifo_clk),                // input wire rd_clk
  .rd_en		(data1_frome_fifo_en),                  // input wire rd_en
  .dout			(data1_frome_fifo),                    // output wire [511 : 0] dout

  .full         (fifo_full1),                    // output wire full
  .empty        (fifo_empty1),                  // output wire empty
  .rd_data_count(data1_rd_data_count),  // output wire [9 : 0] rd_data_count
  .wr_data_count(),  // output wire [9 : 0] wr_data_count
  .wr_rst_busy(),      // output wire wr_rst_busy
  .rd_rst_busy()      // output wire rd_rst_busy
);

fifo512bit_1k lvds2_fifo512bit_1k (
  .rst			(~(rstn&&fifo_rst)),                      // input wire rst

  .wr_clk		(data2_to_fifo_clk),                // input wire wr_clk
  .din			(data2_to_fifo),                      // input wire [511 : 0] din
  .wr_en		(data2_to_fifo_en),                  // input wire wr_en

  .rd_clk		(data2_frome_fifo_clk),                // input wire rd_clk
  .rd_en		(data2_frome_fifo_en),                  // input wire rd_en
  .dout			(data2_frome_fifo),                    // output wire [511 : 0] dout

  .full(fifo_full2),                    // output wire full
  .empty(fifo_empty2),                  // output wire empty
  .rd_data_count(data2_rd_data_count),  // output wire [9 : 0] rd_data_count
  .wr_data_count(),  // output wire [9 : 0] wr_data_count
  .wr_rst_busy(),      // output wire wr_rst_busy
  .rd_rst_busy()      // output wire rd_rst_busy
);

fifo512bit_1k lvds3_fifo512bit_1k (
  .rst			(~(rstn&&fifo_rst)),                      // input wire rst

  .wr_clk		(data3_to_fifo_clk),                // input wire wr_clk
  .din			(data3_to_fifo),                      // input wire [511 : 0] din
  .wr_en		(data3_to_fifo_en),                  // input wire wr_en

  .rd_clk		(data3_frome_fifo_clk),                // input wire rd_clk
  .rd_en		(data3_frome_fifo_en),                  // input wire rd_en
  .dout			(data3_frome_fifo),                    // output wire [511 : 0] dout

  .full(fifo_full3),                    // output wire full
  .empty(fifo_empty3),                  // output wire empty
  .rd_data_count(data3_rd_data_count),  // output wire [9 : 0] rd_data_count
  .wr_data_count(),  // output wire [9 : 0] wr_data_count
  .wr_rst_busy(),      // output wire wr_rst_busy
  .rd_rst_busy()      // output wire rd_rst_busy
);

fifo512bit_1k lvds4_fifo512bit_1k (
  .rst			(~(rstn&&fifo_rst)),                      // input wire rst

  .wr_clk		(data4_to_fifo_clk),                // input wire wr_clk
  .din			(data4_to_fifo),                      // input wire [511 : 0] din
  .wr_en		(data4_to_fifo_en),                  // input wire wr_en

  .rd_clk		(data4_frome_fifo_clk),                // input wire rd_clk
  .rd_en		(data4_frome_fifo_en),                  // input wire rd_en
  .dout			(data4_frome_fifo),                    // output wire [511 : 0] dout

  .full(fifo_full4),                    // output wire full
  .empty(fifo_empty4),                  // output wire empty
  .rd_data_count(data4_rd_data_count),  // output wire [9 : 0] rd_data_count
  .wr_data_count(),  // output wire [9 : 0] wr_data_count
  .wr_rst_busy(),      // output wire wr_rst_busy
  .rd_rst_busy()      // output wire rd_rst_busy
);

//---------------------------------------------------------------
//流水线读�?

(* mark_debug= "TRUE" *)reg [02:0]	c_state;
reg [02:0]	n_state;

always @ (posedge clk125m)
	if(!rstn)
		c_state	<= 3'd0;
	else
		c_state	<= n_state;

always @(c_state or data1_rd_data_count or data2_rd_data_count or data3_rd_data_count or data4_rd_data_count) 
	case(c_state)	
		0 : begin
			if((data1_rd_data_count	>512)||(data2_rd_data_count	>512)||(data3_rd_data_count	>512)||(data4_rd_data_count	>512))
				n_state	= 3'd5;
			else if((data1_rd_data_count >64)&&(data2_rd_data_count	>64)&&(data3_rd_data_count	>64)&&(data4_rd_data_count	>64))
				n_state	= 3'd1;
			else
				n_state	= 3'd0;
		end
		1 : n_state	= 3'd2;
		2 : n_state	= 3'd3;
		3 : n_state	= 3'd4;
		4 : n_state	= 3'd0;
		5 : if(delay_cnt==5)n_state	= 3'd0;
		default:n_state	= 3'd0;
	endcase

always @ (posedge clk125m)
	if(!rstn)begin
		data1_frome_fifo_en	<= 1'b0;
		data2_frome_fifo_en	<= 1'b0;
		data3_frome_fifo_en	<= 1'b0;
		data4_frome_fifo_en	<= 1'b0;
		delay_cnt	<= 8'd0;
		fifo_rst	<= 1'b1;
	end
	else
	case(n_state)
		0 : begin
		data1_frome_fifo_en	<= 1'b0;
		data2_frome_fifo_en	<= 1'b0;
		data3_frome_fifo_en	<= 1'b0;
		data4_frome_fifo_en	<= 1'b0;
		delay_cnt	<= 8'd0;
		fifo_rst	<= 1'b1;
	end
		1 : begin
		data1_frome_fifo_en	<= 1'b1;
		data2_frome_fifo_en	<= 1'b0;
		data3_frome_fifo_en	<= 1'b0;
		data4_frome_fifo_en	<= 1'b0;
	end
		2 : begin
		data1_frome_fifo_en	<= 1'b0;
		data2_frome_fifo_en	<= 1'b1;
		data3_frome_fifo_en	<= 1'b0;
		data4_frome_fifo_en	<= 1'b0;
	end
		3 : begin
		data1_frome_fifo_en	<= 1'b0;
		data2_frome_fifo_en	<= 1'b0;
		data3_frome_fifo_en	<= 1'b1;
		data4_frome_fifo_en	<= 1'b0;
	end
		4 : begin
		data1_frome_fifo_en	<= 1'b0;
		data2_frome_fifo_en	<= 1'b0;
		data3_frome_fifo_en	<= 1'b0;
		data4_frome_fifo_en	<= 1'b1;
	end
		5 : begin
		data1_frome_fifo_en	<= 1'b0;
		data2_frome_fifo_en	<= 1'b0;
		data3_frome_fifo_en	<= 1'b0;
		data4_frome_fifo_en	<= 1'b0;
		delay_cnt	<= delay_cnt	+	1'b1;
		fifo_rst	<= 1'b0;
	end

	endcase

/*
reg data1_frome_fifo_en_r1,data1_frome_fifo_en_r2,data1_frome_fifo_en_r3;
reg 		data1_out_en;
reg [511:0]	data1_out;

	always @ ( posedge clk125m )
		begin
			data1_frome_fifo_en_r1 	<= data1_frome_fifo_en;
			data1_frome_fifo_en_r2 	<= data1_frome_fifo_en_r1;
			data1_frome_fifo_en_r3 	<= data1_frome_fifo_en_r2;
			data1_out_en 			<= data1_frome_fifo_en_r3;
			data1_out 				<= pix_rdata1;
		end

reg data2_frome_fifo_en_r1,data2_frome_fifo_en_r2,data2_frome_fifo_en_r3;
reg 		data2_out_en;
reg [511:0]	data2_out;

	always @ ( posedge clk125m )
		begin
			data2_frome_fifo_en_r1 	<= data2_frome_fifo_en;
			data2_frome_fifo_en_r2 	<= data2_frome_fifo_en_r1;
			data2_frome_fifo_en_r3 	<= data2_frome_fifo_en_r2;
			data2_out_en 			<= data2_frome_fifo_en_r3;
			data2_out 				<= data2_frome_fifo;
		end

reg data3_frome_fifo_en_r1,data3_frome_fifo_en_r2,data3_frome_fifo_en_r3;
reg 		data3_out_en;
reg [511:0]	data3_out;

	always @ ( posedge clk125m )
		begin
			data3_frome_fifo_en_r1 	<= data3_frome_fifo_en;
			data3_frome_fifo_en_r2 	<= data3_frome_fifo_en_r1;
			data3_frome_fifo_en_r3 	<= data3_frome_fifo_en_r2;
			data3_out_en 			<= data3_frome_fifo_en_r3;
			data3_out 				<= data3_frome_fifo;
		end

reg data4_frome_fifo_en_r1,data4_frome_fifo_en_r2,data4_frome_fifo_en_r3;
reg 		data4_out_en;
reg [511:0]	data4_out;

	always @ ( posedge clk125m )
		begin
			data4_frome_fifo_en_r1 	<= data4_frome_fifo_en;
			data4_frome_fifo_en_r2 	<= data4_frome_fifo_en_r1;
			data4_frome_fifo_en_r3 	<= data4_frome_fifo_en_r2;
			data4_out_en 			<= data4_frome_fifo_en_r3;
			data4_out 				<= data4_frome_fifo;
		end
//---------------------------------------------------------------
//poly

	always @ ( posedge clk125m )
	if (!rstn) begin
		pixl_data_out		<= 512'h0;
		pixl_data_out_en	<= 1'b0;
	end
	else if(data1_out_en)begin
		pixl_data_out		<= data1_out;
		pixl_data_out_en	<= 1'b1;	
	end
	else if(data2_out_en)begin
		pixl_data_out		<= data2_out;
		pixl_data_out_en	<= 1'b1;	
	end
	else if(data3_out_en)begin
		pixl_data_out		<= data3_out;
		pixl_data_out_en	<= 1'b1;	
	end
	else if(data4_out_en)begin
		pixl_data_out		<= data4_out;
		pixl_data_out_en	<= 1'b1;	
	end
	else begin
		pixl_data_out		<= pixl_data_out;
		pixl_data_out_en	<= 1'b0;	
	end
*/


//---------------------------------------------------------------
//--config
wire cs_p;
wire clk2m;
reg [07:0] clk_cnt;
always @ (posedge clk10m)
	if(!rstn)
		clk_cnt	<= 8'd0;
	else
		clk_cnt	<= clk_cnt	+	1'b1;

assign 	clk2m	= 	clk_cnt[2];

reg [07:0]	load_cnt;
wire   load	;
always @ (posedge clk2m)
	if(!rstn)
		load_cnt	<=8'd0;
	else if(&load_cnt)
		load_cnt	<=load_cnt;
	else
		load_cnt	<=load_cnt	+	1'b1;
		

assign load	= (load_cnt == 250)	?	1'b1 : 1'b0;

spi_config u_spi_config(
    .clk     ( clk2m   	),//2mhz
	.clk10m  (clk10m),
    .rst_n   ( rstn   	),
	.load	 ( load	    ),
	.cs_spi	 (	cs_p	),
    .clk_spi ( clk_spi 	),
    .mosi    ( mosi    	)
);

assign cs1	=cs_p;
assign cs2	=cs_p;
assign cs3	=cs_p;
assign cs4	=cs_p;
//---------------------------------------------------------------
//--qsfp


endmodule
