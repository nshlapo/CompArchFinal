module register_testbench;
  // Regular register
  wire[31:0] q;
  reg[31:0] d;
  reg wrenable, clk;
  register32 r(q, d, wrenable, clk);

  // Zero register
  wire[31:0] q_z;
  reg[31:0] d_z;
  reg wrenable_z, clk_z;
  register32zero r_z(q_z, d_z, wrenable_z, clk_z);

  reg dutspassed;

  initial begin
    dutspassed = 1;

    // Set initial conditions for 32b register
    wrenable=1'b1; d=32'b0; clk=1'b0; #5
    clk=1'b1; #5 clk=1'b0; #5// trigger first clk posedge
    if (q !== 32'b0) begin
      dutspassed = 0;
      $display(" - 32b register: Initial Condition Setting Failed");
    end

    // -> WRITE ENABLED CASES
    // change d to 1; q won't change yet -- no clk posedge
    d=32'b1; #5
    if (q !== 32'b0) begin
      dutspassed = 0;
      $display(" - 32b register: Test Case 1 Failed");
    end

    // trigger posedge -> q will change to 1
    clk=1'b1; #5
    if (q !== 32'b1) begin
      dutspassed = 0;
      $display(" - 32b register: Test Case 2 Failed");
    end

    // change d back to 0; q won't change yet -- no clk posedge
    d=32'b0; clk=0'b0; #5
    if (q !== 32'b1) begin
      dutspassed = 0;
      $display(" - 32b register: Test Case 3 Failed");
    end

    // trigger posedge -> q will change to 0
    clk=1'b1; #5
    if (q !== 32'b0) begin
      dutspassed = 0;
      $display(" - 32b register: Test Case 4 Failed");
    end

    // -> WRITE DISABLED CASE
    wrenable=1'b0;

    // change d and trigger posedge -> q won't change because wrenable 0
    d=32'b1; clk=1'b0; #5 clk=1'b1; #5
    if (q !== 32'b0) begin
      dutspassed = 0;
      $display(" - 32b register: Test Case 5 Failed");
    end


    // Set initial conditions for zero register
    wrenable_z=1'b1; clk_z=1'b0; #5
    clk_z=1'b1; #5 clk_z=1'b0; #5 // trigger first clock posedge
    if (q_z !== 32'b0) begin
      dutspassed = 0;
      $display(" - Zero register: Initial Condition Setting Failed");
    end

    // q won't change even though clk posedge -- zero register
    clk_z=1'b1; #5
    if (q_z !== 32'b0) begin
      dutspassed = 0;
      $display(" - Zero register: Test Case 1 Failed");
    end

    $display("Registers passed?: %b", dutspassed);
  end

endmodule
