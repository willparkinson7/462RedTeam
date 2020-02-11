
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
    SIGNAL counter1 :STD_LOGIC_VECTOR(11 DOWNTO 0); -- count from 1 to ~4000, thus 12 bits 
    SIGNAL counter2 :STD_LOGIC_VECTOR(11 DOWNTO 0); 
    SIGNAL busy1: STD_LOGIC;
    SIGNAL busy2: STD_LOGIC;
    SIGNAL serial_in_temp: STD_LOGIC;
    SIGNAL serial_in_sync: STD_LOGIC;
    SIGNAL tx_data_reg :  STD_LOGIC_VECTOR(7 DOWNTO 0); 
    SIGNAL rx_data      :  STD_LOGIC_VECTOR(7 DOWNTO 0) ;
    SIGNAL tx_data      :  STD_LOGIC_VECTOR(7 DOWNTO 0) ;
    SIGNAL rx_data_valid:  STD_LOGIC ;
    SIGNAL tx_start     :  STD_LOGIC ;
    SIGNAL tx_busy      :  STD_LOGIC ;
    SIGNAL fifo_full    :  STD_LOGIC ;
    SIGNAL fifo_empty    :  STD_LOGIC ;
    
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
            dout => d(7 downto 0),
            wr_en => rx_data_valid,
            rd_en => oe,
            full => fifo_full,
            empty => fifo_empty,
            clk => clk,
            srst => reset_l);  --active high or low???
   

tx_start <= '1' WHEN ce = '1' and we = '1' and a = "01"; -- the 2 bits of a are bits 3,2

tx_data <= d(7 downto 0) when (we ='1' and ce = '1');
d(7 downto 0) <= rx_data when  (oe = '1' and ce = '1');     --rx_data should be output of fifo
d(0) <= rx_data_valid when (a = "10" and oe = '1');


   syncprocess:PROCESS(clk)  --synchronize the input
   BEGIN
      IF (clk = '1' AND clk'event) THEN
         serial_in_temp <=  serial_in ;  
         serial_in_sync <= serial_in_temp;
      END IF;
   END PROCESS syncprocess ;
   
   receiver_process:PROCESS(clk)
   BEGIN
      IF (clk = '1' AND clk'event) THEN
        IF (reset_l ='0') THEN 
            busy1 <= '0';
            counter1 <= (OTHERS => '0');
        ELSE 
            
            IF (counter1="000000000000" and serial_in_sync = '0') THEN   --check for start bit 
                busy1 <= '1';
            END IF;
            
            IF (busy1 = '1') THEN 
                counter1 <= counter1+1;
            ELSE 
                counter1 <= "000000000000";
            END IF;
                
          IF counter1 = "000011010001" THEN  --at 209 
                IF (serial_in_sync = '1') THEN --debounce, restart the counter 
                    busy1 <= '0';
                    counter1 <= "000000000000";
                END IF;   
          ELSIF counter1 = "001001110011" THEN   -- 209+418*1=627     --wait 418 after the start bit      
                rx_data(0) <= serial_in_sync ;
          ELSIF counter1 = "010000010101" THEN   --209+418*2
                rx_data(1) <= serial_in_sync ;
          ELSIF counter1 = "010110110111" THEN   --209+418*3
                rx_data(2) <= serial_in_sync ;
          ELSIF counter1 = "011101011001" THEN   --209+418*4
                rx_data(3) <= serial_in_sync ;
          ELSIF counter1 = "100011111011" THEN   --209+418 *5
                rx_data(4) <= serial_in_sync ;
          ELSIF counter1 = "101010011101" THEN   --209+418 *6
                rx_data(5) <= serial_in_sync ;
          ELSIF counter1 = "110000111111" THEN   --209+418 *7
                rx_data(6) <= serial_in_sync ;
          ELSIF counter1 = "110111100001" THEN   --209+418 *8
                rx_data(7) <= serial_in_sync ;
                rx_data_valid <= '1' ;
          ELSIF counter1 = "110111100010" THEN   --209+418 *8
                rx_data(7) <= serial_in_sync ;
                rx_data_valid <= '0' ;   
          ELSIF counter1 = "111010110010" THEN   --418 *9 stop bit
                busy1 <= '0';
                
          END IF;
      END IF;
    END IF;
     
   END PROCESS receiver_process ;
   -----------------------------------------------------------------------------------------------
      transmitte_process:PROCESS(clk)
   BEGIN
      IF (clk = '1' AND clk'event) THEN
        IF (reset_l ='0') THEN 
            busy2 <= '0';
            serial_out <= '1';
            counter2 <= (OTHERS => '0');
        ELSE   
            
            IF (tx_start = '1') THEN --when tx_start is asserted , save tx_Data in reg
                tx_data_reg <= tx_data;
				tx_busy <= '1';
                busy2 <= '1';
            END IF; 
            
            IF (busy2 = '1') THEN    --
                counter2 <= counter2 +1;
            ELSE
                counter2 <= "000000000000";
            END IF;      
			
            IF counter2 = "000000000001" THEN  --0 start bit
					serial_out <= '0'; 
            ELSIF counter2 = "000110100010" THEN   -- 418*1     --wait 418 after the start bit      
					serial_out <= tx_data_reg(0);
              ELSIF counter2 = "001101000100" THEN   --418*2
                    serial_out <= tx_data_reg(1);
              ELSIF counter2 = "010011100110" THEN   --418*3
                    serial_out <= tx_data_reg(2);
              ELSIF counter2 = "011010001000" THEN   --418*4
                    serial_out <= tx_data_reg(3);
              ELSIF counter2 = "100000101010" THEN   --418 *5
                    serial_out <= tx_data_reg(4);
              ELSIF counter2 = "100111001100" THEN   --418 *6
                    serial_out <= tx_data_reg(5);
              ELSIF counter2 = "101101101110" THEN   --418 *7
                    serial_out <= tx_data_reg(6);
              ELSIF counter2 = "110100010000" THEN   --418 *8
                    serial_out <= tx_data_reg(7);
                    
               ELSIF counter2 = "111010110010" THEN   --418 *9
                    serial_out <= '1'; --stop bit
                    tx_busy <= '0';
                    busy2 <= '0';
             END IF;
         END IF;
      END IF;

   END PROCESS transmitte_process ;
end Behavioral;
