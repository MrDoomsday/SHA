module packet_alignment (
    input logic clk,
    input logic reset_n,

//input stream for calculate
    output  logic               o_tready_in,
    input   logic               i_tvalid_in,
    input   logic   [511:0]     i_tdata_in,
    input   logic   [63:0]      i_tkeep_in,
    input   logic               i_tlast_in,

//output result
    input   logic               i_tready_out,
    output  logic               o_tvalid_out,
    output  logic   [511:0]     o_tdata_out,
    output  logic               o_tlast_out 
);



    assign o_tready_in  = i_tready_out;
    assign o_tvalid_out = i_tvalid_in;
    assign o_tdata_out  = i_tdata_in;
    assign o_tlast_out  = i_tlast_in;

    
endmodule