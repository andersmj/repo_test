----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--
--      Title           : PCS Synchronisation State Diagram
--
--      Author(s)       : Steve Betteley
--
--      Version         : @(#)synchronisation_b.vhd	1.17
--                        The version number is maintained by XEmacs Version Control, and is based on SCCS.
--                        Use 'C-x v l' to view version history. Previous history is in 'SCCS/aligner_e.vhd'.
--
--      Glossary        : PCS - Physical Coding Sublayer (see reference 1)
--
--      References        1. IEEE Std 802.3-2002 Section 3, clause 36.
--                        2. ANSI X3.230-1994 clauses 11 and 12.
--
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--
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
--
-- Design Description
-- ~~~~~~~~~~~~~~~~~~
--
-- This block contains two 8B10B state machines, one appropriate for a Gigabit Ethernet client format, an one for a Fibrechannel
-- client format. Each state machine generates a 'synchronisation' status, and an error count. Only one state machine is selected
-- by the 'Mode' input.
-- 
-- Requires declarations from 'monitor_8b10b_p.vhd'.
--
-- The 'pcs_synchronisation_state_diagram' process implements section 36.2.5.2.6, reference 1, and generates the synchronisation
-- status of the link, 'sync_status_ok', by detecting the requisite number of commas. The state machine is traversed four times
-- per clock cycle, once for each code-group in the 'aligned data'. An 'errors' output indicates how many errors are detected per
-- clock cycles, up to four are possible.
--
-- The 'fibrechannel_synchronisation_procedure' process implements the 'transmission word synchronisation' and 'Loss of
-- Synchronisation' procedures from reference 2 sections 12.1.2 and 12.1.3. This is a simpler state machine which operates at the
-- 40-bit (transmission word) granularity. In the specification, the transmission words are aligned with comma characters in the
-- leftmost position, but in this design allows them to be in any position as long as they recur in the same position next time.
-- This state machine can only generate one error per clock cycle.
-- 

architecture synchronisation_b of synchronisation_e is


  -- Functional inter-process signals
  signal gbe_sync_status_ok         : boolean;                -- Synchronisation status from the Gigabit Ethernet state machine
  signal gbe_errors                 : integer range 0 to 4;   -- Code Violation error count from the Gigabit Ethernet state machine
  signal fc_sync_status_ok          : boolean;                -- Synchronisation status from the Fibrechannel state machine
  signal fc_errors                  : integer range 0 to 4;   -- Code Violation error count from the Fibrechannel state machine
  signal strobe_r1                  : boolean;                -- Retimed once

  -- Signals used during design debugging, not needed for the block to function
  signal debug_gbe_state            : gigabit_ethernet_state_type;
  signal debug_good_cgs             : integer range 0 to 3;
  signal debug_rx_even              : boolean;
  signal debug_all_characters_valid : boolean;
  signal debug_valid_data_word      : boolean;
  signal debug_comma_word           : boolean;
  signal debug_valid_comma_word     : boolean;
  signal debug_comma_alignment      : boolean_array_type(3 downto 0);
  signal debug_invalid_word         : boolean;
  signal debug_state                : fibrechannel_state_type;
  signal debug_count                : integer range 0 to 3;


begin


  -- Implement the Gigabit Ethernet PCS synchronisation state diagram, figure 36-9 from reference 1.
  pcs_synchronisation_state_diagram : process (reset, clock)
    variable state        : gigabit_ethernet_state_type; -- State variable.
    variable sync_status  : sync_status_type;            -- Synchronisation status of the link.
    variable rx_even      : boolean;                     -- Designates code-groups as either even or odd.
    variable good_cgs     : integer range 0 to 3;        -- Count of consecutive valid code-groups.
    variable error_count  : integer range 0 to 4;        -- Counts errors per clock cycle
  begin
    -- Set initial states
    if reset then
      state              := LOSS_OF_SYNC;
      sync_status        := FAIL;
      rx_even            := false;
      good_cgs           := 0;
      gbe_sync_status_ok <= false;
      gbe_errors         <= 0;
    elsif clock'event and clock = '1' then
      if strobe then
        -- Accumulate up to four errors each clock cycle, one for each 10-bit code-group
        error_count := 0;
        -- If there is no line signal (LOS) and it is not due to a loopback, then stay in the loss of sync state
        if (not signal_detect_ok) and (not mr_loopback) then
          state       := LOSS_OF_SYNC;
          sync_status := FAIL;
        -- Otherwise respond to the data on the line
        else
          -- Iterate four times around the state machine, once for each 10-bit code-group in the
          -- 40-bit data
          process_each_code_group: for i in 3 downto 0 loop
            case state is
              when LOSS_OF_SYNC =>
                sync_status := FAIL;
                rx_even     := not rx_even;
                if code_group_is_comma(i) then
                  state := COMMA_DETECT_1;
                end if;
              when COMMA_DETECT_1 =>
                rx_even := true;
                if code_group_is_data(i) then
                  state := ACQUIRE_SYNC_1;
                else
                  state := LOSS_OF_SYNC;
                end if;
              when ACQUIRE_SYNC_1 =>
                rx_even := not rx_even;
                if cgbad(code_group_is_valid(i), code_group_is_comma(i), rx_even) then
                  state       := LOSS_OF_SYNC;
                  error_count := error_count + 1;
                elsif (not rx_even) and code_group_is_comma(i) then
                  state := COMMA_DETECT_2;
                end if;
              when COMMA_DETECT_2 =>
                rx_even := true;
                if code_group_is_data(i) then
                  state := ACQUIRE_SYNC_2;
                else
                  state := LOSS_OF_SYNC;
                end if;
              when ACQUIRE_SYNC_2 =>
                rx_even := not rx_even;
                if cgbad(code_group_is_valid(i), code_group_is_comma(i), rx_even) then
                  state       := LOSS_OF_SYNC;
                  error_count := error_count + 1;
                elsif (not rx_even) and code_group_is_comma(i) then
                  state := COMMA_DETECT_3;
                end if;
              when COMMA_DETECT_3 =>
                rx_even := true;
                if code_group_is_data(i) then
                  state := SYNC_ACQUIRED_1;
                else
                  state := LOSS_OF_SYNC;
                end if;
              when SYNC_ACQUIRED_1 =>
                sync_status := OK;
                rx_even     := not rx_even;
                if cgbad(code_group_is_valid(i), code_group_is_comma(i), rx_even) then
                  state       := SYNC_ACQUIRED_2;
                  error_count := error_count + 1;
                end if;
              when SYNC_ACQUIRED_2 =>
                rx_even  := not rx_even;
                good_cgs := 0;
                if cggood(code_group_is_valid(i), code_group_is_comma(i), rx_even) then
                  state := SYNC_ACQUIRED_2A;
                elsif cgbad(code_group_is_valid(i), code_group_is_comma(i), rx_even) then
                  state       := SYNC_ACQUIRED_3;
                  error_count := error_count + 1;
                end if;
              when SYNC_ACQUIRED_2A =>
                rx_even  := not rx_even;
                good_cgs := good_cgs + 1;
                if cgbad(code_group_is_valid(i), code_group_is_comma(i), rx_even) then
                  state       := SYNC_ACQUIRED_3;
                  error_count := error_count + 1;
                elsif cggood(code_group_is_valid(i), code_group_is_comma(i), rx_even) and (good_cgs = 3) then
                  state := SYNC_ACQUIRED_1;
                end if;
              when SYNC_ACQUIRED_3 =>
                rx_even  := not rx_even;
                good_cgs := 0;
                if cggood(code_group_is_valid(i), code_group_is_comma(i), rx_even) then
                  state := SYNC_ACQUIRED_3A;
                elsif cgbad(code_group_is_valid(i), code_group_is_comma(i), rx_even) then
                  state       := SYNC_ACQUIRED_4;
                  error_count := error_count + 1;
                end if;
              when SYNC_ACQUIRED_3A =>
                rx_even  := not rx_even;
                good_cgs := good_cgs + 1;
                if cgbad(code_group_is_valid(i), code_group_is_comma(i), rx_even) then
                  state       := SYNC_ACQUIRED_4;
                  error_count := error_count + 1;
                elsif cggood(code_group_is_valid(i), code_group_is_comma(i), rx_even) and (good_cgs = 3) then
                  state := SYNC_ACQUIRED_2;
                end if;
              when SYNC_ACQUIRED_4 =>
                rx_even  := not rx_even;
                good_cgs := 0;
                if cggood(code_group_is_valid(i), code_group_is_comma(i), rx_even) then
                  state := SYNC_ACQUIRED_4A;
                elsif cgbad(code_group_is_valid(i), code_group_is_comma(i), rx_even) then
                  state       := LOSS_OF_SYNC;
                  error_count := error_count + 1;
                end if;
              when SYNC_ACQUIRED_4A =>
                rx_even  := not rx_even;
                good_cgs := good_cgs + 1;
                if cgbad(code_group_is_valid(i), code_group_is_comma(i), rx_even) then
                  state       := LOSS_OF_SYNC;
                  error_count := error_count + 1;
                elsif cggood(code_group_is_valid(i), code_group_is_comma(i), rx_even) and (good_cgs = 3) then
                  state := SYNC_ACQUIRED_3;
                end if;
            end case;
          end loop process_each_code_group;
        end if; -- (not signal_detect_ok) and (not mr_loopback)
        gbe_sync_status_ok <= (sync_status = OK);      -- Drive output
        gbe_errors         <= error_count;             -- Drive output
      end if;  -- strobe
      debug_gbe_state    <= state;
      debug_rx_even      <= rx_even;
      debug_good_cgs     <= good_cgs;
    end if;  -- clock'event and clock = '1'
  end process pcs_synchronisation_state_diagram;


  -- Implement the synchronisation procedures from reference 2.
  fibrechannel_synchronisation_procedure : process (reset, clock)
    variable all_characters_valid : boolean;                         -- All four 8B10B characters are valid codes
    variable valid_data_word      : boolean;                         -- The transmission word is a valid data word
    variable comma_word           : boolean;                         -- A valid comma character appears in one character position
    variable valid_comma_word     : boolean;                         -- Valid comma containing transmission word
    variable invalid_word         : boolean;                         -- Transmission word is not valid
    variable comma_alignment      : boolean_array_type(3 downto 0);  -- Stored value of the comma character position
    variable state                : fibrechannel_state_type;         -- Synchronisation state machine variable.
    variable count                : integer range 0 to 3;            -- Count of transmission words
  begin
    -- Set initial states
    if reset then
      all_characters_valid := false;
      valid_data_word      := false;
      comma_word           := false;
      valid_comma_word     := false;
      invalid_word         := false;
      comma_alignment      := (others => false);
      state                := state_e;
      count                := 0;
      fc_sync_status_ok    <= false;
      fc_errors            <= 0;
    elsif clock'event and clock = '1' then
      -- Implement the 'Invalid Transmission Word' rules. Each character (code-group) must be valid, and there must not be more
      -- than one special character in the transmission word. The special character must be in the leftmost character position. In
      -- practice, it is sufficient to test that it occurs in the same character position because an error would occur in the next
      -- clock cycle.
      -- A pre-requisite is that all characters must themselves be valid 8B10B codes
      all_characters_valid := (code_group_is_valid = (true, true, true, true));
      -- A transmission word is a valid data word if all characters are valid and none contains a comma
      valid_data_word  := all_characters_valid and (code_group_is_comma = (false, false, false, false));
      -- A transmission word is a potentially valid comma word if there is one and only one comma in the word.
      comma_word := (all_characters_valid                                   ) and
                    ((code_group_is_comma = ( true, false, false, false)) or
                     (code_group_is_comma = (false,  true, false, false)) or
                     (code_group_is_comma = (false, false,  true, false)) or
                     (code_group_is_comma = (false, false, false,  true))   );
      -- A comma word is valid when the position of the comma containing character occurs in the same position as the last time
      valid_comma_word := comma_word and (code_group_is_comma = comma_alignment);
      -- A invalid word is neither a valid data word nor a valid comma containing word
      invalid_word := not (valid_data_word or valid_comma_word);
      -- Operate at the data strobe
      if strobe then
        -- Store the current character position of any comma word
        if comma_word then
          comma_alignment := code_group_is_comma;
        end if;
        -- If there is no line signal (LOS) and it is not due to a loopback, then stay in the loss of sync state
        if (not signal_detect_ok) and (not mr_loopback) then
          state := state_e;
          count := 0;
        -- Otherwise respond to the data on the line
        else
          case state is
            -- Loss-of-Sync (First-Invalid-Transmission Detected)
            when state_e =>
              if valid_comma_word then
                count := count + 1;
              elsif invalid_word then
                count := 0;
              end if;
              -- Sync Acquired when 3 valid comma words have been received
              if count = 3 then
                state := state_a;
                count := 0;
              end if;
            -- No-Invalid-Transmission Detected
            when state_a =>
              if invalid_word then
                state := state_b;
                count := 0;
              end if;
            -- First-Invalid-Transmission Detected
            when state_b =>
              if invalid_word then
                state := state_c;
                count := 0;
              else
                count := count + 1;
              end if;
              -- Reprieved if two good words are received
              if count = 2 then
                state := state_a;
                count := 0;
              end if;
            -- Second-Invalid-Transmission Detected
            when state_c =>
              if invalid_word then
                state := state_d;
                count := 0;
              else
                count := count + 1;
              end if;
              if count = 2 then
                state := state_b;
                count := 0;
              end if;
            -- Third-Invalid-Transmission Detected
            when state_d =>
              if invalid_word then
                state := state_e;
                count := 0;
              else
                count := count + 1;
              end if;
              if count = 2 then
                state := state_c;
                count := 0;
              end if;
          end case;
        end if; -- (not signal_detect_ok) and (not mr_loopback)
        -- Sync Acquired state is any state other than state_e
        fc_sync_status_ok <= (state /= state_e);
        -- Signal one code-violation error per invalid word
        if (state /= state_e) and invalid_word then
          fc_errors <= 1;
        else
          fc_errors <= 0;
        end if;
      end if;  -- strobe
      debug_all_characters_valid <= all_characters_valid;
      debug_valid_data_word      <= valid_data_word;
      debug_comma_word           <= comma_word;
      debug_valid_comma_word     <= valid_comma_word;
      debug_comma_alignment      <= comma_alignment;
      debug_invalid_word         <= invalid_word;
      debug_state                <= state;
      debug_count                <= count;
    end if;  -- clock'event and clock = '1'
  end process fibrechannel_synchronisation_procedure;


  -- Select either the Gigabit Ethernet or the Fibrechannel state machine outputs
  generate_outputs : process (reset, clock)
  begin
    -- Set initial states
    if reset then
      errors         <= 0;
      sync_status_ok <= false;
      strobe_r1      <= false;
    elsif clock'event and clock = '1' then
      strobe_r1 <= strobe;
      if strobe_r1 then
        if (mode(1) = '0') then
          errors         <= gbe_errors;
          sync_status_ok <= gbe_sync_status_ok;
        else
          errors         <= fc_errors;
          sync_status_ok <= fc_sync_status_ok;
        end if;
      else
        -- Force errors to be 0 when strobe is not true; this allows the error counters
        -- to run at every clock.
        errors <= 0;
      end if;
    end if;
  end process generate_outputs;
  

end architecture synchronisation_b;
