module testSignEx();
    // parameter width;
    reg [15:0] immediate;
    wire [31:0] extended;

    sign_extend #(32) dut (.immediate(immediate), .extended(extended));

    initial begin
        immediate = 16'b0; #10
        $display("%b", extended);
        immediate = 16'b1; #10
        $display("%b", extended);
        immediate = 16'b1000; #10
        $display("%b", extended);
        immediate = 16'b1000000000000000; #10
        $display("%b", extended);
    end
endmodule