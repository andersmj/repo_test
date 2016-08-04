----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--
--      Title           : Individual 8b10b Code-Group Error Monitor
--
--      Author(s)       : Steve Betteley
--
--      Version         : @(#)ten_bit_monitor_e.vhd	1.10
--                        The version number is maintained by XEmacs Version Control, and is based on SCCS.
--                        Use 'C-x v l' to view version history.
--
--      Remarks         : This component contains combinatorial logic only. Accepts an 8b10b 'code-group' and determines its
--                        validity according to reference 1. The disparity from the previous code-group must be input on
--                        'starting_disparity_is_positive', and the modified running disparity to the following code-group is
--                        output on 'ending_disparity_is_positive'.
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

library monitor_8b10b_lib;
library work;
use monitor_8b10b_lib.monitor_8b10b_p.all;

entity ten_bit_monitor_e is
  port (mode                           : in     bit_vector(7 downto 0);   -- Operational mode
        code_group                     : in     bit_vector(9 downto 0);   -- Input 8b10b code-group
        starting_disparity_is_positive : in     boolean;                  -- Disparity in ('true' = +ve disparity, 'false' = -ve)
        code_group_is_valid            : out    boolean;                  -- Code-group is valid i.e. not /INVALID/
        code_group_is_data             : out    boolean;                  -- Code-group is a data code-group i.e. /D/
        code_group_is_comma            : out    boolean;                  -- Code-group contains a comma i.e. /COMMA/
        ending_disparity_is_positive   : out    boolean);                 -- Disparity out ('true' = +ve disparity, 'false' = -ve)
end entity ten_bit_monitor_e;
