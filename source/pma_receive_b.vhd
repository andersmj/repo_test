----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--
--      Title           : 8b10b Code-Word Aligner
--
--      Author(s)       : Steve Betteley
--
--      Version         : @(#)pma_receive_b.vhd	1.15
--                        The version number is maintained by XEmacs Version Control, and is based on SCCS.
--                        Use 'C-x v l' to view version history. Previous history is in 'SCCS/aligner_b.vhd'.
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
-- This is essentially three functions in series:
--
--  1. Widen the input data from 32-bits to 40-bits (the 'widen_to_40_bits' process).
--  2. Search for comma alignment (see the functions 'comma_positive_detected', 'comma_positive_detected' and 'alignment').
--  3. Re-align the 40-bit data on a 10-bit boundary (the 'align_data' process).
--
-- In step 1, the 'intermediate_data' is passed on as a 49-bit vector rather than 40-bit; this is so that, in step 2, a 10-bit
-- comma pattern can be looked for in bit position 39.
--
-- In step 2, comma patterns found last, (the lower vector indices represent the most recently received bits), take precedence
-- over earlier detections.
--
-- Note that should a data error occur during a frame such that a comma pattern is aliased, then the alignment may be thrown
-- out for the remainder of the frame until alignment is regained at the next /T/,/I/ or /C/ ordered set e.g. between frames.
--

architecture pma_receive_b of pma_receive_e is

  signal data_in_history      : bit_vector(72 downto 0);   -- Data_in with back history to 73 bits
  signal intermediate_data    : bit_vector(48 downto 0);   -- Data converted to unaligned 40 bits, includes 9 bits back history
  signal phase                : bit_vector(2 downto 0);    -- Data_out phase
  signal alignment_position   : bit_vector(3 downto 0);    -- Alignment bit position

begin

  -- Barrel Shift, 32-bits to 40-bits. Data remains unaligned.
  widen_to_40_bits: process (reset, clock)
    variable data : bit_vector(72 downto 0); -- temporary data
  begin
    if reset then
      data_in_history   <= (others => '0');
      intermediate_data <= (others => '0');
      phase             <= "000";
      data              := (others => '0');
    elsif clock'event and clock = '1' then
      -- Assemble a back history
      data_in_history (72 downto 64) <= data_in_history (40 downto 32);
      data_in_history (63 downto 32) <= data_in_history (31 downto 0);
      data_in_history (31 downto 0)  <= data_in;
      -- To match the input rate, the data output has 4 valid phases, count 0 to 4
      if phase = "100" then
        phase <= "000";
      else
        phase <= phase + 1;
      end if;
      -- For valid phases, implement a barrel shift to convert the data width.
      -- To convert 32 bits to 40 bits, then shifts of 0, 8, 16, and 24 are needed.
      --     phase  shift
      --      000    24
      --      001    16
      --      010     8
      --      011     0
      --      100   null
      if (phase(2) = '0') then
        data := data_in_history;
        -- 8 bit shift
        if phase(0) = '0' then
          data := X"00" & data(72 downto 8);
        end if;
        -- 16 bit shift
        if phase(1) = '0' then
          data := X"0000" & data(72 downto 16);
        end if;
        intermediate_data <= data(48 downto 0);
      end if;
    end if;
  end process widen_to_40_bits;
     
  -- Search for the comma pattern in all bit positions, and re-align the data accordingly.
  align_data: process (reset, clock)
    variable data : bit_vector (48 downto 0);  -- temporary data
  begin
    if reset then
      data               := (others => '0');
      alignment_position <= "0000";
      data_out           <= (others => '0');
      strobe             <= false;
    elsif clock'event and clock = '1' then
      -- Look for a comma starting in any one position of the input data, and set the consequent
      -- alignment. Refer to the package for the behaviour of the functions.
      if mode(0) = '0' then
        -- For IEEE802.3, alignment is specified on comma+ only
        if comma_positive_detected(intermediate_data) then
          alignment_position <= alignment(intermediate_data, comma_positive);
        end if;
      else
        -- For fibrechannel, look for any polarity of comma
        if comma_negative_detected(intermediate_data) then
          alignment_position <= alignment(intermediate_data, comma_negative);
        end if;
        if comma_positive_detected(intermediate_data) then
          alignment_position <= alignment(intermediate_data, comma_positive);
        end if;
      end if;
      -- Skip past invalid phases
      if phase /= "000" then
        -- A shift of between 0 and 9 is required
        data := intermediate_data;
        -- 1 bit shift
        if alignment_position(0) = '1' then
          data := '0' & data(48 downto 1);
        end if;
        -- 2 bit shift
        if alignment_position(1) = '1' then
          data := "00" & data(48 downto 2);
        end if;
        -- 4 bit shift
        if alignment_position(2) = '1' then
          data := X"0" & data(48 downto 4);
        end if;
        -- 8 bit shift
        if alignment_position(3) = '1' then
          data := X"00" & data(48 downto 8);
        end if;
        data_out <= data(39 downto 0);
        strobe   <= true;
      else
        strobe   <= false;
      end if;
    end if;
  end process align_data;

end architecture pma_receive_b;
