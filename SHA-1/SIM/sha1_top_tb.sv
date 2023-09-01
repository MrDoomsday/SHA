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

    sha1 sha1_inst = new;

    task automatic dut_driver(string str);
        bit [63:0][7:0] data_for_dut;
        int string_length = str.len();
        int align_string_length;
        bit [7:0][7:0] len_in_bit;
        bit [7:0] message_array [];//create message byte array

        //prepare string
        align_string_length = string_length + 1;//add bit one = 0x80
            
        if(align_string_length % 64 > 56) begin//проверяем, влезает ли 64-битная длина
            align_string_length += 64 - (align_string_length % 64) + 64;//если не влезает, то добавляем 
        end
        else begin
            align_string_length += 64 - (align_string_length % 64);
        end

        message_array = new[align_string_length];

        for(int i = 0; i < align_string_length; i++) begin
            if(i < string_length) message_array[i] = str[i];
            else if(i == string_length) message_array[i] = 8'h80;
            else message_array[i] = 8'h0;
        end

        //add length
        len_in_bit = string_length * 8;
        message_array[align_string_length-8] = len_in_bit[7];
        message_array[align_string_length-7] = len_in_bit[6];
        message_array[align_string_length-6] = len_in_bit[5];
        message_array[align_string_length-5] = len_in_bit[4];
        message_array[align_string_length-4] = len_in_bit[3];
        message_array[align_string_length-3] = len_in_bit[2];
        message_array[align_string_length-2] = len_in_bit[1];
        message_array[align_string_length-1] = len_in_bit[0];

        //send for DUT
        for (int i = 0; i < align_string_length; i+=64) begin
            for(int j = 0; j < 64; j++) data_for_dut[63-j] = message_array[i+j];//create word

            i_tvalid    = 1'b1;
            i_tdata     = data_for_dut;
            i_tlast     = i == (align_string_length - 64);
            #1;
            while(~o_tready) begin
                @(posedge clk);
                #1;
            end
            @(posedge clk);
            i_tvalid    = 1'b0;
            i_tdata     = 512'h0;
            i_tlast     = 1'b0;
        end
    endtask


    task automatic check_transaction(string str);
        string string_for_test;
        bit [4:0][31:0] sha1_result;

        sha1_result = sha1_inst.sha1_calculate(str);
        $display("SHA1 Result = %0h", sha1_result);
        dut_driver(str);

        wait(o_sha_tvalid == 1'b1);
        #1;
        if(o_sha_tdata == sha1_result) $display("***String = %0s COMPLETE***", str);
        else begin
            $display("***String = %0s FAILED***", str);
            $fatal();
        end

    endtask


    initial begin
        string big_string_for_dut = {1_000_000{"a"}};//one million (1,000,000) repetitions of the character "a" (0x61).
        reset_n = 1'b0;
        i_tvalid = 1'b0;
        i_tdata = 512'h0;
        i_tlast = 1'b0;
        repeat(10) @ (posedge clk);
        reset_n = 1'b1;
        repeat(10) @ (posedge clk);
        
        
        repeat(10) @ (posedge clk);
        

        check_transaction("");
        check_transaction("abc");
        check_transaction("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq");
        check_transaction("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu");
        check_transaction(big_string_for_dut);
                
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