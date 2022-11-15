`default_nettype none

module SR #(
    parameter WIDTH = 164
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
	
    input clk,			
    input reset,		/* System reset */
    input Sin,		    /* Shift register program input */
    output Sout, 		/* Shift register program output */


    input [3:0] wstrb,
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
        	Sout <= 1'b0;
	        sr_data <= 164'd0;
	        ready <= 0;
	    end else if(valid && !ready) begin
     	 	ready <=1;      
                sr_data[WIDTH-1:1] <= sr_data[WIDTH-2:0];
            	sr_data[0] <= Sin;
                Sout <= sr_data[WIDTH-1];
	    end
    end
    
endmodule


    
`default_nettype wire
