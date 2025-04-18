// Testbench for the dual-port RAM module with separate read and write clocks and a registered read address.
module ram_dual_port_tb;
    // Testbench signals
    reg [7:0] data;            // 8-bit input data (write data)
    reg [5:0] read_addr;       // 6-bit read address
    reg [5:0] write_addr;      // 6-bit write address
    reg we;                    // Write enable
    reg read_clk;              // Read clock
    reg write_clk;             // Write clock
    wire [7:0] q;              // 8-bit output data (read data)

    // Instantiate the RAM module (unit under test)
    ram_dual_port uut (
        .q(q),
        .data(data),
        .read_addr(read_addr),
        .write_addr(write_addr),
        .we(we),
        .read_clk(read_clk),
        .write_clk(write_clk)
    );

    // Write clock generation: 10 time units period (5 units high, 5 units low)
    initial begin
        write_clk = 0;
        forever #5 write_clk = ~write_clk;
    end

    // Read clock generation: 12 time units period (6 units high, 6 units low)
    initial begin
        read_clk = 0;
        forever #6 read_clk = ~read_clk;
    end

    // Stimulus process
    initial begin
        // Initialize inputs
        data = 8'b0;
        read_addr = 6'b0;
        write_addr = 6'b0;
        we = 1'b0;

        // Monitor inputs and outputs, including read_addr_reg
        $monitor("Time=%0t write_clk=%b read_clk=%b we=%b write_addr=%h data=%h read_addr=%h read_addr_reg=%h q=%h",
                 $time, write_clk, read_clk, we, write_addr, data, read_addr, uut.read_addr_reg, q);

        // Test sequence
        #15; // Wait for initial stabilization

        // Test 1: Write to address 0
        @(negedge write_clk);
        we = 1; write_addr = 6'h00; data = 8'hAA;
        @(negedge write_clk);
        we = 0;

        // Test 2: Read from address 0 (expect 0xAA after two read_clk cycles)
        @(negedge read_clk);
        read_addr = 6'h00;
        @(negedge read_clk); // Wait for read_addr_reg to update
        @(negedge read_clk); // Wait for q to reflect ram[0]

        // Test 3: Write to address 63
        @(negedge write_clk);
        we = 1; write_addr = 6'h3F; data = 8'h55;
        @(negedge write_clk);
        we = 0;

        // Test 4: Read from address 63 (expect 0x55 after two read_clk cycles)
        @(negedge read_clk);
        read_addr = 6'h3F;
        @(negedge read_clk); // Wait for read_addr_reg to update
        @(negedge read_clk); // Wait for q to reflect ram[63]

        // Test 5: Write to multiple addresses
        @(negedge write_clk);
        we = 1;
        write_addr = 6'h01; data = 8'h11;
        @(negedge write_clk);
        write_addr = 6'h02; data = 8'h22;
        @(negedge write_clk);
        we = 0;

        // Test 6: Read from multiple addresses
        @(negedge read_clk);
        read_addr = 6'h01;
        @(negedge read_clk); // Wait for read_addr_reg
        @(negedge read_clk); // Expect 0x11
        read_addr = 6'h02;
        @(negedge read_clk); // Wait for read_addr_reg
        @(negedge read_clk); // Expect 0x22

        // Test 7: Simultaneous write and read (write to addr 10, read from addr 0)
        @(negedge write_clk);
        we = 1; write_addr = 6'h0A; data = 8'hFF;
        @(negedge read_clk);
        read_addr = 6'h00;
        @(negedge write_clk);
        we = 0;
        @(negedge read_clk); // Wait for read_addr_reg
        @(negedge read_clk); // Expect 0xAA

        // Test 8: Read from address 10
        @(negedge read_clk);
        read_addr = 6'h0A;
        @(negedge read_clk); // Wait for read_addr_reg
        @(negedge read_clk); // Expect 0xFF

        // End simulation
        #30 $finish;
    end
endmodule
