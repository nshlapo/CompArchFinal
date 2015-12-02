#CPU with Advanced Math Operations
####David Abrahams, Nur Shlapobersky, Jenny Vaccaro, Sarah Walters

###Project Description

We are planning to extend one of our single-cycle CPUs from Lab 3 to support advanced math operations, which necessitates the addition of a Floating-Point Unit. At minimum, we will implement multiplication and division in both our integer ALU and our fp ALU. We plan to support square root approximation, and as a stretch goal we will add trigonometric or exponential approximations. We will add the new operations to our CPU’s ALU, and we will write Assembly programs to demonstrate the operations’ functionalities.

###Resources:
* [Multiplication Vids](http://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/lecture-videos/lecture-12-square-roots-newtons-method/)
 * This video lecture describes algorithms for high-precision multiplication, high-precision
            division (using Newton’s Method with division by powers of two, which is easy in base 2),
            and square root approximation (using Newton’s Method and the previously explained
            multiplication and division algorithms).
* [Floaing-point instructions and architecture](http://www.cim.mcgill.ca/~langer/273/12-coprocessors.pdf)
 * Describes basic architecture and additional instructions for using floating-point arithmetic
* [FPU Design in MIPS](http://chrispro.to/fpu-report.pdf)
 * Describes floating point unit design in the context of the MIPS architecture
* [Logarithm Approximation](http://www.phy6.org/stargaze/Slog4.htm)
 * Describes an algorithm for approximating logarithms
* [Floating-point multiplication](http://www.cs.umd.edu/class/sum2003/cmsc311/Notes/BinMath/multFloat.html)
 * Describes an algorithm for floating-point multiplication
* [Floating-point load](http://stackoverflow.com/questions/2589233/mips-or-spim-loading-floating-point-numbers)
 * Describes the MIPs standard for loading a floating point value (single or double precision)

###Deliverables
Minimum
* Design and construct a Floating Point Unit which supports two operations (multiplication and division) that can integrate with our current single cycle CPU

Planned
* Add square root approximation to the FPU

Stretch
* Add trigonometric/exponential/logarithmic function approximation to the FPU
* Create a FPU which supports multiplication and division with complex numbers

###Work Plan
Add floating-point functionality to our CPU
* Design and create Floating-Point Unit (FPU)
 * Floating-point ALU -- 3hr
 * 32 floating-point registers -- 30min
 * int-float conversion -- 1.5hr
* Add floating-point commands to our instruction decoder -- 2hr

Simulate multiplication in Verilog and add to floating-point ALU and the CPU’s ALU
* Determine multiplication algorithm -- 30min
* Draw block diagram -- 30min
* Write Verilog -- 1hr
* Write Verilog test bench -- 1hr
* Write Assembly test bench -- 30min

__MIDPOINT CHECK-IN__: floating point done

Simulate division in Verilog and add to floating-point ALU and the CPU’s ALU
* Determine division algorithm -- 2hr
* Draw block diagram -- 1hr
* Write Verilog -- 1hr
* Write Verilog test bench -- 1hr
* Write Assembly test bench -- 30min

Simulate square root approximation in Verilog and add to floating-point ALU
* Determine square root approximation algorithm -- 3hr
* Draw block diagram -- 1hr
* Write Verilog -- 1hr
* Write Verilog test bench -- 1hr
* Write Assembly test bench -- 30min

Questions
* floating-point advice?
* specific hazards?
* can this be done in single-cycle? or do we need to fake multi-cycle?
