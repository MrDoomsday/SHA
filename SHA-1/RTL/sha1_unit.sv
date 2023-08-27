`define FAST //add pipeline register
//`define SIM

module sha1_unit (
    input logic clk,
    input logic reset_n,

//input stream for calculate
    output  logic                   o_tready_in,
    input   logic                   i_tvalid_in,
    input   logic   [15:0][31:0]    i_data_in,//current block
    input   logic   [31:0]          i_A, i_B, i_C, i_D, i_E,//initial values

//output result
    input   logic               i_tready_out,
    output  logic               o_tvalid_out,
    output  logic [31:0]        o_A, o_B, o_C, o_D, o_E
);




/***********************************************************************************************************************/
/***********************************************************************************************************************/
/*******************************************        DECLARATION         ************************************************/
/***********************************************************************************************************************/
/***********************************************************************************************************************/
bit processing;
bit [7:0] iteration;//current iteration 
bit [31:0] A_reg, B_reg, C_reg, D_reg, E_reg;
bit [31:0] A_next, B_next, C_next, D_next, E_next;
bit update;

bit [31:0] F;
bit [31:0] Kt;
bit [15:0][31:0] Wt;
/***********************************************************************************************************************/
/***********************************************************************************************************************/
/*******************************************            LOGIC            ***********************************************/
/***********************************************************************************************************************/
/***********************************************************************************************************************/


always_ff @ (posedge clk or negedge reset_n)
    if(!reset_n) begin
        processing <= 1'b0;
        iteration <= 8'h0;
    end
    else if(o_tready_in) begin
        processing <= i_tvalid_in;
        iteration <= 8'h0;
    end
    else begin
        processing <= i_tready_out & o_tvalid_out ? 1'b0 : processing;//send result to up level and clear
        `ifdef FAST 
            if(iteration[7:1] < 7'd80) iteration <= iteration + 8'h1;
        `else 
            if(iteration < 8'd80) iteration <= iteration + 8'h1;
        `endif
    end

assign o_tready_in = ~processing;



always_ff @ (posedge clk) begin
    if(o_tready_in && i_tvalid_in) begin//initial value
        A_reg <= i_A;
        B_reg <= i_B;
        C_reg <= i_C;
        D_reg <= i_D;
        E_reg <= i_E;
    end
    else if(update) begin//new value
        A_reg <= A_next;
        B_reg <= B_next;
        C_reg <= C_next;
        D_reg <= D_next;
        E_reg <= E_next;
    end
end

wire [31:0] Wt15_next = Wt[0] ^ Wt[2] ^ Wt[8] ^ Wt[13];

always_ff @ (posedge clk) begin
    if(o_tready_in && i_tvalid_in) begin
        {Wt[0], Wt[1], Wt[2], Wt[3], Wt[4], Wt[5], Wt[6], Wt[7], Wt[8], Wt[9], Wt[10], Wt[11], Wt[12], Wt[13], Wt[14], Wt[15]} <= i_data_in;
    end
    else if(update) begin
        Wt[0] <= Wt[1];
        Wt[1] <= Wt[2];
        Wt[2] <= Wt[3];
        Wt[3] <= Wt[4];
        Wt[4] <= Wt[5];
        Wt[5] <= Wt[6];
        Wt[6] <= Wt[7];
        Wt[7] <= Wt[8];
        Wt[8] <= Wt[9];
        Wt[9] <= Wt[10];
        Wt[10] <= Wt[11];
        Wt[11] <= Wt[12];
        Wt[12] <= Wt[13];
        Wt[13] <= Wt[14];
        Wt[14] <= Wt[15];
        Wt[15] <= {Wt15_next[30:0], Wt15_next[31]};
    end
end


always_comb begin
    `ifdef FAST
        if((iteration[7:1] >= 7'd0) && (iteration[7:1] <= 7'd19)) begin
            F = ((B_reg & C_reg) | (~B_reg & D_reg));
            Kt = 32'h5A827999;
        end
        else if((iteration[7:1] >= 7'd20) && (iteration[7:1] <= 7'd39)) begin
            F = (B_reg ^ C_reg ^ D_reg);
            Kt = 32'h6ED9EBA1;
        end
        else if((iteration[7:1] >= 7'd40) && (iteration[7:1] <= 7'd59)) begin
            F = ((B_reg & C_reg) | (B_reg & D_reg) | (C_reg & D_reg));
            Kt = 32'h8F1BBCDC;
        end
        else if((iteration[7:1] >= 7'd60) && (iteration[7:1] <= 7'd79)) begin
            F = (B_reg ^ C_reg ^ D_reg);
            Kt = 32'hCA62C1D6;
        end
        else begin
            F = 32'h0;
            Kt = 32'h0;
        end
    `else
        if((iteration >= 8'd0) && (iteration <= 8'd19)) begin
            F = ((B_reg & C_reg) | (~B_reg & D_reg));
            Kt = 32'h5A827999;
        end
        else if((iteration >= 8'd20) && (iteration <= 8'd39)) begin
            F = (B_reg ^ C_reg ^ D_reg);
            Kt = 32'h6ED9EBA1;
        end
        else if((iteration >= 8'd40) && (iteration <= 8'd59)) begin
            F = ((B_reg & C_reg) | (B_reg & D_reg) | (C_reg & D_reg));
            Kt = 32'h8F1BBCDC;
        end
        else if((iteration >= 8'd60) && (iteration <= 8'd79)) begin
            F = (B_reg ^ C_reg ^ D_reg);
            Kt = 32'hCA62C1D6;
        end
        else begin
            F = 32'h0;
            Kt = 32'h0;
        end
        `ifdef SIM 
            $display("Iteration = %0d, Kt = %0h", iteration, Kt); 
        `endif
    `endif
end

`ifdef FAST
    bit [31:0] A_pipe, B_pipe, C_pipe, D_pipe, E_pipe;
    bit [31:0] FplusE;
    bit [31:0] WtplusKt;

    always_ff @ (posedge clk) begin
        FplusE <= E_reg + F;
        WtplusKt <= Wt[0] + Kt;
        A_pipe <= A_reg;
        B_pipe <= B_reg;
        C_pipe <= C_reg;
        D_pipe <= D_reg;
        E_pipe <= E_reg;
    end

    always_comb begin
        update = iteration[7:1] < 7'd80 & processing & iteration[0];
        A_next = FplusE + {A_pipe[26:0], A_pipe[31:27]} + WtplusKt;
        B_next = A_pipe;
        C_next = {B_pipe[1:0], B_pipe[31:2]};
        D_next = C_pipe;
        E_next = D_pipe;
    end
`else
    always_comb begin
        update = iteration < 8'd80 & processing;
        A_next = E_reg + F + {A_reg[26:0], A_reg[31:27]} + Wt[0] + Kt;
        B_next = A_reg;
        C_next = {B_reg[1:0], B_reg[31:2]};
        D_next = C_reg;
        E_next = D_reg;
    end
`endif


`ifdef FAST
    always_ff @ (posedge clk or negedge reset_n)
        if(!reset_n) o_tvalid_out <= 1'b0;
        else if(update && iteration[7:1] == 8'd79) o_tvalid_out <= 1'b1;
        else if(i_tready_out) o_tvalid_out <= 1'b0;

    always_ff @ (posedge clk) begin
        if(update && iteration[7:1] == 8'd79) begin
            o_A <= A_next;
            o_B <= B_next;
            o_C <= C_next;
            o_D <= D_next;
            o_E <= E_next;
        end
    end
`else
    always_ff @ (posedge clk or negedge reset_n)
        if(!reset_n) o_tvalid_out <= 1'b0;
        else if(update && iteration == 8'd79) o_tvalid_out <= 1'b1;
        else if(i_tready_out) o_tvalid_out <= 1'b0;

    always_ff @ (posedge clk) begin
        if(update & iteration == 8'd79) begin
            o_A <= A_next;
            o_B <= B_next;
            o_C <= C_next;
            o_D <= D_next;
            o_E <= E_next;
        end
    end
`endif


endmodule