module led (
    input              sys_clk   ,       //系统时钟
    input              sys_rst_n ,       //系统复位
    input       [3:0]  state     ,       //交通灯的状态
    output reg  [9:0]  led               //左直右黄红LED灯发光使能 
);

//parameter define
parameter  TWINKLE_CNT = 20_00;     //让黄灯闪烁的计数次数

//reg define
reg    [24:0]     cnt;                   //让黄灯产生闪烁效果的计数器

//计数时间为0.2s的计数器，用于让黄灯闪烁                                                              
always @(posedge sys_clk or negedge sys_rst_n)begin                                  
    if(!sys_rst_n)                                                                   
        cnt <= 25'b0;                                                                
    else if (cnt < TWINKLE_CNT - 1'b1)                                                                                                        
        cnt <= cnt + 1'b1;                                                                                                                                                                                                                                                             
    else                                                                             
        cnt <= 25'b0;                                                                
end                                                                                  
                                                                                     
//在交通灯的四个状态里，使相应的led灯发光                                                              
always @(posedge sys_clk or negedge sys_rst_n)begin                                  
    if(!sys_rst_n)                                                                   
        led <= 10'b0000100001;//东西,左直右黄红;南北,左直右黄红;东西南北均红                                                            
    else begin                                                                       
        case(state)                                                                   
            4'b0000:led<=10'b0000110000;//东西红,南北左                                           
            4'b0001: begin                                                             
                led[9:5]<=5'b00001; //东西红
                led[3:0]<=4'b0000; //南北左闪			 
                if(cnt == TWINKLE_CNT - 1'b1)                        
                    led[4] <= ~led[4];                                               
                else                                                                 
                    led[4] <= led[4];                                                
            end 
            4'b0010:led<=10'b0000101000;//东西红,南北直
            4'b0011: begin                                                             
                led[9:5]<=5'b00001; //东西红
                {led[4],led[2:0]}<=4'b0000; //南北直闪		 
                if(cnt == TWINKLE_CNT - 1'b1)                        
                    led[3] <= ~led[3];                                               
                else                                                                 
                    led[3] <= led[3];                                                
            end
            4'b0100:led<=10'b0000100100;//东西红,南北右
            4'b0101: begin                                                             
                led[9:5]<=5'b00001; //东西红
                {led[4:3],led[1:0]}<=4'b0000; //南北右闪		 
                if(cnt == TWINKLE_CNT - 1'b1)                        
                    led[2] <= ~led[2];                                               
                else                                                                 
                    led[2] <= led[2];                                                
            end
            4'b0110: begin                                                             
                led[9:5]<=5'b00001; //东西红
                {led[4:2],led[0]}<=4'b0000; //南北黄闪		 
                if(cnt == TWINKLE_CNT - 1'b1)                        
                    led[1] <= ~led[1];                                               
                else                                                                 
                    led[1] <= led[1];
            end
				
            4'b0111:led<=10'b1000000001;//东西左,南北红                                          
            4'b1000: begin                                                             
                led[8:5]<=4'b0000; //东西左闪
                led[4:0]<=5'b00001; //南北红		 
                if(cnt == TWINKLE_CNT - 1'b1)                        
                    led[9] <= ~led[9];                                               
                else                                                                 
                    led[9] <= led[9];                                                
            end 
            4'b1001:led<=10'b0100000001;//东西直,南北红
            4'b1010: begin                                                             
                {led[9],led[7:5]}<=4'b0000; //东西直闪
                led[4:0]<=5'b00001; //南北红	 
                if(cnt == TWINKLE_CNT - 1'b1)                        
                    led[8] <= ~led[8];                                               
                else                                                                 
                    led[8] <= led[8];                                                
            end
            4'b1011:led<=10'b0010000001;//东西右,南北红
            4'b0101: begin                                                             
                {led[9:8],led[6:5]}<=4'b0000; //东西右闪
                led[4:0]<=5'b00001; //南北红		 
                if(cnt == TWINKLE_CNT - 1'b1)                        
                    led[7] <= ~led[7];                                               
                else                                                                 
                    led[7] <= led[7];                                                
            end
            4'b0110: begin                                                             
                {led[9:7],led[5]}<=4'b0000; //东西黄闪
                led[4:0]<=5'b00001; //南北红	 
                if(cnt == TWINKLE_CNT - 1'b1)                        
                    led[6] <= ~led[6];                                               
                else                                                                 
                    led[6] <= led[6];
            end                                                                     
            default:led<=10'b0000100001;                                                  
        endcase                                                                      
    end                                                                              
end  

endmodule                