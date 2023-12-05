/* 
Fix Rlong
Remove reset
integrate with my code
integrate ozods
 */

module update (
  input Clock,
  input Reset,
  input [2:0] DataIn,
  output  [1:0] DataResult,
  output  [1:0] location,
  input done,
  output  didwin,
  output  draw,
  output clear
);
	
	
  wire load1, load2, load3, load4, checkWin;
  wire [2:0] data_prev;
  
  // Your part2 logic here

  datapath D0 (
    .clk(Clock),
    .Reset(Reset),
    .data_in(DataIn),
	.data_prev(data_prev),
    .load1(load1),
    .load2(load2),
    .load3(load3),
    .load4(load4),
	.checkWin(checkWin),
    .data_result(DataResult),
	.location(location),
    .didwin(didwin)
  );

  control C0 (
    .clk(Clock),
    
    .done(done),
    .didwin(didwin),
	.clear(clear),
    .Reset(Reset),
    .data_in(DataIn),
	.data_prev(data_prev),
    .load1(load1),
    .load2(load2),
    .load3(load3),
    .load4(load4),
	.checkWin(checkWin),
    .draw(draw)
  );
  endmodule


module control(
  input clk,

  input done,
  output reg didwin,
  output reg clear,
  input Reset,
  input [2:0] data_in,
  output reg [2:0] data_prev,
  output reg load1, load2, load3, load4, checkWin,
  output reg draw
);
	//Using to check if data in changed
	
	

	localparam 
	S_WAIT = 5'd0,
	S_Input1 = 5'd1,
	S_Input1_WAIT = 5'd2,
	S_Input2 = 5'd3,
	S_Input2_WAIT = 5'd4,
	S_Input3 = 5'd5,
	S_Input3_WAIT = 5'd6,
	S_Input4  = 5'd7,
	S_Input4_WAIT = 5'd8,
	S_CheckTheCorrectOrder= 5'd9,
	S_WAIT_CLEAR = 5'd10,
	S_WINNER_PHASE = 5'd11;

	reg storedPrev = 0;
	reg dataChanged;
	
	reg [5:0] current_state, next_state;

	always@(*) begin
		
		if(data_prev != data_in) begin 
			dataChanged <= 1;
		end
		else dataChanged <= 0;
		
		if(data_in == 3'd5) next_state <= S_WAIT_CLEAR;
		else 
		
		begin
		//state_tables
			case (current_state)
			S_WAIT: begin
				data_prev <= 0;
				next_state <= (dataChanged) ? S_Input1 : S_WAIT;
			end
			S_Input1: begin
				next_state <= (done) ? S_Input1_WAIT : S_Input1; // Loop incurrent state until value is input
				storedPrev <= 0;
			end
			
			S_Input1_WAIT: begin
				next_state <= (done) ? S_Input2 : S_Input1_WAIT; // Loop in current state until go signal (go && ~done )es low
				if(storedPrev == 0) begin
					data_prev <= data_in;
					storedPrev <= 1;
				end
			end

			S_Input2: begin 
				next_state <= (dataChanged) ? S_Input2_WAIT : S_Input2; // Loop in current state until value is input
				storedPrev <= 0;
			end
			S_Input2_WAIT: begin
				next_state <= (done) ? S_Input3 : S_Input2_WAIT; // Loopin current state until (go && ~done ) signal goes low
				if(storedPrev == 0) begin
					data_prev <= data_in;
					storedPrev <= 1;
				end
			end
			S_Input3: begin
				next_state <= (dataChanged) ? S_Input3_WAIT : S_Input3; // Loop in current state until value is input
				storedPrev <= 0;
			end
			S_Input3_WAIT: begin
				next_state <= (done) ? S_Input4 : S_Input3_WAIT; // Loop in current state until go signal goes low
				if(storedPrev == 0) begin
					data_prev <= data_in;
					storedPrev <= 1;
				end
			end
			S_Input4: begin
				next_state <= (dataChanged) ? S_Input4_WAIT : S_Input4; // Loop in current state until value is input
				storedPrev <= 0;
			end
			S_Input4_WAIT: begin
				next_state <= (done) ? S_CheckTheCorrectOrder: S_Input4_WAIT; // Loop in current state until go signal goes low
				if(storedPrev == 0) begin
					data_prev <= data_in;
					storedPrev <= 1;
				end
			end
			S_CheckTheCorrectOrder: begin
				next_state <= didwin ? S_WINNER_PHASE : S_WAIT_CLEAR;
				storedPrev <= 0;
			end
			S_WAIT_CLEAR: begin
				next_state <= done ? S_WAIT : S_WAIT_CLEAR; 
				storedPrev <= 0;
			end
			S_WINNER_PHASE: begin
				next_state <= S_WINNER_PHASE;
			end
			// we will be done our two operations, start over after
			default: next_state <= S_WAIT;
			endcase
		end
	end // state_table
	// Output logic aka all of our datapath control signals
	
	
	always @(*)
	begin
	//enable_signals
	// By default make all our signals 0

	load1 <= 1'b0;
	load2 <= 1'b0;
	load3 <= 1'b0;
	load3 <= 1'b0;
	load4 <= 1'b0;
	draw <= 0;
	clear <= 0;
	checkWin <= 0;

	case (current_state)
	S_Input1: begin
		draw <= 1;
		load1 <= 1'b1;
	end
	S_Input1_WAIT: begin
	end
	S_Input2: begin
		draw <= 1;
		load2 <= 1'b1;
	end
	S_Input2_WAIT: begin
	end
	S_Input3: begin
		draw <= 1;
		load3 <= 1'b1;
	end
	S_Input3_WAIT: begin
	end
	S_Input4: begin
		draw <= 1;
		load4 <= 1'b1;
	end
	S_Input4_WAIT: begin
	end

	S_WAIT_CLEAR: begin 
		clear <= 1;
	end
	
	S_CheckTheCorrectOrder: begin 
		checkWin <= 1;
	end


	// default: // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
	endcase
	end 

	// enable_signals

	// current_state registers


	always@(posedge clk)
	begin
	//state_FFs
	if(!Reset)
	current_state <= S_WAIT;
	else
	current_state <= next_state;
	end // state_FFS

endmodule





module datapath(
  input clk,
  input Reset,
  input [2:0] data_in, data_prev,
  input load1, load2, load3, load4, checkWin,
  output reg [1:0] data_result, location,
  output reg didwin
);

	// input registers
	reg [2:0] R1, R2, R3, R4;
	wire [1:0] converted_r;
	// Rlong
	//reg [11:0] Rlong = 0;

	convert conv1 (converted_r, data_in);

	// Registers R1, R2, R3, R4 with respective input logic
	always@(*) begin
		if(!Reset) 
			begin
				R1 <= 2'b0;
				R2 <= 2'b0;
				R3 <= 2'b0;
				R4 <= 2'b0;
				data_result <= 0;
			end
		else begin
			if(load1) begin
				R1 <= converted_r;
				//Rlong[11:9] <= data_prev;
				data_result <= converted_r;
				location <= 2'd0;
			end
			if(load2) begin
				R2 <= converted_r;
				//Rlong[8:6]<= data_prev;
				data_result <= converted_r;
				location <= 2'd1;
			end			
			if(load3) begin
				R3 <= converted_r;
				//Rlong[5:3] <= data_prev;
				data_result <= converted_r;
				location <= 2'd2;
			end
			if(load4) begin
				R4 <= converted_r;
				//Rlong[2:0] <= data_prev;
				data_result <= converted_r;
				location <= 2'd3;
			end
			if(checkWin) begin
				if(R1 == 2'd0 && R2 == 2'd1 && R3 == 2'd2 && R4 == 2'd3) begin
					didwin <= 1;
					
				end
				else didwin <= 0;
			end

		end
	end
	// Output result register
	


/* 	// Assigning values of input - inside  a longer variable
	always@(posedge clk) begin
		if(!Reset) 
			Rlong[11:0] <= 12'b0;

		else 
		begin 
		if(load1) 


		if(load2) 
		Rlong[8:6]<= R2;
		 
		if(load3)
		Rlong[5:3] <= R3;

		if(load4)
		Rlong[2:0] <= R4;
		end
	end */

	/* localparam ideal = 12'b011100010001 ; //3421
	always @(posedge clk ) 
	begin
		if (Rlong == ideal ) 
		begin
		  didwin <= 1;
		end 
		else
		 begin
		  didwin <= 0;
		end
	  end  */

endmodule


module convert (
  output reg [1:0] r,
  input [2:0] data_in
);
  always @* begin
    case (data_in)
      3'd1: r <= 2'd0;
      3'd2: r <= 2'd1;
      3'd3: r <= 2'd2;
      3'd4: r <= 2'd3;
      default: r <= 2'd0; // Provide a default assignment
    endcase
  end
endmodule



//hexDecoder code
module hex_decoder(c, display);
	input [3:0]c;
	output [6:0]display;
	
	assign display[0] = ~((c[3]|c[2]|c[1]|~c[0]) & (c[3]|~c[2]|c[1]|c[0]) & (~c[3]|c[2]|~c[1]|~c[0]) & (~c[3]|~c[2]|c[1]|~c[0]));
	
	assign display[1] = ~((c[3]|~c[2]|c[1]|~c[0]) & (c[3]|~c[2]|~c[1]|c[0]) & (~c[3]|c[2]|~c[1]|~c[0]) & (~c[3]|~c[2]|c[1]|c[0]) & (~c[3]|~c[2]|~c[1]|c[0])& (~c[3]|~c[2]|~c[1]|~c[0]));
	
	assign display[2] = ~((c[3]|c[2]|~c[1]|c[0]) & (~c[3]|~c[2]|c[1]|c[0]) & (~c[3]|~c[2]|~c[1]|c[0]) & (~c[3]|~c[2]|~c[1]|~c[0]));
	
	assign display[3] = ~((c[3]|c[2]|c[1]|~c[0]) & (~c[3]|c[2]|~c[1]|c[0]) & (c[3]|~c[2]|c[1]|c[0]) & (c[3]|~c[2]|~c[1]|~c[0]) &  (~c[3]|c[2]|c[1]|~c[0])&(~c[3]|~c[2]|~c[1]|~c[0]));
	
	assign display[4] = ~((c[3]|c[2]|c[1]|~c[0]) & (c[3]|c[2]|~c[1]|~c[0]) & (c[3]|~c[2]|c[1]|c[0]) & (c[3]|~c[2]|c[1]|~c[0])& (c[3]|~c[2]|~c[1]|~c[0])& (~c[3]|c[2]|c[1]|~c[0]));
	
	assign display[5] = ~((c[3]|c[2]|c[1]|~c[0]) & (c[3]|c[2]|~c[1]|c[0]) & (c[3]|c[2]|~c[1]|~c[0]) & (c[3]|~c[2]|~c[1]|~c[0]) & (~c[3]|~c[2]|c[1]|~c[0]));
	
	assign display[6] = ~((c[3]|c[2]|c[1]|c[0]) & (c[3]|c[2]|c[1]|~c[0]) & (c[3]|~c[2]|~c[1]|~c[0]) & (~c[3]|~c[2]|c[1]|c[0]));

endmodule
