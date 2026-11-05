`timescale 1ns/1ps

module async_fifo_tb;
    parameter DATA_W = 8;
    parameter ADDR_W = 4;
    parameter WPER   = 10;
    parameter RPER   = 14;
    parameter N      = 300; // number of items to write/read in the test
    localparam DEPTH = 1 << ADDR_W; // FIFO depth
// Internal signals for the testbench
    reg              wclk, rclk, wrst, rrst, winc, rinc;
    reg  [DATA_W-1:0] wdata;
    wire [DATA_W-1:0] rdata;
    wire             wfull, rempty;
// Testbench variables
    integer wcount, rcount, errors, wprob, rprob;
    reg              running, chk_pending, seen_full, seen_empty;
    reg  [DATA_W-1:0] exp_q;
// DUT instantiation
    async_fifo #(.DATA_W(DATA_W), .ADDR_W(ADDR_W)) dut (
        .wclk(wclk), .wrst(wrst), .winc(winc), .wdata(wdata), .wfull(wfull),
        .rclk(rclk), .rrst(rrst), .rinc(rinc), .rdata(rdata), .rempty(rempty));
// Clock generation
    initial wclk = 0;  always #(WPER/2.0) wclk = ~wclk;
    initial rclk = 0;  always #(RPER/2.0) rclk = ~rclk;
// Pattern generation function
    function [DATA_W-1:0] pattern;
        input integer k;
        begin pattern = k * 37 + 11; end
    endfunction
// Check task
    task check;
        input cond;
        input [511:0] msg;
        begin
            if (!cond) begin errors = errors + 1; $display("FAIL: %0s", msg); end
        end
    endtask

    // Writer: decides on the falling edge of wclk
    always @(negedge wclk) begin
        if (running && wcount < N && !wfull && (({$random} % 100) < wprob)) begin // write with probability wprob
            winc = 1; wdata = pattern(wcount); wcount = wcount + 1;
        end else begin
            winc = 0; wdata = $random;     // garbage when not writing: checks that 'we' gates the RAM
        end
    end

    // Reader: same style; the data is checked on the next falling edge
    always @(negedge rclk) begin
        if (chk_pending) begin
            if (rdata !== exp_q) begin
                errors = errors + 1;
                $display("FAIL: read #%0d got %h expected %h", rcount-1, rdata, exp_q);
            end
            chk_pending = 0;
        end
        if (running && rcount < N && !rempty && (({$random} % 100) < rprob)) begin
            rinc = 1; exp_q = pattern(rcount); rcount = rcount + 1; chk_pending = 1;
        end else rinc = 0;
    end

    always @(posedge wclk) if (wfull)               seen_full  = 1;
    always @(posedge rclk) if (rempty && rcount>0)  seen_empty = 1;
// Test sequence
    initial begin
        errors = 0; wcount = 0; rcount = 0; running = 0; chk_pending = 0;
        seen_full = 0; seen_empty = 0; winc = 0; rinc = 0; wdata = 0; wprob = 0; rprob = 0;
        wrst = 1; rrst = 1;
        #37 wrst = 0;                 // resets are released between clock edges
        #11 rrst = 0;
        #100 running = 1;
        check(wfull === 0,  "wfull must be 0 after reset");
        check(rempty === 1, "rempty must be 1 after reset");

        // Stage 1: only write, until full
        wprob = 100; rprob = 0;
        repeat (40) @(posedge wclk);
        #1;
        check(wfull === 1,    "wfull must be 1 when filled");
        check(wcount == DEPTH, "exactly DEPTH writes must be accepted");
        $display("stage 1: wfull=%b accepted=%0d", wfull, wcount);

        // Stage 2: reader is faster, FIFO drains
        seen_empty = 0; rprob = 100;
        wprob = (40 * WPER) / RPER; if (wprob > 100) wprob = 100; if (wprob < 1) wprob = 1;
        wait (rcount >= 120);
        check(seen_empty, "rempty must have been seen in stage 2");
        $display("stage 2: reads=%0d seen_empty=%b", rcount, seen_empty);

        // Stage 3: writer is faster, FIFO fills again
        seen_full = 0; wprob = 100;
        rprob = (60 * RPER) / WPER; if (rprob > 100) rprob = 100; if (rprob < 1) rprob = 1;
        wait (rcount >= N);
        repeat (6) @(posedge rclk);
        #1;
        check(seen_full, "wfull must have been seen in stage 3");
        check(wcount == N, "all N items must be written");
        check(rempty === 1, "FIFO must end empty");
        $display("stage 3: reads=%0d seen_full=%b", rcount, seen_full);

        if (errors == 0) $display("ASYNC FIFO: ALL PASSED (%0d items, WPER=%0d RPER=%0d)", N, WPER, RPER);
        else             $display("ASYNC FIFO: %0d ERROR(S)", errors);
        $finish;
    end

    initial begin
        #1000000 $display("TIMEOUT"); $finish;
    end

    initial begin
        $dumpfile("async_fifo.vcd");
        $dumpvars(0, async_fifo_tb);
    end
endmodule
