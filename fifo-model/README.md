# FIFO Implementation in Verilog

## Overview
This project is an example exercise in A Guide to Digital Design and Synthesis, Appendix F book and implements a First-In-First-Out (FIFO) buffer in Verilog. The FIFO is a small memory storage unit that follows the FIFO principle, where data is read in the same order it was written. The design includes the FIFO module, a memory block for storage, and a testbench for validation.

## File Descriptions

### 1. **fifo.v** (Main FIFO Module)
This file contains the primary FIFO implementation.
- Defines a FIFO buffer with a fixed width (`FWIDTH = 32`) and depth (`FDEPTH = 4`).
- Uses `wr_ptr` (write pointer) and `rd_ptr` (read pointer) to manage data storage.
- Includes status signals for FIFO state:
  - `F_FullN`: FIFO is not full.
  - `F_EmptyN`: FIFO is not empty.
  - `F_LastN`: Last entry in FIFO.
  - `F_SLastN`: Second-to-last entry in FIFO.
  - `F_FirstN`: Indicates the first written entry.
- Contains logic to handle read, write, and reset operations.

### 2. **fifo_mem_blk.v** (FIFO Memory Block)
This file implements the memory storage used by the FIFO.
- Uses a 2D register array to store `FDEPTH` entries of `FWIDTH` bits each.
- Implements write operation based on `writeN` signal.
- Implements read operation based on `rd_addr` pointer.
- Acts as a storage element, interfacing with `fifo.v` for data access.

### 3. **fifo_tb.v** (Testbench for Simulation)
This file provides a test environment to validate FIFO functionality.
- Generates a clock signal with a period of 10ns.
- Initializes and resets the FIFO before performing read/write operations.
- Stimulates different input conditions to verify:
  - FIFO push/pop operations.
  - Full and empty conditions.
  - Correctness of stored and retrieved data.
- Uses `$dumpfile` and `$dumpvars` for waveform generation to assist in debugging.

## Possible Improvements
- Implement parameterized FIFO to support different sizes.
- Add asynchronous read/write support.
- Enhance testbench with more edge case tests.
