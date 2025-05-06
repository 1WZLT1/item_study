module mpu6050(
    input                  clk       , //ʱ���ź�
    input                  rest_n    , //��λ�ź�
    output   reg           i2c_rh_wl , //I2C��д�����ź�
    output   reg           i2c_exec  , //I2C����ִ���ź�
    output   reg   [15:0]  i2c_addr  , //I2C�����ڵ�ַ
    output   reg   [7:0]   i2c_data_w, //I2CҪд������
    input          [7:0]   i2c_data_r, //I2C����������
    input                   i2c_done,   //I2Cһ�β������
    
    output  reg    [7:0]    Gyro_z_h,
    output  reg    [7:0]    Gyro_z_l,
    
    output  reg    [7:0]    Gyro_y_h,
    output  reg    [7:0]    Gyro_y_l,
    
    output  reg    [7:0]    Gyro_x_h,
    output  reg    [7:0]    Gyro_x_l,
    
    output  reg    [7:0]    Acc_x_h,
    output  reg    [7:0]    Acc_x_l,
    
    output  reg    [7:0]    Acc_y_h,
    output  reg    [7:0]    Acc_y_l,
    
    output  reg    [7:0]    Acc_z_h,
    output  reg    [7:0]    Acc_z_l
    );
    
reg [10:0] state;
parameter   code = 8'd117;
always @(posedge clk or negedge rest_n)begin
    if(!rest_n)begin
        i2c_exec   <= 1'b0;
        i2c_rh_wl  <= 1'b1;/*0д 1��*/
        i2c_addr   <= 8'd0;
        i2c_data_w <= 8'd0;
        state      <= 10'd0;
    end
    else begin
        i2c_exec <= 1'b0;
        case(state)
            10'd0:begin 
                i2c_exec   <= 1'b1; 
                i2c_rh_wl  <= 1'b1;
                i2c_addr   <= 8'h75;
                if(i2c_done == 1'b1) begin
                state      <= 10'd1;
                end
            end
            
            10'd1:begin
                if(i2c_data_r == 8'h68)begin
                    i2c_exec   <= 1'd1;
                    i2c_rh_wl  <= 1'b0;
                    i2c_addr   <= 8'h6B;
                    i2c_data_w <= 8'h01;
                    
                    if(i2c_done == 1'b1) begin
                    state      <= 10'd2;
                    end
                end
                else begin
                state      <= 4'd0; 
                end 
            end
            
            10'd2:begin
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b0;
                 i2c_addr   <= 8'h6C;
                 i2c_data_w <= 8'h00;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd3;
                 end
            end 
            
            10'd3:begin
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b0;
                 i2c_addr   <= 8'h1A;
                 i2c_data_w <= 8'h06;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd4;
                 end
            end
            
            10'd4:begin
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b0;
                 i2c_addr   <= 8'h19;
                 i2c_data_w <= 8'h09;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd5;
                 end
            end
            
            10'd5:begin
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b0;
                 i2c_addr   <= 8'h1C;
                 i2c_data_w <= 8'h18;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd6;
                 end
            end
           
            10'd6:begin
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b0;
                 i2c_addr   <= 8'h1B;
                 i2c_data_w <= 8'h18;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd7;
                 end
            end
            
             /*************Gyro-x*******************/
             10'd7:begin /*��λ*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h43;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd8;
                 Gyro_z_h   <= i2c_data_r;
                 end
             end 
             
            
            10'd8:begin /*��λ 16.4*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h44;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd9;
                 Gyro_z_l   <= i2c_data_r;
                 end
             end
             /*************Gyro-x*******************/
             10'd9:begin /*��λ 16.4*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h45;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd10;
                 Gyro_y_h   <= i2c_data_r;
                 end
             end
             
             10'd10:begin /*��λ 16.4*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h46;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd11;
                 Gyro_y_l   <= i2c_data_r;
                 end
             end
             
             /*************Gyro-z*******************/
             10'd11:begin /*��λ 16.4*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h47;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd12;
                 Gyro_x_h   <= i2c_data_r;
                 end
             end
             
             10'd12:begin /*��λ 16.4*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h48;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd13;
                 Gyro_x_l   <= i2c_data_r;
                 end
             end
             
             /*************Acc-x*******************/
             10'd13:begin /*��λ 16.4*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h3B;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd14;
                 Acc_x_h   <= i2c_data_r;
                 end
             end
             
             10'd14:begin /*��λ 16.4*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h3C;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd15;
                 Acc_x_l   <= i2c_data_r;
                 end
             end
             
            /*************Acc-y*******************/
             10'd15:begin /*��λ 16.4*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h3D;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd16;
                 Acc_y_h   <= i2c_data_r;
                 end
             end
             
             10'd16:begin /*��λ 16.4*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h3E;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd17;
                 Acc_y_l   <= i2c_data_r;
                 end
             end
             
             /*************Acc-z*******************/
             10'd17:begin /*��λ 16.4*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h3F;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd18;
                 Acc_z_h   <= i2c_data_r;
                 end
             end
             
             10'd18:begin /*��λ 16.4*/
                 i2c_exec   <= 1'd1;
                 i2c_rh_wl  <= 1'b1;
                 i2c_addr   <= 8'h40;
                 if(i2c_done == 1'b1) begin
                 state      <= 10'd7;
                 Acc_z_l   <= i2c_data_r;
                 end
             end
             
        endcase 
    end
end    

endmodule
