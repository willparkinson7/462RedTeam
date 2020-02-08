--- 2018 RSRC new "VGA Testbench" VHDL Code 
--- Current file name:  testbench.vhd
--- Last Revised:  8/22/2018; 3:34 p.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;
use ieee.std_logic_unsigned.all;

ENTITY testbench IS
   PORT(clk       : IN  STD_LOGIC;
        reset_h   : IN  STD_LOGIC;  --change l to h
        r         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;  --change 4 bits to 2 bits 
        g         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
        b         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
        txd       :  IN  STD_LOGIC;
        rxd       : OUT STD_LOGIC;
        hs        : OUT STD_LOGIC ;
        vs        : OUT STD_LOGIC);
END testbench ;

ARCHITECTURE structure OF testbench IS
   COMPONENT uart
      PORT (clk      :      IN    STD_LOGIC ;
            reset_l  :      IN    STD_LOGIC ;
            serial_in  :    IN  STD_LOGIC;
            serial_out :    OUT STD_LOGIC;
            rx_data    :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0) ;
            rx_data_valid:  OUT STD_LOGIC ;
            tx_start:       IN STD_LOGIC;
            tx_data :       IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
            tx_busy :       OUT STD_LOGIC);
   END COMPONENT;
   
   COMPONENT clk_wiz_0
   PORT (clk_out1 : OUT STD_LOGIC;
         clk_out2 : OUT STD_LOGIC;
         clk_in1  : IN  STD_LOGIC);
   END COMPONENT;

   COMPONENT rsrc
   PORT(clk      : IN    STD_LOGIC ;
        reset_l  : IN    STD_LOGIC ;
        d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        address  : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        read     : OUT   STD_LOGIC ;
        write    : OUT   STD_LOGIC ;
        done     : IN    STD_LOGIC) ;
   END COMPONENT ;

   COMPONENT eprom
      PORT(d        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
           address  : IN  STD_LOGIC_VECTOR(9 DOWNTO 0) ;
           ce_l     : IN  STD_LOGIC ;
           oe_l     : IN  STD_LOGIC) ;
   END COMPONENT ;

   COMPONENT sram
      PORT (d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
            address  : IN    STD_LOGIC_VECTOR(9 DOWNTO 0) ;
            ce_l     : IN    STD_LOGIC ;
            oe_l     : IN    STD_LOGIC ;
            we_l     : IN    STD_LOGIC ;
            clk      : IN    STD_LOGIC) ;
   END COMPONENT ;
   
   COMPONENT vga
   PORT(src_clk  : IN  STD_LOGIC ;
        ena      : IN  STD_LOGIC ;
        wea      : IN  STD_LOGIC_VECTOR(0 DOWNTO 0) ;
        addra    : IN  STD_LOGIC_VECTOR(18 DOWNTO 0) ;
        dina     : IN  STD_LOGIC_VECTOR(2 DOWNTO 0) ;  --change 9 bits to 3 bits 
        vga_clk  : IN STD_LOGIC ;
        r        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;  --change 4 bits to 2 bits 
        g        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
        b        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
        hs       : OUT STD_LOGIC ;
        vs       : OUT STD_LOGIC);
   END COMPONENT ;           

   SIGNAL reset_l_temp : STD_LOGIC ;
   SIGNAL reset_l_sync : STD_LOGIC ;
   SIGNAL src_clk      : STD_LOGIC ;
   SIGNAL vga_clk      : STD_LOGIC ;
   SIGNAL d            : STD_LOGIC_VECTOR(31 DOWNTO 0):= "00000000000000000000000000000000" ;
   SIGNAL address      : STD_LOGIC_VECTOR(31 DOWNTO 0):= "00000000000000000000000000000000" ;
   SIGNAL read         : STD_LOGIC;
   SIGNAL write        : STD_LOGIC;
   SIGNAL done         : STD_LOGIC;
   SIGNAL eprom_ce_l   : STD_LOGIC ;
   SIGNAL eprom_oe_l   : STD_LOGIC ;
   SIGNAL sram_ce_l    : STD_LOGIC ;
   SIGNAL sram_oe_l    : STD_LOGIC ;
   SIGNAL sram_we_l    : STD_LOGIC ;
   SIGNAL vga_ena      : STD_LOGIC;
   SIGNAL vga_wea      : STD_LOGIC_VECTOR(0 DOWNTO 0) ;
   
   SIGNAL rx_data      : STD_LOGIC_VECTOR(7 DOWNTO 0) ;
   SIGNAL tx_data      : STD_LOGIC_VECTOR(7 DOWNTO 0) ;
   SIGNAL rx_data_valid: STD_LOGIC ;
   SIGNAL tx_busy      : STD_LOGIC ;
   
BEGIN

   tx_data <= rx_data + 1;
   
   uart1:uart
   PORT MAP(clk             => src_clk,   
            reset_l         => reset_l_sync,
            serial_in       => txd,
            serial_out      => rxd,
            rx_data         => rx_data,
            rx_data_valid   => rx_data_valid,
            tx_start        => rx_data_valid,
            tx_busy         => tx_busy,
            tx_data         => tx_data);
            
   --tx_data <= d (7 DOWNTO 0) WHEN (d(31 DOWNTO 2)) = "111111111111111111111111111111"; --tx_data is the bottom 8 bits of data 
   --tx_start <= '1' WHEN (d(31 DOWNTO 2)) = "111111111111111111111111111111" AND write = '1';
   --tx_busy  <= '1' WHEN (address(31 DOWNTO 2)) = "111111111111111111111111111111" AND read = '1' ELSE 'Z';
   
   mydcm1:clk_wiz_0
   PORT MAP(clk_out1 => src_clk ,
            clk_out2 => vga_clk ,
            clk_in1  => clk) ;

   syncprocess:PROCESS(src_clk)
   BEGIN
      IF (src_clk = '1' AND src_clk'event) THEN
         reset_l_temp <=  reset_h ;  --put not 
         reset_l_sync <= not reset_l_temp ;
      END IF;
   END PROCESS syncprocess ;

   eprom_ce_l <= '0' WHEN (address(31 DOWNTO 12) = "00000000000000000000" AND read = '1') ELSE '1' ;
   sram_ce_l  <= '0' WHEN (address(31 DOWNTO 12) = "00000000000000000001" AND (read = '1' OR write = '1')) ELSE '1' ;

   eprom_oe_l <= '0' WHEN read = '1' ELSE '1' ;
   sram_oe_l  <= '0' WHEN read = '1' ELSE '1' ;

   sram_we_l  <= '0' WHEN write = '1' ELSE '1' ;

   done <= '1' WHEN (eprom_ce_l = '0' OR sram_ce_l = '0' OR vga_ena = '1') ELSE '0' ;

   rsrc1:rsrc      
   PORT MAP(clk       => src_clk,
            reset_l   => reset_l_sync,
            d         => d,
            address   => address,
            read      => read,
            write     => write,
            done      => done);

   erpom1:eprom    
      PORT MAP(d         => d,
               address   => address(11 DOWNTO 2),
               ce_l      => eprom_ce_l,
               oe_l      => eprom_oe_l);
 
   sram1:sram
      PORT MAP(d         => d,
               address   => address(11 DOWNTO 2),
               ce_l      => sram_ce_l,
               oe_l      => sram_oe_l,
               we_l      => sram_we_l,
               clk       => src_clk);

   vga_ena <= '1' WHEN address(31 DOWNTO 21) = "00000000001" ELSE '0' ;
   vga_wea <= CONV_STD_LOGIC_VECTOR(write,1) ;

   vga1:vga
   PORT MAP(src_clk   => src_clk,
            ena       => vga_ena,
            wea       => vga_wea,
            addra     => address(20 DOWNTO 2),
            dina      => d(2 DOWNTO 0),
            vga_clk   => vga_clk,
            r         => r,
            g         => g,
            b         => b,
            hs        => hs,
            vs        => vs);

END structure;