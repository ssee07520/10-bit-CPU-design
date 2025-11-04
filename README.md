# 10-bit CPU (Verilog, Basys3 FPGA)

## Introduction
This project implements a **10-bit CPU** on the **Digilent Basys3** board with an **Artix-7 FPGA**, written entirely in **Verilog**.  
The design was created, tested, and debugged using **Vivado** with dedicated **testbenches** for verification.

To test the CPU, sixteen switches are used as the input `N`. The CPU computes the expression **N(2N - 1)**, and the result is displayed as a **hexadecimal value** on the 4-digit **7-segment display**. The **center button** is used as the reset signal.

## Architecture Overview
The CPU consists of several main modules:
- **IR (Instruction Register)**
- **PC (Program Counter)**
- **ROM (Read-Only Memory)**
- **MUX (Multiplexer)**
- **RF (Register File)**
- **ALU (Arithmetic Logic Unit)**
- **Control Unit**

A **top-down design approach** was adopted:  
1. Start from a high-level architecture describing the overall CPU function.  
2. Gradually refine it into detailed implementations of each module.


---

Note: The instruction set and binary encodings were provided by the course instructor as part of the assignment specification.
