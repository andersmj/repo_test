----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--
--      Title           : 8b10b Code-Group Error Monitor
--
--      Author(s)       : Steve Betteley
--
--      Version         : @(#)ten_bit_monitor_b.vhd	1.8
--                        The version number is maintained by XEmacs Version Control, and is based on SCCS.
--                        Use 'C-x v l' to view version history.
--
--      Remarks         : Requires functions from the 'monitor_8b10b_p' package.
--                        
--      References      : 1. IEEE Std 802.3-2002
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
-- Decodes the code-group in terms of whether it is valid, represents a 'data' code-group, or contains a 'comma'. These
-- determinations are made as combinatorial look-up functions using the appropriate code-group list corresponding to the current
-- running disparity.
--
-- The disparity is updated and output for the next code group to be received. The running disparity calculation is done as two
-- serial processes, splitting the 10-bit code-group into 6-bit and a 4-bit sub-blocks. This is as specified in reference 1.
--

architecture ten_bit_monitor_b of ten_bit_monitor_e is

   -- Running disparity out of the 4 bit sub-group and in to the 6 bit sub-group
  signal intermediate_disparity_is_positive : boolean;
  
begin

  -- Look up the code-group in the appropriate tables according to the current running disparity
  decode: process (code_group, starting_disparity_is_positive)
  begin
    if starting_disparity_is_positive then
      code_group_is_valid <= is_positive_data_code_group(code_group) or is_positive_special_code_group(code_group);
      code_group_is_data  <= is_positive_data_code_group(code_group);
      code_group_is_comma <= is_positive_comma(code_group); 
    else
      code_group_is_valid <= is_negative_data_code_group(code_group) or is_negative_special_code_group(code_group);
      code_group_is_data  <= is_negative_data_code_group(code_group);
      code_group_is_comma <= is_negative_comma(code_group); 
    end if;
  end process decode;

  -- Maintain the disparity. Calculate the disparity through the first 6-bit sub-block
  intermediate_disparity_is_positive <= disparity_6_bits(starting_disparity_is_positive, code_group(9 downto 4));

  -- Calculate the disparity through the second 4-bit sub-block
  ending_disparity_is_positive       <= disparity_4_bits(intermediate_disparity_is_positive, code_group(3 downto 0));

end architecture ten_bit_monitor_b;
