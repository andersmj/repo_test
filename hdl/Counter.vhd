--------------------------------------------------------------------------------
-- Company: University of Warwick School Of Engineering
--
-- File: Counter.vhd
-- File history:
--      <Revision 1>: <19/11/13>: 8 bit counter with generation of UPDOWN
--      uses 1 HOT coding style                          
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- an eight bit up/down counter with enable and asynchronous reset
-- switch inputs (SW1 and SW2) are normally '1' and become '0' when
-- switch depressed
-- The counter will roll around
-- Counter will decode the state of UPDOWN as follows
-- SW1 and SW2 not pressed - no action - counter disabled
-- SW1 and SW2 pressed - count active
-- SW1 pressed and SW2 not pressed capture a Count Up condition
-- SW1 not pressed and SW2 pressed capture a Count Down condition
--
-- Targeted device: <Family::SmartFusion> <Die::A2F200M3F> <Package::484 FBGA>
-- Author: M Anderson
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


entity Counter is
port (
   M2F_RESET_N : in std_logic;     -- active low asynchronous system reset
   CLK10H      : in std_logic;     -- clock 10 Hz in this case
   SW1         : in std_logic;     -- Switch 1 enable active low
   SW2         : in std_logic;     -- Switch 2 enable active low
   COUNT       : out std_logic_vector(7 downto 0) -- result of the counter
);
end Counter;

architecture synth of Counter is
   -- signal, component etc. declarations

signal count_sig : std_logic_vector(7 downto 0);
signal SW1_rt : std_logic_vector(2 downto 0);  -- shift register for synchronising ENABLE to CLK10H
signal SW2_rt : std_logic_vector(2 downto 0);  -- shift register for Metastability retime
signal UpDown_sig : std_logic;     -- store captured state of UPDOWN. '1' = count up
signal Enable_sig : std_logic;     -- Enable counter

begin
-- architecture body

--------------------------------------------------------------------------------
-- shift SW1/2 into a 3 bit shift register from 0 to 2 i.e 2 is the oldest sample
-- bits 0 and 1 are a double retime to counter metastability effects due to SW1/2
-- being asynchronous to CLK10H
-- bits 1 and 2 can then be used to detect a change in state of SW1/2
-- 
-- 
--------------------------------------------------------------------------------
Retime : PROCESS(M2F_RESET_N, CLK10H)

BEGIN

   IF M2F_RESET_N = '0' THEN          -- Asynchronous reset - takes priority over clock
      SW1_rt <= "111";
      SW2_rt <= "111";
   ELSIF CLK10H'event and CLK10H = '1' THEN    -- Defines a rising edge event of CLK10H
      SW1_rt <= SW1_rt(1 downto 0) & SW1;  -- shift register
      SW2_rt <= SW2_rt(1 downto 0) & SW2;
   END IF;
END PROCESS Retime;


Capture_UPDOWN : PROCESS(M2F_RESET_N, CLK10H)

BEGIN

   IF M2F_RESET_N = '0' THEN          -- Asynchronous reset - takes priority over clock
      UpDown_sig <= '0';
   ELSIF CLK10H'event and CLK10H = '1' THEN    -- Defines a rising edge event of CLK10H
      UpDown_Sig <= UpDown_Sig;             -- maintain current value of UpDown_sig
      IF SW1_rt(2 downto 1) = "10" THEN     -- SW1 has gone from '1' to '0'
         IF SW2_rt(1) = '1' THEN            -- and SW2 has not been pressed
            UpDown_sig <= '1';              -- Capture UP
         END IF;
      END IF;

      IF SW2_rt(2 downto 1) = "10" THEN     -- SW2 has gone from '1' to '0'
         IF SW1_rt(1) = '1' THEN            -- and SW1 has not been pressed
            UpDown_sig <= '0';              -- Capture DOWN
         END IF;
      END IF;
   END IF;
   
END PROCESS Capture_UPDOWN;

ASSIGN_Enable_sig : Enable_sig <= '1' WHEN SW1_rt(2) = '0' AND SW2_rt(2) = '0' ELSE '0';  -- Decode counter enable from switch states

Eight_Bit_Count : PROCESS(M2F_RESET_N, CLK10H)

BEGIN

   IF M2F_RESET_N = '0' THEN          -- Asynchronous reset - takes priority over clock
      count_sig <= "00000001";        -- preload LSB with a '1'
   ELSIF CLK10H'event and CLK10H = '1' THEN    -- Defines a rising edge event of CLK10H
      IF Enable_sig = '1' THEN                     -- if counter enabled
         IF UpDown_sig = '1' THEN                  -- count up
            count_sig <= count_sig(6 downto 0)& count_sig(7);      
         ELSE                                      -- count down
            count_sig <= count_sig(0) & count_sig(7 downto 1);
         END IF;
      END IF;
   END IF;
END PROCESS Eight_Bit_Count;

COUNT <= count_sig;                   -- concurrent assignment of signal to output
   
end synth;

