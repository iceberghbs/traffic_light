LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.std_logic_arith.all;
	
ENTITY seg_led IS
   GENERIC (
      WIDTH          : INTEGER := 5
   );
   PORT (
      sys_clk        : IN STD_LOGIC;
      sys_rst_n      : IN STD_LOGIC;
		ew_time        : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		sn_time        : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      en             : IN STD_LOGIC; 		
      sel            : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      seg_led        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
   );
END seg_led;

ARCHITECTURE seg_led_behavior OF seg_led IS

SIGNAL data_ew_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL data_ew_1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL data_sn_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL data_sn_1 : STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL cnt_1ms   : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL cnt_state : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL num       : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

data_ew_0 <= CONV_STD_LOGIC_VECTOR(CONV_INTEGER(ew_time) / 10,4);
data_ew_1 <= CONV_STD_LOGIC_VECTOR(CONV_INTEGER(ew_time) MOD 10,4);
data_sn_0 <= CONV_STD_LOGIC_VECTOR(CONV_INTEGER(sn_time) / 10,4);
data_sn_1 <= CONV_STD_LOGIC_VECTOR(CONV_INTEGER(sn_time) MOD 10,4);

PROCESS (sys_clk, sys_rst_n)
BEGIN
   IF ((NOT(sys_rst_n)) = '1') THEN
      cnt_1ms <= "0000000000000000";
   ELSIF (sys_clk'EVENT AND sys_clk = '1') THEN
      IF (cnt_1ms < CONV_STD_LOGIC_VECTOR(WIDTH - 1, 16)) THEN
         cnt_1ms <= cnt_1ms + "0000000000000001";
      ELSE
         cnt_1ms <= "0000000000000000";
      END IF;
   END IF;
END PROCESS;


PROCESS (sys_clk, sys_rst_n)
BEGIN
   IF ((NOT(sys_rst_n)) = '1') THEN
      cnt_state <= "00";
   ELSIF (sys_clk'EVENT AND sys_clk = '1') THEN
      IF (cnt_1ms = CONV_STD_LOGIC_VECTOR(WIDTH - 1, 16)) THEN
         cnt_state <= cnt_state + "01";
      ELSE
         cnt_state <= cnt_state;
      END IF;
   END IF;
END PROCESS;


PROCESS (sys_clk, sys_rst_n)
BEGIN
   IF ((NOT(sys_rst_n)) = '1') THEN
      sel <= "1111";
      num <= "0000";
   ELSIF (sys_clk'EVENT AND sys_clk = '1') THEN
      IF (en = '1') THEN
         CASE cnt_state IS
            WHEN "00" =>
               sel <= "1110";
               num <= data_ew_0;
            WHEN "01" =>
               sel <= "1101";
               num <= data_ew_1;
            WHEN "10" =>
               sel <= "1011";
               num <= data_sn_0;
            WHEN "11" =>
               sel <= "0111";
               num <= data_sn_1;
            WHEN OTHERS =>
               sel <= "1111";
               num <= "0000";
         END CASE;
      ELSE
         sel <= "1111";
         num <= "0000";
      END IF;
   END IF;
END PROCESS;


PROCESS (sys_rst_n, num)
BEGIN
   IF ((NOT(sys_rst_n)) = '1') THEN
      seg_led <= "00000000";
   ELSE
      CASE num IS
         WHEN "0000" =>
            seg_led <= "11000000";
         WHEN "0001" =>
            seg_led <= "11111001";
         WHEN "0010" =>
            seg_led <= "10100100";
         WHEN "0011" =>
            seg_led <= "10110000";
         WHEN "0100" =>
            seg_led <= "10011001";
         WHEN "0101" =>
            seg_led <= "10010010";
         WHEN "0110" =>
            seg_led <= "10000010";
         WHEN "0111" =>
            seg_led <= "11111000";
         WHEN "1000" =>
            seg_led <= "10000000";
         WHEN "1001" =>
            seg_led <= "10010000";
         WHEN OTHERS =>
            seg_led <= "11000000";
      END CASE;
   END IF;
END PROCESS;


END seg_led_behavior;


