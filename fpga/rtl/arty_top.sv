module arty_top (
  // Clock and Reset
  input 	 clk,
  input 	 rst_n,

  input 	 fetch_enable_i,

  input 	 spi_clk_i,
  input 	 spi_cs_i,
  output 	 spi_sdo0_o,
  input 	 spi_sdi0_i,
  // input        spi_sdi1_i,
  // input        spi_sdi2_i,
  // input        spi_sdi3_i,
  // output [1:0] spi_mode_o,
  // output       spi_sdo1_o,
  // output       spi_sdo2_o,
  // output       spi_sdo3_o,

  output 	 pll_locked,
  output 	 fetch_enable_o, 

  output 	 qspi_clk_o,
  output 	 qspi_csn_o,
  inout [3:0] 	 qspi_dq,

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

  output 	 uart_tx,
  input 	 uart_rx,
  inout [24:0] 	 gpio,
  // input  [31:0] gpio_in,
  // output [31:0] gpio_out,
  // output [31:0] gpio_dir,
  //output [8:0] gpio_o,
  input [31:25]  gpio_i,
  output [31:25] gpio_o, 
  // JTAG signals
  input 	 tck_i,
  input 	 trstn_i,
  input 	 tms_i,
  input 	 tdi_i,
  output 	 tdo_o

);
   logic       spi_master_clk_o;
   logic       spi_master_csn0_o;
   logic       spi_master_csn1_o;
   logic       spi_master_csn2_o;
   logic       spi_master_csn3_o;
   logic [1:0] spi_master_mode_o;
   logic [3:0] spi_master_oen_o;
   logic       spi_master_sdo0_o;
   logic       spi_master_sdo1_o;
   logic       spi_master_sdo2_o;
   logic       spi_master_sdo3_o;
   logic       spi_master_sdi0_i;
   logic       spi_master_sdi1_i;
   logic       spi_master_sdi2_i;
   logic       spi_master_sdi3_i;

  // SPI
   logic [1:0] 	spi_mode_o;
   logic        spi_sdo1_o;
   logic        spi_sdo2_o;
   logic        spi_sdo3_o;
   logic 	spi_sdi1_i  = 1'b0;
   logic 	spi_sdi2_i = 1'b0;
   logic 	spi_sdi3_i = 1'b0;

   // uart
   logic 	uart_rts;
   logic        uart_dtr;
   logic 	uart_cts = 1'b0;
   logic 	uart_dsr = 1'b0;

   // i2c
   logic 	scl_pad_i = 1'b0;
   logic        scl_pad_o;
   logic        scl_padoen_o;
   logic 	sda_pad_i = 1'b0;
   logic        sda_pad_o;
   logic        sda_padoen_o;
   logic        clk_cpu;
   logic 	fetch_enable_reg;
   
   // GPIO
   logic [31:0] gpio_in;
   logic [31:0] gpio_out;
   logic [31:0] gpio_dir;

   assign gpio_o = gpio_out[31:25];
   assign gpio_in[31:25] = gpio_i;
   assign gpio_dir_inv = ~gpio_dir;
   assign qspi_clk_o = spi_master_clk_o;
   assign qspi_csn_o = spi_master_csn0_o;
   // PULLUP qspi_pullup[3:2]
   //   (
   //    .O(qspi_dq[3:2])
   //    );
   PULLDOWN gpio_pd[24:0]
     (
      .O(gpio[24:0])
      );
   IOBUF gpio_iobuf[24:0]
     (
      .IO(gpio[24:0]),
      .O(gpio_in[24:0]),
      .I(gpio_out[24:0]),
      .T(~gpio_dir[24:0])
      );

   IOBUF qspi_iobuf_0
     (
      .IO(qspi_dq[0]),
      .O(spi_master_sdi1_i),
      .I(spi_master_sdo0_o),
      .T(spi_master_oen_o[0])
      );
   IOBUF qspi_iobuf_1
     (
      .IO(qspi_dq[1]),
      .O(spi_master_sdi0_i),
      .I(spi_master_sdo1_o),
      .T(spi_master_oen_o[1])
      );
   IOBUF qspi_iobuf_2
     (
      .IO(qspi_dq[2]),
      .O(spi_master_sdi2_i),
      .I(spi_master_sdo2_o),
      .T(spi_master_oen_o[2])
      );
   IOBUF qspi_iobuf_3
     (
      .IO(qspi_dq[3]),
      .O(spi_master_sdi3_i),
      .I(spi_master_sdo3_o),
      .T(spi_master_oen_o[3])
      );

   assign fetch_enable_o = fetch_enable_reg;

   always_ff @(posedge clk_cpu) begin
      fetch_enable_reg <= fetch_enable_i;
   end
   
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
		      .spi_master_oen_o  ( spi_master_oen_o  ),
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
