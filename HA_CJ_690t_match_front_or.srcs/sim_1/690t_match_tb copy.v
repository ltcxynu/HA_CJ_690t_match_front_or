`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/06 13:41:02
// Design Name: 
// Module Name: 690t_match_tb
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

module tb_690t_match();
	
reg aclk;
reg aresetn;

wire wr_done0;
wire pix_rd_done0;
wire pp_ram_full0;
wire pix_empty0;
wire [8:0] pix_raddr0;
wire pix_rd0;
reg [8:0] cnt_wr0;
wire [508:0] linePix0;
reg dvalid0;
wire [508:0] pix_rdata0;

wire wr_done1;
wire pix_rd_done1;
wire pp_ram_full1;
wire pix_empty1;
wire [8:0] pix_raddr1;
wire pix_rd1;
reg [8:0] cnt_wr1;
reg [508:0] linePix1;
reg dvalid1;
wire [508:0] pix_rdata1;

wire wr_done2;
wire pix_rd_done2;
wire pp_ram_full2;
wire pix_empty2;
wire [8:0] pix_raddr2;
wire pix_rd2;
reg [8:0] cnt_wr2;
reg [508:0] linePix2;
reg dvalid2;
wire [508:0] pix_rdata2;

wire wr_done3;
wire pix_rd_done3;
wire pp_ram_full3;
wire pix_empty3;
wire [8:0] pix_raddr3;
wire pix_rd3;
reg [8:0] cnt_wr3;
reg [508:0] linePix3;
reg dvalid3;
wire [508:0] pix_rdata3;

parameter VA=500;

parameter CYCLE_100MHz = 1000/37.5;
always #(CYCLE_100MHz/2) aclk = ~aclk;  

initial begin
	aclk=0;
	#10000000000000;
	$finish;
end

initial begin
	aresetn=1'b0;
	#50 aresetn=1'b1;
end

/*
initial begin
	pix_empty0=1'b0;
	pix_empty1=1'b0;
	pix_empty2=1'b0;
	pix_empty3=1'b0;
end
*/

reg [508:0] linePix0_temp;
reg fifo_wr;
reg [2:0] state;
reg [2:0] nstate;
wire rd_mid;
wire fifo_temp;
reg [8:0] cnt_rd;
reg [10:0] cnt_line;				//实际输出的行数，0-1079
wire [999:0] linePix_upper; // upper half frame (vertically flipped)
//wire [999:0] linePix_lower; // lower half frame
wire [1999:0] linePix_reorder;		//插值
reg [1919:0] linePix_out;			//每一行的输出，给到syncfifo
wire [1919:0] fifo_din;
wire [959:0] linePix_out_high;
wire [959:0] linePix_out_low;
reg [3:0] cnt_initial;
reg [2:0] cnt0;
reg en0;
reg [2:0] cnt1;
reg en1;
reg [2:0] cnt2;
reg en2;
reg [2:0] cnt3;
reg en3;
reg rd_mid_r;

always @(posedge aclk or negedge aresetn) begin		
  if (!aresetn) begin
    fifo_wr <= 1'b0;
  end else begin
    fifo_wr <= ((rd_mid)&&(cnt_line>=11'd41)) || (cnt_line==11'd1039)||(fifo_temp&&((state==FR)||(state==PRE_UPPER)||(state==PRE_LOWER)||(state==LR)));
  end
end

localparam IDLE = 3'd0;
localparam FR = 3'd1;			//first row
localparam PRE_UPPER = 3'd2;	//40row
localparam MIDDLE = 3'd3;
localparam PRE_LOWER = 3'd4;	//40row
localparam LR = 3'd5;			//last row

always @(posedge aclk or negedge aresetn) begin
  if (!aresetn) begin
    state <= IDLE;
  end else begin
    state <= nstate;
  end
end

assign rd_mid =(state==MIDDLE)&& !(pix_empty0||pix_empty1||pix_empty2||pix_empty3)&& fifo_temp;		//MIDDLE

always @(posedge aclk or negedge aresetn) begin
  if (!aresetn) 
    rd_mid_r <= 1'b0;
  else 
    rd_mid_r <= rd_mid;
end

assign fifo_temp = 1'b1;
//assign fifo_temp = fifo_rd ||((!fifo_full)&&(!(fifo_near_full && fifo_wr)));	

assign pix_rd0 = rd_mid;
assign pix_rd1 = rd_mid;
assign pix_rd2 = rd_mid;		
assign pix_rd3 = rd_mid;	

always @(*) begin
	nstate = state;
	case(state)
		IDLE: if (fifo_temp) begin
				nstate = FR;
			  end
		FR: if (fifo_temp) begin
				nstate = PRE_UPPER;
			  end
		PRE_UPPER: if (cnt_line==11'd39) begin
				nstate = MIDDLE;
			  end
		MIDDLE: if (fifo_temp &&(cnt_line==11'd1039)) begin
				nstate = PRE_LOWER;
			  end
		PRE_LOWER: if (fifo_temp &&(cnt_line==11'd1078)) begin
				nstate = LR;
			  end
		LR: if (fifo_temp &&(cnt_line==11'd1079)) begin
				nstate = IDLE;
			  end
		default: nstate = state;
	endcase
end

always @(posedge aclk or negedge aresetn) begin
  if (!aresetn) begin
    cnt_rd <= 9'd0;
  end else begin
    if ((rd_mid&&cnt_line[0])||((state==MIDDLE)&&(cnt_line==11'd1039))) begin		//一行输出两次，cnt_rd才+1
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

always@(posedge aclk or negedge aresetn) begin
	if(!aresetn)
		cnt_line <=11'd0;
	else if ((rd_mid)||((fifo_temp)&&((state==FR)||(state==PRE_UPPER)||(state==PRE_LOWER)||(state==LR)))) begin		
      if (cnt_line == 11'd1079) 
        cnt_line <= 11'd0;
      else
        cnt_line <= cnt_line + 1'b1;
    end
    else 
        cnt_line <= cnt_line;
end

assign pix_raddr0 = (VA-1) - cnt_rd;		
assign pix_raddr1 = (VA-1) - cnt_rd;
assign pix_raddr2 = cnt_rd;
assign pix_raddr3 = cnt_rd;

assign linePix_upper = {pix_rdata1[499:0], pix_rdata0[499:0]};

genvar i;
for(i=0; i<1000; i=i+1)begin
	assign linePix_reorder[i*2] = linePix_upper[i];
	assign linePix_reorder[i*2+1] = linePix_upper[i];
end

always@(posedge aclk or negedge aresetn) begin
	if(!aresetn)
		linePix_out <= 1920'b0;
	else begin
	case (state)
		IDLE: 		linePix_out <= 1920'b0;
		FR: 		linePix_out <= {48'hffff_ffff_ffff,1872'b0};
		PRE_UPPER: 	linePix_out <= 1920'b0;
		MIDDLE: 	linePix_out <= cnt_line[0]? linePix_reorder[40+:1920]:linePix_out;
		PRE_LOWER: 	linePix_out <= (cnt_line==11'd1039)? linePix_out :1920'b0;
		LR: 		linePix_out <= {1872'b0,48'hffff_ffff_ffff};
	endcase
	end
end

assign fifo_din = linePix_out;		//syncfifo的data输入
assign linePix_out_high = linePix_out[1919:960];
assign linePix_out_low = linePix_out[959:0];

//cnt_initial:0-15
always @(posedge aclk or negedge aresetn) begin		
	if (!aresetn) 
		cnt_initial <= 4'b0;
	else begin 
	if (cnt_initial >= 4'd15)
		cnt_initial <= 4'd0;
	else 
		cnt_initial <= cnt_initial + 1'b1;
	end
end

//------------0------------
//0-4
always @(posedge aclk or negedge aresetn) begin
  if (!aresetn) begin
    cnt0 <= 3'd0;
	dvalid0 <= 1'b0;
	en0 <= 1'b0;
  end else begin
    if (cnt_initial==4'd1 || en0) begin
	  en0 <= 1'b1;
      cnt0 <= cnt0 + 1'b1;
      if (cnt0==3'd4) begin
        cnt0 <= 3'd0;
		dvalid0 <= 1'b1;
      end
	  else 
		dvalid0 <= 1'b0;
    end
  end
end

//0-499
always @(posedge aclk or negedge aresetn) begin
  if (!aresetn) begin
	cnt_wr0 <= 9'd0;
	linePix0_temp <= 509'd0;			
  end else begin
    if (dvalid0) begin
      cnt_wr0 <= cnt_wr0 + 1'b1;
	  linePix0_temp <= linePix0_temp + 1'b1;		//造的写进去的数
      if (cnt_wr0 == (VA-1)) begin
        cnt_wr0 <= 9'd0;
		linePix0_temp <= 509'd0;
      end
    end
  end
end

assign linePix0 = linePix0_temp << 20;
assign wr_done0 = dvalid0 && (cnt_wr0 == (VA-1));
assign pix_rd_done0 = rd_mid && (cnt_rd == 9'd499);

//------------1------------
always @(posedge aclk or negedge aresetn) begin
  if (!aresetn) begin
    cnt1 <= 3'd0;
	dvalid1 <= 1'b0;
	en1 <= 1'b0;
  end else begin
    if (cnt_initial==4'd10 || en1) begin
	  en1 <= 1'b1;
      cnt1 <= cnt1 + 1'b1;
      if (cnt1==3'd4) begin
        cnt1 <= 3'd0;
		dvalid1 <= 1'b1;
      end
	  else 
		dvalid1 <= 1'b0;
    end
  end
end

//0-499
always @(posedge aclk or negedge aresetn) begin
  if (!aresetn) begin
	cnt_wr1 <= 9'd0;
	linePix1 <= 509'd0;			
  end else begin
    if (dvalid1) begin
      cnt_wr1 <= cnt_wr1 + 1'b1;
	  linePix1 <= linePix1 + 1'b1;		//造的写进去的数
      if (cnt_wr1 == (VA-1)) begin
        cnt_wr1 <= 9'd0;
		linePix1 <= 509'd0;
      end
    end
  end
end

assign wr_done1 = dvalid1 && (cnt_wr1 == (VA-1));
assign pix_rd_done1 = rd_mid && (cnt_rd == 9'd499);

//------------2------------
always @(posedge aclk or negedge aresetn) begin
  if (!aresetn) begin
    cnt2 <= 3'd0;
	dvalid2 <= 1'b0;
	en2 <= 1'b0;
  end else begin
    if (cnt_initial==4'd15 || en2) begin
	  en2 <= 1'b1;
      cnt2 <= cnt2 + 1'b1;
      if (cnt2==3'd4) begin
        cnt2 <= 3'd0;
		dvalid2 <= 1'b1;
      end
	  else 
		dvalid2 <= 1'b0;
    end
  end
end

//0-499
always @(posedge aclk or negedge aresetn) begin
  if (!aresetn) begin
	cnt_wr2 <= 9'd0;
	linePix2 <= 509'd0;			
  end else begin
    if (dvalid2) begin
      cnt_wr2 <= cnt_wr2 + 1'b1;
	  linePix2 <= linePix2 + 1'b1;		//造的写进去的数
      if (cnt_wr2 == (VA-1)) begin
        cnt_wr2 <= 9'd0;
		linePix2 <= 509'd0;
      end
    end
  end
end

assign wr_done2 = dvalid2 && (cnt_wr2 == (VA-1));
assign pix_rd_done2 = rd_mid && (cnt_rd == 9'd499);

//------------3------------
always @(posedge aclk or negedge aresetn) begin
  if (!aresetn) begin
    cnt3 <= 3'd0;
	dvalid3 <= 1'b0;
	en3 <= 1'b0;
  end else begin
    if (cnt_initial==4'd8 || en3) begin
	  en3 <= 1'b1;
      cnt3 <= cnt3 + 1'b1;
      if (cnt3==3'd4) begin
        cnt3 <= 3'd0;
		dvalid3 <= 1'b1;
      end
	  else 
		dvalid3 <= 1'b0;
    end
  end
end

//0-499
always @(posedge aclk or negedge aresetn) begin
  if (!aresetn) begin
	cnt_wr3 <= 9'd0;
	linePix3 <= 509'd0;			
  end else begin
    if (dvalid3) begin
      cnt_wr3 <= cnt_wr3 + 1'b1;
	  linePix3 <= linePix3 + 1'b1;		//造的写进去的数
      if (cnt_wr3 == (VA-1)) begin
        cnt_wr3 <= 9'd0;
		linePix3 <= 509'd0;
      end
    end
  end
end

assign wr_done3 = dvalid3 && (cnt_wr3 == (VA-1));
assign pix_rd_done3 = rd_mid && (cnt_rd == 9'd499);

pp_pix #(.VA(VA)) u_pp_pix0 (
.clk_i (aclk),
.resetz_i (aresetn),
.pp_ram_wr_done_i (wr_done0),
.pp_ram_rd_done_i (pix_rd_done0),
.pp_ram_full_o (pp_ram_full0),
.pp_ram_empty_o (pix_empty0),
.pix_raddr_i (pix_raddr0),
.pix_rd_i (pix_rd0),
.pix_waddr_i (cnt_wr0),
.pix_wdata_i (linePix0),
.pix_wr_i (dvalid0),
.pix_rdata_o (pix_rdata0)
);

pp_pix #(.VA(VA)) u_pp_pix1 (
.clk_i (aclk),
.resetz_i (aresetn),
.pp_ram_wr_done_i (wr_done1),
.pp_ram_rd_done_i (pix_rd_done1),
.pp_ram_full_o (pp_ram_full1),
.pp_ram_empty_o (pix_empty1),
.pix_raddr_i (pix_raddr1),
.pix_rd_i (pix_rd1),
.pix_waddr_i (cnt_wr1),
.pix_wdata_i (linePix1),
.pix_wr_i (dvalid1),
.pix_rdata_o (pix_rdata1)
);

pp_pix #(.VA(VA)) u_pp_pix2 (
.clk_i (aclk),
.resetz_i (aresetn),
.pp_ram_wr_done_i (wr_done2),
.pp_ram_rd_done_i (pix_rd_done2),
.pp_ram_full_o (pp_ram_full2),
.pp_ram_empty_o (pix_empty2),
.pix_raddr_i (pix_raddr2),
.pix_rd_i (pix_rd2),
.pix_waddr_i (cnt_wr2),
.pix_wdata_i (linePix2),
.pix_wr_i (dvalid2),
.pix_rdata_o (pix_rdata2)
);

pp_pix #(.VA(VA)) u_pp_pix3 (
.clk_i (aclk),
.resetz_i (aresetn),
.pp_ram_wr_done_i (wr_done3),
.pp_ram_rd_done_i (pix_rd_done3),
.pp_ram_full_o (pp_ram_full3),
.pp_ram_empty_o (pix_empty3),
.pix_raddr_i (pix_raddr3),
.pix_rd_i (pix_rd3),
.pix_waddr_i (cnt_wr3),
.pix_wdata_i (linePix3),
.pix_wr_i (dvalid3),
.pix_rdata_o (pix_rdata3)
);

endmodule 
