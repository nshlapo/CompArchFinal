[Link to Google Doc for working on writeup](https://docs.google.com/document/d/1Hcz5kvzhGNxFzRZeGMU3i1D9Fpzi3pAoX1fYA9cflWI/edit?usp=sharing)

[Link to Google Doc for working on presentation](https://docs.google.com/presentation/d/15q9rChHXG2N1TWunRFMkKt8hkOGpbc3Un-qYIrW7-RI/edit?usp=sharing)

#Floating Point Unit // Advanced Mathematical Operations
###David Abrahams, Jenny Vaccaro, Sarah Walters, Nur Shlapobersky

##Abstract
######We built an FPU which supports addition, multiplication, division, and square-root approximation in the IEEE Standard 754 floating point format.

A floating point unit is often termed a “math coprocessor”. It has its own floating point register file and its own floating point ALU, but it shares a data memory with the CPU. There are MIPS instructions for transferring values from the CPU’s register file to the FPU’s register file and for operating on the floating point registers.



##Significance
###Floating Point Math
The IEEE 754 standard enables computers to represent non-integer numbers. IEEE 754, like an ISA, is a specification which computers of different types can conform to in order to parse a binary string representing a floating point number in the same way. The floating point format is powerful because, with 32 bits, it is able to represent decimal numbers as large as +/- 3.4*10^38 and as small as +/- 2.9*10^-39 (ignoring denormalization) with 23 bits of precision. By contrast, 32-bit signed integers range from -2.2*10^9 to 2.2*10^9.

###Mathematical Function Estimations
Floating point units (FPUs) support mathematical operations in the floating point domain. With a small number of floating point operations (addition, multiplication, division, square root), we can compute excellent approximations to a variety of functions -- trigonometric, exponentials, and logarithms, among others.

##FPU Construction

![Basic FPU block diagram]()

We constructed our FPU by progressively building up the complexity of our mathematical components. We began with a simple converter from 32-bit integer format to 32-bit single precision floating point format, which is required if we want our CPU to be able to pass immediates to the FPU.

![Converter block diagram](img/final/converter.jpg)

The converter functions by first converting 2s complement negatives to their corresponding positive number. It left shifts the 32-bit fixed number until it encounters a 1 in the MSB. It then outputs the 23 MSBs, the correct 2^n exponent, and the sign bit of the original number.

###Multiplication

Our next module was an integer multiplier which performs a series of shifts and additions to calculate the product of two inputs. This was easily scalable into a floating-point multiplier, since the only additional operations needed were to keep track of exponents and appropriately place the radix point after a multiplication. The multiplier works similiar to how one does multiplication by hand, left shifting one of the operands and then adding it to the result if the corresponding bit of the other operand is 1.

![Multiplication block diagram](img/final/fp_multiplier.jpg)

###Division
In order to perform a floating point division, we follow a similar procedure as mulitplication, emulating the long division process. The divider uses combinations of shifts, less-than checks, and subtractions to calculate the quotient.

![Division module block diagram](img/final/fp_divider.jpg)

###Square Root
Our square root approximation module required one more component: a simple positive number floating-point adder. The floating point adder right-shifts the number with the smaller exponent, and then adds the numbers together in the base of the larger number.

![Floating-point addition block diagram](img/final/fp_adder.jpg)

Finally, we had all the necessary modules for performing a square root calculation. We used Newton’s method, which offers an approximation based on the following equation
```
a_(n+1) = (a_n + S/a_n)/2
```
where `a` is our approximation of the square root and `S` is the operand.

We created a module which simulates this calculation, and performs this iteratively for the length of one cpu clock cycle, which allows for approximately 20 iterations.

![Square root module block diagram](img/final/sqrt.jpg)

###Integration
In order to test our floating point math by running assembly code, we integrated the floating point unit with a single-cycle CPU. The integration was limited, because we do not allow floating point values to be stored to memory. Instead, floating point number values are limited to a floating point register. This allowed us to run the MIPS operations of mul.s and div.s. Additionally, though MIPS does not support these functions, we supported a positive floating-point addition, a multiply immediate, and a square root approximation.

![Block diagram of CPU/FPU interaction]()

##Assembly Operations
We used the MIPS opp codes for multiplication and division. However, in order to run our other operations, we repurposed some other MIPS commands. This was fairly straightforward with floating point addition and square root approximation. However, because all floating point MIPS instructions are R-type, (MIPS FPUs do not deal with immediates) our multiply immediate repurposed an invented I-type imstruction. This added a level of complexity, because we had to write assembly programs by hand rather than in MARS.


##Testing
We successfully created assembly test programs to test the integration.


##Difficulties

Writing each floating-point module, we encountered the constant difficulty of keeping track of our radix point. Each mathematical operation required different methods of calculating the resultant position. Most of the time we spent debugging was to diagnose incorrect placement of radix points.

Division and multiplication rely on repeated subtractions or additions, respectively. This necessitates deciding between using only combinational logic and using up large amounts of space, or using clocked logic and less space. Because we decided to use clocked logic, we had to create multiple clocks to control differential levels of modules. The CPU we integrated with WRITE SOME STUFF HERE.

We also had difficulties clocking operations properly. We ran into some problems because our CPU is single cycle but we need to perform many operations iteratively.

Additionally, adding on the implicit 1 at the beginning of floating point numbers to do operations and then removing it afterward caused many off-by-one errors. Often the new implicit one would not be in the same spot as the operand's implicit one.

##Work Plan Reflection

We were reasonably accurate with scoping the project in terms of time spent, but we incorrectly alotted time. We were able to accomplish everything we had planned, and succeeded at a stretch goal of having CPU integration.

We alotted algorithm analysis the most time, but every algorithm was reasonably simple to determine. Actually creating the block diagrams and then debugging the corresponding verilog modules was where most of our time was spent, as well as debugging the CPU integration.
