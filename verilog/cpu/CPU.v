module CPU(
	input clk
);

// 32 bit wires to connect components of CPU
wire [31:0] wire0, wire1, wire2, wire3, wire4, wire5, wire6, wire8, wire9, wire10, wire13;

// Wires for flags and control signals
wire branch, reg_write, mem_write, alu_src, jal, zero;
wire [1:0] jump, reg_dst, mem_to_reg;
wire [2:0] alu_ctrl;
wire [4:0] Rs, Rt, Rd, wire11, wire12;
wire [15:0] immediate;
wire [25:0] target;

wire [9:0] wire2_10b, wire3_10b;
wire [29:0] wire1_30b;

// Instantiate register file
regfile regfile(
	.ReadData1(wire0),
	.ReadData2(wire9),
	.WriteData(wire5),
	.ReadRegister1(Rs),
	.ReadRegister2(Rt),
	.WriteRegister(wire11),
	.RegWrite(reg_write),
	.Clk(clk)
);

// Instantiate Arithmetic Logic Unit
ALU alu(
	.result(wire3),
	.carryflag(),
	.overflag(),
	.zero(zero),
	.a(wire0),
	.b(wire8),
	.selector(alu_ctrl)
);

// Instantiate sign extend unit
sign_extend signExt(
	.immediate(immediate),
	.extended(wire10)
);

// Instantiate memory unit
memory memory(
	.clk(clk),
	.regWE(mem_write),

	.DataAddr(wire3_10b),
	.DataIn(wire7),
	.InstrAddr(wire2_10b),
	.DataOut(wire4),
	.InstrOut(wire6)
);

// Instantiate instruction fetch unit
instr_fetch instr_fetch(
	.clk(clk),
	.branch(branch),
	.zero(zero),
	.jal(jal),
	.jump(jump),
	.imm16(immediate),
	.target(target),
	.Da(wire0),
	.outAdder(wire1_30b),
	.address(wire2)
);

// Instantiate instruction decoder unit
instr_decoder instr_decoder(
	.instruction(wire6),
	.clk(clk),
	.branch(branch),
	.reg_write(reg_write),
	.mem_write(mem_write),
	.alu_src(alu_src),
	.jal(jal),
	.jump(jump),
	.reg_dst(reg_dst),
	.mem_to_reg(mem_to_reg),
	.alu_ctrl(alu_ctrl),
	.Rs(Rs),
	.Rt(Rt),
	.Rd(Rd),
	.immediate(immediate),
	.target(target)
);

// Connect all components together
assign wire2_10b = wire2[9:0];
assign wire3_10b = wire3[9:0];
assign wire1_30b = wire1[29:0];

assign wire8 = alu_src ? wire10 : wire9;

// Address multiplexer
assign wire12 = reg_dst[0] ? Rd : Rt;
assign wire11 = reg_dst[1] ? 5'd31 : wire12;

// Mem_to_reg multiplexer
assign wire13 = mem_to_reg[0] ? wire4 : wire3;
assign wire5 = mem_to_reg[1] ? wire1 : wire13;

endmodule
