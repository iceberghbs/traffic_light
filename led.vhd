LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.std_logic_arith.all;
	
ENTITY led IS
   GENERIC (
      TWINKLE_CNT    : INTEGER := 20_00
   );
   PORT (
      sys_clk        : IN STD_LOGIC;
      sys_rst_n      : IN STD_LOGIC;
      state          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      led            : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
   );
END led;

ARCHITECTURE led_behavior OF led IS

SIGNAL cnt : STD_LOGIC_VECTOR(24 DOWNTO 0);
SIGNAL led_xhdl0 : STD_LOGIC_VECTOR(9 DOWNTO 0);
--SIGNAL xhdl1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
--SIGNAL xhdl2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
--SIGNAL xhdl3 : STD_LOGIC_VECTOR(3 DOWNTO 0);
--SIGNAL xhdl4 : STD_LOGIC_VECTOR(3 DOWNTO 0);
--SIGNAL xhdl5 : STD_LOGIC_VECTOR(3 DOWNTO 0);
--SIGNAL xhdl6 : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
PROCESS (sys_clk, sys_rst_n)
BEGIN
   IF ((NOT(sys_rst_n)) = '1') THEN
      cnt <= "0000000000000000000000000";
   ELSIF (sys_clk'EVENT AND sys_clk = '1') THEN
		--cnt <= TWINKLE_CNT- "01";
      IF (cnt < CONV_STD_LOGIC_VECTOR(TWINKLE_CNT-1, 25)) THEN
         cnt <= cnt + "0000000000000000000000001";
      ELSE
         cnt <= "0000000000000000000000000";
      END IF;
   END IF;
END PROCESS;

--xhdl1 <= "0000";
--xhdl2 <= "0000";
--xhdl3 <= "0000";
--xhdl4 <= "0000";
--xhdl5 <= "0000";
--xhdl6 <= "0000";

led <= led_xhdl0;
PROCESS (sys_clk, sys_rst_n)
BEGIN
   IF ((NOT(sys_rst_n)) = '1') THEN
      led_xhdl0 <= "0000100001";
   ELSIF (sys_clk'EVENT AND sys_clk = '1') THEN
      CASE state IS
         WHEN "0000" =>
            led_xhdl0 <= "0000110000";
         WHEN "0001" =>
            led_xhdl0(9 DOWNTO 5) <= "00001";
            led_xhdl0(3 DOWNTO 0) <= "0000";
            IF (cnt = CONV_STD_LOGIC_VECTOR(TWINKLE_CNT-1, 25)) THEN
               led_xhdl0(4) <= NOT(led_xhdl0(4));
            ELSE
               led_xhdl0(4) <= led_xhdl0(4);
            END IF;
         WHEN "0010" =>
            led_xhdl0 <= "0000101000";
         WHEN "0011" =>
            led_xhdl0(9 DOWNTO 4) <= "000010";
				led_xhdl0(2 DOWNTO 0) <= "000";
            --(led_xhdl0(4), led_xhdl0(2 DOWNTO 0)) <= xhdl1;
            IF (cnt = CONV_STD_LOGIC_VECTOR(TWINKLE_CNT-1, 25)) THEN
               led_xhdl0(3) <= NOT(led_xhdl0(3));
            ELSE
               led_xhdl0(3) <= led_xhdl0(3);
            END IF;
         WHEN "0100" =>
            led_xhdl0 <= "0000100100";
         WHEN "0101" =>
            led_xhdl0(9 DOWNTO 3) <= "0000100";
				led_xhdl0(1 DOWNTO 0) <= "00";
            --(led_xhdl0(4 DOWNTO 3), led_xhdl0(1 DOWNTO 0)) <= xhdl2;
            IF (cnt = CONV_STD_LOGIC_VECTOR(TWINKLE_CNT-1, 25)) THEN
               led_xhdl0(2) <= NOT(led_xhdl0(2));
            ELSE
               led_xhdl0(2) <= led_xhdl0(2);
            END IF;
         WHEN "0110" =>
            led_xhdl0(9 DOWNTO 2) <= "00001000";
				led_xhdl0(0) <= '0';
            --(led_xhdl0(4 DOWNTO 2), led_xhdl0(0)) <= xhdl3;
            IF (cnt = CONV_STD_LOGIC_VECTOR(TWINKLE_CNT-1, 25)) THEN
               led_xhdl0(1) <= NOT(led_xhdl0(1));
            ELSE
               led_xhdl0(1) <= led_xhdl0(1);
            END IF;
         
         WHEN "0111" =>
            led_xhdl0 <= "1000000001";
         WHEN "1000" =>
            led_xhdl0(8 DOWNTO 5) <= "0000";
            led_xhdl0(4 DOWNTO 0) <= "00001";
            IF (cnt = CONV_STD_LOGIC_VECTOR(TWINKLE_CNT-1, 25)) THEN
               led_xhdl0(9) <= NOT(led_xhdl0(9));
            ELSE
               led_xhdl0(9) <= led_xhdl0(9);
            END IF;
         WHEN "1001" =>
            led_xhdl0 <= "0100000001";
         WHEN "1010" =>
            --(led_xhdl0(9), led_xhdl0(7 DOWNTO 5)) <= xhdl4;
            led_xhdl0(9) <= '0';
            led_xhdl0(7 DOWNTO 0) <= "00000001";
            IF (cnt = CONV_STD_LOGIC_VECTOR(TWINKLE_CNT-1, 25)) THEN
               led_xhdl0(8) <= NOT(led_xhdl0(8));
            ELSE
               led_xhdl0(8) <= led_xhdl0(8);
            END IF;
         WHEN "1011" =>
            led_xhdl0 <= "0010000001";
         WHEN "1100" =>
            --(led_xhdl0(9 DOWNTO 8), led_xhdl0(6 DOWNTO 5)) <= xhdl5;
	         led_xhdl0(9 DOWNTO 8) <= "00";			
            led_xhdl0(6 DOWNTO 0) <= "0000001";
            IF (cnt = CONV_STD_LOGIC_VECTOR(TWINKLE_CNT-1, 25)) THEN
               led_xhdl0(7) <= NOT(led_xhdl0(7));
            ELSE
               led_xhdl0(7) <= led_xhdl0(7);
            END IF;
         WHEN "1101" =>
            --(led_xhdl0(9 DOWNTO 7), led_xhdl0(5)) <= xhdl6;
				led_xhdl0(9 DOWNTO 7) <= "000";
            led_xhdl0(5 DOWNTO 0) <= "000001";
            IF (cnt = CONV_STD_LOGIC_VECTOR(TWINKLE_CNT-1, 25)) THEN
               led_xhdl0(6) <= NOT(led_xhdl0(6));
            ELSE
               led_xhdl0(6) <= led_xhdl0(6);
            END IF;
         WHEN OTHERS =>
            led_xhdl0 <= "0000100001";
      END CASE;
   END IF;
END PROCESS;


END led_behavior;


