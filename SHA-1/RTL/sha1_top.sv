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

/***********************************************************************************************************************/
/***********************************************************************************************************************/
/*******************************************        DECLARATION         ************************************************/
/***********************************************************************************************************************/
/***********************************************************************************************************************/
//connect module packet_alignment
reg pa_ready_out;
wire pa_valid_out;
wire [511:0] pa_data_out;
wire pa_tlast_out;

//connect module unit
wire unit_ready_in;
reg unit_valid_in;
reg [511:0] unit_data_in;
reg [31:0] unit_A_in, unit_B_in, unit_C_in, unit_D_in, unit_E_in, unit_F_in;

reg unit_ready_out;
wire unit_valid_out;
wire [31:0] unit_A_out, unit_B_out, unit_C_out, unit_D_out, unit_E_out, unit_F_out;

localparam A_init = 32'h67452301;
localparam B_init = 32'hEFCDAB89;
localparam C_init = 32'h98BADCFE;
localparam D_init = 32'h10325476;
localparam E_init = 32'hC3D2E1F0;

bit [31:0] A, B, C, D, E;//final result is here

enum logic [1:0] {WAIT_START, WAIT_COMPLETE, WAIT_NEW_DATA, SEND_RESULT} state, state_next;
bit last_reg;

/***********************************************************************************************************************/
/***********************************************************************************************************************/
/*******************************************            INSTANCE         ***********************************************/
/***********************************************************************************************************************/
/***********************************************************************************************************************/

packet_alignment packet_alignment_inst(
    .clk    (clk),
    .reset_n(reset_n),

//input stream for calculate
    .o_tready_in(o_tready),
    .i_tvalid_in(i_tvalid),
    .i_tdata_in (i_tdata),
    .i_tkeep_in (i_tkeep),
    .i_tlast_in (i_tlast),

//output result
    .i_tready_out   (pa_ready_out),
    .o_tvalid_out   (pa_valid_out),
    .o_tdata_out    (pa_data_out),
    .o_tlast_out    (pa_tlast_out)
);



sha1_unit sha1_unit_inst(
    .clk    (clk),
    .reset_n(reset_n),

//input stream for calculate
    .o_tready_in(unit_ready_in),
    .i_tvalid_in(unit_valid_in),
    .i_data_in  (unit_data_in),//current block
    .i_A(unit_A_in), 
    .i_B(unit_B_in), 
    .i_C(unit_C_in), 
    .i_D(unit_D_in), 
    .i_E(unit_E_in),//initial values

//output result
    .i_tready_out(unit_ready_out),
    .o_tvalid_out(unit_valid_out),
    .o_A(unit_A_out), 
    .o_B(unit_B_out), 
    .o_C(unit_C_out), 
    .o_D(unit_D_out), 
    .o_E(unit_E_out)
);



/***********************************************************************************************************************/
/***********************************************************************************************************************/
/*******************************************            LOGIC            ***********************************************/
/***********************************************************************************************************************/
/***********************************************************************************************************************/
always_ff @ (posedge clk or negedge reset_n)
    if(!reset_n) state <= WAIT_START;
    else state <= state_next;

always_comb begin
    state_next = state;
    pa_ready_out = ~pa_valid_out;

    unit_A_in = A;
    unit_B_in = B;
    unit_C_in = C;
    unit_D_in = D;
    unit_E_in = E;

    unit_valid_in = 1'b0;
    unit_data_in = pa_data_out;

    unit_ready_out = 1'b1;

    case(state)
        WAIT_START: begin
            pa_ready_out = unit_ready_in;
            unit_valid_in = pa_valid_out;

            unit_A_in = A_init;
            unit_B_in = B_init;
            unit_C_in = C_init;
            unit_D_in = D_init;
            unit_E_in = E_init;

            if(pa_valid_out && pa_ready_out) begin
                state_next = WAIT_COMPLETE;
            end
        end

        WAIT_COMPLETE: begin
            if(unit_valid_out) begin
                if(last_reg) state_next = SEND_RESULT;
                else state_next = WAIT_NEW_DATA;
            end
        end
        
        WAIT_NEW_DATA: begin
            pa_ready_out = unit_ready_in;
            unit_valid_in = pa_valid_out;
            if(pa_valid_out && pa_ready_out) begin
                state_next = WAIT_COMPLETE;
            end
        end
        
        SEND_RESULT: begin
            if(i_sha_tready) state_next = WAIT_START;
        end
        
        default: begin
            state_next = WAIT_START;
        end
    endcase
end


always_ff @ (posedge clk or negedge reset_n)
    if(!reset_n) last_reg <= 1'b0;
    else if(((state == WAIT_START) || (state == WAIT_NEW_DATA)) && pa_valid_out && pa_ready_out) last_reg <= pa_tlast_out;


always_ff @ (posedge clk) begin
    if((state == WAIT_START) && pa_valid_out && pa_ready_out) begin
        A <= A_init;
        B <= B_init;
        C <= C_init;
        D <= D_init;
        E <= E_init;
    end
    else if((state == WAIT_COMPLETE) && unit_valid_out) begin
        A <= A + unit_A_out;
        B <= B + unit_B_out;
        C <= C + unit_C_out;
        D <= D + unit_D_out;
        E <= E + unit_E_out;
    end

end



//send result
always_ff @ (posedge clk or negedge reset_n)
    if(!reset_n) o_sha_tvalid <= 1'b0;
    else if((state == WAIT_COMPLETE) && last_reg) o_sha_tvalid <= 1'b1;
    else if(i_sha_tready) o_sha_tvalid <= 1'b0;

assign o_sha_tdata = {A, B, C, D, E};

endmodule