----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--
--      Title           : 8b10b Monitor - skin for the Multihaul 2.5G G.709 Transponder Wrapper FPGA
--
--      Author(s)       : Steve Betteley
--
--      Version         : @(#)monitor_8b10b_a.vhd	1.14
--                        The version number is maintained by XEmacs Version Control, and is based on SCCS.
--
--      Remarks         : Instances the generic 8b10b monitor core
-- 
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- This is an unpublished work the copyright in which vests in Marconi
-- Communications Limited. All rights reserved.
-- 
-- The information contained herein is confidential and the property of
-- Marconi Communications Limited and is supplied without liability for errors
-- or omissions. No part may be reproduced, disclosed or used except as
-- authorised by contract or other written permission.  The copyright and the
-- foregoing restriction on reproduction and use extend to all media in which
-- the information may be embodied.
-- 
-- New Century Park, PO Box 53, Coventry. England. CV3 1HJ
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

-- Design Description
-- ~~~~~~~~~~~~~~~~~~
--
-- This design instances the 'generic' or 'core' 8b10b Monitor component, and customises it to the template required for the
-- Multihaul 2.5G G.709 Transponder Wrapper FPGA.
--
-- The core component requires a 'block_strobe' to define the block periods for the block error count. The host FPGA has a
-- 19.44 MHz clock available (Ref19M44) which is used to generate the block_strobe. The Ref19M44 clock is asynchronous to the
-- client data 'clock', so metastability protection is used. 
--

architecture monitor_8b10b_a of monitor_8b10b_e is

  -- The generic component, refer to the 'monitor_8b10b_core_e.vhd' file for port descriptions
  component monitor_8b10b_core_e
    generic (code_error_count_width  : integer;
             block_error_count_width : integer);
    port (clock              : in     bit;
          reset              : in     boolean;
          mode               : in     bit_vector(7 downto 0);
          data               : in     bit_vector(31 downto 0);
          block_strobe       : in     boolean;
          freeze             : in     boolean;
          signal_detect_ok   : in     boolean;
          mr_loopback        : in     boolean;
          code_error_count   : buffer bit_vector(code_error_count_width - 1 downto 0);
          block_error_count  : buffer bit_vector(block_error_count_width - 1 downto 0);
          sync_status_ok     : buffer boolean);
  end component monitor_8b10b_core_e;

  signal   code_error_count        : bit_vector(15 downto 0);  -- 8b10b coding errors, rolling count
  signal   block_error_count       : bit_vector(7 downto 0);   -- 8b10b 'block' errors
  signal   mode_as_bit_vector      : bit_vector(7 downto 0);   -- Operational mode
  signal   sync_status_ok          : boolean;                  -- 8b10b synchronisation acquired
  signal   clock_8khz              : bit;                      -- 125us block period timing reference
  signal   clock_8khz_r1           : bit;                      -- Re-timed once
  signal   clock_8khz_r2           : bit;                      -- Re-timed twice
  signal   clock_8khz_r3           : bit;                      -- Re-timed thrice
  signal   block_strobe            : boolean;                  -- 125us timing strobe for block period
  signal   clock_as_bit            : bit;                      -- Type conversion
  signal   reset_as_boolean        : boolean;                  -- Type conversion
  signal   freeze_as_boolean       : boolean;                  -- Type conversion
  signal   signal_detect_ok        : boolean;                  -- Type conversion and inversion
  signal   mr_loopback             : boolean;                  -- Type conversion
  signal   din_as_bit_vector       : bit_vector(31 downto 0);  -- Type conversion
  
begin

  -- Name and type conversions for the required skin
  clock_as_bit           <= to_bit(Clock);
  reset_as_boolean       <= as_boolean(Reset);
  din_as_bit_vector      <= to_bitvector(Din);
  freeze_as_boolean      <= as_boolean(Freeze);
  mode_as_bit_vector     <= to_bitvector(Mode);
  signal_detect_ok       <= not as_boolean(LOS);
  mr_loopback            <= as_boolean(Loopback);
  CodeErrors             <= to_stdlogicvector(code_error_count);
  BlockErrors            <= to_stdlogicvector(block_error_count);
  InSync                 <= as_std_logic(sync_status_ok);

  -- Instance the generic component
  monitor_8b10b_core_1: monitor_8b10b_core_e
    generic map (code_error_count_width  => 16,     -- Generate a 16-bit error count
                 block_error_count_width => 8)      -- Generate an 8-bit block error count
    port map (clock             => clock_as_bit,
              reset             => reset_as_boolean,
              mode              => mode_as_bit_vector,
              data              => din_as_bit_vector,
              block_strobe      => block_strobe,
              freeze            => freeze_as_boolean,
              signal_detect_ok  => signal_detect_ok,
              mr_loopback       => mr_loopback,
              code_error_count  => code_error_count,
              block_error_count => block_error_count,
              sync_status_ok    => sync_status_ok);

  -- Generate an 8kHz signal from the (asynchronous) 19.44MHz clock input.
  block_period_generator: process (reset_as_boolean, Ref19M44)
    constant terminal_count   : integer := 1214;
    variable count            : integer range 0 to terminal_count;
  begin
    if reset_as_boolean then
      clock_8khz <= '1';
      count      := terminal_count;
    elsif Ref19M44'event and (Ref19M44 = '1') then
      if count = 0 then
        clock_8khz <= not clock_8khz;
        count      := terminal_count;
      else
        count := count - 1;
      end if;
    end if;
  end process block_period_generator;
  
  -- Generate a 125 us block strobe signal which is 'true' for one 'clock' cycle. Include metastability protection.
  block_strobe_generator: process (reset_as_boolean, clock)
  begin
    if reset_as_boolean then
      clock_8khz_r1 <= '0';
      clock_8khz_r2 <= '0';
      clock_8khz_r3 <= '0';
      block_strobe  <= false;
    elsif clock'event and (clock = '1') then
      clock_8khz_r1 <= clock_8khz;
      clock_8khz_r2 <= clock_8khz_r1;
      clock_8khz_r3 <= clock_8khz_r2;
      block_strobe  <= (clock_8khz_r3 = '0') and (clock_8khz_r2 = '1');
    end if;
  end process block_strobe_generator;

end architecture monitor_8b10b_a;
