----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--
--      Title           : Physical Medium Attachment (PMA) sublayer, Receive Function. Reference IEEE 802.3-2002, Section Three
--
--      Author(s)       : Steve Betteley
--
--      Version         : @(#)pma_receive_e.vhd	1.9
--                        The version number is maintained by XEmacs Version Control, and is based on SCCS.
--                        Use 'C-x v l' to view version history. Previous history is in 'SCCS/aligner_e.vhd'.
--
--      Remarks         : Accepts 32-bit data samples in an unknown alignment. Finds alignment to a 10-bit comma pattern, and
--                        outputs the data unaltered as an aligned 40-bit word; an exception may occur during a re-alignment,
--                        when some input data may be slipped. A 'strobe' signal is generated to indicate when the output data
--                        is present (4 out of every 5 clock periods).
--
--                        The 'mode' input selects the comma patterns used for alignment. For IEEE802.3 operation,
--                        (mode(0) = '0'), only a comma+ pattern is used, for ANSI X3.230 operation, (mode(0) = '1'), either a
--                        comma+ or a comma- pattern is searched for.
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

library monitor_8b10b_lib;
library work;
use monitor_8b10b_lib.monitor_8b10b_p.all;

entity pma_receive_e is
  port (clock         : in     bit;                      -- Rising edge samples 'data_in'
        reset         : in     boolean;                  -- Synchronous reset
        mode          : in     bit_vector(7 downto 0);   -- Operational mode
        data_in       : in     bit_vector(31 downto 0);  -- Unaligned 32-bit 8b10b data input
        data_out      : buffer bit_vector(39 downto 0);  -- Aligned 40-bit 8b10b data output
        strobe        : buffer boolean);                 -- A new value on 'data_out' is present
end entity pma_receive_e;
