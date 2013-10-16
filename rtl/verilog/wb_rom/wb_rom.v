module wb_rom (
        wb_clk_i,
        wb_rst_i, 

        wb_dat_i, 
        wb_dat_o, 
        wb_adr_i, 
        wb_sel_i, 
        wb_we_i, 
        wb_cyc_i, 
        wb_stb_i, 
        wb_ack_o, 
        wb_err_o
);

parameter 
    AW = 32,
    DW = 32;

input                   wb_clk_i;
input                   wb_rst_i;

input   [DW-1:0]        wb_dat_i;
output  [DW-1:0]        wb_dat_o;
input   [AW-1:0]        wb_adr_i;
input   [3:0]           wb_sel_i;
input                   wb_we_i ;
input                   wb_cyc_i;
input                   wb_stb_i;
output                  wb_ack_o;
output                  wb_err_o;
        
reg                     wb_ack_r;

wire                    rom_clk_i;
wire                    rom_rst_i;
wire                    rom_oe_i ;
wire    [10:0]          rom_adr_i;
wire    [DW-1:0]        rom_dat_o;

// ----------------------------------------------------------------------------
// Inst of ROM
//
// NOTE: user should use their own boot rom verilog module.
bootrom bootrom_inst
(
    .clk_i  ( rom_clk_i ),
    .adr_i  ( rom_adr_i ),
    .dat_o  ( rom_dat_o )
);

assign rom_clk_i = wb_clk_i;
assign rom_adr_i = wb_adr_i[12:2];

assign wb_dat_o  = rom_dat_o;
// ----------------------------------------------------------------------------
always @(posedge wb_clk_i or posedge wb_rst_i) begin
    if (wb_rst_i)
        wb_ack_r <= 1'b0;
    else if(wb_cyc_i & wb_stb_i & ~wb_err_o & ~wb_ack_r)
        wb_ack_r <= 1'b1;
    else
        wb_ack_r <= 1'b0;
end

assign wb_ack_o = wb_ack_r;
assign wb_err_o = 1'b0;

endmodule

