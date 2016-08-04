----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--
--      Author(s)       : Steve Betteley
--
--      Version         : @(#)monitor_8b10b_p.vhd	1.21
--                        The version number is maintained by XEmacs Version Control, and is based on SCCS.
--
--      Remarks         : This file contains declarations specific to the 'Monitor_8b10b' design.
-- 
--      References      : 1. IEEE Std 802.3-2002
--
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- This is an unpublished work the copyright in which vests in
-- Marconi Communications LIMITED ("Marconi Communications"). All rights reserved.
-- 
-- The information contained herein is confidential and the
-- property of Marconi Communications and is supplied without liability for errors
-- or omissions. No part may be reproduced, disclosed or used
-- except as authorised by contract or other written permission.
-- The copyright and the foregoing restriction on reproduction
-- and use extend to all media in which the information may be
-- embodied.
--
-- New Century Park, PO Box 53, Coventry. England. CV3 1HJ
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;

package monitor_8b10b_p is

  ----------------------------------------------------------------------------------------------------------------------------------
  -- 'USEFUL' DECLARATIONS
  ----------------------------------------------------------------------------------------------------------------------------------

  type boolean_array_type is array (integer range <>) of boolean;
  
  function as_boolean (s : std_logic) return boolean;
  
  function as_std_logic (b : boolean) return std_logic;
  
  function "+" (v1, v2 : bit_vector) return bit_vector;
  
  function "+" (v : bit_vector; i : integer) return bit_vector;

  function "-" (v : bit_vector; i : integer) return bit_vector;
    
  function as_bit_vector(i, len: integer) return bit_vector;

  ----------------------------------------------------------------------------------------------------------------------------------
  -- DESIGN SPECIFIC DECLARATIONS
  ----------------------------------------------------------------------------------------------------------------------------------

  -- Enumerate the states for the Gigabit Ethernet PCS synchronisation state machine
  type gigabit_ethernet_state_type is (LOSS_OF_SYNC,
                                       COMMA_DETECT_1,
                                       ACQUIRE_SYNC_1,
                                       COMMA_DETECT_2,
                                       ACQUIRE_SYNC_2,
                                       COMMA_DETECT_3,
                                       SYNC_ACQUIRED_1,
                                       SYNC_ACQUIRED_2,
                                       SYNC_ACQUIRED_2A,
                                       SYNC_ACQUIRED_3,
                                       SYNC_ACQUIRED_3A,
                                       SYNC_ACQUIRED_4,
                                       SYNC_ACQUIRED_4A);

  -- Enumerate the states for the Fibrechannel synchronisation state machine
  type fibrechannel_state_type is (state_e,  -- Loss-of-Synch (Fourth-Invalid-Transmission-Word detection)
                                   state_a,  -- No-Invalid-Transmission-Word detection
                                   state_b,  -- First-Invalid-Transmission-Word detection
                                   state_c,  -- Second-Invalid-Transmission-Word detection
                                   state_d); -- Third-Invalid-Transmission-Word detection

  -- Values for the 'sync_status' variable in the Synchronisation State Machine
  type sync_status_type is (FAIL, OK);
  
  -- The comma+ pattern found in K28.1, K28.5 or K28.7
  constant comma_positive : bit_vector(6 downto 0) := "0011111";

  -- The comma- pattern found in K28.1, K28.5 or K28.7
  constant comma_negative : bit_vector(6 downto 0) := "1100000";

  -- Function calculates the ending disparity (true =  positive disparity) of a 4 bit code-group sub-block.
  function disparity_4_bits (starting_disparity_is_positive : boolean;
                             code_group                     : bit_vector(3 downto 0)) return boolean;
  
  -- Function calculates the ending disparity (true =  positive disparity) of a 6 bit code-group sub-block.
  function disparity_6_bits (starting_disparity_is_positive : boolean;
                             code_group                     : bit_vector(5 downto 0)) return boolean;

  -- Return 'true' if the code-group exists in the positive disparity column of Reference 1, Table 36-1
  function is_positive_data_code_group (code_group : bit_vector(9 downto 0)) return boolean;

  -- Return 'true' if the code-group exists in the negative disparity column of Reference 1, Table 36-1
  function is_negative_data_code_group (code_group : bit_vector(9 downto 0)) return boolean;

  -- Return 'true' if the code-group exists in the positive disparity column of Reference 1, Table 36-2
  function is_positive_special_code_group (code_group : bit_vector(9 downto 0)) return boolean;

  -- Return 'true' if the code-group exists in the negative disparity column of Reference 1, Table 36-2
  function is_negative_special_code_group (code_group : bit_vector(9 downto 0)) return boolean;

  -- Return 'true' if the code-group contains a comma, note 2 in the positive disparity column of Reference 1, Table 36-2
  function is_positive_comma (code_group : bit_vector(9 downto 0)) return boolean;

  -- Return 'true' if the code-group contains a comma, note 2 in the negative disparity column of Reference 1, Table 36-2
  function is_negative_comma (code_group : bit_vector(9 downto 0)) return boolean;

  -- Function searches for a comma 'pattern' in any of 40 possible bit positions 0 to 39, and returns the consequent
  -- alignment position between 0 and 9 (expressed as a bit vector). Returns "1111" if none found. Function allows to
  -- search for a comma+ or a comma- 'pattern'.
  function alignment (data    : bit_vector(48 downto 0);
                      pattern : bit_vector( 6 downto 0)) return bit_vector;

  -- Function returns 'true' if a comma+ is found in any of the 40 possible bit positions 0 to 39.
  function comma_positive_detected (data : bit_vector(48 downto 0)) return boolean;

  -- Function returns 'true' if any comma- is found in any of the 40 possible bit positions 0 to 39.
  function comma_negative_detected (data : bit_vector(48 downto 0)) return boolean;

  -- The 'cgbad' function as specified in reference 1. 'is_valid' and 'is_comma' relate to the status of a code-group, and
  -- 'rx_even' is the state machine variable as specified in the synchronisation state diagram, Figure 36-9, of reference 1.
  function cgbad (is_valid : boolean;
                  is_comma : boolean;
                  rx_even  : boolean) return boolean;

  -- The 'cggood' function as specified in reference 1. 'is_valid' and 'is_comma' relate to the status of a code-group, and
  -- 'rx_even' is the state machine variable as specified in the synchronisation state diagram, Figure 36-9, of reference 1.
  function cggood (is_valid : boolean;
                   is_comma : boolean;
                   rx_even  : boolean) return boolean;
                  
end monitor_8b10b_p ;


package body monitor_8b10b_p is

  ----------------------------------------------------------------------------------------------------------------------------------
  -- 'USEFUL' DECLARATIONS
  ----------------------------------------------------------------------------------------------------------------------------------

  function as_boolean (s : std_logic) return boolean is
  begin
    case s is
      when '1'    => return true ;
      when others => return false ;
    end case ;
  end;

  function as_std_logic (b: boolean) return std_logic is
  begin
    if b = false then
      return '0';
    else
      return '1';
    end if;
  end;

  -- Overloaded bit_vector addition
  function "+" (v1, v2 : bit_vector) return bit_vector is
    variable len    : integer;
    alias v1a       : bit_vector(v1'length -1 downto 0) is v1;
    alias v2a       : bit_vector(v2'length -1 downto 0) is v2;
    variable result : bit_vector(v1'length + v2'length -1 downto 0) := (v1'length + v2'length -1 downto 0 => '0');
    variable carry  : bit := '0';        -- carry or borrow
    variable sum    : bit := '0';        -- sum or difference
  begin
    -- determine length of result vector.
    if v1'length > v2'length then
      len := v1'length;
    else
      len := v2'length;
    end if;
    -- the addition loop
    for i in 0 to len - 1 loop
      sum := carry;
      if i < v1'length then
        sum   := carry xor v1a(i);
        carry := carry and v1a(i);
      else
        carry := '0';
      end if;
      if i < v2'length then
        carry := carry or (sum and v2a(i));
        sum   := sum xor v2a(i);
      end if;
      result(i) := sum;
    end loop;
    return result(len - 1 downto 0);
  end;

  -- Overloaded bit_vector subtraction
  function "-" (v1, v2 : bit_vector) return bit_vector is
    variable len    : integer;
    alias v1a       : bit_vector(v1'length -1 downto 0) is v1;
    alias v2a       : bit_vector(v2'length -1 downto 0) is v2;
    variable result : bit_vector(v1'length + v2'length -1 downto 0) := (v1'length + v2'length -1 downto 0 => '0');
    variable carry : bit := '0';        -- carry or borrow
    variable sum   : bit := '0';        -- sum or difference
  begin
    -- determine length of result vector.
    if v1'length > v2'length then
      len := v1'length;
    else
      len := v2'length;
    end if;
    for i in 0 to len -1 loop
      sum := carry ;
      -- the subtraction loop
      if i < v1'length then
        sum   := carry xor v1a(i);
        carry := carry and not v1a(i);
      end if;
      if i < v2'length then
        sum   := sum xor v2a(i);
        carry := carry or (not sum and v2a(i));
      end if;
      result(i) := sum;
    end loop;
    return result(len - 1 downto 0);         
  end;

  -- Determine the number of bits needed to represent
  -- an integer value in twos-complement notation. The
  -- number of bits returned does not include the sign
  -- bit unless the number is negative and not the
  -- negative of a power of two.
  function length(i : integer) return integer is
    variable int        : integer := i;
    variable complement : integer;
    variable bits       : integer;
  begin
    -- Calculate absolute value of integer, initializing the
    -- complement value.
    if int < 0 then
      complement := 1;
      int := -(int + 1);
    else
      complement := 0;
    end if;
    -- Determine the number of bits
    bits := 0;
    while int > 0 loop
      bits := bits + 1;
      int  := int / 2;
    end loop;
    if bits = 0 then
      bits := 1;
    end if;
    if complement = 0 then
      return bits;
    else
      return bits + 1;
    end if;
  end;


  -- Conversion function integer to bit_vector
  function as_bit_vector(i, len: integer) return bit_vector is 
    variable int        : integer := i;
    variable result     : bit_vector(len-1 downto 0);
    variable complement : boolean;
  begin
    -- Convert integer to one's-complement absolute value, saving
    -- the complement flag as well.
    if int < 0 then
      complement := true;
      int := -(int + 1);
    else
      complement := false;
    end if;
    -- Calculate the unsigned vector.
    for j in result'reverse_range loop
      if ((int rem 2) = 1) = complement then
        result(j) := '0';
      else
        result(j) := '1';
      end if;
      int := int/2;
    end loop;
    return result;
  end function as_bit_vector ;


  function "+" (v: bit_vector; i: integer) return bit_vector is
  begin
    -- synopsys translate_off
    assert length(i) <= v'length report "overflow";
    -- synopsys translate_on
    return v + as_bit_vector(i, v'length) ;
  end;


  function "-" (v: bit_vector; i: integer) return bit_vector is
  begin
    -- synopsys translate_off
    assert length(i) <= v'length report "overflow";
    -- synopsys translate_on
    return v - as_bit_vector(i, v'length) ;
  end;


  ----------------------------------------------------------------------------------------------------------------------------------
  -- DESIGN SPECIFIC DECLARATIONS
  ----------------------------------------------------------------------------------------------------------------------------------

  function disparity_4_bits (starting_disparity_is_positive : boolean;
                             code_group                     : bit_vector(3 downto 0)) return boolean is
    -- d = -1 represents negative running disparity
    -- d = +1 represents positive running disparity    
    -- d =  0 represents no change to the disparity    
    variable d : integer range -1 to +1;
  begin
    -- Implement the disparity rules from reference 1
    case code_group is
      when "0000" => d := -1;
      when "0001" => d := -1;
      when "0010" => d := -1;
      when "0011" => d := +1;
      when "0100" => d := -1;
      when "0101" => d :=  0;
      when "0110" => d :=  0;
      when "0111" => d := +1;
      when "1000" => d := -1;
      when "1001" => d :=  0;
      when "1010" => d :=  0;
      when "1011" => d := +1;
      when "1100" => d := -1;
      when "1101" => d := +1;
      when "1110" => d := +1;
      when "1111" => d := +1;
    end case;
    -- Return 'true' for positive disparity, 'false' for negative disparity
    if d /= 0 then
      return (d = +1);
    else
      return starting_disparity_is_positive;
    end if;
  end function disparity_4_bits;


  function disparity_6_bits (starting_disparity_is_positive : boolean;
                             code_group                     : bit_vector(5 downto 0)) return boolean is
    -- d = -1 represents negative running disparity
    -- d = +1 represents positive running disparity    
    -- d =  0 represents no change to the disparity    
    variable d : integer range -1 to +1;       
  begin
    -- Implement the disparity rules from reference 1
    case code_group is
      when "000000" => d := -1;
      when "000001" => d := -1;
      when "000010" => d := -1;
      when "000011" => d := -1;
      when "000100" => d := -1;
      when "000101" => d := -1;
      when "000110" => d := -1;
      when "000111" => d := +1;
      when "001000" => d := -1;
      when "001001" => d := -1;
      when "001010" => d := -1;
      when "001011" => d :=  0;
      when "001100" => d := -1;
      when "001101" => d :=  0;
      when "001110" => d :=  0;
      when "001111" => d := +1;
      when "010000" => d := -1;
      when "010001" => d := -1;
      when "010010" => d := -1;
      when "010011" => d :=  0;
      when "010100" => d := -1;
      when "010101" => d :=  0;
      when "010110" => d :=  0;
      when "010111" => d := +1;
      when "011000" => d := -1;
      when "011001" => d :=  0;
      when "011010" => d :=  0;
      when "011011" => d := +1;
      when "011100" => d :=  0;
      when "011101" => d := +1;
      when "011110" => d := +1;
      when "011111" => d := +1;
      when "100000" => d := -1;
      when "100001" => d := -1;
      when "100010" => d := -1;
      when "100011" => d :=  0;
      when "100100" => d := -1;
      when "100101" => d :=  0;
      when "100110" => d :=  0;
      when "100111" => d := +1;
      when "101000" => d := -1;
      when "101001" => d :=  0;
      when "101010" => d :=  0;
      when "101011" => d := +1;
      when "101100" => d :=  0;
      when "101101" => d := +1;
      when "101110" => d := +1;
      when "101111" => d := +1;
      when "110000" => d := -1;
      when "110001" => d :=  0;
      when "110010" => d :=  0;
      when "110011" => d := +1;
      when "110100" => d :=  0;
      when "110101" => d := +1;
      when "110110" => d := +1;
      when "110111" => d := +1;
      when "111000" => d := -1;
      when "111001" => d := +1;
      when "111010" => d := +1;
      when "111011" => d := +1;
      when "111100" => d := +1;
      when "111101" => d := +1;
      when "111110" => d := +1;
      when "111111" => d := +1;                       
    end case;
    -- Return 'true' for positive disparity, 'false' for negative disparity
    if d /= 0 then
      return (d = +1);
    else
      return starting_disparity_is_positive;
    end if;
  end function disparity_6_bits;


  function is_positive_data_code_group (code_group : bit_vector(9 downto 0)) return boolean is
  begin
    -- Straightforward lookup
    case code_group is
      --    abcdeifghj
      when "0110001011" => return true;
      when "1000101011" => return true;
      when "0100101011" => return true;
      when "1100010100" => return true;
      when "0010101011" => return true;
      when "1010010100" => return true;
      when "0110010100" => return true;
      when "0001110100" => return true;
      when "0001101011" => return true;
      when "1001010100" => return true;
      when "0101010100" => return true;
      when "1101000100" => return true;
      when "0011010100" => return true;
      when "1011000100" => return true;
      when "0111000100" => return true;
      when "1010001011" => return true;
      when "1001001011" => return true;
      when "1000110100" => return true;
      when "0100110100" => return true;
      when "1100100100" => return true;
      when "0010110100" => return true;
      when "1010100100" => return true;
      when "0110100100" => return true;
      when "0001011011" => return true;
      when "0011001011" => return true;
      when "1001100100" => return true;
      when "0101100100" => return true;
      when "0010011011" => return true;
      when "0011100100" => return true;
      when "0100011011" => return true;
      when "1000011011" => return true;
      when "0101001011" => return true;
      when "0110001001" => return true;
      when "1000101001" => return true;
      when "0100101001" => return true;
      when "1100011001" => return true;
      when "0010101001" => return true;
      when "1010011001" => return true;
      when "0110011001" => return true;
      when "0001111001" => return true;
      when "0001101001" => return true;
      when "1001011001" => return true;
      when "0101011001" => return true;
      when "1101001001" => return true;
      when "0011011001" => return true;
      when "1011001001" => return true;
      when "0111001001" => return true;
      when "1010001001" => return true;
      when "1001001001" => return true;
      when "1000111001" => return true;
      when "0100111001" => return true;
      when "1100101001" => return true;
      when "0010111001" => return true;
      when "1010101001" => return true;
      when "0110101001" => return true;
      when "0001011001" => return true;
      when "0011001001" => return true;
      when "1001101001" => return true;
      when "0101101001" => return true;
      when "0010011001" => return true;
      when "0011101001" => return true;
      when "0100011001" => return true;
      when "1000011001" => return true;
      when "0101001001" => return true;
      when "0110000101" => return true;
      when "1000100101" => return true;
      when "0100100101" => return true;
      when "1100010101" => return true;
      when "0010100101" => return true;
      when "1010010101" => return true;
      when "0110010101" => return true;
      when "0001110101" => return true;
      when "0001100101" => return true;
      when "1001010101" => return true;
      when "0101010101" => return true;
      when "1101000101" => return true;
      when "0011010101" => return true;
      when "1011000101" => return true;
      when "0111000101" => return true;
      when "1010000101" => return true;
      when "1001000101" => return true;
      when "1000110101" => return true;
      when "0100110101" => return true;
      when "1100100101" => return true;
      when "0010110101" => return true;
      when "1010100101" => return true;
      when "0110100101" => return true;
      when "0001010101" => return true;
      when "0011000101" => return true;
      when "1001100101" => return true;
      when "0101100101" => return true;
      when "0010010101" => return true;
      when "0011100101" => return true;
      when "0100010101" => return true;
      when "1000010101" => return true;
      when "0101000101" => return true;
      when "0110001100" => return true;
      when "1000101100" => return true;
      when "0100101100" => return true;
      when "1100010011" => return true;
      when "0010101100" => return true;
      when "1010010011" => return true;
      when "0110010011" => return true;
      when "0001110011" => return true;
      when "0001101100" => return true;
      when "1001010011" => return true;
      when "0101010011" => return true;
      when "1101000011" => return true;
      when "0011010011" => return true;
      when "1011000011" => return true;
      when "0111000011" => return true;
      when "1010001100" => return true;
      when "1001001100" => return true;
      when "1000110011" => return true;
      when "0100110011" => return true;
      when "1100100011" => return true;
      when "0010110011" => return true;
      when "1010100011" => return true;
      when "0110100011" => return true;
      when "0001011100" => return true;
      when "0011001100" => return true;
      when "1001100011" => return true;
      when "0101100011" => return true;
      when "0010011100" => return true;
      when "0011100011" => return true;
      when "0100011100" => return true;
      when "1000011100" => return true;
      when "0101001100" => return true;
      when "0110001101" => return true;
      when "1000101101" => return true;
      when "0100101101" => return true;
      when "1100010010" => return true;
      when "0010101101" => return true;
      when "1010010010" => return true;
      when "0110010010" => return true;
      when "0001110010" => return true;
      when "0001101101" => return true;
      when "1001010010" => return true;
      when "0101010010" => return true;
      when "1101000010" => return true;
      when "0011010010" => return true;
      when "1011000010" => return true;
      when "0111000010" => return true;
      when "1010001101" => return true;
      when "1001001101" => return true;
      when "1000110010" => return true;
      when "0100110010" => return true;
      when "1100100010" => return true;
      when "0010110010" => return true;
      when "1010100010" => return true;
      when "0110100010" => return true;
      when "0001011101" => return true;
      when "0011001101" => return true;
      when "1001100010" => return true;
      when "0101100010" => return true;
      when "0010011101" => return true;
      when "0011100010" => return true;
      when "0100011101" => return true;
      when "1000011101" => return true;
      when "0101001101" => return true;
      when "0110001010" => return true;
      when "1000101010" => return true;
      when "0100101010" => return true;
      when "1100011010" => return true;
      when "0010101010" => return true;
      when "1010011010" => return true;
      when "0110011010" => return true;
      when "0001111010" => return true;
      when "0001101010" => return true;
      when "1001011010" => return true;
      when "0101011010" => return true;
      when "1101001010" => return true;
      when "0011011010" => return true;
      when "1011001010" => return true;
      when "0111001010" => return true;
      when "1010001010" => return true;
      when "1001001010" => return true;
      when "1000111010" => return true;
      when "0100111010" => return true;
      when "1100101010" => return true;
      when "0010111010" => return true;
      when "1010101010" => return true;
      when "0110101010" => return true;
      when "0001011010" => return true;
      when "0011001010" => return true;
      when "1001101010" => return true;
      when "0101101010" => return true;
      when "0010011010" => return true;
      when "0011101010" => return true;
      when "0100011010" => return true;
      when "1000011010" => return true;
      when "0101001010" => return true;
      when "0110000110" => return true;
      when "1000100110" => return true;
      when "0100100110" => return true;
      when "1100010110" => return true;
      when "0010100110" => return true;
      when "1010010110" => return true;
      when "0110010110" => return true;
      when "0001110110" => return true;
      when "0001100110" => return true;
      when "1001010110" => return true;
      when "0101010110" => return true;
      when "1101000110" => return true;
      when "0011010110" => return true;
      when "1011000110" => return true;
      when "0111000110" => return true;
      when "1010000110" => return true;
      when "1001000110" => return true;
      when "1000110110" => return true;
      when "0100110110" => return true;
      when "1100100110" => return true;
      when "0010110110" => return true;
      when "1010100110" => return true;
      when "0110100110" => return true;
      when "0001010110" => return true;
      when "0011000110" => return true;
      when "1001100110" => return true;
      when "0101100110" => return true;
      when "0010010110" => return true;
      when "0011100110" => return true;
      when "0100010110" => return true;
      when "1000010110" => return true;
      when "0101000110" => return true;
      when "0110001110" => return true;
      when "1000101110" => return true;
      when "0100101110" => return true;
      when "1100010001" => return true;
      when "0010101110" => return true;
      when "1010010001" => return true;
      when "0110010001" => return true;
      when "0001110001" => return true;
      when "0001101110" => return true;
      when "1001010001" => return true;
      when "0101010001" => return true;
      when "1101001000" => return true;
      when "0011010001" => return true;
      when "1011001000" => return true;
      when "0111001000" => return true;
      when "1010001110" => return true;
      when "1001001110" => return true;
      when "1000110001" => return true;
      when "0100110001" => return true;
      when "1100100001" => return true;
      when "0010110001" => return true;
      when "1010100001" => return true;
      when "0110100001" => return true;
      when "0001011110" => return true;
      when "0011001110" => return true;
      when "1001100001" => return true;
      when "0101100001" => return true;
      when "0010011110" => return true;
      when "0011100001" => return true;
      when "0100011110" => return true;
      when "1000011110" => return true;
      when "0101001110" => return true;
      when others       => return false;
    end case ;
  end function is_positive_data_code_group;


  function is_negative_data_code_group (code_group : bit_vector(9 downto 0)) return boolean is
  begin
    -- Straightforward lookup
    case code_group is
      --    abcdeifghj
      when "1001110100" => return true;
      when "0111010100" => return true;
      when "1011010100" => return true;
      when "1100011011" => return true;
      when "1101010100" => return true;
      when "1010011011" => return true;
      when "0110011011" => return true;
      when "1110001011" => return true;
      when "1110010100" => return true;
      when "1001011011" => return true;
      when "0101011011" => return true;
      when "1101001011" => return true;
      when "0011011011" => return true;
      when "1011001011" => return true;
      when "0111001011" => return true;
      when "0101110100" => return true;
      when "0110110100" => return true;
      when "1000111011" => return true;
      when "0100111011" => return true;
      when "1100101011" => return true;
      when "0010111011" => return true;
      when "1010101011" => return true;
      when "0110101011" => return true;
      when "1110100100" => return true;
      when "1100110100" => return true;
      when "1001101011" => return true;
      when "0101101011" => return true;
      when "1101100100" => return true;
      when "0011101011" => return true;
      when "1011100100" => return true;
      when "0111100100" => return true;
      when "1010110100" => return true;
      when "1001111001" => return true;
      when "0111011001" => return true;
      when "1011011001" => return true;
      when "1100011001" => return true;
      when "1101011001" => return true;
      when "1010011001" => return true;
      when "0110011001" => return true;
      when "1110001001" => return true;
      when "1110011001" => return true;
      when "1001011001" => return true;
      when "0101011001" => return true;
      when "1101001001" => return true;
      when "0011011001" => return true;
      when "1011001001" => return true;
      when "0111001001" => return true;
      when "0101111001" => return true;
      when "0110111001" => return true;
      when "1000111001" => return true;
      when "0100111001" => return true;
      when "1100101001" => return true;
      when "0010111001" => return true;
      when "1010101001" => return true;
      when "0110101001" => return true;
      when "1110101001" => return true;
      when "1100111001" => return true;
      when "1001101001" => return true;
      when "0101101001" => return true;
      when "1101101001" => return true;
      when "0011101001" => return true;
      when "1011101001" => return true;
      when "0111101001" => return true;
      when "1010111001" => return true;
      when "1001110101" => return true;
      when "0111010101" => return true;
      when "1011010101" => return true;
      when "1100010101" => return true;
      when "1101010101" => return true;
      when "1010010101" => return true;
      when "0110010101" => return true;
      when "1110000101" => return true;
      when "1110010101" => return true;
      when "1001010101" => return true;
      when "0101010101" => return true;
      when "1101000101" => return true;
      when "0011010101" => return true;
      when "1011000101" => return true;
      when "0111000101" => return true;
      when "0101110101" => return true;
      when "0110110101" => return true;
      when "1000110101" => return true;
      when "0100110101" => return true;
      when "1100100101" => return true;
      when "0010110101" => return true;
      when "1010100101" => return true;
      when "0110100101" => return true;
      when "1110100101" => return true;
      when "1100110101" => return true;
      when "1001100101" => return true;
      when "0101100101" => return true;
      when "1101100101" => return true;
      when "0011100101" => return true;
      when "1011100101" => return true;
      when "0111100101" => return true;
      when "1010110101" => return true;
      when "1001110011" => return true;
      when "0111010011" => return true;
      when "1011010011" => return true;
      when "1100011100" => return true;
      when "1101010011" => return true;
      when "1010011100" => return true;
      when "0110011100" => return true;
      when "1110001100" => return true;
      when "1110010011" => return true;
      when "1001011100" => return true;
      when "0101011100" => return true;
      when "1101001100" => return true;
      when "0011011100" => return true;
      when "1011001100" => return true;
      when "0111001100" => return true;
      when "0101110011" => return true;
      when "0110110011" => return true;
      when "1000111100" => return true;
      when "0100111100" => return true;
      when "1100101100" => return true;
      when "0010111100" => return true;
      when "1010101100" => return true;
      when "0110101100" => return true;
      when "1110100011" => return true;
      when "1100110011" => return true;
      when "1001101100" => return true;
      when "0101101100" => return true;
      when "1101100011" => return true;
      when "0011101100" => return true;
      when "1011100011" => return true;
      when "0111100011" => return true;
      when "1010110011" => return true;
      when "1001110010" => return true;
      when "0111010010" => return true;
      when "1011010010" => return true;
      when "1100011101" => return true;
      when "1101010010" => return true;
      when "1010011101" => return true;
      when "0110011101" => return true;
      when "1110001101" => return true;
      when "1110010010" => return true;
      when "1001011101" => return true;
      when "0101011101" => return true;
      when "1101001101" => return true;
      when "0011011101" => return true;
      when "1011001101" => return true;
      when "0111001101" => return true;
      when "0101110010" => return true;
      when "0110110010" => return true;
      when "1000111101" => return true;
      when "0100111101" => return true;
      when "1100101101" => return true;
      when "0010111101" => return true;
      when "1010101101" => return true;
      when "0110101101" => return true;
      when "1110100010" => return true;
      when "1100110010" => return true;
      when "1001101101" => return true;
      when "0101101101" => return true;
      when "1101100010" => return true;
      when "0011101101" => return true;
      when "1011100010" => return true;
      when "0111100010" => return true;
      when "1010110010" => return true;
      when "1001111010" => return true;
      when "0111011010" => return true;
      when "1011011010" => return true;
      when "1100011010" => return true;
      when "1101011010" => return true;
      when "1010011010" => return true;
      when "0110011010" => return true;
      when "1110001010" => return true;
      when "1110011010" => return true;
      when "1001011010" => return true;
      when "0101011010" => return true;
      when "1101001010" => return true;
      when "0011011010" => return true;
      when "1011001010" => return true;
      when "0111001010" => return true;
      when "0101111010" => return true;
      when "0110111010" => return true;
      when "1000111010" => return true;
      when "0100111010" => return true;
      when "1100101010" => return true;
      when "0010111010" => return true;
      when "1010101010" => return true;
      when "0110101010" => return true;
      when "1110101010" => return true;
      when "1100111010" => return true;
      when "1001101010" => return true;
      when "0101101010" => return true;
      when "1101101010" => return true;
      when "0011101010" => return true;
      when "1011101010" => return true;
      when "0111101010" => return true;
      when "1010111010" => return true;
      when "1001110110" => return true;
      when "0111010110" => return true;
      when "1011010110" => return true;
      when "1100010110" => return true;
      when "1101010110" => return true;
      when "1010010110" => return true;
      when "0110010110" => return true;
      when "1110000110" => return true;
      when "1110010110" => return true;
      when "1001010110" => return true;
      when "0101010110" => return true;
      when "1101000110" => return true;
      when "0011010110" => return true;
      when "1011000110" => return true;
      when "0111000110" => return true;
      when "0101110110" => return true;
      when "0110110110" => return true;
      when "1000110110" => return true;
      when "0100110110" => return true;
      when "1100100110" => return true;
      when "0010110110" => return true;
      when "1010100110" => return true;
      when "0110100110" => return true;
      when "1110100110" => return true;
      when "1100110110" => return true;
      when "1001100110" => return true;
      when "0101100110" => return true;
      when "1101100110" => return true;
      when "0011100110" => return true;
      when "1011100110" => return true;
      when "0111100110" => return true;
      when "1010110110" => return true;
      when "1001110001" => return true;
      when "0111010001" => return true;
      when "1011010001" => return true;
      when "1100011110" => return true;
      when "1101010001" => return true;
      when "1010011110" => return true;
      when "0110011110" => return true;
      when "1110001110" => return true;
      when "1110010001" => return true;
      when "1001011110" => return true;
      when "0101011110" => return true;
      when "1101001110" => return true;
      when "0011011110" => return true;
      when "1011001110" => return true;
      when "0111001110" => return true;
      when "0101110001" => return true;
      when "0110110001" => return true;
      when "1000110111" => return true;
      when "0100110111" => return true;
      when "1100101110" => return true;
      when "0010110111" => return true;
      when "1010101110" => return true;
      when "0110101110" => return true;
      when "1110100001" => return true;
      when "1100110001" => return true;
      when "1001101110" => return true;
      when "0101101110" => return true;
      when "1101100001" => return true;
      when "0011101110" => return true;
      when "1011100001" => return true;
      when "0111100001" => return true;
      when "1010110001" => return true;
      when others       => return false;
    end case ;
  end function is_negative_data_code_group;


  function is_positive_special_code_group (code_group : bit_vector(9 downto 0)) return boolean is
  begin
    -- Straightforward lookup
    case code_group is
      --    abcdeifghj
      when "1100001011" => return true;
      when "1100000110" => return true;
      when "1100001010" => return true;
      when "1100001100" => return true;
      when "1100001101" => return true;
      when "1100000101" => return true;
      when "1100001001" => return true;
      when "1100000111" => return true;
      when "0001010111" => return true;
      when "0010010111" => return true;
      when "0100010111" => return true;
      when "1000010111" => return true;
      when others       => return false;
    end case ;
  end function is_positive_special_code_group;


  function is_negative_special_code_group (code_group : bit_vector(9 downto 0)) return boolean is
  begin
    -- Straightforward lookup
    case code_group is
      --    abcdeifghj
      when "0011110100" => return true;
      when "0011111001" => return true;
      when "0011110101" => return true;
      when "0011110011" => return true;
      when "0011110010" => return true;
      when "0011111010" => return true;
      when "0011110110" => return true;
      when "0011111000" => return true;
      when "1110101000" => return true;
      when "1101101000" => return true;
      when "1011101000" => return true;
      when "0111101000" => return true;
      when others       => return false;
    end case ;
  end function is_negative_special_code_group;


  -- Return 'true' if the code-group contains a comma, note 2 in the positive disparity column of Reference 1, Table 36-2
  function is_positive_comma (code_group : bit_vector(9 downto 0)) return boolean is
  begin
    -- Straightforward lookup
    case code_group is
      --    abcdeifghj
      when "1100000110" => return true; -- K28.1
      when "1100000101" => return true; -- K28.5
      when "1100000111" => return true; -- K28.7
      when others       => return false;
    end case ;
  end function is_positive_comma;


  -- Return 'true' if the code-group contains a comma, note 2 in the negative disparity column of Reference 1, Table 36-2
  function is_negative_comma (code_group : bit_vector(9 downto 0)) return boolean is
  begin
    -- Straightforward lookup
    case code_group is
      --    abcdeifghj
      when "0011111001" => return true; -- K28.1
      when "0011111010" => return true; -- K28.5
      when "0011111000" => return true; -- K28.7
      when others       => return false;
    end case ;
  end function is_negative_comma;


  function alignment (data    : bit_vector(48 downto 0);
                      pattern : bit_vector( 6 downto 0)) return bit_vector is
  begin
    -- This is priority encoded to favour a comma found in the latest received data.
    if    data( 9 downto  3) = pattern then
      return "0000";
    elsif data(10 downto  4) = pattern then
      return "0001";
    elsif data(11 downto  5) = pattern then
      return "0010";
    elsif data(12 downto  6) = pattern then
      return "0011";
    elsif data(13 downto  7) = pattern then
      return "0100";
    elsif data(14 downto  8) = pattern then
      return "0101";
    elsif data(15 downto  9) = pattern then
      return "0110";
    elsif data(16 downto 10) = pattern then
      return "0111";
    elsif data(17 downto 11) = pattern then
      return "1000";
    elsif data(18 downto 12) = pattern then
      return "1001";
    elsif data(19 downto 13) = pattern then
      return "0000";
    elsif data(20 downto 14) = pattern then
      return "0001";
    elsif data(21 downto 15) = pattern then
      return "0010";
    elsif data(22 downto 16) = pattern then
      return "0011";
    elsif data(23 downto 17) = pattern then
      return "0100";
    elsif data(24 downto 18) = pattern then
      return "0101";
    elsif data(25 downto 19) = pattern then
      return "0110";
    elsif data(26 downto 20) = pattern then
      return "0111";
    elsif data(27 downto 21) = pattern then
      return "1000";
    elsif data(28 downto 22) = pattern then
      return "1001";
    elsif data(29 downto 23) = pattern then
      return "0000";
    elsif data(30 downto 24) = pattern then
      return "0001";
    elsif data(31 downto 25) = pattern then
      return "0010";
    elsif data(32 downto 26) = pattern then
      return "0011";
    elsif data(33 downto 27) = pattern then
      return "0100";
    elsif data(34 downto 28) = pattern then
      return "0101";
    elsif data(35 downto 29) = pattern then
      return "0110";
    elsif data(36 downto 30) = pattern then
      return "0111";
    elsif data(37 downto 31) = pattern then
      return "1000";
    elsif data(38 downto 32) = pattern then
      return "1001";
    elsif data(39 downto 33) = pattern then
      return "0000";
    elsif data(40 downto 34) = pattern then
      return "0001";
    elsif data(41 downto 35) = pattern then
      return "0010";
    elsif data(42 downto 36) = pattern then
      return "0011";
    elsif data(43 downto 37) = pattern then
      return "0100";
    elsif data(44 downto 38) = pattern then
      return "0101";
    elsif data(45 downto 39) = pattern then
      return "0110";
    elsif data(46 downto 40) = pattern then
      return "0111";
    elsif data(47 downto 41) = pattern then
      return "1000";
    elsif data(48 downto 42) = pattern then
      return "1001";
    else
      -- This is an invalid position
      return "1111";
    end if;
  end function alignment;


  function comma_positive_detected (data : bit_vector(48 downto 0)) return boolean is
    variable answer : boolean;
  begin
    answer := false;
    -- Look for a comma+ in any bit position
    for i in 39 downto 0 loop
      if (data(i + 9 downto i + 3) = comma_positive) then
        answer := true;
      end if;
    end loop;
    return answer;
  end function comma_positive_detected;


  function comma_negative_detected (data : bit_vector(48 downto 0)) return boolean is
    variable answer : boolean;
  begin
    answer := false;
    -- Look for a comma- in any bit position
    for i in 39 downto 0 loop
      if (data(i + 9 downto i + 3) = comma_negative) then
        answer := true;
      end if;
    end loop;
    return answer;
  end function comma_negative_detected;


  function cgbad (is_valid : boolean;
                  is_comma : boolean;
                  rx_even  : boolean) return boolean is
  begin
    -- Function is as specified in reference 1.
    return ((not is_valid) or (is_comma and rx_even));
  end function cgbad;
                  

  function cggood (is_valid : boolean;
                   is_comma : boolean;
                   rx_even  : boolean) return boolean is
  begin
    -- Function is as specified in reference 1.
    return not cgbad(is_valid, is_comma, rx_even);
  end function cggood;
                  

end monitor_8b10b_p ;
