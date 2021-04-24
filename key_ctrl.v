module key_ctrl (
    input               sys_clk       ,
    input               sys_rst_n     ,
    input        [11:0] key           ,
    output  reg  [5:0]  ew_left_time  ,
    output  reg  [5:0]  ew_stra_time  ,
    output  reg  [5:0]  ew_right_time ,
    output  reg  [5:0]  sn_left_time  ,
    output  reg  [5:0]  sn_stra_time  ,
    output  reg  [5:0]  sn_right_time
);

//parameter define
parameter  WIDTH = 5;

wire ew_left_add;
wire ew_left_sub;

wire ew_stra_add;
wire ew_stra_sub;

wire ew_right_add;
wire ew_right_sub;

wire sn_left_add;
wire sn_left_sub;

wire sn_stra_add;
wire sn_stra_sub;

wire sn_right_add;
wire sn_right_sub;

assign {ew_left_add,ew_left_sub,ew_stra_add,ew_stra_sub,ew_right_add,ew_right_sub,
        sn_left_add,sn_left_sub,sn_stra_add,sn_stra_sub,sn_right_add,sn_right_sub } = key;
 
reg    [15:0]    cnt_1ms;
reg              clk_1hz;
		  
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        cnt_1ms <= 15'b0;
    else if (cnt_1ms < WIDTH - 1'b1)
        cnt_1ms <= cnt_1ms + 1'b1;
    else
        cnt_1ms <= 15'b0;
end 

//产生频率为1hz的时钟
always @(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)
        clk_1hz <= 1'b0;
    else  if(cnt_1ms == WIDTH - 1'b1)
        clk_1hz <= ~ clk_1hz;
    else  
        clk_1hz <=  clk_1hz;
end
	  
always @ (posedge clk_1hz or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        ew_left_time <= 6'd10;
		  ew_stra_time <= 6'd10;
		  ew_right_time <= 6'd10;
		  sn_left_time <= 6'd10;
		  sn_stra_time <= 6'd10;
		  sn_right_time <= 6'd10;
	 end
	 
    else  if (ew_left_add == 1'b1 && ew_left_time <= 6'd60)
	     ew_left_time <= ew_left_time + 1'b1;
    else  if (ew_left_sub == 1'b1 && ew_left_time >= 6'd8)
	     ew_left_time <= ew_left_time - 1'b1;
		  
    else  if (ew_stra_add == 1'b1 && ew_stra_time <= 6'd60)
	     ew_stra_time <= ew_stra_time + 1'b1;
    else  if (ew_stra_sub == 1'b1 && ew_stra_time >= 6'd8)
	     ew_stra_time <= ew_stra_time - 1'b1;
		  
    else  if (ew_right_add == 1'b1 && ew_right_time <= 6'd60)
	     ew_right_time <= ew_right_time + 1'b1;
    else  if (ew_right_sub == 1'b1 && ew_right_time >= 6'd8)
	     ew_right_time <= ew_right_time + 1'b1;

    else  if (sn_left_add == 1'b1 && sn_left_time <= 6'd60)
	     sn_left_time <= sn_left_time + 1'b1;
    else  if (sn_left_sub == 1'b1 && sn_left_time >= 6'd8)
	     sn_left_time <= sn_left_time - 1'b1;
		  
    else  if (sn_stra_add == 1'b1 && sn_stra_time <= 6'd60)
	     sn_stra_time <= sn_stra_time + 1'b1;
    else  if (sn_stra_sub == 1'b1 && sn_stra_time >= 6'd8)
	     sn_stra_time <= sn_stra_time - 1'b1;
		  
    else  if (sn_right_add == 1'b1 && sn_right_time <= 6'd60)
	     sn_right_time <= sn_right_time + 1'b1;
    else  if (sn_right_sub == 1'b1 && sn_right_time >= 6'd8)
	     sn_right_time <= sn_right_time + 1'b1;

    else begin
        ew_left_time <= ew_left_time;
        ew_stra_time <= ew_stra_time;
        ew_right_time <= ew_right_time;
        sn_left_time <= sn_left_time;
        sn_stra_time <= sn_stra_time;
        sn_right_time <= sn_right_time;
	 end
end

endmodule
