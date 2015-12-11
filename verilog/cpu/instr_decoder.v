/*
Instruction Decoder

Takes in an instruction, outputs all control signals for CPU components
*/


module instr_decoder (
    input [31:0] instruction,
    input clk,
    output reg branch, reg_write, mem_write, alu_src, jal, fp_reg_write, fp_alu_src,
    output reg [1:0] jump, reg_dst, mem_to_reg, fp_reg_dst,
    output reg [2:0] alu_ctrl, fp_alu_cntrl,
    output reg [4:0] Rs, Rt, Rd,
    output reg [15:0] immediate,
    output reg [25:0] target
);

// CPU
// ...opcode parameters
parameter LW = 6'h23;
parameter SW = 6'h2b;
parameter J = 6'h2;
parameter JAL = 6'h3;
parameter BNE = 6'h5;
parameter ADDI = 6'h8;
parameter FUNC = 6'h0;

// ...function parameters for R-types
parameter XORI = 6'he;
parameter ADD = 6'h20;
parameter SUB = 6'h22;
parameter SLT = 6'h2a;
parameter JR = 6'h8;

// FPU
// ...opcode parameters
parameter FPU_FUNC = 6'h11;

// ...function parameters
parameter FPU_ADD_S = 6'h0; // add.s
parameter FPU_MUL_S = 6'h2; // mul.s
parameter FPU_DIV_S = 6'h3; // div.s
parameter FPU_SQRT_S = 6'h4; // sqrt.s
parameter FPU_MULTI_S = 6'h5; // multiply by immediate -- need to pick instr. to steal

reg [5:0] op_code, func_code;

// Listen for instruction change
always @(instruction) begin

    op_code = instruction[31:26];
    Rs = instruction[25:21];
    Rt = instruction[20:16];
    Rd = instruction[15:11];
    func_code = instruction[5:0];
    target = instruction[25:0];

    case (op_code)

        // Load word
        LW: begin
            branch = 1'b0;
            reg_write = 1'b1;
            mem_write = 1'b0;
            alu_src = 1'b1;
            jal = 1'b0;
            jump = 2'b0;
            reg_dst = 2'b0;
            mem_to_reg = 2'b1;
            alu_ctrl = 3'b0;
            immediate = instruction[15:0];

            fp_reg_write = 1'b0;
            fp_alu_cntrl = 3'bx;
            fp_reg_dst = 2'bx;
            fp_alu_src = 1'bx;
        end

        // Store word
        SW: begin
            branch = 1'b0;
            reg_write = 1'b0;
            mem_write = 1'b1;
            alu_src = 1'b1;
            jal = 1'b0;
            jump = 2'b0;
            reg_dst = 2'bx;
            mem_to_reg = 2'bx;
            alu_ctrl = 3'b0;
            immediate = instruction[15:0];

            fp_reg_write = 1'b0;
            fp_alu_cntrl = 3'bx;
            fp_reg_dst = 2'bx;
            fp_alu_src = 1'bx;
        end

        // Jump
        J: begin
            branch = 1'b0;
            reg_write = 1'b0;
            mem_write = 1'b0;
            alu_src = 1'bx;
            jal = 1'bx;
            jump = 2'b10;
            reg_dst = 2'bx;
            mem_to_reg = 2'bx;
            alu_ctrl = 3'bx;
            immediate = instruction[15:0];

            fp_reg_write = 1'b0;
            fp_alu_cntrl = 3'bx;
            fp_reg_dst = 2'bx;
            fp_alu_src = 1'bx;
        end

        // Jump aligned
        JAL: begin
            branch = 1'b0;
            reg_write = 1'b1;
            mem_write = 1'b0;
            alu_src = 1'bx;
            jal = 1'b1;
            jump = 2'b10;
            reg_dst = 2'b10;
            mem_to_reg = 2'b10;
            alu_ctrl = 3'bx;
            immediate = 16'd8;

            fp_reg_write = 1'b0;
            fp_alu_cntrl = 3'bx;
            fp_reg_dst = 2'bx;
            fp_alu_src = 1'bx;
        end

        // Branch not equal
        BNE: begin
            branch = 1'b1;
            reg_write = 1'b0;
            mem_write = 1'b0;
            alu_src = 1'b0;
            jal = 1'b0;
            jump = 2'b0;
            reg_dst = 2'bx;
            mem_to_reg = 2'bx;
            alu_ctrl = 3'b1;
            immediate = instruction[15:0];

            fp_reg_write = 1'b0;
            fp_alu_cntrl = 3'bx;
            fp_reg_dst = 2'bx;
            fp_alu_src = 1'bx;
        end

        // Add immediate
        ADDI: begin
            branch = 1'b0;
            reg_write = 1'b1;
            mem_write = 1'b0;
            alu_src = 1'b1;
            jal = 1'b0;
            jump = 2'b0;
            reg_dst = 2'b0;
            mem_to_reg = 2'b0;
            alu_ctrl = 3'b0;
            immediate = instruction[15:0];

            fp_reg_write = 1'b0;
            fp_alu_cntrl = 3'bx;
            fp_reg_dst = 2'bx;
            fp_alu_src = 1'bx;
        end

        // R-types, opcode = 0
        FUNC: begin
            branch = 1'b0;
            mem_write = 1'b0;
            mem_to_reg = 2'b0;
            jal = 1'b0;
            reg_dst = 2'b1;
            immediate = instruction[15:0];

            fp_reg_write = 1'b0;
            fp_alu_cntrl = 3'bx;
            fp_reg_dst = 2'bx;
            fp_alu_src = 1'bx;

            case (func_code)

                XORI: begin
                    reg_write = 1'b1;
                    alu_src = 1'b1;
                    jump =  2'b0;
                    alu_ctrl = 3'd2;
                end

                ADD: begin
                    reg_write = 1'b1;
                    alu_src = 1'b0;
                    jump =  2'b0;
                    alu_ctrl = 3'd0;
                end

                SUB: begin
                    reg_write = 1'b1;
                    alu_src = 1'b0;
                    jump = 2'b0;
                    alu_ctrl = 3'd1;
                end

                SLT: begin
                    reg_write = 1'b1;
                    alu_src = 1'b0;
                    jump = 2'b0;
                    alu_ctrl = 3'd3;
                end

                JR: begin
                    reg_write = 1'b0;
                    alu_src = 1'bx;
                    jump = 2'b1;
                    alu_ctrl = 3'bx;
                end
            endcase
        end

        // FPU R-types, opcode = 6'h11
        FPU_FUNC: begin
            branch = 1'b0;
            reg_write = 1'b0;
            mem_write = 1'b0;
            alu_src = 1'bx;
            jal = 1'b0;
            jump =  2'b0;
            reg_dst = 2'bx;
            mem_to_reg = 2'bx;
            alu_ctrl = 3'bx;
            immediate = instruction[15:0];

            fp_reg_write = 1'b1;

            case (func_code)

                FPU_ADD_S: begin
                    fp_alu_cntrl = 3'd0;
                    fp_reg_dst = 2'b1;
                    fp_alu_src = 1'b0;
                end

                FPU_MUL_S: begin
                    fp_alu_cntrl = 3'd1;
                    fp_reg_dst = 2'b1;
                    fp_alu_src = 1'b0;
                end

                FPU_DIV_S: begin
                    fp_alu_cntrl = 3'd2;
                    fp_reg_dst = 2'b1;
                    fp_alu_src = 1'b0;
                end

                FPU_SQRT_S: begin
                    fp_alu_cntrl = 3'd3;
                    fp_reg_dst = 2'b1;
                    fp_alu_src = 1'b0;
                end

                FPU_MULTI_S: begin
                    fp_alu_cntrl = 3'd1;
                    fp_reg_dst = 2'b0;
                    fp_alu_src = 1'b1;
                end

            endcase
        end

        // Default case
        default: begin
            branch = 1'b0;
            reg_write = 1'b0;
            mem_write = 1'b0;
            alu_src = 1'b0;
            jal = 1'b0;
            jump = 2'b0;
            reg_dst = 2'b0;
            mem_to_reg = 2'b0;
            alu_ctrl = 3'b0;
            immediate = instruction[15:0];

            fp_reg_write = 1'b0;
            fp_alu_cntrl = 3'b0;
            fp_reg_dst = 2'b0;
            fp_alu_src = 1'b0;
        end
    endcase
end
endmodule
