----------------------------------------------------------------------
-- Created by Actel SmartDesign Tue Sep 02 14:59:16 2014
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity testbench is
end testbench;

architecture behavioral of testbench is

    constant SYSCLK_PERIOD : time := 100 ns;

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    component repo_test_MSS
        -- ports
        port( 
            -- Inputs
            UART_0_RXD : in std_logic;
            UART_1_RXD : in std_logic;
            SPI_0_DI : in std_logic;
            SPI_1_DI : in std_logic;
            MAC_RXD : in std_logic_vector(1 downto 0);
            MAC_CRSDV : in std_logic;
            MAC_RXER : in std_logic;
            MSS_RESET_N : in std_logic;

            -- Outputs
            FAB_CLK : out std_logic;
            M2F_RESET_N : out std_logic;
            UART_0_TXD : out std_logic;
            UART_1_TXD : out std_logic;
            SPI_0_DO : out std_logic;
            SPI_1_DO : out std_logic;
            EMC_AB : out std_logic_vector(25 downto 0);
            EMC_BYTEN : out std_logic_vector(1 downto 0);
            EMC_CS0_N : out std_logic;
            EMC_CS1_N : out std_logic;
            EMC_OEN0_N : out std_logic;
            EMC_OEN1_N : out std_logic;
            EMC_CLK : out std_logic;
            EMC_RW_N : out std_logic;
            MAC_TXD : out std_logic_vector(1 downto 0);
            MAC_TXEN : out std_logic;
            MAC_MDC : out std_logic;

            -- Inouts
            SPI_0_CLK : inout std_logic;
            SPI_0_SS : inout std_logic;
            SPI_1_CLK : inout std_logic;
            SPI_1_SS : inout std_logic;
            I2C_0_SDA : inout std_logic;
            I2C_0_SCL : inout std_logic;
            I2C_1_SDA : inout std_logic;
            I2C_1_SCL : inout std_logic;
            EMC_DB : inout std_logic_vector(15 downto 0);
            MAC_MDIO : inout std_logic

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

    -- Instantiate Unit Under Test:  repo_test_MSS
    repo_test_MSS_0 : repo_test_MSS
        -- port map
        port map( 
            -- Inputs
            UART_0_RXD => '0',
            UART_1_RXD => '0',
            SPI_0_DI => '0',
            SPI_1_DI => '0',
            MAC_RXD => (others=> '0'),
            MAC_CRSDV => '0',
            MAC_RXER => '0',
            MSS_RESET_N => NSYSRESET,

            -- Outputs
            FAB_CLK =>  open,
            M2F_RESET_N =>  open,
            UART_0_TXD =>  open,
            UART_1_TXD =>  open,
            SPI_0_DO =>  open,
            SPI_1_DO =>  open,
            EMC_AB => open,
            EMC_BYTEN => open,
            EMC_CS0_N =>  open,
            EMC_CS1_N =>  open,
            EMC_OEN0_N =>  open,
            EMC_OEN1_N =>  open,
            EMC_CLK =>  open,
            EMC_RW_N =>  open,
            MAC_TXD => open,
            MAC_TXEN =>  open,
            MAC_MDC =>  open,

            -- Inouts
            SPI_0_CLK =>  open,
            SPI_0_SS =>  open,
            SPI_1_CLK =>  open,
            SPI_1_SS =>  open,
            I2C_0_SDA =>  open,
            I2C_0_SCL =>  open,
            I2C_1_SDA =>  open,
            I2C_1_SCL =>  open,
            EMC_DB => open,
            MAC_MDIO =>  open

        );

end behavioral;

