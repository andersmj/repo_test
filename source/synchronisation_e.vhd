----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--
--      Title           : PCS Synchronisation State Diagram
--
--      Author(s)       : Steve Betteley
--
--      Version         : @(#)synchronisation_e.vhd	1.12
--                        The version number is maintained by XEmacs Version Control, and is based on SCCS.
--
--      Remarks         : Implements synchronisation state machines for references 1 and 2. The 'mode' input selects which of the
--                        state machines is used: mode(1) = '0' => ref. 1, mode(1) = '1' => ref. 2.
--
--                        The state machines indicate 8b10b synchronisation and are traversed according to the validity of client
--                        data as indicated by the 'code_group_is_valid', 'code_group_is_data', and 'code_group_is_comma' inputs.
--                        Note that vector index 0 of these signals represents the most recent 10-bits.
--
--      References        1. IEEE Std 802.3-2002 Section 3, clause 36. (Gigabit Ethernet)
--                        2. ANSI X3.230-1994 clauses 11 and 12. (Fibrechannel)
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

library monitor_8b10b_lib;
library work;
use monitor_8b10b_lib.monitor_8b10b_p.all;

entity synchronisation_e is
  port (clock                 : in     bit;                             -- Rising edge samples 'data_in'
        reset                 : in     boolean;                         -- Synchronous reset
        mode                  : in     bit_vector(7 downto 0);          -- Operational mode
        strobe                : in     boolean;                         -- New data present on the inputs
        signal_detect_ok      : in     boolean;                         -- Signal is present on the link (same as not LOS)
        mr_loopback           : in     boolean;                         -- Data is looped back in the PHY
        code_group_is_valid   : in     boolean_array_type(3 downto 0);  -- Code-group is not /INVALID/
        code_group_is_data    : in     boolean_array_type(3 downto 0);  -- Code-group is /D/
        code_group_is_comma   : in     boolean_array_type(3 downto 0);  -- Code-group is /COMMA/
        sync_status_ok        : buffer boolean;                         -- sync_status = OK
        errors                : buffer integer range 0 to 4);           -- Up to 4 errors per clock cycle
end synchronisation_e;
