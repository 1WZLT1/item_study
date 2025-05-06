module assemble(
    input                clk,
    input                rest_n,
    
    output               led,
    
    output               iic_scl,     
    inout                iic_sda,   
    
    input                uart_rxd,           //UART接收端口
    output               uart_txd            //UART发送端口   
);

parameter    SLAVE_ADDR = 7'h68         ; //器件地址(SLAVE_ADDR)
parameter    BIT_CTRL   = 1'b0          ; //字地址位控制参数(16b/8b)
parameter    CLK_FREQ   = 26'd50_000_000; //i2c_dri模块的驱动时钟频率(CLK_FREQ)
parameter    I2C_FREQ   = 18'd250_000   ; //I2C的SCL时钟频率
    
wire          dri_clk   ;   //I2C操作时钟
wire          i2c_exec  ;   //I2C触发控制
wire  [15:0]  i2c_addr  ;   //I2C操作地址
wire  [ 7:0]  i2c_data_w;   //I2C写入的数据
wire          i2c_done  ;   //I2C操作结束标志
wire          i2c_ack   ;   //I2C应答标志 0:应答 1:未应答
wire          i2c_rh_wl ;   //I2C读写控制
wire  [ 7:0]  i2c_data_r;   //I2C读出的数据

wire       uart_send_en;                //UART发送使能  
wire [7:0] uart_send_data;              //UART发送数据 
wire       uart_tx_busy;                //UART发送忙状态标志
 
wire [7:0] Gyro_z_h;//Gyro z 高位 
wire [7:0] Gyro_z_l;//Gyro z 高位
wire [7:0] Gyro_y_h;//Gyro y 高位 
wire [7:0] Gyro_y_l;//Gyro y 高位  
wire [7:0] Gyro_x_h;//Gyro x 高位 
wire [7:0] Gyro_x_l;//Gyro x 高位  

wire [7:0] Acc_x_h;//Acc x 高位 
wire [7:0] Acc_x_l;//Acc x 高位  
wire [7:0] Acc_y_h;//Acc y 高位 
wire [7:0] Acc_y_l;//Acc y 高位  
wire [7:0] Acc_z_h;//Acc z 高位 
wire [7:0] Acc_z_l;//Acc z 高位  
    
led_twinkle u_led_twinkle(
    .clk(clk),
    .rest_n(rest_n),
    
    .led(led)
);

i2c_dri #(
    .SLAVE_ADDR  (SLAVE_ADDR),  
    .CLK_FREQ    (CLK_FREQ  ),  
    .I2C_FREQ    (I2C_FREQ  )   
) u_i2c_dri(
    .clk         (clk    ),  
    .rst_n       (rest_n ),  
    
    .i2c_exec    (i2c_exec  ), 
    .bit_ctrl    (BIT_CTRL  ), 
    .i2c_rh_wl   (i2c_rh_wl ), 
    .i2c_addr    (i2c_addr  ), 
    .i2c_data_w  (i2c_data_w), 
    .i2c_data_r  (i2c_data_r), 
    .i2c_done    (i2c_done  ), 
    .i2c_ack     (i2c_ack   ), 
    .scl         (iic_scl   ), 
    .sda         (iic_sda   ), 
    
    .dri_clk     (dri_clk   )  
);

mpu6050 u_mpu6050(
   .clk        (dri_clk   ), //时钟信号
   .rest_n     (rest_n    ), //复位信号
   
   .i2c_rh_wl  (i2c_rh_wl), //I2C读写控制信号
   .i2c_exec   (i2c_exec ), //I2C触发执行信号
   .i2c_addr   (i2c_addr ), //I2C器件内地址
   .i2c_data_w (i2c_data_w), //I2C要写的数据
   .i2c_data_r (i2c_data_r), //I2C读出的数据
   .i2c_done   (i2c_done  ),//I2C一次操作完成
   
    .Gyro_z_h  (Gyro_z_h),
    .Gyro_z_l  (Gyro_z_l),
    
    .Gyro_y_h  (Gyro_y_h),
    .Gyro_y_l  (Gyro_y_l),
    
    .Gyro_x_h   (Gyro_x_h),   
    .Gyro_x_l   (Gyro_x_l),
    
     .Acc_z_h      (Acc_z_h),   
    .Acc_z_l      (Acc_z_l),
    
    .Acc_y_h      (Acc_y_h),
    .Acc_y_l      (Acc_y_l),
    
    .Acc_x_h      (Acc_x_h),   
    .Acc_x_l      (Acc_x_l)      
);

uart_send u_uart_send(
   .sys_clk       (clk)      ,             //系统时钟
   .sys_rst_n     (rest_n)    ,            //系统复位，低电平有效
   
   .uart_en       (uart_send_en)  ,          //发送使能信号
   .uart_din      (uart_send_data),          //待发送数据
   .uart_tx_busy  (uart_tx_busy)  ,          //当前发送状态 为1表示在发送  
   .uart_txd      (uart_txd)                 //UART发送端口    
);

LT_Pack u_LT_Pack(
   .sys_clk       (clk)      ,             //系统时钟
   .sys_rst_n     (rest_n)    ,            //系统复位，低电平有效
   
    .tx_busy      (uart_tx_busy) ,           //发送忙状态标志      
    .send_en      (uart_send_en) ,           //发送使能信号
    .send_data    (uart_send_data),          //待发送数据 
    
    .Gyro_z_h     (Gyro_z_h),   
    .Gyro_z_l     (Gyro_z_l),
    
    .Gyro_y_h     (Gyro_y_h),
    .Gyro_y_l     (Gyro_y_l),
    
    .Gyro_x_h     (Gyro_x_h),   
    .Gyro_x_l     (Gyro_x_l), 
    
    .Acc_z_h      (Acc_z_h),   
    .Acc_z_l      (Acc_z_l),
    
    .Acc_y_h      (Acc_y_h),
    .Acc_y_l      (Acc_y_l),
    
    .Acc_x_h      (Acc_x_h),   
    .Acc_x_l      (Acc_x_l)   
);

  
endmodule
