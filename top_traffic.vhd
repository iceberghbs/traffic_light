LIBRARY ieee;
   USE ieee.std_logic_1164.all;

ENTITY top_traffic IS
   PORT (
      sys_clk    : IN STD_LOGIC;
      sys_rst_n  : IN STD_LOGIC;
      emergency  : IN STD_LOGIC;
      key        : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      
      sel        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      seg_led_o    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      led_o        : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
   );
END top_traffic;

ARCHITECTURE top_traffic_behavior OF top_traffic IS


   COMPONENT key_ctrl IS
      GENERIC (
         WIDTH      : INTEGER := 5
      );
      PORT (
         sys_clk    : IN STD_LOGIC;
         sys_rst_n  : IN STD_LOGIC;
         key        : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
         ew_left_time : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
         ew_stra_time : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
         ew_right_time : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
         sn_left_time : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
         sn_stra_time : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
         sn_right_time : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
      );
   END COMPONENT;
	
	COMPONENT seg_led IS
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
	END COMPONENT;

	COMPONENT traffic_light IS
		GENERIC (   
			led_y_time     : INTEGER := 5;
			WIDTH          : INTEGER := 25
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
	END COMPONENT;
	
	COMPONENT led IS
		GENERIC (
			TWINKLE_CNT    : INTEGER := 20
		);
		PORT (
			sys_clk        : IN STD_LOGIC;
			sys_rst_n      : IN STD_LOGIC;
			state          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			led            : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
		);
	END COMPONENT;   
   
   SIGNAL ew_left_time  : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL ew_stra_time  : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL ew_right_time : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL sn_left_time  : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL sn_stra_time  : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL sn_right_time : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL state         : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL ew_time       : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL sn_time       : STD_LOGIC_VECTOR(5 DOWNTO 0);
   
   -- Declare intermediate signals for referenced outputs
   SIGNAL sel_xhdl2     : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL seg_led_xhdl1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL led_xhdl0     : STD_LOGIC_VECTOR(9 DOWNTO 0);
	
BEGIN
   -- Drive referenced outputs
   sel <= sel_xhdl2;
   seg_led_o <= seg_led_xhdl1;
   led_o <= led_xhdl0;
   
   u0_traffic_light : traffic_light
      PORT MAP (
         sys_clk        => sys_clk,
         sys_rst_n      => sys_rst_n,
         ew_left_time   => ew_left_time,
         ew_stra_time   => ew_stra_time,
         ew_right_time  => ew_right_time,
         sn_left_time   => sn_left_time,
         sn_stra_time   => sn_stra_time,
         sn_right_time  => sn_right_time,
         emergency      => emergency,
         state          => state,
         ew_time        => ew_time,
         sn_time        => sn_time
      );
   
   
   
   u1_key_ctrl : key_ctrl
      PORT MAP (
         sys_clk        => sys_clk,
         sys_rst_n      => sys_rst_n,
         key            => key,
         ew_left_time   => ew_left_time,
         ew_stra_time   => ew_stra_time,
         ew_right_time  => ew_right_time,
         sn_left_time   => sn_left_time,
         sn_stra_time   => sn_stra_time,
         sn_right_time  => sn_right_time
      );
   
   
   
   u2_seg_led : seg_led
      PORT MAP (
         sys_clk    => sys_clk,
         sys_rst_n  => sys_rst_n,
         ew_time    => ew_time,
         sn_time    => sn_time,
         en         => '1',
         sel        => sel_xhdl2,
         seg_led    => seg_led_xhdl1
      );
   
   
   
   u3_led : led
      PORT MAP (
         sys_clk    => sys_clk,
         sys_rst_n  => sys_rst_n,
         state      => state,
         led        => led_xhdl0
      );
   
END top_traffic_behavior;


