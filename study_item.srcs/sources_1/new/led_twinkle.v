module led_twinkle(
        input  clk,
        input  rest_n,
        
        output reg led
    );

reg [25:0] cnt;

always @(posedge clk or negedge rest_n)begin
    if(!rest_n)begin
        cnt <= 26'd0;
    end
    else begin
        if(cnt < 26'd5000_0000)begin
            cnt <= cnt + 26'd1;
            
            if(cnt < 26'd2500_0000)begin
                led <= 1'd0;
            end
            else begin
                led <= 1'd1;
            end 
        end
        else begin
            cnt <= 26'd0; 
        end 
    end 
end

//ila_0 u_ila_0 (
//	.clk(clk), // input wire clk


//	.probe0(led), // input wire [0:0]  probe0  
//	.probe1(cnt) // input wire [25:0]  probe1
//);

endmodule
