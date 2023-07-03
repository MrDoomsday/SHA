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



/***********************************************************************************************************************/
/***********************************************************************************************************************/
/*******************************************        DECLARATION         ************************************************/
/***********************************************************************************************************************/
/***********************************************************************************************************************/

typedef struct packed {
    logic               valid;
    logic   [511:0]     data;
    logic   [63:0]      keep;
    logic               last;
} axi_stream;

axi_stream stream_pipe;
bit [7:0] length_pkt = 8'h0;//in bytes
bit start_of_packet;

function logic [7:0] packet_alignment::sum_bits(logic [63:0] vector);
    logic [7:0] result;
    for (int i = 0; i < 64; i++) result += vector[i];
    return result;
endfunction: sum_bits

/***********************************************************************************************************************/
/***********************************************************************************************************************/
/*******************************************            LOGIC            ***********************************************/
/***********************************************************************************************************************/
/***********************************************************************************************************************/

//calculate length packet
always_ff @ (posedge clk) begin
    if(o_tready_in) begin
        stream_pipe.valid <= i_tvalid_in;
        stream_pipe.data <= i_tdata_in;
        stream_pipe.keep <= i_tkeep_in;
        stream_pipe.last <= i_tlast_in;
    end

    if(o_tready_in) begin
        if(i_tvalid_in & i_tlast_in) start_of_packet <= 1'b1;
        else if(i_tvalid_in) start_of_packet <= 1'b0;
    end

    if(o_tready_in && i_tvalid_in) begin
        if(start_of_packet) length_pkt <= sum_bits(i_tkeep_in);//1 bit mask is 1 byte on bus
        else length_pkt <= length_pkt + sum_bits(i_tkeep_in);
    end
end





endmodule