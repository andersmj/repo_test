--------------------------------------------------------------------------------
-- Company: University of Warwick School Of Engineering
--
-- File: clkdiv.vhd
-- File history:
--      <Revision 1>: <28/10/13>: First Version
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- divides an incoming reference clock (250kHz) down to 10Hz
-- Divide clock by 25000 so we can dived by 12500 to obtain each output 
-- transition
-- Number of bits required = log 12500/ log 2 = 13.6  so 14 bit counter
-- Targeted device: <Family::SmartFusion> <Die::A2F200M3F> <Package::484 FBGA>
-- Author: M Anderson
--
--------------------------------------------------------------------------------


Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

Entity clkdiv is 
    port(M2F_RESET_N      : in std_logic; -- FPGA Global Reset active low
	 FAB_CLK          : in std_logic; -- FPGA System Clock 250 kHz
         CLK10H           : out std_logic -- clock output 10 Hz
		 );
end entity clkdiv;

architecture synth of clkdiv is

constant max12k5                 : std_logic_vector(13 downto 0) := conv_std_logic_vector(12500,14);
signal counter12k5               : std_logic_vector(13 downto 0); -- Primary counter
signal clk10h_sig                : std_logic;
 
begin
	 	
--*****************************************************************************************************
-- 
--*****************************************************************************************************


divider : process (FAB_CLK,M2F_RESET_N)
begin
  if M2F_RESET_N = '0' then
     counter12k5 <= (others => '0');
     clk10h_sig <= '0';
  elsif rising_edge(FAB_CLK) then
     counter12k5 <= counter12k5 + '1';
     if counter12k5 = max12k5 then
        counter12k5 <= (others => '0');
        clk10h_sig <= NOT(clk10h_sig);
     end if;
  end if;
end process divider;

CLK10H <= clk10h_sig;

end synth;
 




