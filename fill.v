// Part 2 skeleton

//Add the switches for fill and connect them to my instantiation

module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		SW,
		KEY,
		LEDR,
		HEX0,
		HEX1, 
		HEX2,
		HEX3,
		HEX4,
		HEX5,
		HEX6,
		HEX7,							// On Board Keys
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;
	input	[9:0]	SW;
	output [3:0]	LEDR;			
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	output		[6:0]	HEX0;
	output		[6:0]	HEX1;
	output		[6:0]	HEX2;
	output		[6:0]	HEX3;
	output		[6:0]	HEX4;
	output		[6:0]	HEX5;
	output		[6:0]	HEX6;
	output		[6:0]	HEX7;
	
	wire resetn;
	assign resetn = KEY[0];	
	wire [1:0] image_select;
	wire [1:0] location;
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [23:0] colour;
	wire [9:0] oX;
	wire [8:0] oY;
	
	assign image_select = SW[1:0];
	assign location = SW[3:2];
	wire writeEn;
	assign LEDR[0] = writeEn;
	wire oDone;
	
	wire clear = ~KEY[2];
	//wire clear;
	wire draw = ~KEY[1]; 
	//wire draw;

	//wire [2:0] DataIn = SW[2:0];
	wire [2:0] DataIn;
	wire didwin;
	wire PS2_CLK, PS2_DAT;
	
	wire [3:0] DataResult;
	
	
	//PS2_Demo ps2(CLOCK_50, resetn, PS2_CLK, PS2_DAT, DataIn, HEX0);
	PS2_Demo ps2(CLOCK_50, KEY, PS2_CLK, PS2_DAT, DataIn, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);


	// Create an Instance of a VGA controller - there can be only one!
	//update u1(CLOCK_50, resetn, DataIn, DataResult, location, oDone, didwin, draw, clear);
 /*  input Clock,
  input Reset,
  input [2:0] DataIn,
  output  [2:0] DataResult,
  input done,
  output  didwin,
  output  draw,
  output clear,
  output reg [6:0] HEX0 */

	draw2 d1 (resetn, clear, image_select, location, draw, oDone, CLOCK_50, oX, oY, colour, writeEn);


	//How draw 2 input ports look like
	//draw2(iResetn, image_select, location, draw, oDone, iClock, oX, oY, oColour, oPlot)
	
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(oX),
			.y(oY),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 8;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	
endmodule
