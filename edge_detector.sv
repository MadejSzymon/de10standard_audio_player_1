module edge_detector(clk,level,tick);

//INPUTS:
input wire clk; 
input wire level; 
//clk - WIRE FROM (PLL) 
//level - WIRE FROM (PUSH BUTTON) 

//OUTPUTS:
output reg tick;
//tick - REGISTER THAT STORES VALUE OF TICK (IMPULSE THAT INFORMS THE REST OF THE CIRCUIT ABOUT INTERACTION)

//OTHER NETS AND VARIABLES:
reg state_reg;
reg state_next;
//state_reg - REGISTER THAT STORES VALUE OF CURRENT STATE
//state_next - REGISTER THAT STORES VALUE OF AFTER-CLK-CYCLE STATE

//////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
initial 
begin
	tick <= 0;
	state_reg <= 1;
	state_next <= 1;
end
	
localparam  
    zero = 1'b0,
    one =  1'b1;



always @(posedge clk)
begin
        state_reg <= state_next;
end

always @(state_reg, level)
begin
    // store current state as next
    state_next = state_reg; // required: when no case statement is satisfied
    
    tick = 1'b0; // set tick to zero (so that 'tick = 1' is available for 1 cycle only)
    case(state_reg)
        zero: // set 'tick = 1' if state = zero and level = '1'
            if(level)  
                begin // if level is 1, then go to state one,
                    state_next = one; // otherwise remain in same state.
                    tick = 1'b1;
                end
        one: 
            if(~level) // if level is 0, then go to zero state,
                state_next = zero; // otherwise remain in one state.
				
    endcase
end
endmodule 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////