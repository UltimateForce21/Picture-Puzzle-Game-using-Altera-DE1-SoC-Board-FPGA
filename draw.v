// Todo:

/*
Todo:
1. Finish up the fsm for functionality
2. Clear screen
3. Use Keys to select location

Created address interpreter
*/

/* input clk,
input Reset,
input [2:0] data_in,
input load1 , load2 , load3 , load4 ,
output reg [2:0] data_result  ,
output reg [3:0] location  ;
output reg didwin ; */

module draw(iResetn, image_select, location, draw,, oDone, iClock, oX, oY, oColour, oPlot);
   /* parameter X_SCREEN_PIXELS = 9'd320;
   parameter Y_SCREEN_PIXELS = 8'd240; */


   //Main Datapath variables
   input wire [2:0] image_select;
   input wire [2:0] location;
   input wire draw;
   //input wire didWin; 
   input wire iResetn;
   output wire oDone;
   
   input wire iClock;

   output wire [9:0] oX;         // VGA pixel coordinates
   output wire [8:0] oY;

   output wire [23:0] oColour;     // VGA pixel colour (0-7)
   output wire oPlot;       // Pixel draw enable
 

   

   wire [23:0] iImage1, iImage2, iImage3, iImage4;
   //assign iPixel = 24'HFF00FF;




   //
   // Your code goes here

	wire [9:0] xCounter;
	wire [8:0] yCounter;
   wire [12:0] readAddress80x60;
   wire [13:0] readAddress160x60;
   
   interpretCoords80x60 iC1(xCounter, yCounter, readAddress80x60, iClock); 
   //interpretCoords160x60 iC2(xCounter, yCounter, readAddress160x60, iClock); 
   

   //modelsim
/*    topleft IM1(readAddress80x60, iClock, 0, 0, iImage1);
   bottomleft IM2(readAddress80x60, iClock, 0, 0, iImage2);
   bottomright IM3(readAddress80x60, iClock, 0, 0, iImage3);
   topright IM4(readAddress80x60, iClock, 0, 0, iImage4); */

   
   

   wire ld_image1, ld_image2, ld_image3, ld_image4, ld_draw1, ld_draw2, ld_draw3, ld_draw4;

   
   FSM F0 (iResetn, oDone, image_select, location, draw, iClock, oPlot, iImage1, iImage2, iImage3, iImage4, 
         xCounter, yCounter, ld_image1, ld_image2, ld_image3, ld_image4, ld_draw1, ld_draw2, ld_draw3, ld_draw4);

   Datapath D0 (iResetn, image_select, location, iClock, oPlot, iImage1, iImage2, iImage3, iImage4,
   oColour, oX, oY, xCounter, yCounter, ld_image1, ld_image2, ld_image3, ld_image4, ld_draw1, ld_draw2, ld_draw3, ld_draw4);

endmodule // draw module




//remember need to change so that i can read address based on pivot pixels x and y
module interpretCoords160x60(xCounter, yCounter, address, iClock);
   input wire [9:0] xCounter;
	input wire [8:0] yCounter;
   output reg [13:0] address;
   input wire iClock;

   always@(posedge iClock) begin
      if(address == 13'd9600) address <= 0;
      else address <= xCounter + 8'd160*yCounter;
   end

endmodule //interpretCoords

module interpretCoords80x60(xCounter, yCounter, address, iClock);
   input wire [9:0] xCounter;
	input wire [8:0] yCounter;
   output reg [12:0] address;
   input wire iClock;

   always@(posedge iClock) begin
      if(address == 12'd4800) address <= 0;
      else address <= xCounter + 8'd80*yCounter;
   end

endmodule //interpretCoords

module FSM(iResetn, oDone, image_select, location, draw, iClock, oPlot, iImage1, iImage2, iImage3, iImage4, 
         xCounter, yCounter, ld_image1, ld_image2, ld_image3, ld_image4, ld_draw1, ld_draw2, ld_draw3, ld_draw4);
   
  /*  parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120; */

   input wire iResetn;
   input wire [2:0] image_select;
   input wire [2:0] location;
   output reg oDone;
   //input didWin;
   input draw;

   input wire iClock;
   output reg oPlot;
   input wire [23:0] iImage1, iImage2, iImage3, iImage4;

   input wire [9:0] xCounter;
   input wire [8:0] yCounter;
   
   output reg ld_image1, ld_image2, ld_image3, ld_image4, ld_draw1, ld_draw2, ld_draw3, ld_draw4;
   
   reg [3:0] current_state;
   reg [3:0] next_state;
   
   

   localparam 
   s_reset = 4'd0,
   s_draw_1 = 4'd1, 
   s_draw_2 = 4'd2,
   s_draw_3 = 4'd3, 
   s_draw_4 = 4'd4,
   s_wait = 4'd5,
   s_piece_1 = 4'd6,
   s_done_piece1 = 4'd7,
   s_piece_2 = 4'd8,
   s_done_piece2 = 4'd9,
   s_piece_3 = 4'd10,
   s_done_piece3 = 4'd11,
   s_piece_4 = 4'd12,
   s_done_piece4 = 4'd13;
   
    always@(*)
    begin: state_table
		if(~iResetn) begin
         current_state <= s_reset;
      end
      case (current_state)
         s_reset: begin
            next_state = s_draw_1; //remember: finish reset functionality
         end 
		  s_draw_1: 
		  begin
			   if(xCounter == 8'd79 && yCounter == 7'd59) next_state <= s_draw_2; //condition state change needs to match the condition for resetting the counters in datapath
            else next_state <= s_draw_1;
		  end
        s_draw_2: 
		  begin
			   if(xCounter == 8'd79 && yCounter == 7'd59) next_state <= s_draw_3; //condition state change needs to match the condition for resetting the counters in datapath
            else next_state <= s_draw_2;
		  end
        s_draw_3: 
		  begin
			   if(xCounter == 8'd79 && yCounter == 7'd59) next_state <= s_draw_4; //condition state change needs to match the condition for resetting the counters in datapath
            else next_state <= s_draw_3;
		  end
        s_draw_4: 
		  begin
			   if(xCounter == 8'd79 && yCounter == 7'd59) next_state <= s_wait; //condition state change needs to match the condition for resetting the counters in datapath
            else next_state <= s_draw_4;
		  end
		  s_wait: next_state = draw ? s_piece_1: s_wait; //cycle to draw the imputted pixel

        s_piece_1: begin
         if(xCounter == 8'd79 && yCounter == 7'd59) next_state <= s_done_piece1;
         else next_state <= s_piece_1;
        end

        s_done_piece1: begin
            next_state <= draw ? s_piece_1 : s_done_piece1;
        end

        s_piece_2: begin
         if(xCounter == 8'd79 && yCounter == 7'd59) next_state <= s_done_piece2;
         else next_state <= s_piece_2;
        end

        s_done_piece2: begin
            next_state <= draw ? s_piece_3 : s_done_piece2;
        end

        s_piece_3: begin
         if(xCounter == 8'd79 && yCounter == 7'd59) next_state <= s_done_piece3;
         else next_state <= s_piece_3;
        end

        s_done_piece4: begin
            next_state <= draw ? s_wait : s_done_piece4;
        end
        
		
      default: next_state <= s_draw_1;
	   
	   endcase
          
    end // state_table
 
    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
		oPlot <= 0;
      ld_image1 <= 0;
      ld_image2 <= 0;
      ld_image3 <= 0;
      ld_image4 <= 0;
      ld_draw1 <= 0;
      ld_draw2 <= 0;
      ld_draw3 <= 0;
      ld_draw4 <= 0;
      oDone <= 0;
        case (current_state)
			s_draw_1: begin
            oPlot <= 1;
            ld_image1 <= 1;
         end
         s_draw_2: begin
            oPlot <= 1;
            ld_image2 <= 1;
         end
         s_draw_3: begin
            oPlot <= 1;
            ld_image3 <= 1;
         end
         s_draw_4: begin
            oPlot <= 1;
            ld_image4 <= 1;
         end
         s_wait: begin
            oPlot <= 1;
            oDone <= 1;
         end
         s_wait: oDone <= 1;
         s_piece_1: begin
            oPlot <= 1;
            ld_draw1 <= 1;
         end
         s_done_piece1: begin
            oDone <= 1;
         end 
		endcase
	end

   // current_state registers
   always@(posedge iClock)
   begin: state_FFs
      if(iResetn == 0) begin
         current_state <= s_reset;
         //Do not put enable signals here to 0, everything goes to zero/undefined
      end
      else
         current_state <= next_state;
   end // state_FFS
endmodule//end FSM module


//remember to check that all variables are defined as input or output
module Datapath(iResetn, image_select, location, iClock, oPlot, iImage1, iImage2, iImage3, iImage4,
   oColour, oX, oY, xCounter, yCounter, ld_image1, ld_image2, ld_image3, ld_image4, ld_draw1, ld_draw2, ld_draw3, ld_draw4);
   
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;
   
   input wire iResetn;
   input wire [2:0] image_select;
   input wire [2:0] location;
 
   input wire [23:0] iImage1, iImage2, iImage3, iImage4;

   input wire iClock;
   output reg [9:0] oX;         // VGA pixel coordinates
   output reg [8:0] oY;


   input wire oPlot;

   output reg [23:0] oColour;     // VGA pixel colour (0-7)
   
   output reg [9:0] xCounter;
	output reg [8:0] yCounter;

   input wire ld_image1, ld_image2, ld_image3, ld_image4, ld_draw1, ld_draw2, ld_draw3, ld_draw4;

   localparam //Scrambled Image Pivots
   pv_image1_x = 0, 
   pv_image1_y = 0,
   pv_image2_x = 9'd81,
   pv_image2_y = 0,
   pv_image3_x = 0, 
   pv_image3_y = 9'd61,
   pv_image4_x = 9'd81,
   pv_image4_y = 9'd61;

   //Mux for switching between locations
   reg [9:0] pv_draw_x, pv_draw_y;
   always@(*) begin
      case(location)
         2'b00: begin
            pv_draw_x <= 9'd160;
            pv_draw_y <= 0;
         end
         2'd1: begin
            pv_draw_x <= 9'd240;
            pv_draw_y <= 0;
         end
         2'd2: begin
            pv_draw_x <= 9'd160;
            pv_draw_y <= 9'd60;
         end
         2'd3: begin
            pv_draw_x <= 9'd240;
            pv_draw_y <= 9'd60;
         end
      
      endcase
   end

   //Mux for switching between drawing between images
   reg [23:0] pv_draw;
   always@(*) begin
      case(image_select)
         2'b00: begin
            pv_draw = iImage1;
         end
         2'd1: begin
            pv_draw = iImage2;
         end
         2'd2: begin
            pv_draw = iImage3;
         end
         2'd3: begin
            pv_draw = iImage4;
         end
      
      endcase
   end



   //Logic for Iterating Through the MIF file
   always@(posedge iClock) begin
      if(!iResetn) begin
         oX <= 0;
         oY <= 0;
         oColour <= 0;
         xCounter <= 0;
         yCounter <= 0;
         if(xCounter == 8'd321 && yCounter == 7'd241) begin
            oX <= pv_image1_x + xCounter;
            oY <=  pv_image1_y + yCounter;
            oColour <= iImage1;
            //setting next image location
            xCounter <= 0;
            yCounter <= 0;                 
         end
         else begin
            oX <= pv_image1_x + xCounter;
            oY <= pv_image1_y + yCounter;
            oColour <= 24'd0;
               
            if(xCounter == 8'd321 && yCounter != 7'd241) begin
               xCounter <=  0;
               yCounter <= yCounter + 1;
            end
            else begin
               xCounter <= xCounter + 1;
            end
         end


      end
      else begin
         if(oPlot == 1 && ld_image1 == 1) begin
               if(xCounter == 8'd79 && yCounter == 7'd59) begin
                  oX <= pv_image1_x + xCounter;
                  oY <=  pv_image1_y + yCounter;
                  oColour <= iImage1;
                  //setting next image location
                  xCounter <= 0;
                  yCounter <= 0;                 
               end
               else begin
                  oX <= pv_image1_x + xCounter;
                  oY <= pv_image1_y + yCounter;
                  oColour <= iImage1;
                     
                  if(xCounter == 8'd79 && yCounter != 7'd59) begin
                     xCounter <=  0;
                     yCounter <= yCounter + 1;
                  end
                  else begin
                     xCounter <= xCounter + 1;
                  end
               end
            end
            
         if(oPlot == 1 && ld_image2 == 1) begin
            if(xCounter == 8'd79 && yCounter == 7'd59) begin
                  oX <= pv_image2_x + xCounter;
                  oY <= pv_image2_y + yCounter;
                  oColour <= iImage2;

                  //setting next image location
                  xCounter <= 0;
                  yCounter <= 0;
               end
               else begin
                  oX <= pv_image2_x + xCounter;
                  oY <= pv_image2_y + yCounter;
                  oColour <= iImage2;
                     
                  if(xCounter == 8'd79 && yCounter != 7'd59) begin
                     xCounter <= 0;
                     yCounter <= yCounter + 1;
                  end
                  else begin
                     xCounter <= xCounter + 1;
                  end
               end
         end

         if(oPlot == 1 && ld_image3 == 1) begin
            if(xCounter == 8'd79 && yCounter == 7'd59) begin
                  oX <= pv_image3_x + xCounter;
                  oY <= pv_image3_y + yCounter;
                  oColour <= iImage3;

                  //setting next image location
                  xCounter <= 0;
                  yCounter <= 0;
               end
               else begin
                  oX <= pv_image3_x + xCounter;
                  oY <= pv_image3_y + yCounter;
                  oColour <= iImage3;
                     
                  if(xCounter == 8'd79 && yCounter != 7'd59) begin
                     xCounter <= 0;
                     yCounter <= yCounter + 1;
                  end
                  else begin
                     xCounter <= xCounter + 1;
                  end
               end
         end

         if(oPlot == 1 && ld_image4 == 1) begin
            if(xCounter == 8'd79 && yCounter == 7'd59) begin
                  oX <= pv_image4_x + xCounter;
                  oY <= pv_image4_y + yCounter;
                  oColour <= iImage4;

                  //setting next image location
                  xCounter <= 0;
                  yCounter <= 0;
               end
               else begin
                  oX <= pv_image4_x + xCounter;
                  oY <= pv_image4_y + yCounter;
                  oColour <= iImage4;
                     
                  if(xCounter == 8'd79 && yCounter != 7'd59) begin
                     xCounter <= 0;
                     yCounter <= yCounter + 1;
                  end
                  else begin
                     xCounter <= xCounter + 1;
                  end
               end
         end

         if(oPlot == 1 && ld_draw1 == 1) begin
            if(xCounter == 8'd79 && yCounter == 7'd59) begin
                  oX <= pv_draw_x + xCounter;
                  oY <= pv_draw_y + yCounter;
                  oColour <= pv_draw;

                  //setting next image location
                  xCounter <= 0;
                  yCounter <= 0;
               end
               else begin
                  oX <= pv_draw_x + xCounter;
                  oY <= pv_draw_y + yCounter;
                  oColour <= pv_draw;
                     
                  if(xCounter == 8'd79 && yCounter != 7'd59) begin
                     xCounter <= 0;
                     yCounter <= yCounter + 1;
                  end
                  else begin
                     xCounter <= xCounter + 1;
                  end
               end
         end

         if(oPlot == 1 && ld_draw2 == 1) begin
            if(xCounter == 8'd79 && yCounter == 7'd59) begin
                  oX <= pv_draw_x + xCounter;
                  oY <= pv_draw_y + yCounter;
                  oColour <= pv_draw;

                  //setting next image location
                  xCounter <= 0;
                  yCounter <= 0;
               end
               else begin
                  oX <= pv_draw_x + xCounter;
                  oY <= pv_draw_y + yCounter;
                  oColour <= pv_draw;
                     
                  if(xCounter == 8'd79 && yCounter != 7'd59) begin
                     xCounter <= 0;
                     yCounter <= yCounter + 1;
                  end
                  else begin
                     xCounter <= xCounter + 1;
                  end
               end
         end

         if(oPlot == 1 && ld_draw3 == 1) begin
            if(xCounter == 8'd79 && yCounter == 7'd59) begin
                  oX <= pv_draw_x + xCounter;
                  oY <= pv_draw_y + yCounter;
                  oColour <= pv_draw;

                  //setting next image location
                  xCounter <= 0;
                  yCounter <= 0;
               end
               else begin
                  oX <= pv_draw_x + xCounter;
                  oY <= pv_draw_y + yCounter;
                  oColour <= pv_draw;
                     
                  if(xCounter == 8'd79 && yCounter != 7'd59) begin
                     xCounter <= 0;
                     yCounter <= yCounter + 1;
                  end
                  else begin
                     xCounter <= xCounter + 1;
                  end
               end
         end

         if(oPlot == 1 && ld_draw4 == 1) begin
            if(xCounter == 8'd79 && yCounter == 7'd59) begin
                  oX <= pv_draw_x + xCounter;
                  oY <= pv_draw_y + yCounter;
                  oColour <= pv_draw;

                  //setting next image location
                  xCounter <= 0;
                  yCounter <= 0;
               end
               else begin
                  oX <= pv_draw_x + xCounter;
                  oY <= pv_draw_y + yCounter;
                  oColour <= pv_draw;
                     
                  if(xCounter == 8'd79 && yCounter != 7'd59) begin
                     xCounter <= 0;
                     yCounter <= yCounter + 1;
                  end
                  else begin
                     xCounter <= xCounter + 1;
                  end
               end
         end
      end


   end

endmodule
