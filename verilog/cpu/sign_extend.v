/* Sign Extender

Takes in a number of specified size, sign extends to specified width
*/

module sign_extend
    #(parameter width = 32, size = 16)
     (input [size-1:0] immediate,
      output [width-1:0] extended);

    assign extended = {{(width-size){immediate[size-1]}}, immediate};
endmodule
