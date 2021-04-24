module  traffic_light(
    //input
    input               sys_clk       ,
    input               sys_rst_n     ,
    input        [5:0]  ew_left_time  ,
    input        [5:0]  ew_stra_time  ,
    input        [5:0]  ew_right_time ,
    input        [5:0]  sn_left_time  ,
    input        [5:0]  sn_stra_time  ,
    input        [5:0]  sn_right_time ,
	 input               emergency     ,
	 //output
    output  reg  [3:0]  state         ,
    output  reg  [5:0]  ew_time       ,
    output  reg  [5:0]  sn_time       
	 //output  reg  [5:0]  time_cnt
    );
 
//parameter define
parameter  led_y_time = 5;              //黄灯发光的时间
parameter  WIDTH      = 25_00;     //产生频率为1hz的时钟

//reg define
reg    [5:0]     time_cnt;                 //产生数码管显示时间的计数器    
reg    [24:0]    clk_cnt;                  //用于产生clk_1hz的计数器
reg              clk_1hz;                  //1hz时钟

reg [5:0]  ew_left_time_1x  ;
reg [5:0]  ew_stra_time_1x  ;
reg [5:0]  ew_right_time_1x ;
reg [5:0]  sn_left_time_1x  ;
reg [5:0]  sn_stra_time_1x  ;
reg [5:0]  sn_right_time_1x ;

//*****************************************************
//**                    main code                      
//*****************************************************
//计数周期为0.5s的计数器  
always @ (posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)
        clk_cnt <= 25'b0;
    else if (clk_cnt < WIDTH - 1'b1)
        clk_cnt <= clk_cnt + 1'b1;
    else 
        clk_cnt <= 25'b0;
end 

//产生频率为1hz的时钟
always @(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)
        clk_1hz <= 1'b0;
    else  if(clk_cnt == WIDTH - 1'b1)
        clk_1hz <= ~ clk_1hz;
    else  
        clk_1hz <=  clk_1hz;
end

always @(posedge clk_1hz or negedge sys_rst_n)begin
    if(!sys_rst_n)begin        
        state <= 4'b0000;
        time_cnt <= 6'd10;
		  ew_left_time_1x  <= 6'd10 ;
		  ew_stra_time_1x  <= 6'd10 ;
		  ew_right_time_1x <= 6'd10 ;
		  sn_left_time_1x  <= 6'd10 ;
		  sn_stra_time_1x  <= 6'd10 ;
		  sn_right_time_1x <= 6'd10 ;
    end 
	 else if (emergency == 1'b1)begin
        time_cnt <= time_cnt;
        state <= state;
	 end
    else begin
        case (state)
            4'b0000:  begin //南北左转,东西红灯
                ew_time <= time_cnt + sn_stra_time_1x + sn_right_time_1x + led_y_time;
                sn_time <= time_cnt;
                if (time_cnt > 5)begin
                    time_cnt <= time_cnt - 1'b1;
                    state <= state;
                end 
                else begin
                    time_cnt <= 4;
                    state <= 4'b0001;
                end 
            end 
            4'b0001:  begin //南北左闪,东西红灯
                if (time_cnt > 1 && time_cnt <= 4)begin
                    ew_time <= time_cnt + sn_stra_time_1x + sn_right_time_1x + led_y_time;
                    sn_time <= time_cnt; 
                    time_cnt <= time_cnt - 1'b1;
                    state <= state;
                end 
					 else if (time_cnt == sn_stra_time_1x)
					 begin
                    ew_time <= time_cnt + sn_right_time_1x + led_y_time;
                    sn_time <= time_cnt; 					 
                    state <= 4'b0010;
						  time_cnt <= sn_stra_time_1x - 1'b1;
					 end
                else begin
                    ew_time <= time_cnt + sn_stra_time_1x + sn_right_time_1x + led_y_time;
                    sn_time <= time_cnt; 
                    time_cnt <= sn_stra_time_1x;
                end 
            end 
            4'b0010:  begin //南北直行,东西红灯
                ew_time <= time_cnt + sn_right_time_1x + led_y_time;
                sn_time <= time_cnt; 
                if (time_cnt > 5)begin
                    time_cnt <= time_cnt - 1'b1;
                    state <= state;
                end 
                else begin
                    time_cnt <= 4;
                    state <= 4'b0011;
                end 
            end 
            4'b0011:  begin //南北直闪,东西红灯
                if (time_cnt > 1 && time_cnt <= 4)begin
                    ew_time <= time_cnt + sn_right_time_1x + led_y_time;
                    sn_time <= time_cnt; 					 
                    time_cnt <= time_cnt - 1'b1;
                    state <= state;
                end 
					 else if (time_cnt == sn_right_time_1x)
					 begin
                    ew_time <= sn_right_time_1x + led_y_time;
                    sn_time <= time_cnt; 							 
                    state <= 4'b0100;
						  time_cnt <= sn_right_time_1x - 1'b1;
					 end
                else begin
                    ew_time <= time_cnt + sn_right_time_1x + led_y_time;
                    sn_time <= time_cnt; 							 
                    time_cnt <= sn_right_time_1x;
                end 
            end
            4'b0100:  begin //南北右转,东西红灯
                ew_time <= time_cnt + led_y_time;
                sn_time <= time_cnt; 
                if (time_cnt > 5)begin
                    time_cnt <= time_cnt - 1'b1;
                    state <= state;
                end 
                else begin
                    time_cnt <= 4;
                    state <= 4'b0101;
                end 
            end 
            4'b0101:  begin //南北右闪,东西红灯
                if (time_cnt > 1 && time_cnt <= 4)begin
                    ew_time <= time_cnt + led_y_time;
                    sn_time <= time_cnt; 
                    time_cnt <= time_cnt - 1'b1;
                    state <= state;
                end
					 else if (time_cnt == led_y_time)
					 begin
                    ew_time <= time_cnt;
                    sn_time <= time_cnt; 
                    state <= 4'b0110;
						  time_cnt <= led_y_time - 1'b1;
					 end
                else begin
                    ew_time <= time_cnt + led_y_time;
                    sn_time <= time_cnt; 
                    time_cnt <= led_y_time;
                end 
            end 
            4'b0110:  begin //南北黄灯,东西红灯
                if (time_cnt > 1 && time_cnt <= led_y_time - 1)begin
                    ew_time <= time_cnt;
                    sn_time <= time_cnt; 
                    time_cnt <= time_cnt - 1'b1;
                    state <= state;
                end 
					 else if (time_cnt == ew_left_time_1x)
					 begin
                    sn_time <= time_cnt + ew_stra_time_1x + ew_right_time_1x + led_y_time;
                    ew_time <= time_cnt; 					 
                    state <= 4'b0111;
						  time_cnt <= ew_left_time_1x - 1'b1;
					 end
                else begin
                    ew_time <= time_cnt;
                    sn_time <= time_cnt; 
                    time_cnt <= ew_left_time_1x;
                end 
            end
            4'b0111:  begin //东西左转,南北红灯
                sn_time <= time_cnt + ew_stra_time_1x + ew_right_time_1x + led_y_time;
                ew_time <= time_cnt;
                if (time_cnt > 5)begin
                    time_cnt <= time_cnt - 1'b1;
                    state <= state;
                end 
                else begin
                    time_cnt <= 4;
                    state <= 4'b1000;
                end 
            end 
            4'b1000:  begin //东西左闪,南北红灯
                if (time_cnt > 1 && time_cnt <= 4)begin
                    sn_time <= time_cnt + ew_stra_time_1x + ew_right_time_1x + led_y_time;
                    ew_time <= time_cnt; 
                    time_cnt <= time_cnt - 1'b1;
                    state <= state;
                end 
					 else if (time_cnt == ew_stra_time_1x)
					 begin
                    sn_time <= time_cnt + ew_right_time_1x + led_y_time;
                    ew_time <= time_cnt; 
                    state <= 4'b1001;
						  time_cnt <= ew_stra_time_1x - 1'b1;
					 end
                else begin
                    sn_time <= time_cnt + ew_stra_time_1x + ew_right_time_1x + led_y_time;
                    ew_time <= time_cnt; 
                    time_cnt <= ew_stra_time_1x;
                end 
            end 
            4'b1001:  begin //东西直行,南北红灯
                sn_time <= time_cnt + ew_right_time_1x + led_y_time;
                ew_time <= time_cnt; 
                if (time_cnt > 5)begin
                    time_cnt <= time_cnt - 1'b1;
                    state <= state;
                end 
                else begin
                    time_cnt <= 4;
                    state <= 4'b1010;
                end 
            end 
            4'b1010:  begin //东西直闪,南北红灯
                if (time_cnt > 1 && time_cnt <= 4)begin
                    sn_time <= time_cnt + ew_right_time_1x + led_y_time;
                    ew_time <= time_cnt; 
                    time_cnt <= time_cnt - 1'b1;
                    state <= state;
                end 
					 else if (time_cnt == ew_right_time_1x)
					 begin
                    sn_time <= time_cnt + led_y_time;
                    ew_time <= time_cnt; 
                    state <= 4'b1011;
						  time_cnt <= ew_right_time_1x - 1'b1;
					 end
                else begin
                    sn_time <= time_cnt + ew_right_time_1x + led_y_time;
                    ew_time <= time_cnt; 
                    time_cnt <= ew_right_time_1x;
                end 
            end
            4'b1011:  begin //东西右转,南北红灯
                sn_time <= time_cnt + led_y_time;
                ew_time <= time_cnt; 
                if (time_cnt > 5)begin
                    time_cnt <= time_cnt - 1'b1;
                    state <= state;
                end 
                else begin
                    time_cnt <= 4;
                    state <= 4'b1100;
                end 
            end 
            4'b1100:  begin //东西右闪,南北红灯 
                if (time_cnt > 1 && time_cnt <= 4)begin
                    sn_time <= time_cnt + led_y_time;
                    ew_time <= time_cnt;
                    time_cnt <= time_cnt - 1'b1;
                    state <= state;
                end 
					 else if (time_cnt == led_y_time)
					 begin
                    sn_time <= time_cnt;
                    ew_time <= time_cnt;
                    state <= 4'b1101;
						  time_cnt <= led_y_time - 1'b1;
					 end
                else begin
                    sn_time <= time_cnt + led_y_time;
                    ew_time <= time_cnt;
                    time_cnt <= led_y_time;
                end 
            end 
            4'b1101:  begin //东西黄灯,南北红灯
                if (time_cnt > 1 && time_cnt <= led_y_time - 1)begin
					     sn_time <= time_cnt;
                    ew_time <= time_cnt; 
                    time_cnt <= time_cnt - 1'b1;
                    state <= state;
                end 
					 else if (time_cnt == sn_left_time_1x)
					 begin
                    ew_time <= time_cnt + sn_stra_time_1x + sn_right_time_1x + led_y_time;
                    sn_time <= time_cnt;
                    state <= 4'b0000;
						  time_cnt <= sn_left_time_1x - 1'b1;
					 end					 
                else begin
					     sn_time <= time_cnt;
                    ew_time <= time_cnt;
                    time_cnt <= sn_left_time; 
						  ew_left_time_1x  <= ew_left_time  ;
						  ew_stra_time_1x  <= ew_stra_time  ;
						  ew_right_time_1x <= ew_right_time ;
						  sn_left_time_1x  <= sn_left_time  ;
						  sn_stra_time_1x  <= sn_stra_time  ;
						  sn_right_time_1x <= sn_right_time ;
                end 
            end
            default: begin
                state <= 4'b0000;
                time_cnt <= sn_left_time_1x;  
            end 
        endcase
    end 
end                 

endmodule 