module arty_top (
  // Clock and Reset
  input        clk,
  input        rst_n,

  input        fetch_enable_i,

  input        spi_clk_i,
  input        spi_cs_i,
  output       spi_sdo0_o,
  input        spi_sdi0_i,

  output       pll_locked,

  // output        spi_master_clk_o,
  // output        spi_master_csn0_o,
  // output        spi_master_csn1_o,
  // output        spi_master_csn2_o,
  // output        spi_master_csn3_o,
  // output  [1:0] spi_master_mode_o,
  // output        spi_master_sdo0_o,
  // output        spi_master_sdo1_o,
  // output        spi_master_sdo2_o,
  // output        spi_master_sdo3_o,
  // input         spi_master_sdi0_i,
  // input         spi_master_sdi1_i,
  // input         spi_master_sdi2_i,
  // input         spi_master_sdi3_i,

  output       uart_tx,
  input        uart_rx,

  // input  [31:0] gpio_in,
  // output [31:0] gpio_out,
  // output [31:0] gpio_dir,
  output [8:8] gpio_o,
  // JTAG signals
  input        tck_i,
  input        trstn_i,
  input        tms_i,
  input        tdi_i,
  output       tdo_o

);
  logic        spi_master_clk_o;
  logic        spi_master_csn0_o;
  logic        spi_master_csn1_o;
  logic        spi_master_csn2_o;
  logic        spi_master_csn3_o;
  logic  [1:0] spi_master_mode_o;
  logic        spi_master_sdo0_o;
  logic        spi_master_sdo1_o;
  logic        spi_master_sdo2_o;
  logic        spi_master_sdo3_o;
  logic         spi_master_sdi0_i = 1'b0;
  logic         spi_master_sdi1_i = 1'b0;
  logic         spi_master_sdi2_i = 1'b0;
  logic         spi_master_sdi3_i = 1'b0;

   // SPI
   logic [1:0] spi_mode_o;
  logic        spi_sdo1_o;
  logic        spi_sdo2_o;
  logic        spi_sdo3_o;
  logic         spi_sdi1_i;
  logic         spi_sdi2_i;
  logic         spi_sdi3_i;

   // uart
   logic 	uart_rts;
  logic        uart_dtr;
  logic         uart_cts = 1'b0;
  logic         uart_dsr = 1'b0;

   // i2c
   logic 	scl_pad_i = 1'b0;
  logic        scl_pad_o;
  logic        scl_padoen_o;
  logic         sda_pad_i = 1'b0;
  logic        sda_pad_o;
  logic        sda_padoen_o;
   // GPIO
   logic [31:0] gpio_in = 32'h1;
   logic [31:0] gpio_out;
   
   logic [31:0] gpio_dir;
   assign gpio_o = gpio_out[8];


arty_mmcm u_mmcm (
    .clk_in1  ( clk ) ,
    .clk_out1 ( clk_cpu       ) , // 50MHz
    .resetn   ( rst_n         ) ,
    .locked   ( pll_locked    ) 
 );
  
// PULPino SoC
pulpino u_pulpino (
    .clk               ( clk_cpu           ),
    .rst_n             ( rst_n             ),

    .fetch_enable_i    ( fetch_enable_i    ),

    .spi_clk_i         ( spi_clk_i         ),
    .spi_cs_i          ( spi_cs_i          ),
    .spi_mode_o        ( spi_mode_o        ),
    .spi_sdo0_o        ( spi_sdo0_o        ),
    .spi_sdo1_o        ( spi_sdo1_o        ),
    .spi_sdo2_o        ( spi_sdo2_o        ),
    .spi_sdo3_o        ( spi_sdo3_o        ),
    .spi_sdi0_i        ( spi_sdi0_i        ),
    .spi_sdi1_i        ( spi_sdi1_i        ),
    .spi_sdi2_i        ( spi_sdi2_i        ),
    .spi_sdi3_i        ( spi_sdi3_i        ),

    .spi_master_clk_o  ( spi_master_clk_o  ),
    .spi_master_csn0_o ( spi_master_csn0_o ),
    .spi_master_csn1_o ( spi_master_csn1_o ),
    .spi_master_csn2_o ( spi_master_csn2_o ),
    .spi_master_csn3_o ( spi_master_csn3_o ),
    .spi_master_mode_o ( spi_master_mode_o ),
    .spi_master_sdo0_o ( spi_master_sdo0_o ),
    .spi_master_sdo1_o ( spi_master_sdo1_o ),
    .spi_master_sdo2_o ( spi_master_sdo2_o ),
    .spi_master_sdo3_o ( spi_master_sdo3_o ),
    .spi_master_sdi0_i ( spi_master_sdi0_i ),
    .spi_master_sdi1_i ( spi_master_sdi1_i ),
    .spi_master_sdi2_i ( spi_master_sdi2_i ),
    .spi_master_sdi3_i ( spi_master_sdi3_i ),

    .uart_tx           ( uart_tx           ), // output
    .uart_rx           ( uart_rx           ), // input
    .uart_rts          ( uart_rts          ), // output
    .uart_dtr          ( uart_dtr          ), // output
    .uart_cts          ( uart_cts          ), // input
    .uart_dsr          ( uart_dsr          ), // input

    .scl_pad_i         ( scl_pad_i         ),
    .scl_pad_o         ( scl_pad_o         ),
    .scl_padoen_o      ( scl_padoen_o      ),
    .sda_pad_i         ( sda_pad_i         ),
    .sda_pad_o         ( sda_pad_o         ),
    .sda_padoen_o      ( sda_padoen_o      ),

    .gpio_in           ( gpio_in           ),
    .gpio_out          ( gpio_out          ),
    .gpio_dir          ( gpio_dir          ),

    .tck_i             ( tck_i             ),
    .trstn_i           ( trstn_i           ),
    .tms_i             ( tms_i             ),
    .tdi_i             ( tdi_i             ),
    .tdo_o             ( tdo_o             )
);

endmodule

