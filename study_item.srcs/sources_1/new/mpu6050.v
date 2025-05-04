module mpu6050(
    input                  clk       , //时钟信号
    input                  rest_n    , //复位信号
    output   reg           i2c_rh_wl , //I2C读写控制信号
    output   reg           i2c_exec  , //I2C触发执行信号
    output   reg   [15:0]  i2c_addr  , //I2C器件内地址
    output   reg   [7:0]   i2c_data_w, //I2C要写的数据
    input          [7:0]   i2c_data_r, //I2C读出的数据
    input                   i2c_done   //I2C一次操作完成
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
                i2c_addr   <= 8'h75;
                i2c_data_w <= 8'h75;
                state      <= 1'd1;
            end
            4'd1:begin
                if(i2c_data_r == 8'h68)begin
                i2c_rh_wl  <= 1'b0;
                i2c_exec   <= 1'b1; 
                i2c_addr   <= 8'h6B;
                end
                else begin
                state      <= 1'd0; 
                end 
            end
            
        endcase 
    end
end    

endmodule
