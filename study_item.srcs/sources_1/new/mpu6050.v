module mpu6050(
    input                  clk       , //时钟信号
    input                  rest_n    , //复位信号
    output   reg           i2c_rh_wl , //I2C读写控制信号
    output   reg           i2c_exec  , //I2C触发执行信号
    output   reg   [15:0]  i2c_addr  , //I2C器件内地址
    output   reg   [7:0]   i2c_data_w, //I2C要写的数据
    input          [7:0]   i2c_data_r, //I2C读出的数据
    input                   i2c_done,   //I2C一次操作完成
    
    output  reg    [7:0]    Gyro_z_h
    );
    
reg [3:0] state;
parameter   code = 8'd117;
always @(posedge clk or negedge rest_n)begin
    if(!rest_n)begin
        i2c_exec   <= 1'b0;
        i2c_rh_wl  <= 1'b1;/*0写 1读*/
        i2c_addr   <= 8'd0;
        i2c_data_w <= 8'd0;
        state      <= 4'd0;
    end
    else begin
        i2c_exec <= 1'b0;
        case(state)
            4'd0:begin 
                i2c_exec   <= 1'b1; 
                i2c_rh_wl  <= 1'b1;
                i2c_addr   <= 8'h75;
                if(i2c_done == 1'b1) begin
                state      <= 4'd1;
                end
            end
            
            4'd1:begin
                if(i2c_data_r == 8'h68)begin
                    i2c_exec   <= 1'd1;
                    i2c_rh_wl  <= 1'b0;
                    i2c_addr   <= 8'h6B;
                    i2c_data_w <= 8'h01;
                    
                    if(i2c_done == 1'b1) begin
                    state      <= 4'd2;
                    end
                end
                else begin
                state      <= 4'd0; 
                end 
            end
            
            4'd2:begin
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b0;
                 i2c_addr   <= 8'h6C;
                 i2c_data_w <= 8'h00;
                 if(i2c_done == 1'b1) begin
                 state      <= 4'd3;
                 end
            end 
            
            4'd3:begin
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b0;
                 i2c_addr   <= 8'h1A;
                 i2c_data_w <= 8'h06;
                 if(i2c_done == 1'b1) begin
                 state      <= 4'd4;
                 end
            end
            
            4'd4:begin
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b0;
                 i2c_addr   <= 8'h19;
                 i2c_data_w <= 8'h09;
                 if(i2c_done == 1'b1) begin
                 state      <= 4'd5;
                 end
            end
            
            4'd5:begin
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b0;
                 i2c_addr   <= 8'h1C;
                 i2c_data_w <= 8'h18;
                 if(i2c_done == 1'b1) begin
                 state      <= 4'd6;
                 end
            end
            
            4'd6:begin
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b0;
                 i2c_addr   <= 8'h1B;
                 i2c_data_w <= 8'h18;
                 if(i2c_done == 1'b1) begin
                 state      <= 4'd7;
                 end
            end
            
             4'd7:begin /*高位*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h43;
                 if(i2c_done == 1'b1) begin
                 state      <= 4'd8;
                 Gyro_z_h   <= i2c_data_r;
                 end
             end 
             
            4'd8:begin /*低位 16.4*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h44;
                 if(i2c_done == 1'b1) begin
                 state      <= 4'd9;
                 end
             end
             
             4'd9:begin /*低位 16.4*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h45;
                 if(i2c_done == 1'b1) begin
                 state      <= 4'd10;
                 end
             end
             
             4'd10:begin /*低位 16.4*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h46;
                 if(i2c_done == 1'b1) begin
                 state      <= 4'd7;
                 end
             end
             
        endcase 
    end
end    

endmodule
