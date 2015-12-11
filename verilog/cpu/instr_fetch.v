/* Instruction Fetch Module

Reads in instructions, performs operations on PC based on instructions
*/

module instr_fetch (
    input clk, branch, zero, jal,
    input [1:0] jump,
    input [15:0] imm16,
    input [25:0] target,
    input [31:0] Da,
    output [29:0] outAdder,
    output [31:0] address
);

    wire [29:0] extended, inAdder, concWire;
    wire orWire, andWire;
    reg [29:0] PC = 30'h0;

    // Instantiate sign extender
    sign_extend #(30) ext (.immediate(imm16),
                           .extended(extended));

    and AND (andWire, branch, !zero);
    or OR (orWire, jal, andWire);

    // branch/jal control mux
    assign inAdder = orWire ? extended : 30'b0;

    // behavioral adder
    assign outAdder = PC + inAdder + 30'b1;

    // jump operation
    assign concWire = {PC[29:26], target};

    //output assignment
    assign address = PC << 2;

    // Mux to determine correct flow for jump control signal
    always @(posedge clk) begin
        case (jump)
            2'b00:
                PC <= outAdder;
            2'b01:
                PC <= Da[31:2];
            2'b10:
                PC <= concWire;
        endcase
    end
endmodule