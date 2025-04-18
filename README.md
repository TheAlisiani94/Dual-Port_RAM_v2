# Dual-Port RAM with Registered Read Address in Verilog

This project implements a dual-port RAM in Verilog with a 64x8 configuration (64 locations, 8-bit data width). The RAM supports synchronous write operations on a write clock and synchronous read operations on a read clock, with the read address registered to introduce a one-cycle delay for read data. A testbench is included to verify the RAM’s functionality across various scenarios, including simultaneous read/write operations and different clock frequencies.

## Project Overview

The dual-port RAM enables writing an 8-bit data value to a 6-bit address when the write enable (`we`) signal is high, synchronized to the `write_clk`. Simultaneously, it allows reading an 8-bit data value from a different 6-bit address, synchronized to the `read_clk`. The read address is registered, so the output data (`q`) reflects the data at the address provided in the previous clock cycle. This design is suitable for FPGA or ASIC block RAMs, particularly in applications requiring independent read and write operations, such as data buffers or multi-core systems.

### Files in the Project

- **`ram_dual_port.sv`**: The main Verilog module implementing the dual-port RAM. It defines a 64x8 memory array, handles synchronous writes on `write_clk`, and registers the read address for synchronous reads on `read_clk`.

- **`ram_dual_port_tb.sv`**: The testbench for the RAM module. It tests write and read operations across multiple addresses, simultaneous read/write scenarios, and edge cases, using different clock periods for read and write clocks to verify dual-clock operation.

- **`README.md`**: This file, providing documentation and instructions for the project.
