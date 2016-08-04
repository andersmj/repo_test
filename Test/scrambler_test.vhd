library ieee;
use ieee.std_logic_1164.all;


entity testbench is
end testbench;

architecture behavioral of testbench is


constant SYSCLK_PERIOD : time := 10 ns;

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';
    signal DATA  : std_logic;
    signal DATA_RT  : std_logic;
    signal SYSCLK10M : std_logic;
    signal CLK10M : std_logic;
    signal data_del : std_logic;
    
component SCRAMBLER
        -- ports
        port(RESET             : in std_logic ; -- FPGA Global Reset
	    CLOCK             : in Std_logic ;	-- FPGA System Clock
	    SYNC              : out std_logic;
	    SYNC_RESET        : in std_logic ; -- Synchronous reset of scrambler
	    SCRAMBLER_ENB     : in std_logic ;	-- Disable scrambler pass data transparently
	    DATA_IN           : in std_logic ;	-- Data input, (Data to be Scrambled)
            DATA_OUT          : out std_logic	-- Scrambled data output 
		 ); 
end component;

component DESCRAMBLER
        -- ports
        port(RESET             : in std_logic ; -- FPGA Global Reset
	 CLOCK             : in Std_logic ;	-- FPGA System Clock
	 DATA_IN           : in std_logic ;	-- Data input, (Data to be Scrambled)
	 ERROR_LONG        : out std_logic;
         ERR               : out std_logic;
         ERRCNT            : out std_logic_vector(31 downto 0);
         DATA_OUT          : out std_logic	-- Scrambled data output 
		 ); 
end component;

component RECOVERY  
    port(RESET             : in std_logic ; -- FPGA Global Reset
	 CLOCK80M          : in Std_logic ;	-- FPGA System Clock
	 CLOCK10M          : in std_logic ;     -- recovered 10M clock post buffer
	 DATA_IN           : in std_logic ;	-- Data input,
         DATA_OUT          : out std_logic ;
         CLOCK_OUT         : out std_logic	-- Scrambled data output 
		 );
end component;

component clkgen  
    port(RESET             : in std_logic ; -- FPGA Global Reset
	 CLOCK80M          : in Std_logic ;	-- FPGA System Clock
         CLOCK_OUT         : out std_logic	-- Scrambled data output 
		 );
end component;

begin

    process
        variable vhdl_initial : BOOLEAN := TRUE;

    begin
        if ( vhdl_initial ) then
            -- Assert Reset
            NSYSRESET <= '0';
            wait for ( SYSCLK_PERIOD * 10 );
            
            NSYSRESET <= '1';
            wait;
        end if;
    end process;

    -- 10MHz Clock Driver
    SYSCLK <= not SYSCLK after (SYSCLK_PERIOD / 2.0 );

-- Instantiate units under test

scram : SCRAMBLER
PORT MAP(RESET             => NSYSRESET, -- FPGA Global Reset
	 CLOCK             => SYSCLK10M,	-- FPGA System Clock
	 SYNC              => open,
	 SYNC_RESET        => '0', -- Synchronous reset of scrambler
	 SCRAMBLER_ENB     => '1',	-- Disable scrambler pass data transparently
	 DATA_IN           => '0',	-- Data input, (Data to be Scrambled)
         DATA_OUT          => DATA
         );
 
data_del <= transport DATA after 150 ns;
        
descram : DESCRAMBLER
PORT MAP(RESET             => NSYSRESET, -- FPGA Global Reset
	 CLOCK             => CLK10M,	-- FPGA System Clock
	 DATA_IN           => DATA_RT,
	 ERROR_LONG        => open,
         ERR               => open,
         ERRCNT            => open,
	 DATA_OUT          => OPEN
	 );
	 
rec : RECOVERY  
port map(RESET             => NSYSRESET, -- FPGA Global Reset
	 CLOCK80M          => SYSCLK,	-- FPGA System Clock
	 CLOCK10M          => CLK10M,     -- recovered 10M clock post buffer
	 DATA_IN           => data_del,	-- Data input,
         DATA_OUT          => DATA_RT,
         CLOCK_OUT         => CLK10M	-- Scrambled data output 
		 );


clkgen_0 : clkgen  
port map(RESET             => NSYSRESET, -- FPGA Global Reset
	       CLOCK80M          => SYSCLK,	-- FPGA System Clock
         CLOCK_OUT         => SYSCLK10M	-- Scrambled data output 
		     );
	 
end behavioral;

    
