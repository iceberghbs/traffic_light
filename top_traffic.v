module top_traffic( 
    input              sys_clk   ,    //系统时钟信号
    input              sys_rst_n ,    //系统复位信号
    input              emergency ,
	 input    [11:0]    key       ,
	 
    output   [3:0]     sel       ,    //数码管位选信号
    output   [7:0]     seg_led   ,    //数码管段选信号
    output	 [5:0]	  led            //LED使能信号
);

//wire define    
wire [5:0]  ew_left_time  ;
wire [5:0]  ew_stra_time  ;
wire [5:0]  ew_right_time ;
wire [5:0]  sn_left_time  ;
wire [5:0]  sn_stra_time  ;
wire [5:0]  sn_right_time ;
wire [3:0]  state         ;
wire [5:0]  ew_time       ;
wire [5:0]  sn_time       ;
//*****************************************************
//**                    main code                      
//*****************************************************
//交通灯控制模块    
traffic_light u0_traffic_light(
    .sys_clk       (sys_clk       ),
    .sys_rst_n     (sys_rst_n     ),
    .ew_left_time  (ew_left_time  ),
    .ew_stra_time  (ew_stra_time  ),
    .ew_right_time (ew_right_time ),
    .sn_left_time  (sn_left_time  ),
    .sn_stra_time  (sn_stra_time  ),
    .sn_right_time (sn_right_time ),
    .emergency     (emergency     ),
    .state         (state         ),
    .ew_time       (ew_time       ),
    .sn_time       (sn_time       )
);

key_ctrl u1_key_ctrl(
    .sys_clk       (sys_clk       ),
    .sys_rst_n     (sys_rst_n     ),
    .key           (key           ),
    .ew_left_time  (ew_left_time  ),
    .ew_stra_time  (ew_stra_time  ),
    .ew_right_time (ew_right_time ),
    .sn_left_time  (sn_left_time  ),
    .sn_stra_time  (sn_stra_time  ),
    .sn_right_time (sn_right_time )
);

//数码管显示模块	
seg_led  u2_seg_led(
    .sys_clk       (sys_clk    ),
    .sys_rst_n     (sys_rst_n  ),
    .ew_time       (ew_time    ),
    .sn_time       (sn_time    ), 
    .en            (1'b1       ),   
    .sel           (sel        ), 
    .seg_led       (seg_led    )
);

//led灯控制模块
led  u3_led(
    .sys_clk       (sys_clk    ),
    .sys_rst_n     (sys_rst_n  ),
    .state         (state      ),
    .led           (led        )
); 
   
endmodule        