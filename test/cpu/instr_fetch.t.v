module test_instrFetch();

	reg clk, branch, zero, jal;
	reg [1:0] jump;
	reg [15:0] imm16;
	reg [25:0] target;
	reg [31:0] Da;

	wire [29:0] outAdder;
	wire [31:0] address;

	reg dutpassed;

	instr_fetch dut(
		.clk(clk),
		.branch(branch),
		.zero(zero),
		.jal(jal),
		.jump(jump),
		.imm16(imm16),
		.target(target),
		.Da(Da),
		.outAdder(outAdder),
		.address(address)
	);

	initial begin
		dutpassed = 1;
		clk = 0;

		// Initially set flags for normal case (!jump, !branch)
		branch = 0;
		zero = 0;
		jal = 0;
		jump = 2'b0;
		imm16 = 16'b0;
		target = 26'b0;
		Da = 32'b0;

		#10 clk = 1; #10 clk = 0;

		// Tests whether PC will increment in normal case; should be 4
		if (address != 32'd4) begin
			$display("PC failed to increment in non-jump, non-branch case.");
			dutpassed = 0;
		end

		// Tests whether PC will increment in normal case; should be 8
		#10 clk = 1; #10 clk = 0;
		if (address != 32'd8) begin
			$display("PC failed to increment in non-jump, non-branch case.");
			dutpassed = 0;
		end

		// Set branch and imm for branch test
		branch = 1;
		imm16 = 16'd24;
		zero = 1;

		// Tests whether PC will branch correctly; should be 32
		#10 clk = 1; #10 clk = 0;
		if (address != 32'd36) begin
			$display("PC failed to branch.");
			dutpassed = 0;
		end

		branch = 0;
		jump = 2'b10;
		target = 26'd200;

		// Tests whether PC will jump correctly; should be 200
		#10 clk = 1; #10 clk = 0;
		if (address != 26'd800) begin
			$display("PC failed to jump.");
			dutpassed = 0;
		end

		$display("Instruction Fetch Passed? %b", dutpassed);
	end

endmodule
