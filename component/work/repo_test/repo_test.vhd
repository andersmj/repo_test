----------------------------------------------------------------------
-- Created by SmartDesign Tue Sep 02 15:12:11 2014
-- Version: v11.3 11.3.0.112
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion;
use smartfusion.all;
----------------------------------------------------------------------
-- repo_test entity declaration
----------------------------------------------------------------------
entity repo_test is
    -- Port list
    port(
        -- Inputs
        MAC_CRSDV   : in    std_logic;
        MAC_RXD     : in    std_logic_vector(1 downto 0);
        MAC_RXER    : in    std_logic;
        MSS_RESET_N : in    std_logic;
        SPI_0_DI    : in    std_logic;
        SPI_1_DI    : in    std_logic;
        SW1         : in    std_logic;
        SW2         : in    std_logic;
        UART_0_RXD  : in    std_logic;
        UART_1_RXD  : in    std_logic;
        -- Outputs
        COUNT       : out   std_logic_vector(7 downto 0);
        EMC_AB      : out   std_logic_vector(25 downto 0);
        EMC_BYTEN   : out   std_logic_vector(1 downto 0);
        EMC_CLK     : out   std_logic;
        EMC_CS0_N   : out   std_logic;
        EMC_CS1_N   : out   std_logic;
        EMC_OEN0_N  : out   std_logic;
        EMC_OEN1_N  : out   std_logic;
        EMC_RW_N    : out   std_logic;
        MAC_MDC     : out   std_logic;
        MAC_TXD     : out   std_logic_vector(1 downto 0);
        MAC_TXEN    : out   std_logic;
        SPI_0_DO    : out   std_logic;
        SPI_1_DO    : out   std_logic;
        UART_0_TXD  : out   std_logic;
        UART_1_TXD  : out   std_logic;
        -- Inouts
        EMC_DB      : inout std_logic_vector(15 downto 0);
        I2C_0_SCL   : inout std_logic;
        I2C_0_SDA   : inout std_logic;
        I2C_1_SCL   : inout std_logic;
        I2C_1_SDA   : inout std_logic;
        MAC_MDIO    : inout std_logic;
        SPI_0_CLK   : inout std_logic;
        SPI_0_SS    : inout std_logic;
        SPI_1_CLK   : inout std_logic;
        SPI_1_SS    : inout std_logic
        );
end repo_test;
----------------------------------------------------------------------
-- repo_test architecture body
----------------------------------------------------------------------
architecture RTL of repo_test is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- clkdiv
component clkdiv
    -- Port list
    port(
        -- Inputs
        FAB_CLK     : in  std_logic;
        M2F_RESET_N : in  std_logic;
        -- Outputs
        CLK10H      : out std_logic
        );
end component;
-- CLKINT
component CLKINT
    -- Port list
    port(
        -- Inputs
        A : in  std_logic;
        -- Outputs
        Y : out std_logic
        );
end component;
-- Counter
component Counter
    -- Port list
    port(
        -- Inputs
        CLK10H      : in  std_logic;
        M2F_RESET_N : in  std_logic;
        SW1         : in  std_logic;
        SW2         : in  std_logic;
        -- Outputs
        COUNT       : out std_logic_vector(7 downto 0)
        );
end component;
-- repo_test_MSS
component repo_test_MSS
    -- Port list
    port(
        -- Inputs
        MAC_CRSDV   : in    std_logic;
        MAC_RXD     : in    std_logic_vector(1 downto 0);
        MAC_RXER    : in    std_logic;
        MSS_RESET_N : in    std_logic;
        SPI_0_DI    : in    std_logic;
        SPI_1_DI    : in    std_logic;
        UART_0_RXD  : in    std_logic;
        UART_1_RXD  : in    std_logic;
        -- Outputs
        EMC_AB      : out   std_logic_vector(25 downto 0);
        EMC_BYTEN   : out   std_logic_vector(1 downto 0);
        EMC_CLK     : out   std_logic;
        EMC_CS0_N   : out   std_logic;
        EMC_CS1_N   : out   std_logic;
        EMC_OEN0_N  : out   std_logic;
        EMC_OEN1_N  : out   std_logic;
        EMC_RW_N    : out   std_logic;
        FAB_CLK     : out   std_logic;
        M2F_RESET_N : out   std_logic;
        MAC_MDC     : out   std_logic;
        MAC_TXD     : out   std_logic_vector(1 downto 0);
        MAC_TXEN    : out   std_logic;
        SPI_0_DO    : out   std_logic;
        SPI_1_DO    : out   std_logic;
        UART_0_TXD  : out   std_logic;
        UART_1_TXD  : out   std_logic;
        -- Inouts
        EMC_DB      : inout std_logic_vector(15 downto 0);
        I2C_0_SCL   : inout std_logic;
        I2C_0_SDA   : inout std_logic;
        I2C_1_SCL   : inout std_logic;
        I2C_1_SDA   : inout std_logic;
        MAC_MDIO    : inout std_logic;
        SPI_0_CLK   : inout std_logic;
        SPI_0_SS    : inout std_logic;
        SPI_1_CLK   : inout std_logic;
        SPI_1_SS    : inout std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal clkdiv_0_CLK10H             : std_logic;
signal CLKINT_0_Y                  : std_logic;
signal CLKINT_1_Y                  : std_logic;
signal COUNT_net_0                 : std_logic_vector(7 downto 0);
signal EMC_AB_net_0                : std_logic_vector(25 downto 0);
signal EMC_BYTEN_net_0             : std_logic_vector(1 downto 0);
signal EMC_CLK_net_0               : std_logic;
signal EMC_CS0_N_net_0             : std_logic;
signal EMC_CS1_N_net_0             : std_logic;
signal EMC_OEN0_N_net_0            : std_logic;
signal EMC_OEN1_N_net_0            : std_logic;
signal EMC_RW_N_net_0              : std_logic;
signal MAC_MDC_net_0               : std_logic;
signal MAC_TXD_net_0               : std_logic_vector(1 downto 0);
signal MAC_TXEN_net_0              : std_logic;
signal repo_test_MSS_0_FAB_CLK     : std_logic;
signal repo_test_MSS_0_M2F_RESET_N : std_logic;
signal SPI_0_DO_net_0              : std_logic;
signal SPI_1_DO_net_0              : std_logic;
signal UART_0_TXD_net_0            : std_logic;
signal UART_1_TXD_net_0            : std_logic;
signal EMC_CLK_net_1               : std_logic;
signal EMC_CS0_N_net_1             : std_logic;
signal EMC_CS1_N_net_1             : std_logic;
signal EMC_OEN0_N_net_1            : std_logic;
signal EMC_OEN1_N_net_1            : std_logic;
signal EMC_RW_N_net_1              : std_logic;
signal EMC_AB_net_1                : std_logic_vector(25 downto 0);
signal EMC_BYTEN_net_1             : std_logic_vector(1 downto 0);
signal UART_1_TXD_net_1            : std_logic;
signal UART_0_TXD_net_1            : std_logic;
signal SPI_1_DO_net_1              : std_logic;
signal SPI_0_DO_net_1              : std_logic;
signal MAC_MDC_net_1               : std_logic;
signal MAC_TXD_net_1               : std_logic_vector(1 downto 0);
signal MAC_TXEN_net_1              : std_logic;
signal COUNT_net_1                 : std_logic_vector(7 downto 0);

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 EMC_CLK_net_1         <= EMC_CLK_net_0;
 EMC_CLK               <= EMC_CLK_net_1;
 EMC_CS0_N_net_1       <= EMC_CS0_N_net_0;
 EMC_CS0_N             <= EMC_CS0_N_net_1;
 EMC_CS1_N_net_1       <= EMC_CS1_N_net_0;
 EMC_CS1_N             <= EMC_CS1_N_net_1;
 EMC_OEN0_N_net_1      <= EMC_OEN0_N_net_0;
 EMC_OEN0_N            <= EMC_OEN0_N_net_1;
 EMC_OEN1_N_net_1      <= EMC_OEN1_N_net_0;
 EMC_OEN1_N            <= EMC_OEN1_N_net_1;
 EMC_RW_N_net_1        <= EMC_RW_N_net_0;
 EMC_RW_N              <= EMC_RW_N_net_1;
 EMC_AB_net_1          <= EMC_AB_net_0;
 EMC_AB(25 downto 0)   <= EMC_AB_net_1;
 EMC_BYTEN_net_1       <= EMC_BYTEN_net_0;
 EMC_BYTEN(1 downto 0) <= EMC_BYTEN_net_1;
 UART_1_TXD_net_1      <= UART_1_TXD_net_0;
 UART_1_TXD            <= UART_1_TXD_net_1;
 UART_0_TXD_net_1      <= UART_0_TXD_net_0;
 UART_0_TXD            <= UART_0_TXD_net_1;
 SPI_1_DO_net_1        <= SPI_1_DO_net_0;
 SPI_1_DO              <= SPI_1_DO_net_1;
 SPI_0_DO_net_1        <= SPI_0_DO_net_0;
 SPI_0_DO              <= SPI_0_DO_net_1;
 MAC_MDC_net_1         <= MAC_MDC_net_0;
 MAC_MDC               <= MAC_MDC_net_1;
 MAC_TXD_net_1         <= MAC_TXD_net_0;
 MAC_TXD(1 downto 0)   <= MAC_TXD_net_1;
 MAC_TXEN_net_1        <= MAC_TXEN_net_0;
 MAC_TXEN              <= MAC_TXEN_net_1;
 COUNT_net_1           <= COUNT_net_0;
 COUNT(7 downto 0)     <= COUNT_net_1;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- clkdiv_0
clkdiv_0 : clkdiv
    port map( 
        -- Inputs
        M2F_RESET_N => CLKINT_1_Y,
        FAB_CLK     => repo_test_MSS_0_FAB_CLK,
        -- Outputs
        CLK10H      => clkdiv_0_CLK10H 
        );
-- CLKINT_0
CLKINT_0 : CLKINT
    port map( 
        -- Inputs
        A => clkdiv_0_CLK10H,
        -- Outputs
        Y => CLKINT_0_Y 
        );
-- CLKINT_1
CLKINT_1 : CLKINT
    port map( 
        -- Inputs
        A => repo_test_MSS_0_M2F_RESET_N,
        -- Outputs
        Y => CLKINT_1_Y 
        );
-- Counter_0
Counter_0 : Counter
    port map( 
        -- Inputs
        M2F_RESET_N => CLKINT_1_Y,
        CLK10H      => CLKINT_0_Y,
        SW1         => SW1,
        SW2         => SW2,
        -- Outputs
        COUNT       => COUNT_net_0 
        );
-- repo_test_MSS_0
repo_test_MSS_0 : repo_test_MSS
    port map( 
        -- Inputs
        UART_0_RXD  => UART_0_RXD,
        UART_1_RXD  => UART_1_RXD,
        SPI_1_DI    => SPI_1_DI,
        SPI_0_DI    => SPI_0_DI,
        MSS_RESET_N => MSS_RESET_N,
        MAC_CRSDV   => MAC_CRSDV,
        MAC_RXER    => MAC_RXER,
        MAC_RXD     => MAC_RXD,
        -- Outputs
        EMC_CLK     => EMC_CLK_net_0,
        EMC_CS0_N   => EMC_CS0_N_net_0,
        EMC_CS1_N   => EMC_CS1_N_net_0,
        EMC_OEN0_N  => EMC_OEN0_N_net_0,
        EMC_OEN1_N  => EMC_OEN1_N_net_0,
        EMC_RW_N    => EMC_RW_N_net_0,
        UART_0_TXD  => UART_0_TXD_net_0,
        UART_1_TXD  => UART_1_TXD_net_0,
        SPI_1_DO    => SPI_1_DO_net_0,
        SPI_0_DO    => SPI_0_DO_net_0,
        MAC_TXEN    => MAC_TXEN_net_0,
        MAC_MDC     => MAC_MDC_net_0,
        EMC_AB      => EMC_AB_net_0,
        EMC_BYTEN   => EMC_BYTEN_net_0,
        MAC_TXD     => MAC_TXD_net_0,
        FAB_CLK     => repo_test_MSS_0_FAB_CLK,
        M2F_RESET_N => repo_test_MSS_0_M2F_RESET_N,
        -- Inouts
        I2C_1_SDA   => I2C_1_SDA,
        I2C_1_SCL   => I2C_1_SCL,
        SPI_1_CLK   => SPI_1_CLK,
        SPI_1_SS    => SPI_1_SS,
        SPI_0_CLK   => SPI_0_CLK,
        SPI_0_SS    => SPI_0_SS,
        I2C_0_SCL   => I2C_0_SCL,
        I2C_0_SDA   => I2C_0_SDA,
        MAC_MDIO    => MAC_MDIO,
        EMC_DB      => EMC_DB 
        );

end RTL;
