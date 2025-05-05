module LT_Pack(
    input	         sys_clk,                   //ϵͳʱ��
    input            sys_rst_n,                 //ϵͳ��λ���͵�ƽ��Ч
    
    input            tx_busy,                   //����æ״̬��־      
    output reg       send_en,                   //����ʹ���ź�
    output reg [7:0] send_data,                  //����������
    
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
                tx_ready  <= 1'b1;                  //׼���������͹���
                send_en   <= 1'b0;
                send_data <= 8'hFC;             //�Ĵ洮�ڽ��յ�����
                state      = state +  7'd1;
            end 
            8'd1:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //׼�����̽���
                    send_en  <= 1'b1;                   //���߷���ʹ���ź� 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                    state      = state +  7'd1;
                end      
            end 
            
            /*****************head2*******************/
            8'd2:begin
                tx_ready  <= 1'b1;                  //׼���������͹���
                send_en   <= 1'b0;
                send_data <= 8'h93;             //�Ĵ洮�ڽ��յ�����
                state      = state +  7'd1;
            end 
            
            8'd3:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //׼�����̽���
                    send_en  <= 1'b1;                   //���߷���ʹ���ź� 
                end
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                    state      = state +  7'd1;
                end      
            end 
            
            /*****************len*******************/
            8'd4:begin
                tx_ready  <= 1'b1;                  //׼���������͹���
                send_en   <= 1'b0;
                send_data <= 8'h04;             //�Ĵ洮�ڽ��յ�����
                state      = state +  7'd1;
            end
            8'd5:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //׼�����̽���
                    send_en  <= 1'b1;                   //���߷���ʹ���ź� 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                    state      = state +  7'd1;
                end  
            end
            
            /*****************Gyro_z_h*******************/
            8'd6:begin
                tx_ready  <= 1'b1;                  //׼���������͹���
                send_en   <= 1'b0;
                send_data <= Gyro_z_h;             //�Ĵ洮�ڽ��յ�����
                state      = state +  7'd1;
            end
            8'd7:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //׼�����̽���
                    send_en  <= 1'b1;                   //���߷���ʹ���ź� 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                    state      = state +  7'd1;
                end  
            end
            
            /*****************Gyro_z_l*******************/
            8'd8:begin
                tx_ready  <= 1'b1;                  //׼���������͹���
                send_en   <= 1'b0;
                send_data <= Gyro_z_l;             //�Ĵ洮�ڽ��յ�����
                state      = state +  7'd1;
            end
            8'd9:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //׼�����̽���
                    send_en  <= 1'b1;                   //���߷���ʹ���ź� 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                     state      = state +  7'd1;
                end  
            end
            
            /*****************Gyro_y_h*******************/
            8'd10:begin
                tx_ready  <= 1'b1;                  //׼���������͹���
                send_en   <= 1'b0;
                send_data <= Gyro_y_h;             //�Ĵ洮�ڽ��յ�����
                state      = state +  7'd1;
            end
            8'd11:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //׼�����̽���
                    send_en  <= 1'b1;                   //���߷���ʹ���ź� 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                       state      = state +  7'd1;
                end  
            end
            
            /*****************Gyro_y_l*******************/
            8'd12:begin
                tx_ready  <= 1'b1;                  //׼���������͹���
                send_en   <= 1'b0;
                send_data <= Gyro_y_l;             //�Ĵ洮�ڽ��յ�����
                state      = state +  7'd1;
            end
            8'd13:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //׼�����̽���
                    send_en  <= 1'b1;                   //���߷���ʹ���ź� 
                end 
                else if(tx_ready == 1'b0 && tx_busy == 0)begin
                       //state      = 7'd0;
                     state      = state +  7'd1;
                end  
            end
                           
            /*****************end*******************/
            8'd14:begin
                tx_ready  <= 1'b1;                  //׼���������͹���
                send_en   <= 1'b0;
                send_data <= 8'hFD;             //�Ĵ洮�ڽ��յ�����
                state      = state +  7'd1;
            end
            8'd15:begin
                if(tx_ready && (~tx_busy)) begin
                    tx_ready <= 1'b0;                   //׼�����̽���
                    send_en  <= 1'b1;                   //���߷���ʹ���ź� 
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
