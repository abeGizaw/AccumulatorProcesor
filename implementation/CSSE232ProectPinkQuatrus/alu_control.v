// ALU control

module alu_control (
input [4:0] Opcode,
input [1:0] ALUOp,
input [4:0] AlterOp,
output reg [3:0] out);



   always @ (Opcode, ALUOp, AlterOp)
     begin
	  case (ALUOp)
			2'b10:
			  case (Opcode)
			  
				5'b00000:
					begin
						$display("ADD");
						out = 4'b0000;
					end 
				 
				5'b00001:
					begin
						$display("SUB");
						out = 4'b0001;
					end 
					
				5'b00010:
					begin
						$display("XOR");
						out = 4'b0111;
					end 
				 
				 5'b00011:
					begin
						$display("OR");
						out = 4'b0101;
					end
					
				 5'b00100:
					begin
						$display("AND");
						out = 4'b0110;
					end 
				 
				 5'b00101:
					begin
						$display("SLL");
						out = 4'b0010;
					end
				
				 5'b01000:
					begin
						$display("ORI");
						out = 4'b0101;
					end
					
				 5'b01001:
					begin
						$display("XORI");
						out = 4'b0111;
					end 
				 
				 5'b01010:
					begin
						$display("ANDI");
						out = 4'b0110;
					end
					
				 5'b01011:
					begin
						$display("ADDI");
						out = 4'b0000;
					end 
				 
				 5'b01100:
					begin
						$display("SLLI");
						out = 4'b0010;
					end
					
				 5'b01101:
					begin
						$display("SRLI");
						out = 4'b0011;
					end 
				 
				 5'b01110:
					begin
						$display("SRAI");
						out = 4'b0100;
					end 
					
				 5'b01111:
					begin
						$display("SLT");
						out = 4'b1011;
					end 
				 
				 5'b10000:
					begin
						$display("BEQ");
						out = 4'b1000;
					end
					
				 5'b10001:
					begin
						$display("BNQ");
						out = 4'b1001;
					end 
				 
				 5'b10010:
					begin
						$display("BLT");
						out = 4'b1010;
					end
					
				 5'b10011:
					begin
						$display("BGE");
						out = 4'b1011;
					end 
				 
				 5'b10111:
					begin
						$display("STORESP");
						out = 4'b0000;
					end
					
				 5'b11000:
					begin
						$display("LOADSP");
						out = 4'b1111;
					end 
				 
				 5'b11001:
					begin
						$display("MOVESP");
						out = 4'b0000;
					end
					
				 5'b11101:
					begin
						$display("SWAP");
						out = 4'b1110;
					end
					
				5'b10100:
					begin
						$display("JAL");
						out = 4'b0001;
					end
					
				5'b11010:
					begin
						$display("Input");
						out = 4'b0000;
					end
					
				
				endcase
			2'b00: 
				out = 4'b0000;
			
			2'b01:
			  out = 4'b0001;
			  
			2'b11:
			  case (AlterOp)
				 5'b00000:
					 out = 4'b0000;
				 5'b00001:
					 out = 4'b0001;
				 5'b00110:
					 out = 4'b0011;
				 5'b00111:
					 out = 4'b0100;
				 5'b01101:
					 out = 4'b1100;
			  	 5'b01110:
					 out = 4'b1101;
			  endcase	
			
			default:
				out = 4'b1010;
				
		endcase
	end 
endmodule 
