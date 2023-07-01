module unit_tb();



    reg clk;
    reg reset_n;

//input stream for calculate
    wire               o_tready_in;
    reg               i_tvalid_in;
    reg   [79:0][31:0] i_data_in;//current block
    reg   [31:0]      i_A, i_B, i_C, i_D, i_E;//initial values

//output result
    reg               i_tready_out;
    wire               o_tvalid_out;
    wire [31:0]        o_A, o_B, o_C, o_D, o_E;




    sha1_unit DUT(
        .clk(clk),
        .reset_n(reset_n),
    
    //input stream for calculate
        .o_tready_in(o_tready_in),
        .i_tvalid_in(i_tvalid_in),
        .i_data_in  (i_data_in),//current block
        .i_A(i_A), 
        .i_B(i_B), 
        .i_C(i_C), 
        .i_D(i_D), 
        .i_E(i_E),//initial values
    
    //output result
        .i_tready_out(i_tready_out),
        .o_tvalid_out(o_tvalid_out),
        .o_A(o_A),
        .o_B(o_B),
        .o_C(o_C),
        .o_D(o_D),
        .o_E(o_E)
    );


    always begin
        clk = 1'b0;
        #10;
        clk = 1'b1;
        #10;
    end



    initial begin
        reset_n = 1'b0;
        i_tvalid_in = 1'b0;
        i_data_in = 512'h0;//current block
        i_A = 32'h0; 
        i_B = 32'h0; 
        i_C = 32'h0;
        i_D = 32'h0;
        i_E = 32'h0;
        i_tready_out = 1'b0;
        repeat(10) @ (posedge clk);
        reset_n = 1'b1;
        i_tready_out = 1'b1;
        repeat(10) @ (posedge clk);
        
        repeat(10) begin
            i_tvalid_in = 1'b1;
            @(posedge clk);
            i_tvalid_in = 1'b0;
            wait(o_tvalid_out == 1'b1);
            @(posedge clk);
        end

        
        repeat(100) @ (posedge clk);
        $stop();
    end



endmodule