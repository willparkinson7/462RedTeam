
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;
use ieee.std_logic_unsigned.all;

entity uart is
  Port ( clk          : IN    STD_LOGIC ;
        reset_l       : IN    STD_LOGIC ;
        serial_in     : In STD_LOGIC;
        serial_out    : OUT STD_LOGIC;
        d: INOUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
        a: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        ce: IN STD_LOGIC;
        oe: IN STD_LOGIC;
        we: IN STD_LOGIC);
end uart;

architecture Behavioral of uart is
    SIGNAL serial_in_temp: STD_LOGIC;
    SIGNAL serial_in_sync: STD_LOGIC;
    SIGNAL tx_data_reg :  STD_LOGIC_VECTOR(7 DOWNTO 0); 
    SIGNAL rx_data      :  STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
    SIGNAL tx_data      :  STD_LOGIC_VECTOR(7 DOWNTO 0) ;
    SIGNAL rx_data_valid:  STD_LOGIC := '0';
    SIGNAL tx_start     :  STD_LOGIC ;
    SIGNAL tx_busy      :  STD_LOGIC := '0';
    SIGNAL fifo_full    :  STD_LOGIC ;
    SIGNAL fifo_dout    :  STD_LOGIC_VECTOR(7 DOWNTO 0) ;
    SIGNAL reset_h :  STD_LOGIC ;
    SIGNAL fifo_empty    :  STD_LOGIC ; --:= '1';
	
	SIGNAL receiving : STD_LOGIC := '0';
	SIGNAL transmitting: STD_LOGIC := '0';
	SIGNAL rx_data_in_progress: STD_LOGIC := '0';
	SIGNAL count1        : STD_LOGIC_VECTOR(12 DOWNTO 0) ;
	SIGNAL count2        : STD_LOGIC_VECTOR(12 DOWNTO 0) ;
	SIGNAL tx_data_save  : STD_LOGIC_VECTOR(7 DOWNTO 0) ;

   COMPONENT fifo_generator_0
   PORT (din:   IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
          dout: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
          full:  OUT STD_LOGIC;
          empty: OUT STD_LOGIC; 
          wr_en: IN STD_LOGIC;
          rd_en: IN STD_LOGIC;
          clk : IN STD_LOGIC;
          srst: IN STD_LOGIC);
    END COMPONENT;
begin

    myfifo: fifo_generator_0
    PORT MAP( 
            din => rx_data,
            dout => fifo_dout,      --tie signal to tri state buffer based on read enable
            wr_en => rx_data_valid,
            rd_en => oe,
            full => fifo_full,
            empty => fifo_empty,            --- has to be put into a register   rx_data_flag, need rx_data_flag to be 1 when there's data to read
            clk => clk,
            srst => reset_h);  --active high or low???
   

tx_start <= '1' WHEN (ce = '1' and we = '1' and a = "01") ELSE '0'; -- the 2 bits of a are bits 3,2

tx_data <= d(7 downto 0) when (we ='1' and ce = '1') ELSE "00000000";
--d(7 downto 0) <= rx_data when  (oe = '1' and ce = '1');     --rx_data should be output of fifo
d(31 downto 0) <= "000000000000000000000000" & fifo_dout when (ce='1' AND oe='1' AND a(1 downto 0)="11") ELSE "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";       --rx_data
--d(0) <= rx_data_valid when (a = "10" and oe = '1');
d(31 downto 0) <= "0000000000000000000000000000000" & NOT(fifo_empty) when (ce='1' AND oe='1' AND a(1 downto 0)="10") ELSE "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";  --rx_data_flag

d(31 downto 0) <= "0000000000000000000000000000000" & tx_busy when (ce='1' AND oe='1' AND a(1 downto 0)="00") ELSE "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";  --tx_start
--d(31 downto 0) <= "0000000000001011101010111110000" & tx_busy when (ce='1' AND oe='1' AND a(1 downto 0)="00") ELSE "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";  --tx_start


reset_h <= NOT(reset_l) ;

   
   
    counter_receive_process:PROCESS(clk)
    BEGIN
        IF (clk = '1' and clk'EVENT) THEN
            IF (receiving = '0' OR reset_l = '0') THEN
                count1 <= (OTHERS => '0') ;
            ELSIF (receiving = '1') THEN
                count1 <= count1 + 1 ;
            END IF ;
        END IF ;
    END PROCESS counter_receive_process ;
    
    counter_trasmit_process:PROCESS(clk)
    BEGIN
        IF (clk = '1' and clk'EVENT) THEN
            IF (transmitting = '0' OR reset_l = '0') THEN
                count2 <= (OTHERS => '0') ;
            ELSE
                IF(transmitting = '1') THEN
                    count2 <= count2 + 1 ;
                END IF ;
            END IF ;
        END IF ;
    END PROCESS counter_trasmit_process ;
    
    serial_sync:PROCESS(clk)
    BEGIN
        IF (clk'EVENT AND clk='1') THEN
            IF (reset_l = '0')THEN
                serial_in_temp <= '1';
            ELSE
                serial_in_temp <= serial_in; 
                serial_in_sync <= serial_in_temp;
            END IF ;
        END IF ;
    END PROCESS serial_sync ;
    
    
    receive:PROCESS(clk)
    BEGIN
        IF (clk = '1' AND clk'EVENT) THEN
            IF (serial_in_sync = '0') THEN -- check for start bit
                receiving <= '1' ;
            END IF;
           
            IF (count1 = 209 AND serial_in_sync = '0') THEN --check if start bit still valid in middle
                rx_data_in_progress <= '1' ;
            ELSIF(count1 = 209 AND serial_in_sync = '1') THEN
                receiving <= '0' ;
            ELSIF(count1 = 627 AND rx_data_in_progress = '1') THEN
                rx_data(0) <= serial_in_sync ;
            
            ELSIF(count1 = 1045 AND rx_data_in_progress = '1') THEN
                rx_data(1) <= serial_in_sync ;
            
            ELSIF(count1 = 1463 AND rx_data_in_progress = '1') THEN
                rx_data(2) <= serial_in_sync ;
            
            ELSIF(count1 = 1881 AND rx_data_in_progress = '1') THEN
                rx_data(3) <= serial_in_sync ;
    
            ELSIF(count1 = 2299 AND rx_data_in_progress = '1') THEN
                rx_data(4) <= serial_in_sync ;
            
            ELSIF(count1 = 2717 AND rx_data_in_progress = '1') THEN
                rx_data(5) <= serial_in_sync ;
            
            ELSIF(count1 = 3135 AND rx_data_in_progress = '1') THEN
                rx_data(6) <= serial_in_sync ;
            
            ELSIF(count1 = 3553 AND rx_data_in_progress = '1') THEN
                rx_data(7) <= serial_in_sync ;
                rx_data_valid <= '1' ;
          
            ELSIF(count1 = 3554 AND rx_data_in_progress = '1') THEN
                rx_data_valid <= '0' ;
            
            ELSIF(count1 = 3971 AND rx_data_in_progress = '1' AND serial_in_sync = '1') THEN -- check stop bit
                rx_data_in_progress <= '0';
                receiving <= '0' ;  
            END IF ;
        END IF ;
    END PROCESS receive ;
                

    transmit:PROCESS(clk)
    BEGIN
        IF (clk = '1' AND clk'EVENT) THEN
            IF(reset_l = '0') THEN
                serial_out <= '1' ;
            ELSIF (tx_start = '1') THEN
                transmitting <= '1' ;
                serial_out <= '0' ; -- output start bit
                --tx_busy <= '0' ;
                tx_data_save <= tx_data; 
                tx_busy <= '1' ;
            ELSE
                IF(count2 = 418 AND tx_busy = '1') THEN
                    serial_out <= tx_data_save(0) ;
                
                ELSIF(count2 = 836 AND tx_busy = '1') THEN
                    serial_out <= tx_data_save(1) ;
                
                ELSIF(count2 = 1254 AND tx_busy = '1') THEN
                    serial_out <= tx_data_save(2) ;
                
                ELSIF(count2 = 1672 AND tx_busy = '1') THEN
                    serial_out <= tx_data_save(3) ;
                
                ELSIF(count2 = 2090 AND tx_busy = '1') THEN
                    serial_out <= tx_data_save(4) ;
    
                ELSIF(count2 = 2508 AND tx_busy = '1') THEN
                    serial_out <= tx_data_save(5) ;
                
                ELSIF(count2 = 2926 AND tx_busy = '1') THEN
                    serial_out <= tx_data_save(6) ;
                
                ELSIF(count2 = 3344 AND tx_busy = '1') THEN
                    serial_out <= tx_data_save(7) ;
    
                ELSIF(count2 = 3762 AND tx_busy = '1') THEN
                    serial_out <= '1' ; --output stop bit
                
                ELSIF(count2 = 4180 AND tx_busy = '1') THEN
                    transmitting <= '0' ;
                    tx_busy <= '0' ;
                    serial_out <= '1' ;
                END IF ;
            END IF ;
        END IF ;
    END PROCESS transmit ;           
            
end Behavioral;