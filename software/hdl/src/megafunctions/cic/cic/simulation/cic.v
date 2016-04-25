// cic.v

// Generated using ACDS version 15.1 185

`timescale 1 ps / 1 ps
module cic (
		input  wire [1:0]  in_error,  //  av_st_in.error
		input  wire        in_valid,  //          .valid
		output wire        in_ready,  //          .ready
		input  wire [19:0] in_data,   //          .in_data
		output wire [53:0] out_data,  // av_st_out.out_data
		output wire [1:0]  out_error, //          .error
		output wire        out_valid, //          .valid
		input  wire        out_ready, //          .ready
		input  wire        clk,       //     clock.clk
		input  wire        reset_n    //     reset.reset_n
	);

	cic_cic_ii_0 cic_ii_0 (
		.clk       (clk),       //     clock.clk
		.reset_n   (reset_n),   //     reset.reset_n
		.in_error  (in_error),  //  av_st_in.error
		.in_valid  (in_valid),  //          .valid
		.in_ready  (in_ready),  //          .ready
		.in_data   (in_data),   //          .in_data
		.out_data  (out_data),  // av_st_out.out_data
		.out_error (out_error), //          .error
		.out_valid (out_valid), //          .valid
		.out_ready (out_ready), //          .ready
		.clken     (1'b1)       // (terminated)
	);

endmodule
