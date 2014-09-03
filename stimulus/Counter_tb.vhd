--------------------------------------------------------------------------------
-- Company: University of Warwick School Of Engineering
--
-- File: Counter_tb.vhd
-- File history:
--      <Revision 1>: <18/11/13>: <Testbench for Counter function>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
-- 
-- Testbench Sequential logic design implementing
-- an eight bit up/down counter with enable and asynchronous reset
-- switch inputs (SW1 and SW2) are normally '1' and become '0' when
-- switch depressed
-- The counter will roll over from 00000000 <> 11111111
-- applies sequence of inputs and generates clock
-- 
-- Author: M Anderson
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Counter_tb IS
END ENTITY Counter_tb;


ARCHITECTURE test OF Counter_tb IS

SIGNAL M2F_RESET_N : std_logic;  -- Global reset
SIGNAL CLK10H : std_logic := '0';  -- 10 Hz clock. NOTE use of initial value
SIGNAL SW1 : std_logic; -- Active low 
SIGNAL SW2 : std_logic; -- Active low
SIGNAL COUNT : std_logic_vector(7 downto 0); -- result of count 

CONSTANT Clk_Period : time := 100 ms;  -- define the clock period
-- Define the component to be tested - note the similarity to the entity declaration  
COMPONENT Counter
  
port (
   M2F_RESET_N : in std_logic;     -- active low asynchronous system reset
   CLK10H      : in std_logic;     -- clock 10 Hz in this case
   SW1         : in std_logic;     -- active low
   SW2         : in std_logic;     -- active low
   COUNT       : out std_logic_vector(7 downto 0) -- result of the counter
);
END COMPONENT;
-------------------------------------------------------------------
-- Start of the test architecture
-------------------------------------------------------------------
  
BEGIN

    
-- instantiate the Unit under Test. 
--This is where we connect the testbench to the component   

uut_Counter : Counter
   port map (M2F_RESET_N  => M2F_RESET_N,
             CLK10H       => CLK10H,  
	     SW1          => SW1,
	     SW2          => SW2,
	     COUNT        => COUNT
	     );


-- Define the clock

   CLK10H <= NOT(CLK10H) after Clk_Period/2;
   

   
   
-- Define the behaviour of the input signals
Stimulus : PROCESS
BEGIN
   
Wait for 100 ms;  -- up to this point the inputs and the output will be undefined
   M2F_RESET_N <= '0';  -- active reset COUNT should now go to 0
Wait for 10 ms;
   SW1 <= '1';  -- counter not enabled
   SW2 <= '1';
Wait for 10 ms;
   M2F_RESET_N <= '1';
FOR i in 0 to 4 LOOP   -- wait for a few clock cycles, COUNT shouldn't change
   Wait until rising_edge(CLK10H);
END LOOP;
   SW1 <= '0';  -- 
FOR i in 0 to 30 LOOP   -- wait for a few clock cycles, COUNT shouldn't increase
   Wait until rising_edge(CLK10H);
END LOOP;
   SW2 <= '0';  -- enable counter will count up
FOR i in 0 to 40 LOOP   -- wait for a few clock cycles, COUNT should change
   Wait until rising_edge(CLK10H);
END LOOP;
   SW2 <= '1';   -- stop count
FOR i in 0 to 4 LOOP   -- wait for a few clock cycles, COUNT shouldn't change
   Wait until rising_edge(CLK10H);
END LOOP;
   SW1 <= '1';  -- disable counter, 
FOR i in 0 to 4 LOOP   -- wait for a few clock cycles, COUNT shouldn't change
   Wait until rising_edge(CLK10H);
   SW2 <= '0';  -- 
END LOOP;
FOR i in 0 to 30 LOOP   -- wait for a few clock cycles, COUNT shouldn't increase
   Wait until rising_edge(CLK10H);
END LOOP;
   SW1 <= '0';  -- enable counter will count down
FOR i in 0 to 60 LOOP   -- wait for a few clock cycles, COUNT should decrease
   Wait until rising_edge(CLK10H);
END LOOP;
-- force end to testbench
   assert false report "NONE. End of simulation." severity failure;

Wait;
END PROCESS;

END Test;









