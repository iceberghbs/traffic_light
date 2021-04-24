LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.std_logic_arith.all;
	
ENTITY traffic_light IS
   GENERIC (   
      led_y_time     : INTEGER := 5;
      WIDTH          : INTEGER := 2500
   );
   PORT (
      sys_clk        : IN STD_LOGIC;
      sys_rst_n      : IN STD_LOGIC;
      ew_left_time   : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      ew_stra_time   : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      ew_right_time  : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      sn_left_time   : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      sn_stra_time   : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      sn_right_time  : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      emergency      : IN STD_LOGIC;
      state          : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      ew_time        : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      sn_time        : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
   );
END traffic_light;

ARCHITECTURE traffic_light_behavior OF traffic_light IS
   
   SIGNAL time_cnt         : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL clk_cnt          : STD_LOGIC_VECTOR(24 DOWNTO 0);
   SIGNAL clk_1hz          : STD_LOGIC;
   
   SIGNAL ew_left_time_1x  : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL ew_stra_time_1x  : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL ew_right_time_1x : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL sn_left_time_1x  : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL sn_stra_time_1x  : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL sn_right_time_1x : STD_LOGIC_VECTOR(5 DOWNTO 0);
   
   -- Declare intermediate signals for referenced outputs
   SIGNAL state_xhdl0      : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
   -- Drive referenced outputs
   state <= state_xhdl0;
   
   PROCESS (sys_clk, sys_rst_n)
   BEGIN
      IF ((NOT(sys_rst_n)) = '1') THEN
         clk_cnt <= "0000000000000000000000000";
      ELSIF (sys_clk'EVENT AND sys_clk = '1') THEN
         IF (clk_cnt < CONV_STD_LOGIC_VECTOR(WIDTH-1, 25)) THEN
            clk_cnt <= clk_cnt + "0000000000000000000000001";
         ELSE
            clk_cnt <= "0000000000000000000000000";
         END IF;
      END IF;
   END PROCESS;
   
   
   PROCESS (sys_clk, sys_rst_n)
   BEGIN
      IF ((NOT(sys_rst_n)) = '1') THEN
         clk_1hz <= '0';
      ELSIF (sys_clk'EVENT AND sys_clk = '1') THEN
         IF (clk_cnt = CONV_STD_LOGIC_VECTOR(WIDTH-1, 25)) THEN
            clk_1hz <= NOT(clk_1hz);
         ELSE
            clk_1hz <= clk_1hz;
         END IF;
      END IF;
   END PROCESS;
   
   
   PROCESS (clk_1hz, sys_rst_n)
   BEGIN
      IF ((NOT(sys_rst_n)) = '1') THEN
         state_xhdl0 <= "0000";
         time_cnt <= "001010";
         ew_left_time_1x <= "001010";
         ew_stra_time_1x <= "001010";
         ew_right_time_1x <= "001010";
         sn_left_time_1x <= "001010";
         sn_stra_time_1x <= "001010";
         sn_right_time_1x <= "001010";
      ELSIF (clk_1hz'EVENT AND clk_1hz = '1') THEN
         IF (emergency = '1') THEN
            time_cnt <= time_cnt;
            state_xhdl0 <= state_xhdl0;
         ELSE
            CASE state_xhdl0 IS
               WHEN "0000" =>
                  ew_time <= time_cnt + sn_stra_time_1x + sn_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                  sn_time <= time_cnt;
                  IF (time_cnt > "000101") THEN
                     time_cnt <= time_cnt - "000001";
                     state_xhdl0 <= state_xhdl0;
                  ELSE
                     time_cnt <= "000100";
                     state_xhdl0 <= "0001";
                  END IF;
               WHEN "0001" =>
                  IF (time_cnt > "000001" AND time_cnt <= "000100") THEN
                     ew_time <= time_cnt + sn_stra_time_1x + sn_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     sn_time <= time_cnt;
                     time_cnt <= time_cnt - "000001";
                     state_xhdl0 <= state_xhdl0;
                  ELSIF (time_cnt = sn_stra_time_1x) THEN
                     ew_time <= time_cnt + sn_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     sn_time <= time_cnt;
                     state_xhdl0 <= "0010";
                     time_cnt <= sn_stra_time_1x - "000001";
                  ELSE
                     ew_time <= time_cnt + sn_stra_time_1x + sn_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     sn_time <= time_cnt;
                     time_cnt <= sn_stra_time_1x;
                  END IF;
               WHEN "0010" =>
                  ew_time <= time_cnt + sn_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                  sn_time <= time_cnt;
                  IF (time_cnt > "000101") THEN
                     time_cnt <= time_cnt - "000001";
                     state_xhdl0 <= state_xhdl0;
                  ELSE
                     time_cnt <= "000100";
                     state_xhdl0 <= "0011";
                  END IF;
               WHEN "0011" =>
                  IF (time_cnt > "000001" AND time_cnt <= "000100") THEN
                     ew_time <= time_cnt + sn_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     sn_time <= time_cnt;
                     time_cnt <= time_cnt - "000001";
                     state_xhdl0 <= state_xhdl0;
                  ELSIF (time_cnt = sn_right_time_1x) THEN
                     ew_time <= sn_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     sn_time <= time_cnt;
                     state_xhdl0 <= "0100";
                     time_cnt <= sn_right_time_1x - "000001";
                  ELSE
                     ew_time <= time_cnt + sn_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     sn_time <= time_cnt;
                     time_cnt <= sn_right_time_1x;
                  END IF;
               WHEN "0100" =>
                  ew_time <= time_cnt + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                  sn_time <= time_cnt;
                  IF (time_cnt > "000101") THEN
                     time_cnt <= time_cnt - "000001";
                     state_xhdl0 <= state_xhdl0;
                  ELSE
                     time_cnt <= "000100";
                     state_xhdl0 <= "0101";
                  END IF;
               WHEN "0101" =>
                  IF (time_cnt > "000001" AND time_cnt <= "000100") THEN
                     ew_time <= time_cnt + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     sn_time <= time_cnt;
                     time_cnt <= time_cnt - "000001";
                     state_xhdl0 <= state_xhdl0;
                  ELSIF (time_cnt = CONV_STD_LOGIC_VECTOR(led_y_time, 6)) THEN
                     ew_time <= time_cnt;
                     sn_time <= time_cnt;
                     state_xhdl0 <= "0110";
                     time_cnt <= CONV_STD_LOGIC_VECTOR(led_y_time, 6) - "000001";
                  ELSE
                     ew_time <= time_cnt + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     sn_time <= time_cnt;
                     time_cnt <= CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                  END IF;
               WHEN "0110" =>
                  IF (time_cnt > "000001" AND time_cnt <= CONV_STD_LOGIC_VECTOR(led_y_time - 1, 6)) THEN
                     ew_time <= time_cnt;
                     sn_time <= time_cnt;
                     time_cnt <= time_cnt - "000001";
                     state_xhdl0 <= state_xhdl0;
                  ELSIF (time_cnt = ew_left_time_1x) THEN
                     sn_time <= time_cnt + ew_stra_time_1x + ew_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     ew_time <= time_cnt;
                     state_xhdl0 <= "0111";
                     time_cnt <= ew_left_time_1x - "000001";
                  ELSE
                     ew_time <= time_cnt;
                     sn_time <= time_cnt;
                     time_cnt <= ew_left_time_1x;
                  END IF;
               WHEN "0111" =>
                  sn_time <= time_cnt + ew_stra_time_1x + ew_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                  ew_time <= time_cnt;
                  IF (time_cnt > "000101") THEN
                     time_cnt <= time_cnt - "000001";
                     state_xhdl0 <= state_xhdl0;
                  ELSE
                     time_cnt <= "000100";
                     state_xhdl0 <= "1000";
                  END IF;
               WHEN "1000" =>
                  IF (time_cnt > "000001" AND time_cnt <= "000100") THEN
                     sn_time <= time_cnt + ew_stra_time_1x + ew_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     ew_time <= time_cnt;
                     time_cnt <= time_cnt - "000001";
                     state_xhdl0 <= state_xhdl0;
                  ELSIF (time_cnt = ew_stra_time_1x) THEN
                     sn_time <= time_cnt + ew_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     ew_time <= time_cnt;
                     state_xhdl0 <= "1001";
                     time_cnt <= ew_stra_time_1x - "000001";
                  ELSE
                     sn_time <= time_cnt + ew_stra_time_1x + ew_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     ew_time <= time_cnt;
                     time_cnt <= ew_stra_time_1x;
                  END IF;
               WHEN "1001" =>
                  sn_time <= time_cnt + ew_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                  ew_time <= time_cnt;
                  IF (time_cnt > "000101") THEN
                     time_cnt <= time_cnt - "000001";
                     state_xhdl0 <= state_xhdl0;
                  ELSE
                     time_cnt <= "000100";
                     state_xhdl0 <= "1010";
                  END IF;
               WHEN "1010" =>
                  IF (time_cnt > "000001" AND time_cnt <= "000100") THEN
                     sn_time <= time_cnt + ew_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     ew_time <= time_cnt;
                     time_cnt <= time_cnt - "000001";
                     state_xhdl0 <= state_xhdl0;
                  ELSIF (time_cnt = ew_right_time_1x) THEN
                     sn_time <= time_cnt + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     ew_time <= time_cnt;
                     state_xhdl0 <= "1011";
                     time_cnt <= ew_right_time_1x - "000001";
                  ELSE
                     sn_time <= time_cnt + ew_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     ew_time <= time_cnt;
                     time_cnt <= ew_right_time_1x;
                  END IF;
               WHEN "1011" =>
                  sn_time <= time_cnt + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                  ew_time <= time_cnt;
                  IF (time_cnt > "000101") THEN
                     time_cnt <= time_cnt - "000001";
                     state_xhdl0 <= state_xhdl0;
                  ELSE
                     time_cnt <= "000100";
                     state_xhdl0 <= "1100";
                  END IF;
               WHEN "1100" =>
                  IF (time_cnt > "000001" AND time_cnt <= "000100") THEN
                     sn_time <= time_cnt + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     ew_time <= time_cnt;
                     time_cnt <= time_cnt - "000001";
                     state_xhdl0 <= state_xhdl0;
                  ELSIF (time_cnt = CONV_STD_LOGIC_VECTOR(led_y_time, 6)) THEN
                     sn_time <= time_cnt;
                     ew_time <= time_cnt;
                     state_xhdl0 <= "1101";
                     time_cnt <= CONV_STD_LOGIC_VECTOR(led_y_time, 6) - "000001";
                  ELSE
                     sn_time <= time_cnt + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     ew_time <= time_cnt;
                     time_cnt <= CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                  END IF;
               WHEN "1101" =>
                  IF (time_cnt > "000001" AND time_cnt <= CONV_STD_LOGIC_VECTOR(led_y_time - 1, 6)) THEN
                     sn_time <= time_cnt;
                     ew_time <= time_cnt;
                     time_cnt <= time_cnt - "000001";
                     state_xhdl0 <= state_xhdl0;
                  ELSIF (time_cnt = sn_left_time_1x) THEN
                     ew_time <= time_cnt + sn_stra_time_1x + sn_right_time_1x + CONV_STD_LOGIC_VECTOR(led_y_time, 6);
                     sn_time <= time_cnt;
                     state_xhdl0 <= "0000";
                     time_cnt <= sn_left_time_1x - "000001";
                  ELSE
                     sn_time <= time_cnt;
                     ew_time <= time_cnt;
                     time_cnt <= sn_left_time;
                     ew_left_time_1x <= ew_left_time;
                     ew_stra_time_1x <= ew_stra_time;
                     ew_right_time_1x <= ew_right_time;
                     sn_left_time_1x <= sn_left_time;
                     sn_stra_time_1x <= sn_stra_time;
                     sn_right_time_1x <= sn_right_time;
                  END IF;
               WHEN OTHERS =>
                  state_xhdl0 <= "0000";
                  time_cnt <= sn_left_time_1x;
            END CASE;
         END IF;
      END IF;
   END PROCESS;
   
   
END traffic_light_behavior;


