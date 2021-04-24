module seg_led(
    input                  sys_clk     ,
    input                  sys_rst_n   ,
    input        [5:0]     ew_time     ,
    input        [5:0]     sn_time     ,
    input                  en          ,                                                   
    output  reg  [3:0]     sel         ,
    output  reg  [7:0]     seg_led      
);

//parameter define
parameter  WIDTH = 5;

//reg define 
reg    [15:0]             cnt_1ms;   
reg    [1:0]              cnt_state; 
reg    [3:0]              num;       

//wire define
wire   [3:0]              data_ew_0; 
wire   [3:0]              data_ew_1; 
wire   [3:0]              data_sn_0; 
wire   [3:0]              data_sn_1; 


assign  data_ew_0   = ew_time / 10;
assign  data_ew_1   = ew_time % 10;
assign  data_sn_0   = sn_time / 10;
assign  data_sn_1   = sn_time % 10;


always @ (posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        cnt_1ms <= 15'b0;
    else if (cnt_1ms < WIDTH - 1'b1)
        cnt_1ms <= cnt_1ms + 1'b1;
    else
        cnt_1ms <= 15'b0;
end 


always @ (posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        cnt_state <= 2'd0;
    else  if (cnt_1ms == WIDTH - 1'b1)
        cnt_state <= cnt_state + 1'b1;
    else
        cnt_state <= cnt_state;
end 


always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        sel  <= 4'b1111;
        num  <= 4'b0;
    end 
    else if(en) begin       
        case (cnt_state) 
            3'd0 : begin     
                sel <= 4'b1110;                
                num <= data_ew_0;
            end       
            3'd1 : begin     
                sel <= 4'b1101;              
                num <= data_ew_1;
            end 
            3'd2 : begin 
                sel <= 4'b1011;              
                num  <= data_sn_0;
            end
            3'd3 : begin 
                sel <= 4'b0111;              
                num  <= data_sn_1 ;    
            end
            default : begin     
                sel <= 4'b1111;                     
                num <= 4'b0;
            end 
        endcase
    end
    else  begin
          sel <= 4'b1111;
          num <= 4'b0;    
    end
end 

    
always @ (*) begin
    if (!sys_rst_n) 
        seg_led <= 8'b0; 
    else begin
        case (num)              
            4'd0 :     seg_led <= 8'b1100_0000;                                                        
            4'd1 :     seg_led <= 8'b1111_1001;                            
            4'd2 :     seg_led <= 8'b1010_0100;                            
            4'd3 :     seg_led <= 8'b1011_0000;                            
            4'd4 :     seg_led <= 8'b1001_1001;                            
            4'd5 :     seg_led <= 8'b1001_0010;                            
            4'd6 :     seg_led <= 8'b1000_0010;                            
            4'd7 :     seg_led <= 8'b1111_1000;      
            4'd8 :     seg_led <= 8'b1000_0000;      
            4'd9 :     seg_led <= 8'b1001_0000;    
            default :  seg_led <= 8'b1100_0000;
        endcase
    end 
end
 
endmodule