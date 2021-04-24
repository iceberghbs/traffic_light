LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.std_logic_arith.all;
ENTITY key_ctrl IS
   GENERIC (
      WIDTH          : INTEGER := 1000
   );
   PORT (
      sys_clk        : IN STD_LOGIC;
      sys_rst_n      : IN STD_LOGIC;
      key            : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      ew_left_time   : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      ew_stra_time   : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      ew_right_time  : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      sn_left_time   : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      sn_stra_time   : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      sn_right_time  : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
   );
END key_ctrl;

ARCHITECTURE key_ctrl_behavior OF key_ctrl IS
   
   SIGNAL ew_left_add         : STD_LOGIC;
   SIGNAL ew_left_sub         : STD_LOGIC;
   
   SIGNAL ew_stra_add         : STD_LOGIC;
   SIGNAL ew_stra_sub         : STD_LOGIC;
   
   SIGNAL ew_right_add        : STD_LOGIC;
   SIGNAL ew_right_sub        : STD_LOGIC;
   
   SIGNAL sn_left_add         : STD_LOGIC;
   SIGNAL sn_left_sub         : STD_LOGIC;
   
   SIGNAL sn_stra_add         : STD_LOGIC;
   SIGNAL sn_stra_sub         : STD_LOGIC;
   
   SIGNAL sn_right_add        : STD_LOGIC;
   SIGNAL sn_right_sub        : STD_LOGIC;
   
   SIGNAL cnt_1ms             : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL clk_1hz             : STD_LOGIC;
   
   -- Declare intermediate signals for referenced outputs
   SIGNAL ew_left_time_xhdl0  : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL ew_stra_time_xhdl2  : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL ew_right_time_xhdl1 : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL sn_left_time_xhdl3  : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL sn_stra_time_xhdl5  : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL sn_right_time_xhdl4 : STD_LOGIC_VECTOR(5 DOWNTO 0);
BEGIN
   -- Drive referenced outputs
   ew_left_time <= ew_left_time_xhdl0;
   ew_stra_time <= ew_stra_time_xhdl2;
   ew_right_time <= ew_right_time_xhdl1;
   sn_left_time <= sn_left_time_xhdl3;
   sn_stra_time <= sn_stra_time_xhdl5;
   sn_right_time <= sn_right_time_xhdl4;
   (ew_left_add, ew_left_sub, ew_stra_add, ew_stra_sub, ew_right_add, ew_right_sub, sn_left_add, sn_left_sub, sn_stra_add, sn_stra_sub, sn_right_add, sn_right_sub) <= key;
   
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
         clk_1hz <= '0';
      ELSIF (sys_clk'EVENT AND sys_clk = '1') THEN
         IF (cnt_1ms = CONV_STD_LOGIC_VECTOR(WIDTH - 1, 16)) THEN
            clk_1hz <= NOT(clk_1hz);
         ELSE
            clk_1hz <= clk_1hz;
         END IF;
      END IF;
   END PROCESS;
   
   
   PROCESS (clk_1hz, sys_rst_n)
   BEGIN
      IF ((NOT(sys_rst_n)) = '1') THEN
         ew_left_time_xhdl0 <= "001010";
         ew_stra_time_xhdl2 <= "001010";
         ew_right_time_xhdl1 <= "001010";
         sn_left_time_xhdl3 <= "001010";
         sn_stra_time_xhdl5 <= "001010";
         sn_right_time_xhdl4 <= "001010";
      ELSIF (clk_1hz'EVENT AND clk_1hz = '1') THEN
         
         IF (ew_left_add = '1' AND ew_left_time_xhdl0 <= "111100") THEN
            ew_left_time_xhdl0 <= ew_left_time_xhdl0 + "000001";
         ELSIF (ew_left_sub = '1' AND ew_left_time_xhdl0 >= "001000") THEN
            ew_left_time_xhdl0 <= ew_left_time_xhdl0 - "000001";
         
         ELSIF (ew_stra_add = '1' AND ew_stra_time_xhdl2 <= "111100") THEN
            ew_stra_time_xhdl2 <= ew_stra_time_xhdl2 + "000001";
         ELSIF (ew_stra_sub = '1' AND ew_stra_time_xhdl2 >= "001000") THEN
            ew_stra_time_xhdl2 <= ew_stra_time_xhdl2 - "000001";
         
         ELSIF (ew_right_add = '1' AND ew_right_time_xhdl1 <= "111100") THEN
            ew_right_time_xhdl1 <= ew_right_time_xhdl1 + "000001";
         ELSIF (ew_right_sub = '1' AND ew_right_time_xhdl1 >= "001000") THEN
            ew_right_time_xhdl1 <= ew_right_time_xhdl1 + "000001";
         
         ELSIF (sn_left_add = '1' AND sn_left_time_xhdl3 <= "111100") THEN
            sn_left_time_xhdl3 <= sn_left_time_xhdl3 + "000001";
         ELSIF (sn_left_sub = '1' AND sn_left_time_xhdl3 >= "001000") THEN
            sn_left_time_xhdl3 <= sn_left_time_xhdl3 - "000001";
         
         ELSIF (sn_stra_add = '1' AND sn_stra_time_xhdl5 <= "111100") THEN
            sn_stra_time_xhdl5 <= sn_stra_time_xhdl5 + "000001";
         ELSIF (sn_stra_sub = '1' AND sn_stra_time_xhdl5 >= "001000") THEN
            sn_stra_time_xhdl5 <= sn_stra_time_xhdl5 - "000001";
         
         ELSIF (sn_right_add = '1' AND sn_right_time_xhdl4 <= "111100") THEN
            sn_right_time_xhdl4 <= sn_right_time_xhdl4 + "000001";
         ELSIF (sn_right_sub = '1' AND sn_right_time_xhdl4 >= "001000") THEN
            sn_right_time_xhdl4 <= sn_right_time_xhdl4 + "000001";
         ELSE
            
            ew_left_time_xhdl0 <= ew_left_time_xhdl0;
            ew_stra_time_xhdl2 <= ew_stra_time_xhdl2;
            ew_right_time_xhdl1 <= ew_right_time_xhdl1;
            sn_left_time_xhdl3 <= sn_left_time_xhdl3;
            sn_stra_time_xhdl5 <= sn_stra_time_xhdl5;
            sn_right_time_xhdl4 <= sn_right_time_xhdl4;
         END IF;
      END IF;
   END PROCESS;
   
   
END key_ctrl_behavior;