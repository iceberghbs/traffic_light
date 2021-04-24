LIBRARY ieee;
   USE IEEE.STD_LOGIC_1164.ALL;
   USE IEEE.STD_LOGIC_UNSIGNED.ALL;
   USE IEEE.STD_LOGIC_ARITH.ALL;
	
ENTITY top_traffic_sim IS
END top_traffic_sim;

architecture behavior of top_traffic_sim is

	COMPONENT top_traffic IS
	   PORT (
		  sys_clk    : IN STD_LOGIC;
		  sys_rst_n  : IN STD_LOGIC;
		  emergency  : IN STD_LOGIC;
		  key        : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		  
		  sel        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		  seg_led_o    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		  led_o        : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	   );
	END  COMPONENT;
	
	SIGNAL sys_clk    : STD_LOGIC := '0';
	SIGNAL sys_rst_n  : STD_LOGIC := '0';
	SIGNAL emergency  : STD_LOGIC := '0';	
	SIGNAL key        : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
	
	SIGNAL sel        : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL seg_led_o  : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL led_o      : STD_LOGIC_VECTOR(9 DOWNTO 0);

    BEGIN
	
    u0_top_traffic : top_traffic
      PORT MAP (
         sys_clk        => sys_clk,
         sys_rst_n      => sys_rst_n,
         emergency      => emergency,
         key            => key,
         sel            => sel,
         seg_led_o      => seg_led_o,
         led_o          => led_o
      );
	
    clk_gen : PROCESS
	BEGIN
		WAIT FOR 10ns;
		sys_clk <= '1';
		WAIT FOR 10ns;
		sys_clk <= '0';		
	END PROCESS;
	
	rst_gen : PROCESS
	BEGIN
		WAIT FOR 40ns;
        sys_rst_n <= '1';	    
	END PROCESS;
	
	--emergency_gen : PROCESS
	--BEGIN
	--    WAIT FOR 100000ns;
	--	emergency <= '1';
	--	WAIT FOR 500000ns;
	--	emergency <= '0';
    --    WAIT;		
	--END PROCESS;

	key_gen : PROCESS
	BEGIN
		WAIT FOR 5000000ns;
        key <= "100000000000";
 		WAIT FOR 5000ns; 
		key <= "000000000000";
		WAIT;
	END PROCESS;
END behavior;
	

