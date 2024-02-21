//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    02/1/2024 
// Module Name:    Control unit
// Project Name: 
//
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

// Cycle 29 and 30, SRL is not a thing anymore and the opcode is no longer an R-Type, SRA is not a thing anymore and the opcode is no longer an R-Type

module control_unit (ALUOp,
                          ALUSrcA,
                          ALUSrcB,
                          MemtoReg,
                          RegWrite, 
                          MemRead,
                          MemWrite,
                          IorD,
                          IRWrite, 
                          PCWrite,
                          Opcode,
                          CLK,
								  Jump,
								  Branch,
								  shouldBranch,
								  RegFileSrc,
								  ReturnSrc,
								  DataSrc,
								  OperandSrc,
								  SPWrite,
								  Output,
								  Reset
                          );

	integer temp;
								  
   output [1:0]		  ALUOp;
   output [1:0]        ALUSrcA;
   output [1:0]        ALUSrcB;
   output [1:0]        MemtoReg;
   output              RegWrite;
   output              MemRead;
   output              MemWrite;
   output [1:0]        IorD;
   output              IRWrite;
   output              PCWrite;
	output              Jump;
	output [1:0]        Branch;
	output              shouldBranch;
	output [1:0]        RegFileSrc;
	output [2:0]        ReturnSrc;
	output [1:0]  		  DataSrc;
	output [1:0]        OperandSrc;
	output              SPWrite;
	output              Output;
	output              Reset;
	
	
	
   //-- You can add these state registers to the IO pins in the module
   //-- declaration and uncomment the output statements here if you want, but
   //-- Quartus won't identify this as a State Machine with the state
   //-- registers as inputs or outputs.
   //output [3:0] current_state;
   //output [3:0] next_state;

   input [4:0]  Opcode;
   input        CLK;

   reg [1:0]		  ALUOp;
   reg [1:0]        ALUSrcA;
   reg [1:0]        ALUSrcB;
   reg [1:0]        MemtoReg;
   reg              RegWrite;
   reg              MemRead;
   reg              MemWrite;
   reg [1:0]        IorD;
   reg              IRWrite;
   reg              PCWrite;
	reg              Jump;
	reg [1:0]        Branch;
	reg              shouldBranch;
	reg [1:0]        RegFileSrc;
	reg [2:0]        ReturnSrc;
	reg [1:0]  		  DataSrc;
	reg [1:0]        OperandSrc;
	reg        		  SPWrite;
	reg        		  Output;
	reg        		  Reset;
	

   //state flip-flops
   reg [4:0]    current_state;
   reg [4:0]    next_state;

   //state definitions
	parameter    Restart = 0; // Not sure if we need this or not
   parameter    Fetch = 1; // Cycle 1
   parameter    Decode = 2; // Cycle 2
   parameter    cycle_3 = 3; // R-Type not load or store instruction
   parameter    cycle_4 = 4; // R-Type or I-Type not a load, store, loadsp, or storesp instruction
   parameter    cycle_5 = 5; // R-Type store instruction
   parameter    cycle_6 = 6; // R-Type load instruction
   parameter    cycle_7 = 7; // I-Type not loadsp or storesp instruction
   parameter    cycle_8 = 8; // I-Type that is loadsp or storesp instruction or a J-Type that is a movesp instruction
   parameter    cycle_9 = 9; // I-Type that is loadsp instruction
   parameter    cycle_10 = 10; // I-Type that is loadsp instruction
	parameter    cycle_11 = 11; // I-Type that is storesp instruction
	parameter    cycle_12 = 12; // B-Type instruction
	parameter    cycle_13 = 13; // A-Type instruction
	parameter    cycle_14 = 14; // A-Type instruction
	parameter    cycle_15 = 15; // C-Type instruction
	parameter    cycle_16 = 16; // C-Type instruction
	parameter    cycle_17 = 17; // J-Type that is a lui instruction
	parameter    cycle_18 = 18; // J-Type that is a movesp instruction
	parameter    cycle_19 = 19; // J-Type that is a jal instruction
	parameter    cycle_20 = 20; // J-Type that is jb instruction
	parameter    cycle_21 = 21; // J-Type that is jal instruction
	parameter    cycle_22 = 22; // J-Type that is jal instruction
	parameter    cycle_23 = 23; // J-Type that is jal instruction
	parameter    cycle_24 = 24; // J-Type that is jal instruction
	parameter    cycle_25 = 25; // J-Type that is jb instruction
	parameter    cycle_26 = 26; // J-Type that is jb instruction
	parameter    cycle_27 = 27; // J-Type that is jb instruction
	parameter    cycle_28 = 28; // J-Type that is jb instruction
	parameter    cycle_29 = 29; // J-Type that is jb instruction
	parameter    cycle_30 = 30; // J-Type that is jb instruction
	parameter    cycle_31 = 31;
	
	initial begin
		current_state = Restart;
	end
	

   //register calculationS
   always @ (posedge CLK)
     begin
		  current_state = next_state;
     end


   //OUTPUT signals for each state (depends on current state)
   always @ (current_state)
     begin
        //Reset all signals that cannot be don't cares
        clearsig;
		  // SP = 0xFFF8 (Not sure if I need this here)
		  // PC = 0x0	  (Not sure if I need this here)
        
        case (current_state)
		  
			Restart:
            begin
               Reset = 1;
				end 
          
          Fetch: // Cycle 1
            begin
               PCWrite = 1;
					IorD = 2'b00;
					MemRead = 1;
					ALUSrcA = 2'b00;
					ALUSrcB = 2'b11;
					Branch = 2'b00;
					ALUOp = 2'b00;
					MemWrite = 0;
					RegWrite = 0;
					SPWrite = 0;
					OperandSrc = 2'b00;
					ReturnSrc = 3'b000;
            end 
                         
          Decode: // Cycle 2
            begin
               IorD = 2'b01;
					MemRead = 1;
					ALUSrcA = 2'b00;
					ALUSrcB = 2'b01;
					ALUOp = 2'b00;
					PCWrite = 0;
					IRWrite = 1;
            end
        
          cycle_3:
            begin
               ALUSrcA = 2'b10;
					ALUSrcB = 2'b10;
					ALUOp = 2'b10;
					MemRead = 0;
            end
        
          cycle_4:
            begin
               RegWrite = 1;
					RegFileSrc = 2'b10;
					ReturnSrc = 3'b00;
            end
        
          cycle_5:
            begin
               MemWrite = 1;
					IorD = 2'b01;
					IRWrite = 0;
            end
        
          cycle_6:
            begin
               RegWrite = 1;
					RegFileSrc = 2'b00;
					ReturnSrc = 3'b00;
            end
          
          cycle_7:
            begin
               ALUSrcA = 2'b10;
					ALUSrcB = 2'b001;
					ALUOp = 2'b10;
					MemRead = 0;
            end
        
          cycle_8:
            begin
					ALUSrcA = 2'b11;
					ALUSrcB = 2'b01;
					ALUOp = 2'b10;
				end
				
			 cycle_9:
            begin
					IorD = 2'b10;
					MemRead = 1;
				end
				
			 cycle_10:
            begin
					RegFileSrc = 2'b00;
					RegWrite = 1;
					ReturnSrc = 3'b000;
					MemRead = 0;
				end
				
			 cycle_11:
            begin
					MemWrite = 1;
					IorD = 2'b10;
					DataSrc = 2'b01;
				end
				
			 cycle_12:
            begin
					ALUOp = 2'b10;
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b00;
					Branch = 2'b01;
					MemRead = 0;
				end
				
			 cycle_13:
            begin
					ALUSrcA = 2'b10;
					ALUSrcB = 2'b00;
					ALUOp = 2'b11;
					MemRead = 0;
				end
				
			 cycle_14:
            begin
					RegWrite = 1;
					ReturnSrc = 3'b01;
					RegFileSrc = 3'b10;
				end
				
			 cycle_15:
            begin
					ALUSrcA = 2'b10;
					ALUOp = 2'b10;
					RegFileSrc = 2'b01;
					RegWrite = 1;
					ReturnSrc = 3'b00;
				end
				
			 cycle_16:
            begin
					ReturnSrc = 3'b10;
					RegWrite = 1;
					RegFileSrc = 2'b10;
				end
				
			 cycle_17:
            begin
					ReturnSrc = 3'b011;
					RegFileSrc = 2'b11;
					RegWrite = 1;
					MemRead = 0;
				end
				
			 cycle_18:
            begin
					SPWrite = 1;
				end
				
			 cycle_19:
            begin
					ALUSrcA = 2'b11;
					ALUSrcB = 2'b11;
					ALUOp = 2'b10;
				end
				
			 cycle_20:
            begin
					MemRead = 1;
					IorD = 2'b11;
					ALUSrcA = 2'b11;
					ALUSrcB = 2'b11;
					ALUOp = 2'b10;
				end
				
			 cycle_21:
            begin
					OperandSrc = 2'b11;
					DataSrc = 2'b00;
					IorD = 2'b10;
					MemWrite = 1;
					ALUSrcA = 2'b01;
					ALUSrcB = 2'b11;
					ALUOp = 2'b10;
				end
				
			 cycle_22:
            begin
					OperandSrc = 2'b10;
					DataSrc = 2'b01;
					IorD = 2'b10;
					MemWrite = 1;
					ALUSrcA = 2'b01;
					ALUSrcB = 2'b11;
					ALUOp = 2'b10;
				end
				
			 cycle_23:
            begin
					OperandSrc = 2'b01;
					DataSrc = 2'b01;
					IorD = 2'b10;
					MemWrite = 1;
					ALUSrcA = 2'b01;
					ALUSrcB = 2'b11;
					ALUOp = 2'b10;
				end
				
			 cycle_24:
            begin
					DataSrc = 2'b01;
					IorD = 2'b10;
					MemWrite = 1;
					SPWrite = 1;
					ALUSrcA = 2'b00;
					ALUSrcB = 2'b01;
					ALUOp = 2'b00;
					Jump = 1;
					Branch = 2'b00;
				end
				
			 cycle_25:
            begin
					RegFileSrc = 2'b00;
					ReturnSrc = 3'b101;
					RegWrite = 1;
					MemRead = 1;
					IorD = 2'b10;
					ALUSrcA = 2'b01;
					ALUSrcB = 2'b11;
					ALUOp = 2'b10;
				end
				
			 cycle_26:
            begin
					RegFileSrc = 2'b00;
					ReturnSrc = 3'b100;
					RegWrite = 1;
					MemRead = 1;
					IorD = 2'b10;
					ALUSrcA = 2'b01;
					ALUSrcB = 2'b11;
					ALUOp = 2'b10;
				end
				
			cycle_27:
            begin
					RegFileSrc = 2'b00;
					ReturnSrc = 3'b011;
					RegWrite = 1;
					MemRead = 1;
					IorD = 2'b10;
					ALUSrcA = 2'b01;
					ALUSrcB = 2'b11;
					ALUOp = 2'b10;
				end
				
			 cycle_28:
            begin
					Branch = 2'b10;
					Jump = 1;
					SPWrite = 1;
					MemRead = 0;
					RegWrite = 0;
				end
				
			cycle_29:
            begin
					DataSrc = 2'b10;
					IorD = 2'b10;
					MemWrite = 1;
				end
				
			 cycle_30:
            begin
					RegFileSrc = 2'b11;
					ReturnSrc = 3'b00;
					RegWrite = 1;
					MemRead = 0;
				end
				
			cycle_31:
			begin
				Output = 1;
			end
				
			default:
            begin 
					////$display ("not implemented"); 
				end
          
        endcase
     end
                
   //NEXT STATE calculation (depends on current state and opcode)       
   always @ (current_state, next_state, Opcode)
     begin         
      //$display("The current state is %d", current_state);
        
        case (current_state)
          
          Fetch:
            begin
               next_state = Decode;
               ////$display("In Fetch, the next_state is %d", next_state);
            end
          
          Decode: 
            begin       
               //$display("The opcode is %b", Opcode);
					
					
					if ((Opcode >= 5'b00000 && Opcode <= 5'b00101) || Opcode ==  5'b01111) begin
							temp = 0; // R-Type that is not load or store instruction (cycle 3)
							
					end else if (Opcode >= 5'b01000 && Opcode <= 5'b01110) begin
							temp = 1; // I-Type that is not loadsp or storesp instruction (cycle 7)
							
					end else if (Opcode >= 5'b10000 && Opcode <= 5'b10011) begin
							temp = 2; // B-Type instruction (cycle 12)
					
					end else if (Opcode ==  5'b10111 || Opcode ==  5'b11000 || Opcode ==  5'b11001 || Opcode ==  5'b11010) begin
							temp = 3; // storesp, loadsp, movesp, or input instruction (cycle 8)
					
					end else if (Opcode ==  5'b10101) begin
							temp = 4; // load instruction (cycle 6)
					
					end else if (Opcode ==  5'b10110) begin
							temp = 5; // store instruction (cycle 5)
					
					end else if (Opcode ==  5'b11011) begin
							temp = 6; // lui instruction (cycle 17)
					
					end else if (Opcode ==  5'b10100) begin
							temp = 7; // jal instruction (cycle 19)
					
					end else if (Opcode ==  5'b11100) begin
							temp = 8; // jb instruction (cycle 20)
							
					end else if (Opcode ==  5'b00111) begin
							temp = 9; // stop instruction (reset)
							
					end else if (Opcode ==  5'b11110) begin
							temp = 10; // alter instruction (cycle 13)
					
					end else if (Opcode ==  5'b11101) begin
							temp = 11; // swap instruction (cycle 15)
							
					end else if (Opcode ==  5'b00110) begin
							temp = 12; // set instruction (cycle 30)
					end else if (Opcode ==  5'b11111) begin
							temp = 13; // output instruction (cycle 31)
					end
					
               case (temp)
                 0:
                   begin
                      next_state = cycle_3;
                      //$display("The next state is Cycle 3");
                   end
                 1:
                   begin
                      next_state = cycle_7;
                      //$display("The next state is Cycle 7");
                   end
                 2:
                   begin
                      next_state = cycle_12;
                      //$display("The next state is Cycle 12");
                   end
                 3:
                   begin
                      next_state = cycle_8;
                      //$display("The next state is Cycle 8");
                   end
                 4:
                   begin next_state = cycle_6;
                      //$display("The next state is Cycle 6");
                   end
					  5:
                   begin next_state = cycle_5;
                      //$display("The next state is Cycle 5");
                   end
					  6:
                   begin next_state = cycle_17;
                      //$display("The next state is Cycle 17");
                   end
					  7:
                   begin next_state = cycle_19;
                      //$display("The next state is Cycle 19");
                   end
					  8:
                   begin next_state = cycle_20;
                      //$display("The next state is Cycle 20");
                   end
					  9:
                   begin next_state = Restart;
                      //$display("The next state is Restart"); // Not sure if this is how reset is suppose to work
                   end
					  10:
                   begin next_state = cycle_13;
                      //$display("The next state is Cycle 13");
                   end
					  11:
                   begin next_state = cycle_15;
                      //$display("The next state is Cycle 15");
                   end
					  12:
						 begin next_state = cycle_30;
                      //$display("The next state is Cycle 30");
                   end
					  13:
						 begin next_state = cycle_31;
							 //$display("The next state is Cycle 31");
						 end
						  default:
                   begin 
                      //$display(" Wrong Opcode %d ", Opcode);  
                      next_state = Fetch; 
                   end
               endcase  
               
               //$display("In Decode, the next_state is %d", next_state);
            end
          
          cycle_3:
            begin
               next_state = cycle_4;
               //$display("In Cycle 3, the next_state is %d", next_state);
            end
          
          cycle_4:
            begin
               next_state = Fetch;
               //$display("In Cycle 4, the next_state is %d", next_state);
            end
          
          cycle_7:
            begin
               next_state = cycle_4;
               //$display("In Cycle 7, the next_state is %d", next_state);
            end

          cycle_12:
            begin
               next_state = Fetch;
               //$display("In Cycle 12, the next_state is %d", next_state);
            end
          
          cycle_8:
            begin
					if (Opcode ==  5'b11000) begin // loadsp
						next_state = cycle_9;
						
					end else if (Opcode ==  5'b10111) begin // storesp
						next_state = cycle_11;
						
					end else if (Opcode ==  5'b11001) begin // movesp
						next_state = cycle_18;
						
					end else if (Opcode ==  5'b11010) begin // input
						next_state = cycle_29;
					end else begin
						next_state = Restart;
					end
					
               //$display("In Cycle 8, the next_state is %d", next_state);
            end
				
			 cycle_9:
            begin
               next_state = cycle_10;
               //$display("In Cycle 9, the next_state is %d", next_state);
            end
				
			 cycle_10:
            begin
               next_state = Fetch;
               //$display("In Cycle 10, the next_state is %d", next_state);
            end
				
			 cycle_11:
            begin
               next_state = Fetch;
               //$display("In Cycle 11, the next_state is %d", next_state);
            end
				
			 cycle_18:
            begin
               next_state = Fetch;
               //$display("In Cycle 18, the next_state is %d", next_state);
            end
				
			 cycle_6:
            begin
               next_state = Fetch;
               //$display("In Cycle 6, the next_state is %d", next_state);
            end
				
			 cycle_5:
            begin
               next_state = Fetch;
               //$display("In Cycle 5, the next_state is %d", next_state);
            end
				
			 cycle_17:
            begin
               next_state = Fetch;
               //$display("In Cycle 17, the next_state is %d", next_state);
            end
				
			 cycle_19:
            begin
               next_state = cycle_21;
               //$display("In Cycle 19, the next_state is %d", next_state);
            end
				
			 cycle_21:
            begin
               next_state = cycle_22;
               //$display("In Cycle 21, the next_state is %d", next_state);
            end
				
			 cycle_22:
            begin
               next_state = cycle_23;
               //$display("In Cycle 22, the next_state is %d", next_state);
            end
				
			 cycle_23:
            begin
               next_state = cycle_24;
               //$display("In Cycle 23, the next_state is %d", next_state);
            end
				
			 cycle_24:
            begin
               next_state = Fetch;
               //$display("In Cycle 24, the next_state is %d", next_state);
            end
				
			 cycle_20:
            begin
               next_state = cycle_25;
               //$display("In Cycle 20, the next_state is %d", next_state);
            end
				
			 cycle_25:
            begin
               next_state = cycle_26;
               //$display("In Cycle 25, the next_state is %d", next_state);
            end
				
			 cycle_26:
            begin
               next_state = cycle_27;
               //$display("In Cycle 26, the next_state is %d", next_state);
            end
				
			 cycle_27:
            begin
               next_state = cycle_28;
               //$display("In Cycle 27, the next_state is %d", next_state);
            end
				
			 cycle_28:
            begin
               next_state = Fetch;
               //$display("In Cycle 28, the next_state is %d", next_state);
            end
				
			 Restart:
            begin
               next_state = Fetch;
               //$display("In Restart, the next_state is %d", next_state);
            end
				
			 cycle_13:
            begin
               next_state = cycle_14;
               //$display("In Cycle 13, the next_state is %d", next_state);
            end
				
			 cycle_14:
            begin
               next_state = Fetch;
               //$display("In Cycle 14, the next_state is %d", next_state);
            end
				
			 cycle_15:
            begin
               next_state = cycle_16;
               //$display("In Cycle 15, the next_state is %d", next_state);
            end
				
			 cycle_16:
            begin
               next_state = Fetch;
               //$display("In Cycle 16, the next_state is %d", next_state);
            end
				
			 cycle_29:
            begin
               next_state = Fetch;
               //$display("In Cycle 29, the next_state is %d", next_state);
            end
				
			 cycle_30:
            begin
               next_state = Fetch;
               //$display("In Cycle 30, the next_state is %d", next_state);
            end
				
			cycle_31:
			begin
				next_state = Fetch;
				//$display("In Cycle 31, the next_state is %d", next_state);
			end
          
          default:
            begin
               //$display(" Not implemented!");
               next_state = Fetch;
            end
          
        endcase
        
        ////$display("After the tests, the next_state is %d", next_state);
                
     end
	  
task clearsig;
	begin
		ALUOp = 0;
		ALUSrcA = 0;
		ALUSrcB = 0;
		MemtoReg = 0;
		RegWrite = 0;
		MemRead = 0;
		MemWrite = 0;
		IorD = 0;
		IRWrite = 0;
		PCWrite = 0;
		Jump = 0;
		Branch = 0;
		shouldBranch = 0;
		RegFileSrc = 0;
		ReturnSrc = 0;
		DataSrc = 0;
		OperandSrc = 0;
		SPWrite = 0;
		Reset = 0;
	end
endtask

endmodule