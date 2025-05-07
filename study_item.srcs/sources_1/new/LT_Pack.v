module LT_Pack(
    input	         sys_clk,                   //系统时钟
    input            sys_rst_n,                 //系统复位，低电平有效
    
    input            tx_busy,                   //发送忙状态标志      
    output reg       send_en,                   //发送使能信号
    output reg [7:0] send_data,                  //待发送数据
    
    input      [7:0] recv_data,                 //接收的数据
    
    input [7:0]      Gyro_z_h,
    input [7:0]      Gyro_z_l,
    
    input [7:0]      Gyro_y_h,
    input [7:0]      Gyro_y_l,
    
    input [7:0]      Gyro_x_h,
    input [7:0]      Gyro_x_l,
    
    input    [7:0]    Acc_x_h,
    input    [7:0]    Acc_x_l,

    input    [7:0]    Acc_y_h,
    input    [7:0]    Acc_y_l,

    input    [7:0]    Acc_z_h,
    input    [7:0]    Acc_z_l,
    
    input            recv_done,                 //接收一帧数据完成标志
    
    output reg       motor,
    output reg       motor_2,
    output reg       motor_3,  
    output reg       motor_4
);

reg tx_ready;
reg flag;
reg[6:0] state;

always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin
        tx_ready  <= 1'b0; 
        send_en   <= 1'b0;
        send_data <= 8'd0;
        state     <= 7'd0;
    end                                                      
    else begin
        case(state)
            /*****************head1*******************/
            8'd0:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= 8'hFC;             //寄存串口接收的数据
                state      = state +  7'd1;
            end 
            8'd1:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                    state      = state +  7'd1;
                end      
            end 
            
            /*****************head2*******************/
            8'd2:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= 8'h93;             //寄存串口接收的数据
                state      = state +  7'd1;
            end 
            
            8'd3:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                    state      = state +  7'd1;
                end      
            end 
            
            /*****************len*******************/
            8'd4:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= 8'd12;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd5:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                    state      = state +  7'd1;
                end  
            end
            
            /*****************Gyro_z_h*******************/
            8'd6:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= Gyro_z_h;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd7:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                    state      = state +  7'd1;
                end  
            end
            
            /*****************Gyro_z_l*******************/
            8'd8:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= Gyro_z_l;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd9:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                     state      = state +  7'd1;
                end  
            end
            
            /*****************Gyro_y_h*******************/
            8'd10:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= Gyro_y_h;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd11:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                       state      = state +  7'd1;
                end  
            end
            
            /*****************Gyro_y_l*******************/
            8'd12:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= Gyro_y_l;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd13:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                       //state      = 7'd0;
                     state      = state +  7'd1;
                end  
            end
            
            /*****************Gyro_z_H*******************/
            8'd14:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= Gyro_x_h;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd15:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                       //state      = 7'd0;
                     state      = state +  7'd1;
                end  
            end
            
             /*****************Gyro_z_l*******************/
            8'd16:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= Gyro_x_l;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd17:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                       //state      = 7'd0;
                     state      = state +  7'd1;
                end  
            end
            
            /*****************acc_x_h*******************/
            8'd18:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= Acc_x_h;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd19:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                       //state      = 7'd0;
                     state      = state +  7'd1;
                end  
            end
            
            /*****************acc_x_l*******************/
            8'd20:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= Acc_x_l;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd21:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                       //state      = 7'd0;
                     state      = state +  7'd1;
                end  
            end
            
            /*****************acc_y_h*******************/
            8'd22:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= Acc_y_h;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd23:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                       //state      = 7'd0;
                     state      = state +  7'd1;
                end  
            end
            
            /*****************acc_y_l*******************/
            8'd24:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= Acc_y_l;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd25:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                       //state      = 7'd0;
                     state      = state +  7'd1;
                end  
            end
            
            /*****************acc_z_l*******************/
            8'd26:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= Acc_z_h;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd27:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                       //state      = 7'd0;
                     state      = state +  7'd1;
                end  
            end
            
            /*****************acc_z_l*******************/
            8'd28:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= Acc_z_l;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd29:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                       //state      = 7'd0;
                     state      = state +  7'd1;
                end  
            end
                           
            /*****************end*******************/
            8'd30:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= 8'hFD;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd31:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //准备过程结束
                    send_en  <= 1'b1;                   //拉高发送使能信号 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                       state      = 7'd0;
                     //state      = state +  7'd1;
                end  
            end
        endcase 
    end
end

//判断接收完成信号，并在串口发送模块空闲时给出发送使能信号
wire recv_done_flag;
reg recv_done_d0;
reg recv_done_d1;

assign recv_done_flag = (~recv_done_d1) & recv_done_d0;
always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin
        recv_done_d0 <= 1'b0;                                  
        recv_done_d1 <= 1'b0;
    end                                                      
    else begin                                               
        recv_done_d0 <= recv_done;                               
        recv_done_d1 <= recv_done_d0;                            
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin
        motor     <= 1'b0;//IN1 左电机前进
        motor_2   <= 1'b0;//IN2 左电机后退
        motor_3   <= 1'b0;//IN3 右电机后退
        motor_4   <= 1'b0;//IN4 右电机后退
    end                                                      
    else begin                                               
        if(recv_done_flag)begin                 //检测串口接收到数据
            case (recv_data)
                8'd5:begin
                    motor   = 1'd0;
                    motor_2 = 1'd0;
                    motor_3 = 1'd0;
                    motor_4 = 1'd0;
                 end 
                8'd1:begin/*前进*/
                    motor   = 1'd1;
                    motor_4 = 1'd1;
                    motor_2 = 1'd0;
                    motor_3 = 1'd0; 
                 end
                8'd2:begin/*右转*/
                    motor_2 = 1'd1;
                    motor_4 = 1'd1;
             
                    motor   = 1'd0;
                    motor_3 = 1'd0; 
                 end 
                 8'd3:begin/*右转*/
                    motor_2 = 1'd0;
                    motor_4 = 1'd0;
             
                    motor   = 1'd1;
                    motor_3 = 1'd1; 
                 end   
                 8'd4:begin/*前进*/
                    motor   = 1'd0;
                    motor_4 = 1'd0;
                    motor_2 = 1'd1;
                    motor_3 = 1'd1; 
                 end   
            endcase 
            /*if(recv_data == 8'd1)begin
                motor     <= 1'b1;
            end*/ 
        end
    end
end

endmodule
