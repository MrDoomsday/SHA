`timescale 1ns/1ns
`include "defs.svh"

module sha1_top_tb();

    reg clk;
    reg reset_n;

//input stream for calculate
    wire              o_tready;
    reg               i_tvalid;
    reg   [511:0]     i_tdata;
    reg               i_tlast;

//output result
    reg               i_sha_tready;
    wire              o_sha_tvalid;
    wire [159:0]      o_sha_tdata;


    sha1_top DUT (
        .clk    (clk),
        .reset_n(reset_n),
    
    //input stream for calculate
        .o_tready   (o_tready),
        .i_tvalid   (i_tvalid),
        .i_tdata    (i_tdata),
        .i_tkeep    (64'hFFFFFFFF_FFFFFFFF),
        .i_tlast    (i_tlast),
    
    //output result
        .i_sha_tready   (i_sha_tready),
        .o_sha_tvalid   (o_sha_tvalid),
        .o_sha_tdata    (o_sha_tdata)
    );




    always begin
        clk = 1'b0;
        #10;
        clk = 1'b1;
        #10;
    end

    sha1 sha1_inst;


    initial begin
        reset_n = 1'b0;
        i_tvalid = 1'b0;
        i_tdata = 512'h0;
        i_tlast = 1'b0;
        i_sha_tready = 1'b0;
        sha1_inst = new();
        repeat(10) @ (posedge clk);
        reset_n = 1'b1;
        i_sha_tready = 1'b1;
        sha1_inst.sha1_calculate("Dirik zaebal");
        repeat(10) @ (posedge clk);
        
        
        for(int i = 0; i < 16; i++) begin
            i_tvalid = 1'b1;
            i_tdata = {8'h80, 504'h0};
            i_tlast = 1'b1;
            @(posedge clk);
            i_tvalid = 1'b0;
            i_tlast = 1'b0;
            @(posedge clk);
            wait(o_sha_tvalid == 1'b1 && i_sha_tready == 1'b1);
            if(o_sha_tdata == 160'hda39a3ee_5e6b4b0d_3255bfef_95601890_afd80709) $display("***PATTERN OK***");
            else begin
                $display("***TEST FAILED***");
                $fatal();
            end
            @(posedge clk);
        end
        
        repeat(1000) @ (posedge clk);
        $display("***TEST PASSED***");
        $stop();
    end


    int delay_rdy = 0;

    initial begin
        wait(reset_n == 1'b1);
        repeat(10) @ (posedge clk);
        
        forever begin
            delay_rdy = $urandom_range(1,10);
            i_sha_tready = 1'b0;
            repeat(delay_rdy) @ (posedge clk);
            i_sha_tready = 1'b1;
            delay_rdy = $urandom_range(1,10);
            repeat(delay_rdy) @ (posedge clk);
        end
    end

endmodule