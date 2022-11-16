 `default_nettype none

module SR #(
    parameter WIDTH = 164,
    parameter [31:0] BASE_ADDR = 32'h3000_0000
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
	
    input clk,			
    input reset,		/* System reset */
    input Sin,		    /* Shift register program input */
    output Sout, 		/* Shift register program output */

    input [31:0] wb_addr,
    input  wen,
    input valid,
    output ready,  
    
    input [31:0] wProgData, /* storage to hold programming data */
    output [31:0] rProgData /* storage to read back the programming data */
);
    reg [164:0] sr_data;
    reg Sout;			/* Latched shift register output */
    
    reg ready;
    reg Sout_r;
        
    always @(posedge clk) begin
        if (reset) begin      	
	        sr_data <= 164'd0;
	        ready <= 0;
	end else if(valid && !ready && wen && (wb_addr == BASE_ADDR)) begin
     	 	$display("writing");
     	 	ready <=1;      
                sr_data[WIDTH-1:1] <= sr_data[WIDTH-2:0];
            	sr_data[0] <= Sin;
	    end
    end
    
    always@(negedge clk) begin
    	if (reset) begin
    	   Sout <= 1'b0;
    	end
    	else begin
    	   Sout <= sr_data[WIDTH-1];
    	end
    end
    
endmodule


    
`default_nettype wire
