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
      X"2e40005c" WHEN X"00000000" , 
      X"2d80004c" WHEN X"00000004" , 
      X"2d40011c" WHEN X"00000008" , 
      X"2d000110" WHEN X"0000000c" , 
      X"2e000160" WHEN X"00000010" , 
      X"2d800124" WHEN X"00000014" , 
      X"2fc00030" WHEN X"00000018" , 
      X"2f81ffe0" WHEN X"0000001c" , 
      X"2f41ffe4" WHEN X"00000020" , 
      X"2f01ffe8" WHEN X"00000024" , 
      X"2ec1ffec" WHEN X"00000028" , 
      X"2dc01000" WHEN X"0000002c" , 
      X"08780000" WHEN X"00000030" , 
      X"403e1002" WHEN X"00000034" , 
      X"08760000" WHEN X"00000038" , 
      X"6883ffc1" WHEN X"0000003c" , 
      X"40322002" WHEN X"00000040" , 
      X"68c3ff90" WHEN X"00000044" , 
      X"402a3002" WHEN X"00000048" , 
      X"08bc0000" WHEN X"0000004c" , 
      X"402c2003" WHEN X"00000050" , 
      X"187a0000" WHEN X"00000054" , 
      X"403e0001" WHEN X"00000058" , 
      X"087c0000" WHEN X"0000005c" , 
      X"40321003" WHEN X"00000060" , 
      X"68800052" WHEN X"00000064" , 
      X"4be80001" WHEN X"00000068" , 
      X"18ba0000" WHEN X"0000006c" , 
      X"68800049" WHEN X"00000070" , 
      X"4be80001" WHEN X"00000074" , 
      X"18ba0000" WHEN X"00000078" , 
      X"68800043" WHEN X"0000007c" , 
      X"4be80001" WHEN X"00000080" , 
      X"18ba0000" WHEN X"00000084" , 
      X"68800048" WHEN X"00000088" , 
      X"4be80001" WHEN X"0000008c" , 
      X"18ba0000" WHEN X"00000090" , 
      X"68800041" WHEN X"00000094" , 
      X"4be80001" WHEN X"00000098" , 
      X"18ba0000" WHEN X"0000009c" , 
      X"68800052" WHEN X"000000a0" , 
      X"4be80001" WHEN X"000000a4" , 
      X"18ba0000" WHEN X"000000a8" , 
      X"68800044" WHEN X"000000ac" , 
      X"4be80001" WHEN X"000000b0" , 
      X"18ba0000" WHEN X"000000b4" , 
      X"68800055" WHEN X"000000b8" , 
      X"4be80001" WHEN X"000000bc" , 
      X"18ba0000" WHEN X"000000c0" , 
      X"68800049" WHEN X"000000c4" , 
      X"4be80001" WHEN X"000000c8" , 
      X"18ba0000" WHEN X"000000cc" , 
      X"6880004e" WHEN X"000000d0" , 
      X"4be80001" WHEN X"000000d4" , 
      X"18ba0000" WHEN X"000000d8" , 
      X"6880004f" WHEN X"000000dc" , 
      X"4be80001" WHEN X"000000e0" , 
      X"18ba0000" WHEN X"000000e4" , 
      X"68800020" WHEN X"000000e8" , 
      X"4be80001" WHEN X"000000ec" , 
      X"18ba0000" WHEN X"000000f0" , 
      X"68800056" WHEN X"000000f4" , 
      X"4be80001" WHEN X"000000f8" , 
      X"18ba0000" WHEN X"000000fc" , 
      X"68800032" WHEN X"00000100" , 
      X"4be80001" WHEN X"00000104" , 
      X"18ba0000" WHEN X"00000108" , 
      X"403e0001" WHEN X"0000010c" , 
      X"087c0000" WHEN X"00000110" , 
      X"40281003" WHEN X"00000114" , 
      X"401e0001" WHEN X"00000118" , 
      X"28c00000" WHEN X"0000011c" , 
      X"29400000" WHEN X"00000120" , 
      X"08780000" WHEN X"00000124" , 
      X"402c1002" WHEN X"00000128" , 
      X"08760000" WHEN X"0000012c" , 
      X"187a0000" WHEN X"00000130" , 
      X"e14a0008" WHEN X"00000134" , 
      X"b14a1000" WHEN X"00000138" , 
      X"68c60001" WHEN X"0000013c" , 
      X"6907fffc" WHEN X"00000140" , 
      X"402c4005" WHEN X"00000144" , 
      X"401e0001" WHEN X"00000148" , 
      X"2dc01000" WHEN X"0000014c" , 
      X"4bea0001" WHEN X"00000150" , 
      X"28c00000" WHEN X"00000154" , 
      X"79805000" WHEN X"00000158" , 
      X"698dffff" WHEN X"0000015c" , 
      X"08780000" WHEN X"00000160" , 
      X"402c1002" WHEN X"00000164" , 
      X"08760000" WHEN X"00000168" , 
      X"187a0000" WHEN X"0000016c" , 
      X"6dee0008" WHEN X"00000170" , 
      X"186e0000" WHEN X"00000174" , 
      X"68c60001" WHEN X"00000178" , 
      X"61066000" WHEN X"0000017c" , 
      X"40304005" WHEN X"00000180" , 
      X"68800045" WHEN X"00000184" , 
      X"4be80001" WHEN X"00000188" , 
      X"18ba0000" WHEN X"0000018c" , 
      X"68800058" WHEN X"00000190" , 
      X"4be80001" WHEN X"00000194" , 
      X"18ba0000" WHEN X"00000198" , 
      X"68800049" WHEN X"0000019c" , 
      X"4be80001" WHEN X"000001a0" , 
      X"18ba0000" WHEN X"000001a4" , 
      X"68800054" WHEN X"000001a8" , 
      X"4be80001" WHEN X"000001ac" , 
      X"18ba0000" WHEN X"000001b0" , 
      X"68800050" WHEN X"000001b4" , 
      X"4be80001" WHEN X"000001b8" , 
      X"18ba0000" WHEN X"000001bc" , 
      X"403e0001" WHEN X"000001c0" , 
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
