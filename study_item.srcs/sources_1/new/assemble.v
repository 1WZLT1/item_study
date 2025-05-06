module assemble(
    input                clk,
    input                rest_n,
    
    output               led,
    
    output               iic_scl,     
    inout                iic_sda,   
    
    input                uart_rxd,           //UART���ն˿�
    output               uart_txd            //UART���Ͷ˿�   
);

parameter    SLAVE_ADDR = 7'h68         ; //������ַ(SLAVE_ADDR)
parameter    BIT_CTRL   = 1'b0          ; //�ֵ�ַλ���Ʋ���(16b/8b)
parameter    CLK_FREQ   = 26'd50_000_000; //i2c_driģ�������ʱ��Ƶ��(CLK_FREQ)
parameter    I2C_FREQ   = 18'd250_000   ; //I2C��SCLʱ��Ƶ��
    
wire          dri_clk   ;   //I2C����ʱ��
wire          i2c_exec  ;   //I2C��������
wire  [15:0]  i2c_addr  ;   //I2C������ַ
wire  [ 7:0]  i2c_data_w;   //I2Cд�������
wire          i2c_done  ;   //I2C����������־
wire          i2c_ack   ;   //I2CӦ���־ 0:Ӧ�� 1:δӦ��
wire          i2c_rh_wl ;   //I2C��д����
wire  [ 7:0]  i2c_data_r;   //I2C����������

wire       uart_send_en;                //UART����ʹ��  
wire [7:0] uart_send_data;              //UART�������� 
wire       uart_tx_busy;                //UART����æ״̬��־
 
wire [7:0] Gyro_z_h;//Gyro z ��λ 
wire [7:0] Gyro_z_l;//Gyro z ��λ
wire [7:0] Gyro_y_h;//Gyro y ��λ 
wire [7:0] Gyro_y_l;//Gyro y ��λ  
wire [7:0] Gyro_x_h;//Gyro x ��λ 
wire [7:0] Gyro_x_l;//Gyro x ��λ  

wire [7:0] Acc_x_h;//Acc x ��λ 
wire [7:0] Acc_x_l;//Acc x ��λ  
wire [7:0] Acc_y_h;//Acc y ��λ 
wire [7:0] Acc_y_l;//Acc y ��λ  
wire [7:0] Acc_z_h;//Acc z ��λ 
wire [7:0] Acc_z_l;//Acc z ��λ  
    
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
   .clk        (dri_clk   ), //ʱ���ź�
   .rest_n     (rest_n    ), //��λ�ź�
   
   .i2c_rh_wl  (i2c_rh_wl), //I2C��д�����ź�
   .i2c_exec   (i2c_exec ), //I2C����ִ���ź�
   .i2c_addr   (i2c_addr ), //I2C�����ڵ�ַ
   .i2c_data_w (i2c_data_w), //I2CҪд������
   .i2c_data_r (i2c_data_r), //I2C����������
   .i2c_done   (i2c_done  ),//I2Cһ�β������
   
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
   .sys_clk       (clk)      ,             //ϵͳʱ��
   .sys_rst_n     (rest_n)    ,            //ϵͳ��λ���͵�ƽ��Ч
   
   .uart_en       (uart_send_en)  ,          //����ʹ���ź�
   .uart_din      (uart_send_data),          //����������
   .uart_tx_busy  (uart_tx_busy)  ,          //��ǰ����״̬ Ϊ1��ʾ�ڷ���  
   .uart_txd      (uart_txd)                 //UART���Ͷ˿�    
);

LT_Pack u_LT_Pack(
   .sys_clk       (clk)      ,             //ϵͳʱ��
   .sys_rst_n     (rest_n)    ,            //ϵͳ��λ���͵�ƽ��Ч
   
    .tx_busy      (uart_tx_busy) ,           //����æ״̬��־      
    .send_en      (uart_send_en) ,           //����ʹ���ź�
    .send_data    (uart_send_data),          //���������� 
    
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
