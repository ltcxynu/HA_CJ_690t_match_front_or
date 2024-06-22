module sync_fifo2 #(
    parameter ASIZE = 4,
    parameter DSIZE = 16
)(
    input clk,
    input rst_n,
    input wr_en,
    input [DSIZE - 1 : 0]wr_data,
    input rd_en,
    output [DSIZE - 1 : 0]rd_data,
    output fifo_full,
    output fifo_empty
);
localparam DEPTH = 1<< ASIZE;
reg [ASIZE-1:0] wptr,rptr;
reg [ASIZE  :0] fifo_cnt;
reg [DSIZE-1:0] fifo_mem [0:DEPTH-1];
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wptr <= 0;
    end else if(wr_en & ~fifo_full)begin
        wptr <= wptr + 1;
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        rptr <= 0;
    end else if((rd_en & ~fifo_empty))begin
        rptr <= rptr + 1;
    end
end
always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        fifo_cnt <= 0;
    end else if(wr_en&~fifo_full&~rd_en)begin
        fifo_cnt <= fifo_cnt + 1;
    end else if(rd_en&~fifo_empty&~wr_en)begin
        fifo_cnt <= fifo_cnt - 1;
    end
end

always@(posedge clk) begin
    if(wr_en & ~fifo_full)
        fifo_mem[wptr] <= wr_data;
end

assign rd_data = (rd_en&~fifo_empty)?fifo_mem[rptr]:fifo_mem[rptr-1];
assign fifo_full = fifo_cnt[ASIZE];
assign fifo_empty = (fifo_cnt == 'd0);
endmodule