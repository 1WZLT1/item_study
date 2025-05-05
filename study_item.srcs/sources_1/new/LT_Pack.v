module LT_Pack(
    input	         sys_clk,                   //系统时钟
    input            sys_rst_n,                 //系统复位，低电平有效
    
    input            tx_busy,                   //发送忙状态标志      
    output reg       send_en,                   //发送使能信号
    output reg [7:0] send_data,                  //待发送数据
    
    input [7:0]      Gyro_z_h,
    input [7:0]      Gyro_z_l,
    
    input [7:0]      Gyro_y_h,
    input [7:0]      Gyro_y_l
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
                send_data <= 8'h04;             //寄存串口接收的数据
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
                           
            /*****************end*******************/
            8'd14:begin
                tx_ready  <= 1'b1;                  //准备启动发送过程
                send_en   <= 1'b0;
                send_data <= 8'hFD;             //寄存串口接收的数据
                state      = state +  7'd1;
            end
            8'd15:begin
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

endmodule
