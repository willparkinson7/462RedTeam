---2019 BIN-TO-VHD CONVERTER 1.0
---Copyright William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY eprom IS
   PORT (d        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         address  : IN  STD_LOGIC_VECTOR(9 DOWNTO 0) ;
         ce_l     : IN  STD_LOGIC ;
         oe_l     : IN  STD_LOGIC) ;
   END eprom ;

ARCHITECTURE behavioral OF eprom IS

   SIGNAL data    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL sel     : STD_LOGIC_VECTOR(31 DOWNTO 0) ;

BEGIN

   sel <= "00000000000000000000" & address & "00" ;

   WITH sel  SELECT
   data <=
      X"2fc00014" WHEN X"00000000" , 
      X"2f400010" WHEN X"00000004" , 
      X"28400000" WHEN X"00000008" , 
      X"309ffff0" WHEN X"0000000c" , 
      X"379fffec" WHEN X"00000010" , 
      X"187c0000" WHEN X"00000014" , 
      X"6fbc0004" WHEN X"00000018" , 
      X"a0fc2000" WHEN X"0000001c" , 
      X"403e3003" WHEN X"00000020" , 
      X"68420001" WHEN X"00000024" , 
      X"403a0001" WHEN X"00000028" , 
      X"f8000000" WHEN X"0000002c" , 
      X"00000000" WHEN OTHERS ;

   readprocess:PROCESS(ce_l,oe_l,data)
   begin
      IF (ce_l = '0' AND oe_l = '0') THEN
         d(31 DOWNTO 0) <= data ;
      else
	       d(31 DOWNTO 0) <= (OTHERS => 'Z') ;
      END IF;
   END PROCESS readprocess ;

END behavioral ;
