----------------------------------------------------------------------
-- Created by SmartDesign Tue Sep 02 14:59:15 2014
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
-- repo_test_MSS entity declaration
----------------------------------------------------------------------
entity repo_test_MSS is
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
end repo_test_MSS;
----------------------------------------------------------------------
-- repo_test_MSS architecture body
----------------------------------------------------------------------
architecture RTL of repo_test_MSS is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- MSS_APB
component MSS_APB
    generic( 
        ACT_CONFIG : integer := 0 ;
        ACT_FCLK   : integer := 0 ;
        ACT_DIE    : string  := "" ;
        ACT_PKG    : string  := "" 
        );
    -- Port list
    port(
        -- Inputs
        ABPS0          : in  std_logic;
        ABPS1          : in  std_logic;
        ABPS10         : in  std_logic;
        ABPS11         : in  std_logic;
        ABPS2          : in  std_logic;
        ABPS3          : in  std_logic;
        ABPS4          : in  std_logic;
        ABPS5          : in  std_logic;
        ABPS6          : in  std_logic;
        ABPS7          : in  std_logic;
        ABPS8          : in  std_logic;
        ABPS9          : in  std_logic;
        ADC0           : in  std_logic;
        ADC1           : in  std_logic;
        ADC10          : in  std_logic;
        ADC11          : in  std_logic;
        ADC2           : in  std_logic;
        ADC3           : in  std_logic;
        ADC4           : in  std_logic;
        ADC5           : in  std_logic;
        ADC6           : in  std_logic;
        ADC7           : in  std_logic;
        ADC8           : in  std_logic;
        ADC9           : in  std_logic;
        CALIBIN        : in  std_logic;
        CM0            : in  std_logic;
        CM1            : in  std_logic;
        CM2            : in  std_logic;
        CM3            : in  std_logic;
        CM4            : in  std_logic;
        CM5            : in  std_logic;
        DMAREADY       : in  std_logic_vector(1 downto 0);
        EMCCLKRTN      : in  std_logic;
        EMCRDB         : in  std_logic_vector(15 downto 0);
        F2MRESETn      : in  std_logic;
        FABACETRIG     : in  std_logic;
        FABINT         : in  std_logic;
        FABPADDR       : in  std_logic_vector(31 downto 0);
        FABPENABLE     : in  std_logic;
        FABPSEL        : in  std_logic;
        FABPWDATA      : in  std_logic_vector(31 downto 0);
        FABPWRITE      : in  std_logic;
        FABSDD0CLK     : in  std_logic;
        FABSDD0D       : in  std_logic;
        FABSDD1CLK     : in  std_logic;
        FABSDD1D       : in  std_logic;
        FABSDD2CLK     : in  std_logic;
        FABSDD2D       : in  std_logic;
        FCLK           : in  std_logic;
        GNDTM0         : in  std_logic;
        GNDTM1         : in  std_logic;
        GNDTM2         : in  std_logic;
        GNDVAREF       : in  std_logic;
        GPI            : in  std_logic_vector(31 downto 0);
        I2C0BCLK       : in  std_logic;
        I2C0SCLI       : in  std_logic;
        I2C0SDAI       : in  std_logic;
        I2C0SMBALERTNI : in  std_logic;
        I2C0SMBUSNI    : in  std_logic;
        I2C1BCLK       : in  std_logic;
        I2C1SCLI       : in  std_logic;
        I2C1SDAI       : in  std_logic;
        I2C1SMBALERTNI : in  std_logic;
        I2C1SMBUSNI    : in  std_logic;
        LVTTL0EN       : in  std_logic;
        LVTTL10EN      : in  std_logic;
        LVTTL11EN      : in  std_logic;
        LVTTL1EN       : in  std_logic;
        LVTTL2EN       : in  std_logic;
        LVTTL3EN       : in  std_logic;
        LVTTL4EN       : in  std_logic;
        LVTTL5EN       : in  std_logic;
        LVTTL6EN       : in  std_logic;
        LVTTL7EN       : in  std_logic;
        LVTTL8EN       : in  std_logic;
        LVTTL9EN       : in  std_logic;
        MACCLK         : in  std_logic;
        MACCLKCCC      : in  std_logic;
        MACCRSDV       : in  std_logic;
        MACF2MCRSDV    : in  std_logic;
        MACF2MMDI      : in  std_logic;
        MACF2MRXD      : in  std_logic_vector(1 downto 0);
        MACF2MRXER     : in  std_logic;
        MACMDI         : in  std_logic;
        MACRXD         : in  std_logic_vector(1 downto 0);
        MACRXER        : in  std_logic;
        MSSPRDATA      : in  std_logic_vector(31 downto 0);
        MSSPREADY      : in  std_logic;
        MSSPSLVERR     : in  std_logic;
        MSSRESETn      : in  std_logic;
        PLLLOCK        : in  std_logic;
        PUn            : in  std_logic;
        RCOSC          : in  std_logic;
        RXEV           : in  std_logic;
        SPI0CLKI       : in  std_logic;
        SPI0DI         : in  std_logic;
        SPI0SSI        : in  std_logic;
        SPI1CLKI       : in  std_logic;
        SPI1DI         : in  std_logic;
        SPI1SSI        : in  std_logic;
        SYNCCLKFDBK    : in  std_logic;
        TM0            : in  std_logic;
        TM1            : in  std_logic;
        TM2            : in  std_logic;
        TM3            : in  std_logic;
        TM4            : in  std_logic;
        TM5            : in  std_logic;
        UART0CTSn      : in  std_logic;
        UART0DCDn      : in  std_logic;
        UART0DSRn      : in  std_logic;
        UART0RIn       : in  std_logic;
        UART0RXD       : in  std_logic;
        UART1CTSn      : in  std_logic;
        UART1DCDn      : in  std_logic;
        UART1DSRn      : in  std_logic;
        UART1RIn       : in  std_logic;
        UART1RXD       : in  std_logic;
        VAREF0         : in  std_logic;
        VAREF1         : in  std_logic;
        VAREF2         : in  std_logic;
        VRON           : in  std_logic;
        -- Outputs
        ACEFLAGS       : out std_logic_vector(31 downto 0);
        CALIBOUT       : out std_logic;
        CMP0           : out std_logic;
        CMP1           : out std_logic;
        CMP10          : out std_logic;
        CMP11          : out std_logic;
        CMP2           : out std_logic;
        CMP3           : out std_logic;
        CMP4           : out std_logic;
        CMP5           : out std_logic;
        CMP6           : out std_logic;
        CMP7           : out std_logic;
        CMP8           : out std_logic;
        CMP9           : out std_logic;
        DEEPSLEEP      : out std_logic;
        EMCAB          : out std_logic_vector(25 downto 0);
        EMCBYTEN       : out std_logic_vector(1 downto 0);
        EMCCLK         : out std_logic;
        EMCCS0n        : out std_logic;
        EMCCS1n        : out std_logic;
        EMCDBOE        : out std_logic;
        EMCOEN0n       : out std_logic;
        EMCOEN1n       : out std_logic;
        EMCRWn         : out std_logic;
        EMCWDB         : out std_logic_vector(15 downto 0);
        FABPRDATA      : out std_logic_vector(31 downto 0);
        FABPREADY      : out std_logic;
        FABPSLVERR     : out std_logic;
        GPO            : out std_logic_vector(31 downto 0);
        GPOE           : out std_logic_vector(31 downto 0);
        I2C0SCLO       : out std_logic;
        I2C0SDAO       : out std_logic;
        I2C0SMBALERTNO : out std_logic;
        I2C0SMBUSNO    : out std_logic;
        I2C1SCLO       : out std_logic;
        I2C1SDAO       : out std_logic;
        I2C1SMBALERTNO : out std_logic;
        I2C1SMBUSNO    : out std_logic;
        LVTTL0         : out std_logic;
        LVTTL1         : out std_logic;
        LVTTL10        : out std_logic;
        LVTTL11        : out std_logic;
        LVTTL2         : out std_logic;
        LVTTL3         : out std_logic;
        LVTTL4         : out std_logic;
        LVTTL5         : out std_logic;
        LVTTL6         : out std_logic;
        LVTTL7         : out std_logic;
        LVTTL8         : out std_logic;
        LVTTL9         : out std_logic;
        M2FRESETn      : out std_logic;
        MACM2FMDC      : out std_logic;
        MACM2FMDEN     : out std_logic;
        MACM2FMDO      : out std_logic;
        MACM2FTXD      : out std_logic_vector(1 downto 0);
        MACM2FTXEN     : out std_logic;
        MACMDC         : out std_logic;
        MACMDEN        : out std_logic;
        MACMDO         : out std_logic;
        MACTXD         : out std_logic_vector(1 downto 0);
        MACTXEN        : out std_logic;
        MSSINT         : out std_logic_vector(7 downto 0);
        MSSPADDR       : out std_logic_vector(19 downto 0);
        MSSPENABLE     : out std_logic;
        MSSPSEL        : out std_logic;
        MSSPWDATA      : out std_logic_vector(31 downto 0);
        MSSPWRITE      : out std_logic;
        PUFABn         : out std_logic;
        SDD0           : out std_logic;
        SDD1           : out std_logic;
        SDD2           : out std_logic;
        SLEEP          : out std_logic;
        SPI0CLKO       : out std_logic;
        SPI0DO         : out std_logic;
        SPI0DOE        : out std_logic;
        SPI0MODE       : out std_logic;
        SPI0SSO        : out std_logic_vector(7 downto 0);
        SPI1CLKO       : out std_logic;
        SPI1DO         : out std_logic;
        SPI1DOE        : out std_logic;
        SPI1MODE       : out std_logic;
        SPI1SSO        : out std_logic_vector(7 downto 0);
        TXEV           : out std_logic;
        UART0DTRn      : out std_logic;
        UART0RTSn      : out std_logic;
        UART0TXD       : out std_logic;
        UART1DTRn      : out std_logic;
        UART1RTSn      : out std_logic;
        UART1TXD       : out std_logic;
        VAREFOUT       : out std_logic;
        VCC15GOOD      : out std_logic;
        VCC33GOOD      : out std_logic;
        WDINT          : out std_logic
        );
end component;
-- repo_test_MSS_tmp_MSS_CCC_0_MSS_CCC   -   Actel:SmartFusionMSS:MSS_CCC:2.0.106
component repo_test_MSS_tmp_MSS_CCC_0_MSS_CCC
    -- Port list
    port(
        -- Inputs
        CLKA           : in  std_logic;
        CLKA_PAD       : in  std_logic;
        CLKA_PADN      : in  std_logic;
        CLKA_PADP      : in  std_logic;
        CLKB           : in  std_logic;
        CLKB_PAD       : in  std_logic;
        CLKB_PADN      : in  std_logic;
        CLKB_PADP      : in  std_logic;
        CLKC           : in  std_logic;
        CLKC_PAD       : in  std_logic;
        CLKC_PADN      : in  std_logic;
        CLKC_PADP      : in  std_logic;
        LPXIN          : in  std_logic;
        MAC_CLK        : in  std_logic;
        MAINXIN        : in  std_logic;
        -- Outputs
        FAB_CLK        : out std_logic;
        FAB_LOCK       : out std_logic;
        GLA            : out std_logic;
        GLA0           : out std_logic;
        GLB            : out std_logic;
        GLC            : out std_logic;
        LPXIN_CLKOUT   : out std_logic;
        MAC_CLK_CCC    : out std_logic;
        MAC_CLK_IO     : out std_logic;
        MAINXIN_CLKOUT : out std_logic;
        MSS_LOCK       : out std_logic;
        RCOSC_CLKOUT   : out std_logic;
        YB             : out std_logic;
        YC             : out std_logic
        );
end component;
-- OUTBUF_MSS
component OUTBUF_MSS
    generic( 
        ACT_CONFIG : integer := 0 ;
        ACT_PIN    : string  := "NA" 
        );
    -- Port list
    port(
        -- Inputs
        D   : in  std_logic;
        -- Outputs
        PAD : out std_logic
        );
end component;
-- BIBUF_MSS
component BIBUF_MSS
    generic( 
        ACT_CONFIG : integer := 0 ;
        ACT_PIN    : string  := "NA" 
        );
    -- Port list
    port(
        -- Inputs
        D   : in    std_logic;
        E   : in    std_logic;
        -- Outputs
        Y   : out   std_logic;
        -- Inouts
        PAD : inout std_logic
        );
end component;
-- BIBUF_OPEND_MSS
component BIBUF_OPEND_MSS
    generic( 
        ACT_CONFIG : integer := 0 ;
        ACT_PIN    : string  := "NA" 
        );
    -- Port list
    port(
        -- Inputs
        E   : in    std_logic;
        -- Outputs
        Y   : out   std_logic;
        -- Inouts
        PAD : inout std_logic
        );
end component;
-- INBUF_MSS
component INBUF_MSS
    generic( 
        ACT_CONFIG : integer := 0 ;
        ACT_PIN    : string  := "NA" 
        );
    -- Port list
    port(
        -- Inputs
        PAD : in  std_logic;
        -- Outputs
        Y   : out std_logic
        );
end component;
-- TRIBUFF_MSS
component TRIBUFF_MSS
    generic( 
        ACT_CONFIG : integer := 0 ;
        ACT_PIN    : string  := "NA" 
        );
    -- Port list
    port(
        -- Inputs
        D   : in  std_logic;
        E   : in  std_logic;
        -- Outputs
        PAD : out std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal DSSGEN_EMC_AB_0                  : std_logic;
signal DSSGEN_EMC_AB_1                  : std_logic;
signal DSSGEN_EMC_AB_2                  : std_logic;
signal DSSGEN_EMC_AB_3                  : std_logic;
signal DSSGEN_EMC_AB_4                  : std_logic;
signal DSSGEN_EMC_AB_5                  : std_logic;
signal DSSGEN_EMC_AB_6                  : std_logic;
signal DSSGEN_EMC_AB_7                  : std_logic;
signal DSSGEN_EMC_AB_8                  : std_logic;
signal DSSGEN_EMC_AB_9                  : std_logic;
signal DSSGEN_EMC_AB_10                 : std_logic;
signal DSSGEN_EMC_AB_11                 : std_logic;
signal DSSGEN_EMC_AB_12                 : std_logic;
signal DSSGEN_EMC_AB_13                 : std_logic;
signal DSSGEN_EMC_AB_14                 : std_logic;
signal DSSGEN_EMC_AB_15                 : std_logic;
signal DSSGEN_EMC_AB_16                 : std_logic;
signal DSSGEN_EMC_AB_17                 : std_logic;
signal DSSGEN_EMC_AB_18                 : std_logic;
signal DSSGEN_EMC_AB_19                 : std_logic;
signal DSSGEN_EMC_AB_20                 : std_logic;
signal DSSGEN_EMC_AB_21                 : std_logic;
signal DSSGEN_EMC_AB_22                 : std_logic;
signal DSSGEN_EMC_AB_23                 : std_logic;
signal DSSGEN_EMC_AB_24                 : std_logic;
signal DSSGEN_EMC_AB_25                 : std_logic;
signal DSSGEN_EMC_BYTEN_0               : std_logic;
signal DSSGEN_EMC_BYTEN_1               : std_logic;
signal MAC_RXD_slice_0                  : std_logic_vector(0 to 0);
signal MAC_RXD_slice_1                  : std_logic_vector(1 to 1);
signal DSSGEN_MAC_TXD_0                 : std_logic;
signal DSSGEN_MAC_TXD_1                 : std_logic;
signal EMC_CLK_net_0                    : std_logic;
signal EMC_CS0_N_net_0                  : std_logic;
signal EMC_CS1_N_net_0                  : std_logic;
signal EMC_OEN0_N_net_0                 : std_logic;
signal EMC_OEN1_N_net_0                 : std_logic;
signal EMC_RW_N_net_0                   : std_logic;
signal MSS_ADLIB_INST_FCLK              : std_logic;
signal MSS_ADLIB_INST_MACCLK            : std_logic;
signal MSS_ADLIB_INST_MACCLKCCC         : std_logic;
signal MSS_ADLIB_INST_PLLLOCK           : std_logic;
signal MSS_ADLIB_INST_SYNCCLKFDBK       : std_logic;
signal MSS_EMI_0_AB_0_D                 : std_logic_vector(0 to 0);
signal MSS_EMI_0_AB_1_D                 : std_logic_vector(1 to 1);
signal MSS_EMI_0_AB_2_D                 : std_logic_vector(2 to 2);
signal MSS_EMI_0_AB_3_D                 : std_logic_vector(3 to 3);
signal MSS_EMI_0_AB_4_D                 : std_logic_vector(4 to 4);
signal MSS_EMI_0_AB_5_D                 : std_logic_vector(5 to 5);
signal MSS_EMI_0_AB_6_D                 : std_logic_vector(6 to 6);
signal MSS_EMI_0_AB_7_D                 : std_logic_vector(7 to 7);
signal MSS_EMI_0_AB_8_D                 : std_logic_vector(8 to 8);
signal MSS_EMI_0_AB_9_D                 : std_logic_vector(9 to 9);
signal MSS_EMI_0_AB_10_D                : std_logic_vector(10 to 10);
signal MSS_EMI_0_AB_11_D                : std_logic_vector(11 to 11);
signal MSS_EMI_0_AB_12_D                : std_logic_vector(12 to 12);
signal MSS_EMI_0_AB_13_D                : std_logic_vector(13 to 13);
signal MSS_EMI_0_AB_14_D                : std_logic_vector(14 to 14);
signal MSS_EMI_0_AB_15_D                : std_logic_vector(15 to 15);
signal MSS_EMI_0_AB_16_D                : std_logic_vector(16 to 16);
signal MSS_EMI_0_AB_17_D                : std_logic_vector(17 to 17);
signal MSS_EMI_0_AB_18_D                : std_logic_vector(18 to 18);
signal MSS_EMI_0_AB_19_D                : std_logic_vector(19 to 19);
signal MSS_EMI_0_AB_20_D                : std_logic_vector(20 to 20);
signal MSS_EMI_0_AB_21_D                : std_logic_vector(21 to 21);
signal MSS_EMI_0_AB_22_D                : std_logic_vector(22 to 22);
signal MSS_EMI_0_AB_23_D                : std_logic_vector(23 to 23);
signal MSS_EMI_0_AB_24_D                : std_logic_vector(24 to 24);
signal MSS_EMI_0_AB_25_D                : std_logic_vector(25 to 25);
signal MSS_EMI_0_BYTEN_0_D              : std_logic_vector(0 to 0);
signal MSS_EMI_0_BYTEN_1_D              : std_logic_vector(1 to 1);
signal MSS_EMI_0_CLK_D                  : std_logic;
signal MSS_EMI_0_CS0_N_D                : std_logic;
signal MSS_EMI_0_CS1_N_D                : std_logic;
signal MSS_EMI_0_DB_0_D                 : std_logic_vector(0 to 0);
signal MSS_EMI_0_DB_0_Y                 : std_logic;
signal MSS_EMI_0_DB_1_D                 : std_logic_vector(1 to 1);
signal MSS_EMI_0_DB_1_Y                 : std_logic;
signal MSS_EMI_0_DB_2_D                 : std_logic_vector(2 to 2);
signal MSS_EMI_0_DB_2_Y                 : std_logic;
signal MSS_EMI_0_DB_3_D                 : std_logic_vector(3 to 3);
signal MSS_EMI_0_DB_3_Y                 : std_logic;
signal MSS_EMI_0_DB_4_D                 : std_logic_vector(4 to 4);
signal MSS_EMI_0_DB_4_Y                 : std_logic;
signal MSS_EMI_0_DB_5_D                 : std_logic_vector(5 to 5);
signal MSS_EMI_0_DB_5_Y                 : std_logic;
signal MSS_EMI_0_DB_6_D                 : std_logic_vector(6 to 6);
signal MSS_EMI_0_DB_6_Y                 : std_logic;
signal MSS_EMI_0_DB_7_D                 : std_logic_vector(7 to 7);
signal MSS_EMI_0_DB_7_Y                 : std_logic;
signal MSS_EMI_0_DB_8_D                 : std_logic_vector(8 to 8);
signal MSS_EMI_0_DB_8_Y                 : std_logic;
signal MSS_EMI_0_DB_9_D                 : std_logic_vector(9 to 9);
signal MSS_EMI_0_DB_9_Y                 : std_logic;
signal MSS_EMI_0_DB_10_D                : std_logic_vector(10 to 10);
signal MSS_EMI_0_DB_10_Y                : std_logic;
signal MSS_EMI_0_DB_11_D                : std_logic_vector(11 to 11);
signal MSS_EMI_0_DB_11_Y                : std_logic;
signal MSS_EMI_0_DB_12_D                : std_logic_vector(12 to 12);
signal MSS_EMI_0_DB_12_Y                : std_logic;
signal MSS_EMI_0_DB_13_D                : std_logic_vector(13 to 13);
signal MSS_EMI_0_DB_13_Y                : std_logic;
signal MSS_EMI_0_DB_14_D                : std_logic_vector(14 to 14);
signal MSS_EMI_0_DB_14_Y                : std_logic;
signal MSS_EMI_0_DB_15_D                : std_logic_vector(15 to 15);
signal MSS_EMI_0_DB_15_E                : std_logic;
signal MSS_EMI_0_DB_15_Y                : std_logic;
signal MSS_EMI_0_OEN0_N_D               : std_logic;
signal MSS_EMI_0_OEN1_N_D               : std_logic;
signal MSS_EMI_0_RW_N_D                 : std_logic;
signal MSS_I2C_0_SCL_E                  : std_logic;
signal MSS_I2C_0_SCL_Y                  : std_logic;
signal MSS_I2C_0_SDA_E                  : std_logic;
signal MSS_I2C_0_SDA_Y                  : std_logic;
signal MSS_I2C_1_SCL_E                  : std_logic;
signal MSS_I2C_1_SCL_Y                  : std_logic;
signal MSS_I2C_1_SDA_E                  : std_logic;
signal MSS_I2C_1_SDA_Y                  : std_logic;
signal MSS_MAC_0_CRSDV_Y                : std_logic;
signal MSS_MAC_0_MDC_D                  : std_logic;
signal MSS_MAC_0_MDIO_D                 : std_logic;
signal MSS_MAC_0_MDIO_E                 : std_logic;
signal MSS_MAC_0_MDIO_Y                 : std_logic;
signal MSS_MAC_0_RXD_0_Y                : std_logic;
signal MSS_MAC_0_RXD_1_Y                : std_logic;
signal MSS_MAC_0_RXER_Y                 : std_logic;
signal MSS_MAC_0_TXD_0_D                : std_logic_vector(0 to 0);
signal MSS_MAC_0_TXD_1_D                : std_logic_vector(1 to 1);
signal MSS_MAC_0_TXEN_D                 : std_logic;
signal MSS_RESET_0_MSS_RESET_N_Y        : std_logic;
signal MSS_SPI_0_CLK_D                  : std_logic;
signal MSS_SPI_0_CLK_Y                  : std_logic;
signal MSS_SPI_0_DI_Y                   : std_logic;
signal MSS_SPI_0_DO_D                   : std_logic;
signal MSS_SPI_0_DO_E                   : std_logic;
signal MSS_SPI_0_SS_D                   : std_logic_vector(0 to 0);
signal MSS_SPI_0_SS_E                   : std_logic;
signal MSS_SPI_0_SS_Y                   : std_logic;
signal MSS_SPI_1_CLK_D                  : std_logic;
signal MSS_SPI_1_CLK_Y                  : std_logic;
signal MSS_SPI_1_DI_Y                   : std_logic;
signal MSS_SPI_1_DO_D                   : std_logic;
signal MSS_SPI_1_DO_E                   : std_logic;
signal MSS_SPI_1_SS_D                   : std_logic_vector(0 to 0);
signal MSS_SPI_1_SS_E                   : std_logic;
signal MSS_SPI_1_SS_Y                   : std_logic;
signal MSS_UART_0_RXD_Y                 : std_logic;
signal MSS_UART_0_TXD_D                 : std_logic;
signal MSS_UART_1_RXD_Y                 : std_logic;
signal MSS_UART_1_TXD_D                 : std_logic;
signal net_71                           : std_logic;
signal PAD_0                            : std_logic;
signal PAD_1                            : std_logic;
signal SPI_0_DO_net_0                   : std_logic;
signal SPI_1_DO_net_0                   : std_logic;
signal UART_0_TXD_net_0                 : std_logic;
signal UART_1_TXD_net_0                 : std_logic;
signal MSS_ADLIB_INST_SYNCCLKFDBK_net_0 : std_logic;
signal net_71_net_0                     : std_logic;
signal UART_0_TXD_net_1                 : std_logic;
signal UART_1_TXD_net_1                 : std_logic;
signal SPI_0_DO_net_1                   : std_logic;
signal SPI_1_DO_net_1                   : std_logic;
signal DSSGEN_EMC_AB_0_net_0            : std_logic_vector(0 to 0);
signal DSSGEN_EMC_AB_10_net_0           : std_logic_vector(10 to 10);
signal DSSGEN_EMC_AB_11_net_0           : std_logic_vector(11 to 11);
signal DSSGEN_EMC_AB_12_net_0           : std_logic_vector(12 to 12);
signal DSSGEN_EMC_AB_13_net_0           : std_logic_vector(13 to 13);
signal DSSGEN_EMC_AB_14_net_0           : std_logic_vector(14 to 14);
signal DSSGEN_EMC_AB_15_net_0           : std_logic_vector(15 to 15);
signal DSSGEN_EMC_AB_16_net_0           : std_logic_vector(16 to 16);
signal DSSGEN_EMC_AB_17_net_0           : std_logic_vector(17 to 17);
signal DSSGEN_EMC_AB_18_net_0           : std_logic_vector(18 to 18);
signal DSSGEN_EMC_AB_19_net_0           : std_logic_vector(19 to 19);
signal DSSGEN_EMC_AB_1_net_0            : std_logic_vector(1 to 1);
signal DSSGEN_EMC_AB_20_net_0           : std_logic_vector(20 to 20);
signal DSSGEN_EMC_AB_21_net_0           : std_logic_vector(21 to 21);
signal DSSGEN_EMC_AB_22_net_0           : std_logic_vector(22 to 22);
signal DSSGEN_EMC_AB_23_net_0           : std_logic_vector(23 to 23);
signal DSSGEN_EMC_AB_24_net_0           : std_logic_vector(24 to 24);
signal DSSGEN_EMC_AB_25_net_0           : std_logic_vector(25 to 25);
signal DSSGEN_EMC_AB_2_net_0            : std_logic_vector(2 to 2);
signal DSSGEN_EMC_AB_3_net_0            : std_logic_vector(3 to 3);
signal DSSGEN_EMC_AB_4_net_0            : std_logic_vector(4 to 4);
signal DSSGEN_EMC_AB_5_net_0            : std_logic_vector(5 to 5);
signal DSSGEN_EMC_AB_6_net_0            : std_logic_vector(6 to 6);
signal DSSGEN_EMC_AB_7_net_0            : std_logic_vector(7 to 7);
signal DSSGEN_EMC_AB_8_net_0            : std_logic_vector(8 to 8);
signal DSSGEN_EMC_AB_9_net_0            : std_logic_vector(9 to 9);
signal DSSGEN_EMC_BYTEN_0_net_0         : std_logic_vector(0 to 0);
signal DSSGEN_EMC_BYTEN_1_net_0         : std_logic_vector(1 to 1);
signal EMC_CS0_N_net_1                  : std_logic;
signal EMC_CS1_N_net_1                  : std_logic;
signal EMC_OEN0_N_net_1                 : std_logic;
signal EMC_OEN1_N_net_1                 : std_logic;
signal EMC_CLK_net_1                    : std_logic;
signal EMC_RW_N_net_1                   : std_logic;
signal DSSGEN_MAC_TXD_0_net_0           : std_logic_vector(0 to 0);
signal DSSGEN_MAC_TXD_1_net_0           : std_logic_vector(1 to 1);
signal PAD_0_net_0                      : std_logic;
signal PAD_1_net_0                      : std_logic;
signal MACRXD_net_0                     : std_logic_vector(1 downto 0);
signal EMCRDB_net_0                     : std_logic_vector(15 downto 0);
signal SPI0SSO_net_0                    : std_logic_vector(7 downto 0);
signal SPI1SSO_net_0                    : std_logic_vector(7 downto 0);
signal MACTXD_net_0                     : std_logic_vector(1 downto 0);
signal EMCAB_net_0                      : std_logic_vector(25 downto 0);
signal EMCWDB_net_0                     : std_logic_vector(15 downto 0);
signal EMCBYTEN_net_0                   : std_logic_vector(1 downto 0);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal GND_net                          : std_logic;
signal VCC_net                          : std_logic;
signal DMAREADY_const_net_0             : std_logic_vector(1 downto 0);
signal GPI_const_net_0                  : std_logic_vector(31 downto 0);
signal MACF2MRXD_const_net_0            : std_logic_vector(1 downto 0);
signal MSSPRDATA_const_net_0            : std_logic_vector(31 downto 0);
signal FABPADDR_const_net_0             : std_logic_vector(31 downto 0);
signal FABPWDATA_const_net_0            : std_logic_vector(31 downto 0);

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 GND_net               <= '0';
 VCC_net               <= '1';
 DMAREADY_const_net_0  <= B"00";
 GPI_const_net_0       <= B"00000000000000000000000000000000";
 MACF2MRXD_const_net_0 <= B"00";
 MSSPRDATA_const_net_0 <= B"00000000000000000000000000000000";
 FABPADDR_const_net_0  <= B"00000000000000000000000000000000";
 FABPWDATA_const_net_0 <= B"00000000000000000000000000000000";
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 MSS_ADLIB_INST_SYNCCLKFDBK_net_0 <= MSS_ADLIB_INST_SYNCCLKFDBK;
 FAB_CLK                          <= MSS_ADLIB_INST_SYNCCLKFDBK_net_0;
 net_71_net_0                     <= net_71;
 M2F_RESET_N                      <= net_71_net_0;
 UART_0_TXD_net_1                 <= UART_0_TXD_net_0;
 UART_0_TXD                       <= UART_0_TXD_net_1;
 UART_1_TXD_net_1                 <= UART_1_TXD_net_0;
 UART_1_TXD                       <= UART_1_TXD_net_1;
 SPI_0_DO_net_1                   <= SPI_0_DO_net_0;
 SPI_0_DO                         <= SPI_0_DO_net_1;
 SPI_1_DO_net_1                   <= SPI_1_DO_net_0;
 SPI_1_DO                         <= SPI_1_DO_net_1;
 DSSGEN_EMC_AB_0_net_0(0)         <= DSSGEN_EMC_AB_0;
 EMC_AB(0)                        <= DSSGEN_EMC_AB_0_net_0(0);
 DSSGEN_EMC_AB_10_net_0(10)       <= DSSGEN_EMC_AB_10;
 EMC_AB(10)                       <= DSSGEN_EMC_AB_10_net_0(10);
 DSSGEN_EMC_AB_11_net_0(11)       <= DSSGEN_EMC_AB_11;
 EMC_AB(11)                       <= DSSGEN_EMC_AB_11_net_0(11);
 DSSGEN_EMC_AB_12_net_0(12)       <= DSSGEN_EMC_AB_12;
 EMC_AB(12)                       <= DSSGEN_EMC_AB_12_net_0(12);
 DSSGEN_EMC_AB_13_net_0(13)       <= DSSGEN_EMC_AB_13;
 EMC_AB(13)                       <= DSSGEN_EMC_AB_13_net_0(13);
 DSSGEN_EMC_AB_14_net_0(14)       <= DSSGEN_EMC_AB_14;
 EMC_AB(14)                       <= DSSGEN_EMC_AB_14_net_0(14);
 DSSGEN_EMC_AB_15_net_0(15)       <= DSSGEN_EMC_AB_15;
 EMC_AB(15)                       <= DSSGEN_EMC_AB_15_net_0(15);
 DSSGEN_EMC_AB_16_net_0(16)       <= DSSGEN_EMC_AB_16;
 EMC_AB(16)                       <= DSSGEN_EMC_AB_16_net_0(16);
 DSSGEN_EMC_AB_17_net_0(17)       <= DSSGEN_EMC_AB_17;
 EMC_AB(17)                       <= DSSGEN_EMC_AB_17_net_0(17);
 DSSGEN_EMC_AB_18_net_0(18)       <= DSSGEN_EMC_AB_18;
 EMC_AB(18)                       <= DSSGEN_EMC_AB_18_net_0(18);
 DSSGEN_EMC_AB_19_net_0(19)       <= DSSGEN_EMC_AB_19;
 EMC_AB(19)                       <= DSSGEN_EMC_AB_19_net_0(19);
 DSSGEN_EMC_AB_1_net_0(1)         <= DSSGEN_EMC_AB_1;
 EMC_AB(1)                        <= DSSGEN_EMC_AB_1_net_0(1);
 DSSGEN_EMC_AB_20_net_0(20)       <= DSSGEN_EMC_AB_20;
 EMC_AB(20)                       <= DSSGEN_EMC_AB_20_net_0(20);
 DSSGEN_EMC_AB_21_net_0(21)       <= DSSGEN_EMC_AB_21;
 EMC_AB(21)                       <= DSSGEN_EMC_AB_21_net_0(21);
 DSSGEN_EMC_AB_22_net_0(22)       <= DSSGEN_EMC_AB_22;
 EMC_AB(22)                       <= DSSGEN_EMC_AB_22_net_0(22);
 DSSGEN_EMC_AB_23_net_0(23)       <= DSSGEN_EMC_AB_23;
 EMC_AB(23)                       <= DSSGEN_EMC_AB_23_net_0(23);
 DSSGEN_EMC_AB_24_net_0(24)       <= DSSGEN_EMC_AB_24;
 EMC_AB(24)                       <= DSSGEN_EMC_AB_24_net_0(24);
 DSSGEN_EMC_AB_25_net_0(25)       <= DSSGEN_EMC_AB_25;
 EMC_AB(25)                       <= DSSGEN_EMC_AB_25_net_0(25);
 DSSGEN_EMC_AB_2_net_0(2)         <= DSSGEN_EMC_AB_2;
 EMC_AB(2)                        <= DSSGEN_EMC_AB_2_net_0(2);
 DSSGEN_EMC_AB_3_net_0(3)         <= DSSGEN_EMC_AB_3;
 EMC_AB(3)                        <= DSSGEN_EMC_AB_3_net_0(3);
 DSSGEN_EMC_AB_4_net_0(4)         <= DSSGEN_EMC_AB_4;
 EMC_AB(4)                        <= DSSGEN_EMC_AB_4_net_0(4);
 DSSGEN_EMC_AB_5_net_0(5)         <= DSSGEN_EMC_AB_5;
 EMC_AB(5)                        <= DSSGEN_EMC_AB_5_net_0(5);
 DSSGEN_EMC_AB_6_net_0(6)         <= DSSGEN_EMC_AB_6;
 EMC_AB(6)                        <= DSSGEN_EMC_AB_6_net_0(6);
 DSSGEN_EMC_AB_7_net_0(7)         <= DSSGEN_EMC_AB_7;
 EMC_AB(7)                        <= DSSGEN_EMC_AB_7_net_0(7);
 DSSGEN_EMC_AB_8_net_0(8)         <= DSSGEN_EMC_AB_8;
 EMC_AB(8)                        <= DSSGEN_EMC_AB_8_net_0(8);
 DSSGEN_EMC_AB_9_net_0(9)         <= DSSGEN_EMC_AB_9;
 EMC_AB(9)                        <= DSSGEN_EMC_AB_9_net_0(9);
 DSSGEN_EMC_BYTEN_0_net_0(0)      <= DSSGEN_EMC_BYTEN_0;
 EMC_BYTEN(0)                     <= DSSGEN_EMC_BYTEN_0_net_0(0);
 DSSGEN_EMC_BYTEN_1_net_0(1)      <= DSSGEN_EMC_BYTEN_1;
 EMC_BYTEN(1)                     <= DSSGEN_EMC_BYTEN_1_net_0(1);
 EMC_CS0_N_net_1                  <= EMC_CS0_N_net_0;
 EMC_CS0_N                        <= EMC_CS0_N_net_1;
 EMC_CS1_N_net_1                  <= EMC_CS1_N_net_0;
 EMC_CS1_N                        <= EMC_CS1_N_net_1;
 EMC_OEN0_N_net_1                 <= EMC_OEN0_N_net_0;
 EMC_OEN0_N                       <= EMC_OEN0_N_net_1;
 EMC_OEN1_N_net_1                 <= EMC_OEN1_N_net_0;
 EMC_OEN1_N                       <= EMC_OEN1_N_net_1;
 EMC_CLK_net_1                    <= EMC_CLK_net_0;
 EMC_CLK                          <= EMC_CLK_net_1;
 EMC_RW_N_net_1                   <= EMC_RW_N_net_0;
 EMC_RW_N                         <= EMC_RW_N_net_1;
 DSSGEN_MAC_TXD_0_net_0(0)        <= DSSGEN_MAC_TXD_0;
 MAC_TXD(0)                       <= DSSGEN_MAC_TXD_0_net_0(0);
 DSSGEN_MAC_TXD_1_net_0(1)        <= DSSGEN_MAC_TXD_1;
 MAC_TXD(1)                       <= DSSGEN_MAC_TXD_1_net_0(1);
 PAD_0_net_0                      <= PAD_0;
 MAC_TXEN                         <= PAD_0_net_0;
 PAD_1_net_0                      <= PAD_1;
 MAC_MDC                          <= PAD_1_net_0;
----------------------------------------------------------------------
-- Slices assignments
----------------------------------------------------------------------
 MAC_RXD_slice_0(0)     <= MAC_RXD(0);
 MAC_RXD_slice_1(1)     <= MAC_RXD(1);
 MSS_EMI_0_AB_0_D(0)    <= EMCAB_net_0(0);
 MSS_EMI_0_AB_1_D(1)    <= EMCAB_net_0(1);
 MSS_EMI_0_AB_2_D(2)    <= EMCAB_net_0(2);
 MSS_EMI_0_AB_3_D(3)    <= EMCAB_net_0(3);
 MSS_EMI_0_AB_4_D(4)    <= EMCAB_net_0(4);
 MSS_EMI_0_AB_5_D(5)    <= EMCAB_net_0(5);
 MSS_EMI_0_AB_6_D(6)    <= EMCAB_net_0(6);
 MSS_EMI_0_AB_7_D(7)    <= EMCAB_net_0(7);
 MSS_EMI_0_AB_8_D(8)    <= EMCAB_net_0(8);
 MSS_EMI_0_AB_9_D(9)    <= EMCAB_net_0(9);
 MSS_EMI_0_AB_10_D(10)  <= EMCAB_net_0(10);
 MSS_EMI_0_AB_11_D(11)  <= EMCAB_net_0(11);
 MSS_EMI_0_AB_12_D(12)  <= EMCAB_net_0(12);
 MSS_EMI_0_AB_13_D(13)  <= EMCAB_net_0(13);
 MSS_EMI_0_AB_14_D(14)  <= EMCAB_net_0(14);
 MSS_EMI_0_AB_15_D(15)  <= EMCAB_net_0(15);
 MSS_EMI_0_AB_16_D(16)  <= EMCAB_net_0(16);
 MSS_EMI_0_AB_17_D(17)  <= EMCAB_net_0(17);
 MSS_EMI_0_AB_18_D(18)  <= EMCAB_net_0(18);
 MSS_EMI_0_AB_19_D(19)  <= EMCAB_net_0(19);
 MSS_EMI_0_AB_20_D(20)  <= EMCAB_net_0(20);
 MSS_EMI_0_AB_21_D(21)  <= EMCAB_net_0(21);
 MSS_EMI_0_AB_22_D(22)  <= EMCAB_net_0(22);
 MSS_EMI_0_AB_23_D(23)  <= EMCAB_net_0(23);
 MSS_EMI_0_AB_24_D(24)  <= EMCAB_net_0(24);
 MSS_EMI_0_AB_25_D(25)  <= EMCAB_net_0(25);
 MSS_EMI_0_BYTEN_0_D(0) <= EMCBYTEN_net_0(0);
 MSS_EMI_0_BYTEN_1_D(1) <= EMCBYTEN_net_0(1);
 MSS_EMI_0_DB_0_D(0)    <= EMCWDB_net_0(0);
 MSS_EMI_0_DB_1_D(1)    <= EMCWDB_net_0(1);
 MSS_EMI_0_DB_2_D(2)    <= EMCWDB_net_0(2);
 MSS_EMI_0_DB_3_D(3)    <= EMCWDB_net_0(3);
 MSS_EMI_0_DB_4_D(4)    <= EMCWDB_net_0(4);
 MSS_EMI_0_DB_5_D(5)    <= EMCWDB_net_0(5);
 MSS_EMI_0_DB_6_D(6)    <= EMCWDB_net_0(6);
 MSS_EMI_0_DB_7_D(7)    <= EMCWDB_net_0(7);
 MSS_EMI_0_DB_8_D(8)    <= EMCWDB_net_0(8);
 MSS_EMI_0_DB_9_D(9)    <= EMCWDB_net_0(9);
 MSS_EMI_0_DB_10_D(10)  <= EMCWDB_net_0(10);
 MSS_EMI_0_DB_11_D(11)  <= EMCWDB_net_0(11);
 MSS_EMI_0_DB_12_D(12)  <= EMCWDB_net_0(12);
 MSS_EMI_0_DB_13_D(13)  <= EMCWDB_net_0(13);
 MSS_EMI_0_DB_14_D(14)  <= EMCWDB_net_0(14);
 MSS_EMI_0_DB_15_D(15)  <= EMCWDB_net_0(15);
 MSS_MAC_0_TXD_0_D(0)   <= MACTXD_net_0(0);
 MSS_MAC_0_TXD_1_D(1)   <= MACTXD_net_0(1);
 MSS_SPI_0_SS_D(0)      <= SPI0SSO_net_0(0);
 MSS_SPI_1_SS_D(0)      <= SPI1SSO_net_0(0);
----------------------------------------------------------------------
-- Concatenation assignments
----------------------------------------------------------------------
 MACRXD_net_0 <= ( MSS_MAC_0_RXD_1_Y & MSS_MAC_0_RXD_0_Y );
 EMCRDB_net_0 <= ( MSS_EMI_0_DB_15_Y & MSS_EMI_0_DB_14_Y & MSS_EMI_0_DB_13_Y & MSS_EMI_0_DB_12_Y & MSS_EMI_0_DB_11_Y & MSS_EMI_0_DB_10_Y & MSS_EMI_0_DB_9_Y & MSS_EMI_0_DB_8_Y & MSS_EMI_0_DB_7_Y & MSS_EMI_0_DB_6_Y & MSS_EMI_0_DB_5_Y & MSS_EMI_0_DB_4_Y & MSS_EMI_0_DB_3_Y & MSS_EMI_0_DB_2_Y & MSS_EMI_0_DB_1_Y & MSS_EMI_0_DB_0_Y );
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- MSS_ADLIB_INST
MSS_ADLIB_INST : MSS_APB
    generic map( 
        ACT_CONFIG => ( 128 ),
        ACT_DIE    => ( "IP4X3M1" ),
        ACT_FCLK   => ( 100000000 ),
        ACT_PKG    => ( "fg484" )
        )
    port map( 
        -- Inputs
        MSSPRDATA      => MSSPRDATA_const_net_0, -- tied to X"0" from definition
        MSSPREADY      => VCC_net, -- tied to '1' from definition
        MSSPSLVERR     => GND_net, -- tied to '0' from definition
        FABPADDR       => FABPADDR_const_net_0, -- tied to X"0" from definition
        FABPWDATA      => FABPWDATA_const_net_0, -- tied to X"0" from definition
        FABPWRITE      => GND_net, -- tied to '0' from definition
        FABPSEL        => GND_net, -- tied to '0' from definition
        FABPENABLE     => GND_net, -- tied to '0' from definition
        SYNCCLKFDBK    => MSS_ADLIB_INST_SYNCCLKFDBK,
        CALIBIN        => GND_net, -- tied to '0' from definition
        FABINT         => GND_net, -- tied to '0' from definition
        F2MRESETn      => VCC_net, -- tied to '1' from definition
        DMAREADY       => DMAREADY_const_net_0, -- tied to X"0" from definition
        RXEV           => GND_net, -- tied to '0' from definition
        VRON           => GND_net, -- tied to '0' from definition
        GPI            => GPI_const_net_0, -- tied to X"0" from definition
        UART0CTSn      => GND_net, -- tied to '0' from definition
        UART0DSRn      => GND_net, -- tied to '0' from definition
        UART0RIn       => GND_net, -- tied to '0' from definition
        UART0DCDn      => GND_net, -- tied to '0' from definition
        UART1CTSn      => GND_net, -- tied to '0' from definition
        UART1DSRn      => GND_net, -- tied to '0' from definition
        UART1RIn       => GND_net, -- tied to '0' from definition
        UART1DCDn      => GND_net, -- tied to '0' from definition
        I2C0SMBUSNI    => GND_net, -- tied to '0' from definition
        I2C0SMBALERTNI => GND_net, -- tied to '0' from definition
        I2C0BCLK       => GND_net, -- tied to '0' from definition
        I2C1SMBUSNI    => GND_net, -- tied to '0' from definition
        I2C1SMBALERTNI => GND_net, -- tied to '0' from definition
        I2C1BCLK       => GND_net, -- tied to '0' from definition
        MACF2MRXD      => MACF2MRXD_const_net_0, -- tied to X"0" from definition
        MACF2MCRSDV    => GND_net, -- tied to '0' from definition
        MACF2MRXER     => GND_net, -- tied to '0' from definition
        MACF2MMDI      => GND_net, -- tied to '0' from definition
        FABSDD0D       => GND_net, -- tied to '0' from definition
        FABSDD1D       => GND_net, -- tied to '0' from definition
        FABSDD2D       => GND_net, -- tied to '0' from definition
        FABSDD0CLK     => GND_net, -- tied to '0' from definition
        FABSDD1CLK     => GND_net, -- tied to '0' from definition
        FABSDD2CLK     => GND_net, -- tied to '0' from definition
        FABACETRIG     => GND_net, -- tied to '0' from definition
        LVTTL0EN       => GND_net, -- tied to '0' from definition
        LVTTL1EN       => GND_net, -- tied to '0' from definition
        LVTTL2EN       => GND_net, -- tied to '0' from definition
        LVTTL3EN       => GND_net, -- tied to '0' from definition
        LVTTL4EN       => GND_net, -- tied to '0' from definition
        LVTTL5EN       => GND_net, -- tied to '0' from definition
        LVTTL6EN       => GND_net, -- tied to '0' from definition
        LVTTL7EN       => GND_net, -- tied to '0' from definition
        LVTTL8EN       => GND_net, -- tied to '0' from definition
        LVTTL9EN       => GND_net, -- tied to '0' from definition
        LVTTL10EN      => GND_net, -- tied to '0' from definition
        LVTTL11EN      => GND_net, -- tied to '0' from definition
        FCLK           => MSS_ADLIB_INST_FCLK,
        MACCLKCCC      => MSS_ADLIB_INST_MACCLKCCC,
        RCOSC          => GND_net, -- tied to '0' from definition
        MACCLK         => MSS_ADLIB_INST_MACCLK,
        PLLLOCK        => MSS_ADLIB_INST_PLLLOCK,
        MSSRESETn      => MSS_RESET_0_MSS_RESET_N_Y,
        SPI0DI         => MSS_SPI_0_DI_Y,
        SPI0CLKI       => MSS_SPI_0_CLK_Y,
        SPI0SSI        => MSS_SPI_0_SS_Y,
        UART0RXD       => MSS_UART_0_RXD_Y,
        I2C0SDAI       => MSS_I2C_0_SDA_Y,
        I2C0SCLI       => MSS_I2C_0_SCL_Y,
        SPI1DI         => MSS_SPI_1_DI_Y,
        SPI1CLKI       => MSS_SPI_1_CLK_Y,
        SPI1SSI        => MSS_SPI_1_SS_Y,
        UART1RXD       => MSS_UART_1_RXD_Y,
        I2C1SDAI       => MSS_I2C_1_SDA_Y,
        I2C1SCLI       => MSS_I2C_1_SCL_Y,
        MACRXD         => MACRXD_net_0,
        MACCRSDV       => MSS_MAC_0_CRSDV_Y,
        MACRXER        => MSS_MAC_0_RXER_Y,
        MACMDI         => MSS_MAC_0_MDIO_Y,
        EMCCLKRTN      => MSS_EMI_0_CLK_D,
        EMCRDB         => EMCRDB_net_0,
        ADC0           => GND_net, -- tied to '0' from definition
        ADC1           => GND_net, -- tied to '0' from definition
        ADC2           => GND_net, -- tied to '0' from definition
        ADC3           => GND_net, -- tied to '0' from definition
        ADC4           => GND_net, -- tied to '0' from definition
        ADC5           => GND_net, -- tied to '0' from definition
        ADC6           => GND_net, -- tied to '0' from definition
        ADC7           => GND_net, -- tied to '0' from definition
        ADC8           => GND_net, -- tied to '0' from definition
        ADC9           => GND_net, -- tied to '0' from definition
        ADC10          => GND_net, -- tied to '0' from definition
        ADC11          => GND_net, -- tied to '0' from definition
        ABPS0          => GND_net, -- tied to '0' from definition
        ABPS1          => GND_net, -- tied to '0' from definition
        ABPS2          => GND_net, -- tied to '0' from definition
        ABPS3          => GND_net, -- tied to '0' from definition
        ABPS4          => GND_net, -- tied to '0' from definition
        ABPS5          => GND_net, -- tied to '0' from definition
        ABPS6          => GND_net, -- tied to '0' from definition
        ABPS7          => GND_net, -- tied to '0' from definition
        ABPS8          => GND_net, -- tied to '0' from definition
        ABPS9          => GND_net, -- tied to '0' from definition
        ABPS10         => GND_net, -- tied to '0' from definition
        ABPS11         => GND_net, -- tied to '0' from definition
        TM0            => GND_net, -- tied to '0' from definition
        TM1            => GND_net, -- tied to '0' from definition
        TM2            => GND_net, -- tied to '0' from definition
        TM3            => GND_net, -- tied to '0' from definition
        TM4            => GND_net, -- tied to '0' from definition
        TM5            => GND_net, -- tied to '0' from definition
        CM0            => GND_net, -- tied to '0' from definition
        CM1            => GND_net, -- tied to '0' from definition
        CM2            => GND_net, -- tied to '0' from definition
        CM3            => GND_net, -- tied to '0' from definition
        CM4            => GND_net, -- tied to '0' from definition
        CM5            => GND_net, -- tied to '0' from definition
        GNDTM0         => GND_net, -- tied to '0' from definition
        GNDTM1         => GND_net, -- tied to '0' from definition
        GNDTM2         => GND_net, -- tied to '0' from definition
        VAREF0         => GND_net, -- tied to '0' from definition
        VAREF1         => GND_net, -- tied to '0' from definition
        VAREF2         => GND_net, -- tied to '0' from definition
        GNDVAREF       => GND_net, -- tied to '0' from definition
        PUn            => GND_net, -- tied to '0' from definition
        -- Outputs
        MSSPADDR       => OPEN,
        MSSPWDATA      => OPEN,
        MSSPWRITE      => OPEN,
        MSSPSEL        => OPEN,
        MSSPENABLE     => OPEN,
        FABPRDATA      => OPEN,
        FABPREADY      => OPEN,
        FABPSLVERR     => OPEN,
        CALIBOUT       => OPEN,
        MSSINT         => OPEN,
        WDINT          => OPEN,
        M2FRESETn      => net_71,
        DEEPSLEEP      => OPEN,
        SLEEP          => OPEN,
        TXEV           => OPEN,
        GPO            => OPEN,
        UART0RTSn      => OPEN,
        UART0DTRn      => OPEN,
        UART1RTSn      => OPEN,
        UART1DTRn      => OPEN,
        I2C0SMBUSNO    => OPEN,
        I2C0SMBALERTNO => OPEN,
        I2C1SMBUSNO    => OPEN,
        I2C1SMBALERTNO => OPEN,
        MACM2FTXD      => OPEN,
        MACM2FTXEN     => OPEN,
        MACM2FMDO      => OPEN,
        MACM2FMDEN     => OPEN,
        MACM2FMDC      => OPEN,
        ACEFLAGS       => OPEN,
        CMP0           => OPEN,
        CMP1           => OPEN,
        CMP2           => OPEN,
        CMP3           => OPEN,
        CMP4           => OPEN,
        CMP5           => OPEN,
        CMP6           => OPEN,
        CMP7           => OPEN,
        CMP8           => OPEN,
        CMP9           => OPEN,
        CMP10          => OPEN,
        CMP11          => OPEN,
        LVTTL0         => OPEN,
        LVTTL1         => OPEN,
        LVTTL2         => OPEN,
        LVTTL3         => OPEN,
        LVTTL4         => OPEN,
        LVTTL5         => OPEN,
        LVTTL6         => OPEN,
        LVTTL7         => OPEN,
        LVTTL8         => OPEN,
        LVTTL9         => OPEN,
        LVTTL10        => OPEN,
        LVTTL11        => OPEN,
        PUFABn         => OPEN,
        VCC15GOOD      => OPEN,
        VCC33GOOD      => OPEN,
        GPOE           => OPEN,
        SPI0DO         => MSS_SPI_0_DO_D,
        SPI0DOE        => MSS_SPI_0_DO_E,
        SPI0CLKO       => MSS_SPI_0_CLK_D,
        SPI0MODE       => MSS_SPI_0_SS_E,
        SPI0SSO        => SPI0SSO_net_0,
        UART0TXD       => MSS_UART_0_TXD_D,
        I2C0SDAO       => MSS_I2C_0_SDA_E,
        I2C0SCLO       => MSS_I2C_0_SCL_E,
        SPI1DO         => MSS_SPI_1_DO_D,
        SPI1DOE        => MSS_SPI_1_DO_E,
        SPI1CLKO       => MSS_SPI_1_CLK_D,
        SPI1MODE       => MSS_SPI_1_SS_E,
        SPI1SSO        => SPI1SSO_net_0,
        UART1TXD       => MSS_UART_1_TXD_D,
        I2C1SDAO       => MSS_I2C_1_SDA_E,
        I2C1SCLO       => MSS_I2C_1_SCL_E,
        MACTXD         => MACTXD_net_0,
        MACTXEN        => MSS_MAC_0_TXEN_D,
        MACMDO         => MSS_MAC_0_MDIO_D,
        MACMDEN        => MSS_MAC_0_MDIO_E,
        MACMDC         => MSS_MAC_0_MDC_D,
        EMCCLK         => MSS_EMI_0_CLK_D,
        EMCAB          => EMCAB_net_0,
        EMCWDB         => EMCWDB_net_0,
        EMCRWn         => MSS_EMI_0_RW_N_D,
        EMCCS0n        => MSS_EMI_0_CS0_N_D,
        EMCCS1n        => MSS_EMI_0_CS1_N_D,
        EMCOEN0n       => MSS_EMI_0_OEN0_N_D,
        EMCOEN1n       => MSS_EMI_0_OEN1_N_D,
        EMCBYTEN       => EMCBYTEN_net_0,
        EMCDBOE        => MSS_EMI_0_DB_15_E,
        SDD0           => OPEN,
        SDD1           => OPEN,
        SDD2           => OPEN,
        VAREFOUT       => OPEN 
        );
-- MSS_CCC_0   -   Actel:SmartFusionMSS:MSS_CCC:2.0.106
MSS_CCC_0 : repo_test_MSS_tmp_MSS_CCC_0_MSS_CCC
    port map( 
        -- Inputs
        CLKA           => GND_net, -- tied to '0' from definition
        CLKA_PAD       => GND_net, -- tied to '0' from definition
        CLKA_PADP      => GND_net, -- tied to '0' from definition
        CLKA_PADN      => GND_net, -- tied to '0' from definition
        CLKB           => GND_net, -- tied to '0' from definition
        CLKB_PAD       => GND_net, -- tied to '0' from definition
        CLKB_PADP      => GND_net, -- tied to '0' from definition
        CLKB_PADN      => GND_net, -- tied to '0' from definition
        CLKC           => GND_net, -- tied to '0' from definition
        CLKC_PAD       => GND_net, -- tied to '0' from definition
        CLKC_PADP      => GND_net, -- tied to '0' from definition
        CLKC_PADN      => GND_net, -- tied to '0' from definition
        MAINXIN        => GND_net, -- tied to '0' from definition
        LPXIN          => GND_net, -- tied to '0' from definition
        MAC_CLK        => GND_net, -- tied to '0' from definition
        -- Outputs
        GLA            => OPEN,
        GLB            => OPEN,
        GLC            => OPEN,
        FAB_CLK        => MSS_ADLIB_INST_SYNCCLKFDBK,
        YB             => OPEN,
        YC             => OPEN,
        FAB_LOCK       => OPEN,
        RCOSC_CLKOUT   => OPEN,
        MAINXIN_CLKOUT => OPEN,
        LPXIN_CLKOUT   => OPEN,
        GLA0           => MSS_ADLIB_INST_FCLK,
        MSS_LOCK       => MSS_ADLIB_INST_PLLLOCK,
        MAC_CLK_CCC    => MSS_ADLIB_INST_MACCLKCCC,
        MAC_CLK_IO     => MSS_ADLIB_INST_MACCLK 
        );
-- MSS_EMI_0_AB_0
MSS_EMI_0_AB_0 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "A8" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_0_D(0),
        -- Outputs
        PAD => DSSGEN_EMC_AB_0 
        );
-- MSS_EMI_0_AB_1
MSS_EMI_0_AB_1 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "A9" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_1_D(1),
        -- Outputs
        PAD => DSSGEN_EMC_AB_1 
        );
-- MSS_EMI_0_AB_2
MSS_EMI_0_AB_2 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "B10" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_2_D(2),
        -- Outputs
        PAD => DSSGEN_EMC_AB_2 
        );
-- MSS_EMI_0_AB_3
MSS_EMI_0_AB_3 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "B11" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_3_D(3),
        -- Outputs
        PAD => DSSGEN_EMC_AB_3 
        );
-- MSS_EMI_0_AB_4
MSS_EMI_0_AB_4 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "E11" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_4_D(4),
        -- Outputs
        PAD => DSSGEN_EMC_AB_4 
        );
-- MSS_EMI_0_AB_5
MSS_EMI_0_AB_5 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "E12" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_5_D(5),
        -- Outputs
        PAD => DSSGEN_EMC_AB_5 
        );
-- MSS_EMI_0_AB_6
MSS_EMI_0_AB_6 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "B12" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_6_D(6),
        -- Outputs
        PAD => DSSGEN_EMC_AB_6 
        );
-- MSS_EMI_0_AB_7
MSS_EMI_0_AB_7 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "A12" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_7_D(7),
        -- Outputs
        PAD => DSSGEN_EMC_AB_7 
        );
-- MSS_EMI_0_AB_8
MSS_EMI_0_AB_8 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "C13" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_8_D(8),
        -- Outputs
        PAD => DSSGEN_EMC_AB_8 
        );
-- MSS_EMI_0_AB_9
MSS_EMI_0_AB_9 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "D13" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_9_D(9),
        -- Outputs
        PAD => DSSGEN_EMC_AB_9 
        );
-- MSS_EMI_0_AB_10
MSS_EMI_0_AB_10 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "D11" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_10_D(10),
        -- Outputs
        PAD => DSSGEN_EMC_AB_10 
        );
-- MSS_EMI_0_AB_11
MSS_EMI_0_AB_11 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "D12" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_11_D(11),
        -- Outputs
        PAD => DSSGEN_EMC_AB_11 
        );
-- MSS_EMI_0_AB_12
MSS_EMI_0_AB_12 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "A14" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_12_D(12),
        -- Outputs
        PAD => DSSGEN_EMC_AB_12 
        );
-- MSS_EMI_0_AB_13
MSS_EMI_0_AB_13 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "A15" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_13_D(13),
        -- Outputs
        PAD => DSSGEN_EMC_AB_13 
        );
-- MSS_EMI_0_AB_14
MSS_EMI_0_AB_14 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "B13" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_14_D(14),
        -- Outputs
        PAD => DSSGEN_EMC_AB_14 
        );
-- MSS_EMI_0_AB_15
MSS_EMI_0_AB_15 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "B14" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_15_D(15),
        -- Outputs
        PAD => DSSGEN_EMC_AB_15 
        );
-- MSS_EMI_0_AB_16
MSS_EMI_0_AB_16 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "C14" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_16_D(16),
        -- Outputs
        PAD => DSSGEN_EMC_AB_16 
        );
-- MSS_EMI_0_AB_17
MSS_EMI_0_AB_17 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "C15" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_17_D(17),
        -- Outputs
        PAD => DSSGEN_EMC_AB_17 
        );
-- MSS_EMI_0_AB_18
MSS_EMI_0_AB_18 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "B16" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_18_D(18),
        -- Outputs
        PAD => DSSGEN_EMC_AB_18 
        );
-- MSS_EMI_0_AB_19
MSS_EMI_0_AB_19 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "B17" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_19_D(19),
        -- Outputs
        PAD => DSSGEN_EMC_AB_19 
        );
-- MSS_EMI_0_AB_20
MSS_EMI_0_AB_20 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "F13" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_20_D(20),
        -- Outputs
        PAD => DSSGEN_EMC_AB_20 
        );
-- MSS_EMI_0_AB_21
MSS_EMI_0_AB_21 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "F14" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_21_D(21),
        -- Outputs
        PAD => DSSGEN_EMC_AB_21 
        );
-- MSS_EMI_0_AB_22
MSS_EMI_0_AB_22 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "C17" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_22_D(22),
        -- Outputs
        PAD => DSSGEN_EMC_AB_22 
        );
-- MSS_EMI_0_AB_23
MSS_EMI_0_AB_23 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "C18" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_23_D(23),
        -- Outputs
        PAD => DSSGEN_EMC_AB_23 
        );
-- MSS_EMI_0_AB_24
MSS_EMI_0_AB_24 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "C16" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_24_D(24),
        -- Outputs
        PAD => DSSGEN_EMC_AB_24 
        );
-- MSS_EMI_0_AB_25
MSS_EMI_0_AB_25 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "D16" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_AB_25_D(25),
        -- Outputs
        PAD => DSSGEN_EMC_AB_25 
        );
-- MSS_EMI_0_BYTEN_0
MSS_EMI_0_BYTEN_0 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "B9" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_BYTEN_0_D(0),
        -- Outputs
        PAD => DSSGEN_EMC_BYTEN_0 
        );
-- MSS_EMI_0_BYTEN_1
MSS_EMI_0_BYTEN_1 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "C9" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_BYTEN_1_D(1),
        -- Outputs
        PAD => DSSGEN_EMC_BYTEN_1 
        );
-- MSS_EMI_0_CLK
MSS_EMI_0_CLK : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "C6" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_CLK_D,
        -- Outputs
        PAD => EMC_CLK_net_0 
        );
-- MSS_EMI_0_CS0_N
MSS_EMI_0_CS0_N : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "A5" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_CS0_N_D,
        -- Outputs
        PAD => EMC_CS0_N_net_0 
        );
-- MSS_EMI_0_CS1_N
MSS_EMI_0_CS1_N : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "A6" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_CS1_N_D,
        -- Outputs
        PAD => EMC_CS1_N_net_0 
        );
-- MSS_EMI_0_DB_0
MSS_EMI_0_DB_0 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "K2" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_0_D(0),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_0_Y,
        -- Inouts
        PAD => EMC_DB(0) 
        );
-- MSS_EMI_0_DB_1
MSS_EMI_0_DB_1 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "K3" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_1_D(1),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_1_Y,
        -- Inouts
        PAD => EMC_DB(1) 
        );
-- MSS_EMI_0_DB_2
MSS_EMI_0_DB_2 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "K5" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_2_D(2),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_2_Y,
        -- Inouts
        PAD => EMC_DB(2) 
        );
-- MSS_EMI_0_DB_3
MSS_EMI_0_DB_3 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "J4" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_3_D(3),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_3_Y,
        -- Inouts
        PAD => EMC_DB(3) 
        );
-- MSS_EMI_0_DB_4
MSS_EMI_0_DB_4 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "J3" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_4_D(4),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_4_Y,
        -- Inouts
        PAD => EMC_DB(4) 
        );
-- MSS_EMI_0_DB_5
MSS_EMI_0_DB_5 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "J2" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_5_D(5),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_5_Y,
        -- Inouts
        PAD => EMC_DB(5) 
        );
-- MSS_EMI_0_DB_6
MSS_EMI_0_DB_6 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "J1" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_6_D(6),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_6_Y,
        -- Inouts
        PAD => EMC_DB(6) 
        );
-- MSS_EMI_0_DB_7
MSS_EMI_0_DB_7 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "H1" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_7_D(7),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_7_Y,
        -- Inouts
        PAD => EMC_DB(7) 
        );
-- MSS_EMI_0_DB_8
MSS_EMI_0_DB_8 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "H3" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_8_D(8),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_8_Y,
        -- Inouts
        PAD => EMC_DB(8) 
        );
-- MSS_EMI_0_DB_9
MSS_EMI_0_DB_9 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "G3" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_9_D(9),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_9_Y,
        -- Inouts
        PAD => EMC_DB(9) 
        );
-- MSS_EMI_0_DB_10
MSS_EMI_0_DB_10 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "F4" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_10_D(10),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_10_Y,
        -- Inouts
        PAD => EMC_DB(10) 
        );
-- MSS_EMI_0_DB_11
MSS_EMI_0_DB_11 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "G5" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_11_D(11),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_11_Y,
        -- Inouts
        PAD => EMC_DB(11) 
        );
-- MSS_EMI_0_DB_12
MSS_EMI_0_DB_12 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "D2" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_12_D(12),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_12_Y,
        -- Inouts
        PAD => EMC_DB(12) 
        );
-- MSS_EMI_0_DB_13
MSS_EMI_0_DB_13 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "D3" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_13_D(13),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_13_Y,
        -- Inouts
        PAD => EMC_DB(13) 
        );
-- MSS_EMI_0_DB_14
MSS_EMI_0_DB_14 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "C1" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_14_D(14),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_14_Y,
        -- Inouts
        PAD => EMC_DB(14) 
        );
-- MSS_EMI_0_DB_15
MSS_EMI_0_DB_15 : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "B1" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_DB_15_D(15),
        E   => MSS_EMI_0_DB_15_E,
        -- Outputs
        Y   => MSS_EMI_0_DB_15_Y,
        -- Inouts
        PAD => EMC_DB(15) 
        );
-- MSS_EMI_0_OEN0_N
MSS_EMI_0_OEN0_N : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "D10" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_OEN0_N_D,
        -- Outputs
        PAD => EMC_OEN0_N_net_0 
        );
-- MSS_EMI_0_OEN1_N
MSS_EMI_0_OEN1_N : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "C10" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_OEN1_N_D,
        -- Outputs
        PAD => EMC_OEN1_N_net_0 
        );
-- MSS_EMI_0_RW_N
MSS_EMI_0_RW_N : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 536870912 ),
        ACT_PIN    => ( "B6" )
        )
    port map( 
        -- Inputs
        D   => MSS_EMI_0_RW_N_D,
        -- Outputs
        PAD => EMC_RW_N_net_0 
        );
-- MSS_I2C_0_SCL
MSS_I2C_0_SCL : BIBUF_OPEND_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "U21" )
        )
    port map( 
        -- Inputs
        E   => MSS_I2C_0_SCL_E,
        -- Outputs
        Y   => MSS_I2C_0_SCL_Y,
        -- Inouts
        PAD => I2C_0_SCL 
        );
-- MSS_I2C_0_SDA
MSS_I2C_0_SDA : BIBUF_OPEND_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "V21" )
        )
    port map( 
        -- Inputs
        E   => MSS_I2C_0_SDA_E,
        -- Outputs
        Y   => MSS_I2C_0_SDA_Y,
        -- Inouts
        PAD => I2C_0_SDA 
        );
-- MSS_I2C_1_SCL
MSS_I2C_1_SCL : BIBUF_OPEND_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "U20" )
        )
    port map( 
        -- Inputs
        E   => MSS_I2C_1_SCL_E,
        -- Outputs
        Y   => MSS_I2C_1_SCL_Y,
        -- Inouts
        PAD => I2C_1_SCL 
        );
-- MSS_I2C_1_SDA
MSS_I2C_1_SDA : BIBUF_OPEND_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "V22" )
        )
    port map( 
        -- Inputs
        E   => MSS_I2C_1_SDA_E,
        -- Outputs
        Y   => MSS_I2C_1_SDA_Y,
        -- Inouts
        PAD => I2C_1_SDA 
        );
-- MSS_MAC_0_CRSDV
MSS_MAC_0_CRSDV : INBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "W4" )
        )
    port map( 
        -- Inputs
        PAD => MAC_CRSDV,
        -- Outputs
        Y   => MSS_MAC_0_CRSDV_Y 
        );
-- MSS_MAC_0_MDC
MSS_MAC_0_MDC : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "AA3" )
        )
    port map( 
        -- Inputs
        D   => MSS_MAC_0_MDC_D,
        -- Outputs
        PAD => PAD_1 
        );
-- MSS_MAC_0_MDIO
MSS_MAC_0_MDIO : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "V4" )
        )
    port map( 
        -- Inputs
        D   => MSS_MAC_0_MDIO_D,
        E   => MSS_MAC_0_MDIO_E,
        -- Outputs
        Y   => MSS_MAC_0_MDIO_Y,
        -- Inouts
        PAD => MAC_MDIO 
        );
-- MSS_MAC_0_RXD_0
MSS_MAC_0_RXD_0 : INBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "V5" )
        )
    port map( 
        -- Inputs
        PAD => MAC_RXD_slice_0(0),
        -- Outputs
        Y   => MSS_MAC_0_RXD_0_Y 
        );
-- MSS_MAC_0_RXD_1
MSS_MAC_0_RXD_1 : INBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "U5" )
        )
    port map( 
        -- Inputs
        PAD => MAC_RXD_slice_1(1),
        -- Outputs
        Y   => MSS_MAC_0_RXD_1_Y 
        );
-- MSS_MAC_0_RXER
MSS_MAC_0_RXER : INBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "AA4" )
        )
    port map( 
        -- Inputs
        PAD => MAC_RXER,
        -- Outputs
        Y   => MSS_MAC_0_RXER_Y 
        );
-- MSS_MAC_0_TXD_0
MSS_MAC_0_TXD_0 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "AA5" )
        )
    port map( 
        -- Inputs
        D   => MSS_MAC_0_TXD_0_D(0),
        -- Outputs
        PAD => DSSGEN_MAC_TXD_0 
        );
-- MSS_MAC_0_TXD_1
MSS_MAC_0_TXD_1 : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "W5" )
        )
    port map( 
        -- Inputs
        D   => MSS_MAC_0_TXD_1_D(1),
        -- Outputs
        PAD => DSSGEN_MAC_TXD_1 
        );
-- MSS_MAC_0_TXEN
MSS_MAC_0_TXEN : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "Y4" )
        )
    port map( 
        -- Inputs
        D   => MSS_MAC_0_TXEN_D,
        -- Outputs
        PAD => PAD_0 
        );
-- MSS_RESET_0_MSS_RESET_N
MSS_RESET_0_MSS_RESET_N : INBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "R1" )
        )
    port map( 
        -- Inputs
        PAD => MSS_RESET_N,
        -- Outputs
        Y   => MSS_RESET_0_MSS_RESET_N_Y 
        );
-- MSS_SPI_0_CLK
MSS_SPI_0_CLK : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "W19" )
        )
    port map( 
        -- Inputs
        D   => MSS_SPI_0_CLK_D,
        E   => MSS_SPI_0_SS_E,
        -- Outputs
        Y   => MSS_SPI_0_CLK_Y,
        -- Inouts
        PAD => SPI_0_CLK 
        );
-- MSS_SPI_0_DI
MSS_SPI_0_DI : INBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "V18" )
        )
    port map( 
        -- Inputs
        PAD => SPI_0_DI,
        -- Outputs
        Y   => MSS_SPI_0_DI_Y 
        );
-- MSS_SPI_0_DO
MSS_SPI_0_DO : TRIBUFF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "U17" )
        )
    port map( 
        -- Inputs
        D   => MSS_SPI_0_DO_D,
        E   => MSS_SPI_0_DO_E,
        -- Outputs
        PAD => SPI_0_DO_net_0 
        );
-- MSS_SPI_0_SS
MSS_SPI_0_SS : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "Y20" )
        )
    port map( 
        -- Inputs
        D   => MSS_SPI_0_SS_D(0),
        E   => MSS_SPI_0_SS_E,
        -- Outputs
        Y   => MSS_SPI_0_SS_Y,
        -- Inouts
        PAD => SPI_0_SS 
        );
-- MSS_SPI_1_CLK
MSS_SPI_1_CLK : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "AA22" )
        )
    port map( 
        -- Inputs
        D   => MSS_SPI_1_CLK_D,
        E   => MSS_SPI_1_SS_E,
        -- Outputs
        Y   => MSS_SPI_1_CLK_Y,
        -- Inouts
        PAD => SPI_1_CLK 
        );
-- MSS_SPI_1_DI
MSS_SPI_1_DI : INBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "V19" )
        )
    port map( 
        -- Inputs
        PAD => SPI_1_DI,
        -- Outputs
        Y   => MSS_SPI_1_DI_Y 
        );
-- MSS_SPI_1_DO
MSS_SPI_1_DO : TRIBUFF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "T17" )
        )
    port map( 
        -- Inputs
        D   => MSS_SPI_1_DO_D,
        E   => MSS_SPI_1_DO_E,
        -- Outputs
        PAD => SPI_1_DO_net_0 
        );
-- MSS_SPI_1_SS
MSS_SPI_1_SS : BIBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "W21" )
        )
    port map( 
        -- Inputs
        D   => MSS_SPI_1_SS_D(0),
        E   => MSS_SPI_1_SS_E,
        -- Outputs
        Y   => MSS_SPI_1_SS_Y,
        -- Inouts
        PAD => SPI_1_SS 
        );
-- MSS_UART_0_RXD
MSS_UART_0_RXD : INBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "U18" )
        )
    port map( 
        -- Inputs
        PAD => UART_0_RXD,
        -- Outputs
        Y   => MSS_UART_0_RXD_Y 
        );
-- MSS_UART_0_TXD
MSS_UART_0_TXD : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "Y22" )
        )
    port map( 
        -- Inputs
        D   => MSS_UART_0_TXD_D,
        -- Outputs
        PAD => UART_0_TXD_net_0 
        );
-- MSS_UART_1_RXD
MSS_UART_1_RXD : INBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "W22" )
        )
    port map( 
        -- Inputs
        PAD => UART_1_RXD,
        -- Outputs
        Y   => MSS_UART_1_RXD_Y 
        );
-- MSS_UART_1_TXD
MSS_UART_1_TXD : OUTBUF_MSS
    generic map( 
        ACT_CONFIG => ( 0 ),
        ACT_PIN    => ( "V20" )
        )
    port map( 
        -- Inputs
        D   => MSS_UART_1_TXD_D,
        -- Outputs
        PAD => UART_1_TXD_net_0 
        );

end RTL;
