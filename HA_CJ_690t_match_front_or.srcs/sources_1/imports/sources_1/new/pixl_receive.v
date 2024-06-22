`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/22 20:43:38
// Design Name: 
// Module Name: pixl_receive
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


module pixl_receive
#(
	parameter DATA_WIDTH		= 21	
)
(
	input 	[1:0]					ch_cnt,
	input	[DATA_WIDTH-1:0]				pixl_bit_p,
	input	[DATA_WIDTH-1:0]				pixl_bit_n,
	input						pixl_clk_p,
	input						pixl_clk_n,
	// input						pixl_frame_p,
	// input						pixl_frame_n,

	input						rstn,
	input						refclk,
	input	[4:0]				SET_DELAY_VALUE,
	output	[4:0]				DELAY_OUT,

	output 						DATA_CLK,
	output	reg [511:0]			DATA,
	output 						DATA_EN
);


  
wire	[DATA_WIDTH-1:0]		pixl_bit;
wire	 						pixl_frame;
wire	[DATA_WIDTH-1:0]		data_in_from_pins_delay;

wire pixl_clk_in;
wire pixl_clk;
wire pixl_clk_div;



wire	[DATA_WIDTH-1:0]		Q1;
wire	[DATA_WIDTH-1:0]		Q2;
wire	[DATA_WIDTH-1:0]		Q3;
wire	[DATA_WIDTH-1:0]		Q4;
wire	[DATA_WIDTH-1:0]		Q5;

reg	[4:0]		data_out[DATA_WIDTH-1:0];
reg	[24:0]		data_out_25bit[DATA_WIDTH-1:0];



wire	[4:0]		delay_out_value[DATA_WIDTH-1:0];  
assign 	DELAY_OUT			 = 	delay_out_value[0];


//-----------------------------------------------------------------------
//--BITSLIP 

reg [24:0]	frame_head;
reg BITSLIP=1'b0;
reg output_flag;
always @ (posedge pixl_clk_div)
	frame_head 	<={frame_head[19:0],data_out[20]};


reg [07:0]	c_state;
reg [07:0]	n_state;

always @ (posedge pixl_clk_div)
	if(!rstn)
		c_state	<= 8'd0;
	else
		c_state	<= n_state;

always @ (c_state	or	frame_head)
	case(c_state)
		0 : begin
			if(|frame_head)
				n_state		=	8'd1;
			else
				n_state		=	8'd0;
		end
		1 : begin
			if(&frame_head)
				n_state		=	8'd2;
			else if(&(!frame_head))
				n_state		=	8'd3;
			else
				n_state		=	8'd1;
		end
		2 : begin
			if(&(!frame_head))
				n_state		=	8'd0;
			else
				n_state		=	8'd2;
		end
		3 : begin
				n_state		=	8'd0;
		end
		default:n_state		=	8'd0;
	endcase

always @ (posedge pixl_clk_div)
	if(!rstn)
		BITSLIP	<=0;
	else
		case(n_state)
		0 : begin
			BITSLIP	<=0;
		end
		1 : begin
			BITSLIP	<=0;
		end
		2 : begin
			BITSLIP	<=0;
		end
		3 : begin
			BITSLIP	<=1;
		end
		default:BITSLIP	<=0;
	endcase

always @ (posedge pixl_clk_div)
	if(!rstn)
		output_flag	<=	1'b0;
	else if(&frame_head)
		output_flag	<=	1'b1;
	else
		output_flag	<=	output_flag;
//-----------------------------------------------------------------------
//--line 
reg	[15:0]	line;
reg [07:0] pixl_clk_div_cnt;
always @ (posedge pixl_clk_div)
	if(!rstn) begin
		line	<=	0;
		pixl_clk_div_cnt	<=	0;
	end
	else if((|frame_head)&&(line!=16'd1)&&(line!=16'd2)) begin
		line	<=	1;
		pixl_clk_div_cnt	<=	1;
	end
	else if(pixl_clk_div_cnt==5) begin
		line	<=	line	+	1'b1;
		pixl_clk_div_cnt	<=	1;
	end
	else begin
		line	<=	line;
		pixl_clk_div_cnt	<=pixl_clk_div_cnt	+	1'b1;
	end

//-----------------------------------------------------------------------
//--clk clk_div

   IBUFDS #(
      .DIFF_TERM("TRUE"),       // Differential Termination
      .IBUF_LOW_PWR("FALSE"),     // Low power="TRUE", Highest performance="FALSE" 
      .IOSTANDARD("LVDS")     // Specify the input I/O standard
   ) IBUFDS_inst1 (
      .O(pixl_clk_in),  // Buffer output
      .I(pixl_clk_p),  // Diff_p buffer input (connect directly to top-level port)
      .IB(pixl_clk_n) // Diff_n buffer input (connect directly to top-level port)
   );


   BUFIO BUFIO_inst1 (
      .O(pixl_clk), // 1-bit output: Clock output (connect to I/O clock loads).
      .I(pixl_clk_in)  // 1-bit input: Clock input (connect to an IBUF or BUFMR).
   );

   BUFR #(
      .BUFR_DIVIDE("5"),   // Values: "BYPASS, 1, 2, 3, 4, 5, 6, 7, 8" 
      .SIM_DEVICE("7SERIES")  // Must be set to "7SERIES" 
   )
   BUFR_inst (
      .O(pixl_clk_div),     // 1-bit output: Clock output port
      .CE(1'b1),   // 1-bit input: Active high, clock enable (Divided modes only)
      .CLR(1'b0), // 1-bit input: Active high, asynchronous clear (Divided modes only)
      .I(pixl_clk_in)      // 1-bit input: Clock buffer input driven by an IBUF, MMCM or local interconnect
   );   


//--bit decode


genvar pin_count;
genvar slice_count;
generate for (pin_count = 0; pin_count < DATA_WIDTH; pin_count = pin_count + 1) begin: pins

IBUFDS
#(	.DIFF_TERM  ("TRUE"),             // Differential termination
	.IOSTANDARD ("LVDS"))
ibufds_inst
(	.I          (pixl_bit_p[pin_count]),
	.IB         (pixl_bit_n[pin_count]),
	.O          (pixl_bit[pin_count]));


//     (* IODELAY_GROUP = "sel_1bi4_group" *)
     IDELAYE2
       # (
         .CINVCTRL_SEL           ("FALSE"),                            // TRUE, FALSE
         .DELAY_SRC              ("IDATAIN"),                          // IDATAIN, DATAIN
         .HIGH_PERFORMANCE_MODE  ("TRUE"),                            // TRUE, FALSE
         .IDELAY_TYPE            ("VAR_LOAD"),              // FIXED, VARIABLE, or VAR_LOADABLE
         .IDELAY_VALUE           (0),                 		 // 0 to 31
         .REFCLK_FREQUENCY       (200.0),
         .PIPE_SEL               ("FALSE"),
         .SIGNAL_PATTERN         ("DATA"))                             // CLOCK, DATA
       idelaye2_inst
           (
         .DATAOUT                (data_in_from_pins_delay[pin_count]),
         .DATAIN                 (1'b0),                               // Data from FPGA logic
         .C                      (refclk),
         .CE                     (1'b0),
         .INC                    (1'b0),
         .IDATAIN                (pixl_bit[pin_count]), 				// Driven by IOB
         .LD                     (1'b1),
         .REGRST                 (~rstn),
         .LDPIPEEN               (1'b0),
         .CNTVALUEIN             (SET_DELAY_VALUE),
         .CNTVALUEOUT            (delay_out_value[pin_count]),
         .CINVCTRL               (1'b0)
         );

    ISERDESE2 #(
      .DATA_RATE("SDR"),           // DDR, SDR
      .DATA_WIDTH(5),              // Parallel data width (2-8,10,14)
      .DYN_CLKDIV_INV_EN("FALSE"), // Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
      .DYN_CLK_INV_EN("FALSE"),    // Enable DYNCLKINVSEL inversion (FALSE, TRUE)
      // INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
      .INIT_Q1(1'b0),
      .INIT_Q2(1'b0),
      .INIT_Q3(1'b0),
      .INIT_Q4(1'b0),
      .INTERFACE_TYPE("NETWORKING"),   // MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
      .IOBDELAY("BOTH"),           // NONE, BOTH, IBUF, IFD
      .NUM_CE(1),                  // Number of clock enables (1,2)
      .OFB_USED("FALSE"),          // Select OFB path (FALSE, TRUE)
      .SERDES_MODE("MASTER"),      // MASTER, SLAVE
      // SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
      .SRVAL_Q1(1'b0),
      .SRVAL_Q2(1'b0),
      .SRVAL_Q3(1'b0),
      .SRVAL_Q4(1'b0)
    )
    ISERDESE2_inst (
      .O(),                       // 1-bit output: Combinatorial output
      // Q1 - Q8: 1-bit (each) output: Registered data outputs
      .Q1(Q1[pin_count]),
      .Q2(Q2[pin_count]),
      .Q3(Q3[pin_count]),
      .Q4(Q4[pin_count]),
      .Q5(Q5[pin_count]),
      .Q6(),
      .Q7(),
      .Q8(),
      // SHIFTOUT1, SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
      .SHIFTOUT1(),
      .SHIFTOUT2(),
      .BITSLIP(BITSLIP),           // 1-bit input: The BITSLIP pin performs a Bitslip operation synchronous to
                                   // CLKDIV when asserted (active High). Subsequently, the data seen on the Q1
                                   // to Q8 output ports will shift, as in a barrel-shifter operation, one
                                   // position every time Bitslip is invoked (DDR operation is different from
                                   // SDR).

      // CE1, CE2: 1-bit (each) input: Data register clock enable inputs
      .CE1(1'b1),
      .CE2(1'b0),
      .CLKDIVP(1'b0),           // 1-bit input: TBD
      // Clocks: 1-bit (each) input: ISERDESE2 clock input ports
      .CLK(pixl_clk),                   // 1-bit input: High-speed clock
      .CLKB(),                 // 1-bit input: High-speed secondary clock
      .CLKDIV(pixl_clk_div),             // 1-bit input: Divided clock
      .OCLK(),                 // 1-bit input: High speed output clock used when INTERFACE_TYPE="MEMORY" 
      // Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
      .DYNCLKDIVSEL(1'b0), // 1-bit input: Dynamic CLKDIV inversion
      .DYNCLKSEL(1'b0),       // 1-bit input: Dynamic CLK/CLKB inversion
      // Input Data: 1-bit (each) input: ISERDESE2 data input ports
      .D(),                       // 1-bit input: Data input
      .DDLY(data_in_from_pins_delay[pin_count]),                 // 1-bit input: Serial data from IDELAYE2
      .OFB(),                   // 1-bit input: Data feedback from OSERDESE2
      .OCLKB(),               // 1-bit input: High speed negative edge output clock
      .RST(~rstn),                   // 1-bit input: Active high asynchronous reset
      // SHIFTIN1, SHIFTIN2: 1-bit (each) input: Data width expansion input ports
      .SHIFTIN1(),
      .SHIFTIN2()
    );

	
	// always @ (posedge pixl_clk_div)
	//  data_out[pin_count]		<=	{Q5[pin_count],Q4[pin_count],Q3[pin_count],Q2[pin_count],Q1[pin_count]};

	// always @ (posedge pixl_clk_div)
	//  data_out_25bit[pin_count]	<=	{data_out_25bit[pin_count][19:0],data_out[pin_count]};
	always @ (posedge pixl_clk_div)
	 data_out[pin_count]		<=	{Q1[pin_count],Q2[pin_count],Q3[pin_count],Q4[pin_count],Q5[pin_count]};

	always @ (posedge pixl_clk_div)
	 data_out_25bit[pin_count]	<=	{data_out[pin_count],data_out_25bit[pin_count][24:5]};	 

  end

  endgenerate

wire[499:0] data_out_500bit;
assign data_out_500bit[ 24:  0]	=	data_out_25bit[ 0];
assign data_out_500bit[ 49: 25]	=	data_out_25bit[ 1];
assign data_out_500bit[ 74: 50]	=	data_out_25bit[ 2];
assign data_out_500bit[ 99: 75]	=	data_out_25bit[ 3];
assign data_out_500bit[124:100]	=	data_out_25bit[ 4];
assign data_out_500bit[149:125]	=	data_out_25bit[ 5];
assign data_out_500bit[174:150]	=	data_out_25bit[ 6];
assign data_out_500bit[199:175]	=	data_out_25bit[ 7];
assign data_out_500bit[224:200]	=	data_out_25bit[ 8];
assign data_out_500bit[249:225]	=	data_out_25bit[ 9];
assign data_out_500bit[274:250]	=	data_out_25bit[10];
assign data_out_500bit[299:275]	=	data_out_25bit[11];
assign data_out_500bit[324:300]	=	data_out_25bit[12];
assign data_out_500bit[349:325]	=	data_out_25bit[13];
assign data_out_500bit[374:350]	=	data_out_25bit[14];
assign data_out_500bit[399:375]	=	data_out_25bit[15];
assign data_out_500bit[424:400]	=	data_out_25bit[16];
assign data_out_500bit[449:425]	=	data_out_25bit[17];
assign data_out_500bit[474:450]	=	data_out_25bit[18];
assign data_out_500bit[499:475]	=	data_out_25bit[19];

always @ (posedge pixl_clk_div)
	if(~rstn)
		DATA[511:0]	<=	512'd0;
	else
		DATA[511:0]	<=	{ch_cnt,line[9:0]-1'b1,data_out_500bit};
		
assign	DATA_EN		=	output_flag	&	(pixl_clk_div_cnt==5);
assign	DATA_CLK	=	pixl_clk_div;

//ila_1 PIXL_ILA (
//	.clk(pixl_clk_div), // input wire clk
//	.probe0(data_out[20]) // input wire [20:0] probe0
//);

endmodule
