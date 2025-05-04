module assemble(
    input clk,
    input rest_n,
    
    output led
    );
    
led_twinkle u_led_twinkle(
    .clk(clk),
    .rest_n(rest_n),
    
    .led(led)
);    
   
endmodule
