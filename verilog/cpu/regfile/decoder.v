// 32 bit decoder with enable signal
//   enable=0: all output bits are 0
//   enable=1: out[address] is 1, all other outputs are 0
module decoder1to32
(
output[31:0]	out,
input		enable,
input[4:0]	address
);

    // The `<<` operator left-shifts enable by address bits
    // out is 32 bits long, so the result of the << operation gets left-padded with zeros
    // so: out is 32'b0 when enable is 0
    //     out is 32'b0 but with a 1 in the address-th bit when enable is 1
    assign out = enable<<address;

endmodule

