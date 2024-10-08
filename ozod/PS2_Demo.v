
module PS2_Demo (
	// Inputs
	clock,
	KEY,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	Key_Pressed,
	
	// Outputs
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input				clock;
input		[3:0]	KEY;

// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;

// Outputs
output		[6:0]	HEX0;
output		[6:0]	HEX1;
output		[6:0]	HEX2;
output		[6:0]	HEX3;
output		[6:0]	HEX4;
output		[6:0]	HEX5;
output		[6:0]	HEX6;
output		[6:0]	HEX7;
output reg [3:0] Key_Pressed = 0;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire		[7:0]	ps2_key_data;
wire				ps2_key_pressed;

// Internal Registers
reg			[7:0]	last_data_received;
// reg 			[3:0] Key_Pressed;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(*)
begin
	if (KEY[0] == 1'b0)
		last_data_received <= 8'h00;
	else if (ps2_key_pressed == 1'b1)
		last_data_received <= ps2_key_data;
end

always@(*) begin
	if (last_data_received == 8'h16)
		Key_Pressed <= 3'b001;
	else if (last_data_received == 8'h1E)
		Key_Pressed <= 3'b010;
	else if (last_data_received == 8'h26)
		Key_Pressed <= 3'b011;
	else if (last_data_received == 8'h25)
		Key_Pressed <= 3'b100;
	else if (last_data_received == 8'h2D)
		Key_Pressed <= 3'b101;
end

		

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign HEX2 = 7'h7F;
assign HEX3 = 7'h7F;
assign HEX4 = 7'h7F;
assign HEX5 = 7'h7F;
assign HEX6 = 7'h7F;
assign HEX7 = 7'h7F;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

PS2_Controller PS2 (
	// Inputs
	.CLOCK_50				(clock),
	.reset				(~KEY[0]),

	// Bidirectionals
	.PS2_CLK			(PS2_CLK),
 	.PS2_DAT			(PS2_DAT),

	// Outputs
	.received_data		(ps2_key_data),
	.received_data_en	(ps2_key_pressed)
);




//Hexadecimal_To_Seven_Segment Segment1 (
//	// Inputs
//	.hex_number			(last_data_received[7:4]),
//
//	// Bidirectional
//
//	// Outputs
//	.seven_seg_display	(HEX1)
//);


endmodule
