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
      X"2e400040" WHEN X"00000000" , 
      X"2d800030" WHEN X"00000004" , 
      X"2fc0001c" WHEN X"00000008" , 
      X"2f81ffe0" WHEN X"0000000c" , 
      X"2f41ffe4" WHEN X"00000010" , 
      X"2f01ffe8" WHEN X"00000014" , 
      X"2ec1ffec" WHEN X"00000018" , 
      X"08780000" WHEN X"0000001c" , 
      X"403e1002" WHEN X"00000020" , 
      X"08760000" WHEN X"00000024" , 
      X"6883ffc1" WHEN X"00000028" , 
      X"40322002" WHEN X"0000002c" , 
      X"08bc0000" WHEN X"00000030" , 
      X"402c2003" WHEN X"00000034" , 
      X"187a0000" WHEN X"00000038" , 
      X"403e0001" WHEN X"0000003c" , 
      X"087c0000" WHEN X"00000040" , 
      X"40321003" WHEN X"00000044" , 
      X"68800052" WHEN X"00000048" , 
      X"18ba0000" WHEN X"0000004c" , 
      X"68800049" WHEN X"00000050" , 
      X"18ba0000" WHEN X"00000054" , 
      X"68800043" WHEN X"00000058" , 
      X"18ba0000" WHEN X"0000005c" , 
      X"68800048" WHEN X"00000060" , 
      X"18ba0000" WHEN X"00000064" , 
      X"68800041" WHEN X"00000068" , 
      X"18ba0000" WHEN X"0000006c" , 
      X"68800052" WHEN X"00000070" , 
      X"18ba0000" WHEN X"00000074" , 
      X"68800044" WHEN X"00000078" , 
      X"18ba0000" WHEN X"0000007c" , 
      X"68800055" WHEN X"00000080" , 
      X"18ba0000" WHEN X"00000084" , 
      X"68800049" WHEN X"00000088" , 
      X"18ba0000" WHEN X"0000008c" , 
      X"6880004e" WHEN X"00000090" , 
      X"18ba0000" WHEN X"00000094" , 
      X"6880004f" WHEN X"00000098" , 
      X"18ba0000" WHEN X"0000009c" , 
      X"68800020" WHEN X"000000a0" , 
      X"18ba0000" WHEN X"000000a4" , 
      X"68800056" WHEN X"000000a8" , 
      X"18ba0000" WHEN X"000000ac" , 
      X"68800032" WHEN X"000000b0" , 
      X"18ba0000" WHEN X"000000b4" , 
      X"403e0001" WHEN X"000000b8" , 
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
