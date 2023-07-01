module sha1_top (
    input logic clk,
    input logic reset_n,

//input stream for calculate
    output  logic               o_tready,
    input   logic               i_tvalid,
    input   logic   [511:0]     i_tdata,
    input   logic   [63:0]      i_tkeep,
    input   logic               i_tlast,

//output result
    input   logic               i_sha_tready,
    output  logic               o_sha_tvalid,
    output  logic [159:0]       o_sha_tdata
);




endmodule