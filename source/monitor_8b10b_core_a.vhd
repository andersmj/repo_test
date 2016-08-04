----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--
--      Title           : 8b10b Monitor Core Component, 1sbb60063aaf
--
--      Author(s)       : Steve Betteley
--
--      Version         : @(#)monitor_8b10b_core_a.vhd	1.22
--                        The version number is maintained by XEmacs Version Control, and is based on SCCS.
--                        Use 'C-x v l' to view version history.
--
--      Glossary        : PMA - Physical Medium Attachment Sublayer (reference 1)
--
--      References        1. IEEE Std 802.3-2002 Section 3, clause 36.
--                        2. ANSI X3.230-1994 clauses 11 and 12.
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
-- Accepts unaligned 8b10b encoded client 'data', and performs comma synchronisation so that the 8b10b code-words can be examined
-- for validity as specified in reference 1. The 'code_error_count' provides a rolling count of the errors detected. The
-- 'block_error_count' increments if one or more code-word error occurs in a 'block period'; The 'block_strobe' input defines the
-- 'block_period'; 125 us is expected. A 'sync_status_ok' flag indicates when comma synchronisation has been achieved.
--
-- The client data rate is not specified, rates of 1250.0 Mbit/s (Gigabit Ethernet), 1062.5 Mbit/s (Fibrechannel), or 2125.0
-- Mbit/s (Double Fibrechannel) are expected. 
--
--               +-------------+    
--               |             |    
--               |             |---> strobe           (running disparity)
--  data_in -/-->| pma_receive |                    +-------------<----------+
--           32  |             |-/--+ aligned_      |                        |
--               |             | 40 | data          v                        |
--               +------^------+    |          +---------+    +----------+   |    +----------+
--                      |           |  39..30  |         |    |          |   |    |          |
--                      |           |\-------->| ten_bit |--->|          |---|--->|          |
--                    clock         |          | monitor |    |          |   |    |          |                       sync_
--                                  |          |         |    |          |   |    |          |---------------------> status_
--                                  |          +---------+    |          |   |    |          |                       ok
--                                  |               |         |          |   |    |          |
--                                  |               v         |          |   |    |          |
--                                  |          +---------+    |          |   |    |          |       +---------+    
--                                  |  29..20  |         |    |          |   |    |          |errors |         |     code_
--                                  |\-------->| ten_bit |--->|          |---|--->|          |   +-->| error _ |---> error_
--                                  |          | monitor |    |          |   |    |          |   |   | counter |     count_
--                                  |          |         |    |          |   |    |          |   |   |         |    
--                                  |          +---------+    |          |   |    |          |   |   +----^----+    
--                                  |               |         | Signal   |   ^    | Synchro- |---+        |
--                                  |               v         | Retiming |   |    | nisation |   |      clock
--                                  |          +---------+    |          |   |    |          |   |
--                                  |  19..10  |         |    |          |   |    |          |   |   +---------+        
--                                  |\-------->| ten_bit |--->|          |---|--->|          |   |   |         |     block_   
--                                  |          | monitor |    |          |   |    |          |   +-->| block   |---> error_
--                                  |          |         |    |          |   |    |          |       | error   |     count
--                                  |          +---------+    |          |   |    |          |       | counter |        
--                                  |               |         |          |   |    |          |       +----^----+        
--                                  |               v         |          |   |    |          |            |             
--                                  |          +---------+    |          |   |    |          |          clock        
--                                  |   9..0   |         |    |          |   |    |          |                       
--                                   \-------->| ten_bit |--->|          |---|--->|          |
--                                             | monitor |    |          |   |    |          |
--                                             |         |    |          |   ^    |          |
--                                             +---------+    |          |   |    |          |
--                                                  |         |          |   |    |          |
--                                                  +-------->|          |---+    |          |
--                                                            +-----^----+        +-----^----+
--                                                                  |                   |
--                                                                  |                   |
--                                                                clock               clock
--
--                                                                
-- The 'pma_receive' component performs the PMA function as specified in reference 1. The unaligned 32-bit data_in is aligned to
-- any incoming comma code-groups, and output as a aligned 40-bit vector, 'aligned_data', comprising four code-groups per
-- clock cycle. This alignment may be on comma+ patterns alone if IEEE802.3 operation is selected, or either comma+ or comma-
-- patterns if ANSI X3.230 operation is selected. The 'mode' input indicates IEEE802.3 or ANSI X3.230 operation. The
-- 'aligned_data' conveys new data for four out of every five clock cycles, this being indicated by the 'strobe' signal. Vector
-- range 9 downto 0 represents the most recently received code-group, range 39 downto 30, the oldest code-group (first
-- transmitted).
--
-- Each code-group is processed by a 'ten_bit_monitor' component which is a combinatorial lookup function which determines
-- whether the code-group is valid, is a 'comma', or corresponds to a data byte. A running disparity calculation is performed
-- and chained through each component.
--
-- The information from the 'ten_bit_monitors' is retimed (to meet expected 12ns clock to clock), and passed into the
-- 'synchronisation' component.
--
-- The 'synchronisation' component implements the 'Synchronisation' state diagram from reference 1, and the synchronisation
-- procedures from reference 2. The 'mode' input selects one of these state machines according to the client data format. The
-- selected state machine produces a 'sync_status_ok' signal, and generates  a code 'errors' signal.
--
-- The 'error_counter' process generates an error count, incrementing by up to four each clock cycle when IEEE802.3 operation is
-- selected, and by up to one each cycle when ANSI X3.230 operation is selected.
--
-- The 'block_error_counter' process maintains an 'error_flag' which is cleared at the start of each 'block' period, and set
-- if the 'synchronisation' component generates 'errors > 0'. A 'block_error_count' is kept which counts block periods in which
-- the error_flag has been set.
--

architecture monitor_8b10b_core_a of monitor_8b10b_core_e is

  -- PMA, receive part only
  component pma_receive_e
    port (clock         : in     bit;
          reset         : in     boolean;
          mode          : in     bit_vector(7 downto 0);
          data_in       : in     bit_vector(31 downto 0);
          data_out      : buffer bit_vector(39 downto 0);
          strobe        : buffer boolean);
  end component pma_receive_e;

  -- Monitors one code-group
  component ten_bit_monitor_e
    port (mode                           : in   bit_vector(7 downto 0);
          code_group                     : in   bit_vector(9 downto 0);
          starting_disparity_is_positive : in   boolean;
          code_group_is_valid            : out  boolean;
          code_group_is_data             : out  boolean;
          code_group_is_comma            : out  boolean;
          ending_disparity_is_positive   : out  boolean);
  end component ten_bit_monitor_e;

  -- PCS Synchronisation State Machine
  component synchronisation_e
    port (clock                 : in     bit;
          reset                 : in     boolean;
          mode                  : in     bit_vector(7 downto 0);
          strobe                : in     boolean;
          signal_detect_ok      : in     boolean;
          mr_loopback           : in     boolean;
          code_group_is_valid   : in     boolean_array_type(3 downto 0);
          code_group_is_data    : in     boolean_array_type(3 downto 0);
          code_group_is_comma   : in     boolean_array_type(3 downto 0);
          sync_status_ok        : buffer boolean;
          errors                : buffer integer range 0 to 4);
  end component synchronisation_e;

  signal code_group_is_valid            : boolean_array_type(3 downto 0);  -- Is a valid code-group i.e. not /INVALID/
  signal code_group_is_valid_r1         : boolean_array_type(3 downto 0);  -- Retimed once
  signal code_group_is_data             : boolean_array_type(3 downto 0);  -- Is a data code-group  i.e. /D/
  signal code_group_is_data_r1          : boolean_array_type(3 downto 0);  -- Retimed once
  signal code_group_is_comma            : boolean_array_type(3 downto 0);  -- Is a comma code-group i.e. /COMMA/
  signal code_group_is_comma_r1         : boolean_array_type(3 downto 0);  -- Retimed once
  signal aligned_data                   : bit_vector(39 downto 0);         -- Slice (40 bit wide, code-group aligned)
  signal strobe                         : boolean;                         -- Enable for above (enable 4, disable 1)
  signal strobe_r1                      : boolean;                         -- Enable for above (enable 4, disable 1)
  signal starting_disparity_is_positive : boolean_array_type(3 downto 0);  -- Disparity into each ten bit monitor
  signal ending_disparity_is_positive   : boolean_array_type(3 downto 0);  -- Disparity out of each ten bit monitor
  signal errors                         : integer range 0 to 4;            -- Error count per clock cycle, up to 4
  signal freeze_r1                      : boolean;                         -- Retimed 'freeze' input
  signal update_counter_outputs         : boolean;                         -- Transfer the running error counts to the outputs

begin

  -- Instance PMA receiver
  pma_receive_1: pma_receive_e
    port map (clock        => clock,
              reset        => reset,
              mode         => mode,
              data_in      => data,
              data_out     => aligned_data,
              strobe       => strobe);

  -- Instance the four ten_bit_monitors, each operating on one of the code-groups in 'aligned_data'. Chain the
  -- disparity through each component starting at the earliest code-group.
  for_each_ten_bit_monitor: for i in 3 downto 0 generate
    ten_bit_monitor_1: ten_bit_monitor_e
      port map (mode                           => mode,
                code_group                     => aligned_data(i * 10 + 9 downto i * 10),
                starting_disparity_is_positive => starting_disparity_is_positive(i),
                code_group_is_valid            => code_group_is_valid(i),
                code_group_is_data             => code_group_is_data(i),
                code_group_is_comma            => code_group_is_comma(i),
                ending_disparity_is_positive   => ending_disparity_is_positive(i));
    -- Pass the disparity between components operating in the same clock cycle
    boundary_condition: if i < 3 generate
      starting_disparity_is_positive(i) <= ending_disparity_is_positive(i + 1);
    end generate boundary_condition;
  end generate for_each_ten_bit_monitor;

  -- The disparity for the earliest code-group is passed from the latest code-group from the previous clock cycle
  pass_disparity_on: process (reset, clock)
  begin
    if reset then
      starting_disparity_is_positive(3) <= false;
    elsif clock'event and (clock = '1') then
      if strobe then
        starting_disparity_is_positive(3) <= ending_disparity_is_positive(0);
      end if;
    end if;
  end process pass_disparity_on;

  -- Gather together the re-timing stages in one process
  signal_retiming : process (reset, clock)
  begin
    if reset then
      strobe_r1              <= false;
      code_group_is_valid_r1 <= (others => false);
      code_group_is_data_r1  <= (others => false);
      code_group_is_comma_r1 <= (others => false);
      freeze_r1              <= false;
      update_counter_outputs <= false;
    elsif clock'event and (clock = '1') then
      strobe_r1              <= strobe;
      code_group_is_valid_r1 <= code_group_is_valid;
      code_group_is_data_r1  <= code_group_is_data;
      code_group_is_comma_r1 <= code_group_is_comma;
      freeze_r1              <= freeze;
      update_counter_outputs <= freeze and not freeze_r1;
    end if;
  end process signal_retiming;

  -- Instance the Synchronisation state machine
  synchronisation_1: synchronisation_e
    port map (clock                 => clock,
              reset                 => reset,
              mode                  => mode,
              strobe                => strobe_r1,
              signal_detect_ok      => signal_detect_ok,
              mr_loopback           => mr_loopback,
              code_group_is_valid   => code_group_is_valid_r1,
              code_group_is_data    => code_group_is_data_r1,
              code_group_is_comma   => code_group_is_comma_r1,
              sync_status_ok        => sync_status_ok,
              errors                => errors);

  -- Count errors
  -- The count read by software is designed to be a rolling count which does not cycle around completely in the polling
  -- interval. The working count is reset at each software read and stops at all 1s. When a software read occurs (freeze),
  -- the process adds the new count to the previous software count. This means that in each polling interval, the error
  -- count 'tops out' at the maximum count afforded by the counter width.
  -- Note that 'errors' is forced to '0' when there is no strobe, so this process can run at every clock.
  error_counter: process (reset, clock)
    constant terminal_count  : bit_vector(code_error_count_width - 1 downto 0) := (others => '1'); -- all 1s
    -- Declare these counts one bit wider than the code_error_count so that a top bit carry can be detected.
    variable count           : bit_vector(code_error_count_width downto 0);                        -- The working count
    variable potential_count : bit_vector(code_error_count_width downto 0);                        -- The potential count
  begin
    if reset then
      count            := (others => '0');
      code_error_count <= (others => '0');
    elsif clock'event and (clock = '1') then
      -- Determine the potential new count
      potential_count := count + errors;
      -- If it is greater than the counter terminal count (carry = '1'), then stop at the terminal count
      if potential_count(code_error_count_width) = '1' then
        count := '0' & terminal_count;
      else
        count := potential_count;
      end if;
      -- Update the count when software asserts the 'freeze'
      if update_counter_outputs then
        -- Software wants a rolling count, not the interval count
        code_error_count <= code_error_count + count(code_error_count_width - 1 downto 0);
        -- Reset working count
        count := (others => '0');
      end if;
    end if;
  end process error_counter;

  -- Count errored 'blocks'
  -- Note that 'errors' is forced to '0' when there is no strobe, so this process can run at every clock.
  block_error_counter: process (reset, clock)
    variable count        : bit_vector(block_error_count_width - 1 downto 0); -- The working block error count
    variable error_flag   : boolean;                                          -- Set if any error occurs during a block period
  begin
    if reset then
      count             := (others => '0');
      error_flag        := false;
      block_error_count <= (others => '0');
    elsif clock'event and (clock = '1') then
      -- Set error flag for any error
      if errors > 0 then
        error_flag := true;
      end if;
      -- At each block period boundary
      if block_strobe then
        -- Increment the block error count if the flag is set
        if error_flag then
          count := count + 1;
        end if;
        -- Reset the error flag for the next block period
        error_flag := false;
      end if;
      -- Capture the current working count when software asserts the 'freeze'
      if update_counter_outputs then
        block_error_count <= count;
      end if;
    end if;
  end process block_error_counter;

end architecture monitor_8b10b_core_a;
