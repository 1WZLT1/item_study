module mpu6050(
    input                  clk       , //ʱ���ź�
    input                  rest_n    , //��λ�ź�
    output   reg           i2c_rh_wl , //I2C��д�����ź�
    output   reg           i2c_exec  , //I2C����ִ���ź�
    output   reg   [15:0]  i2c_addr  , //I2C�����ڵ�ַ
    output   reg   [7:0]   i2c_data_w, //I2CҪд������
    input          [7:0]   i2c_data_r, //I2C����������
    input                   i2c_done   //I2Cһ�β������
    );
    
reg [3:0] state;
parameter   code = 8'd117;
always @(posedge clk or negedge rest_n)begin
    if(!rest_n)begin
        i2c_exec   <= 1'b0;
        i2c_rh_wl  <= 1'b1;/*0д 1��*/
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
