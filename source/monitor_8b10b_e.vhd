----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--
--      Title           : 8b10b Monitor 'skin'
--
--      Author(s)       : Steve Betteley
--
--      Version         : @(#)monitor_8b10b_e.vhd	1.14
--                        The version number is maintained by XEmacs Version Control, and is based on SCCS
--                        Use 'C-x v l' to view version history.
--
--      Remarks         : This is a 'skin' to provide the required interfaces for use in the Multihaul 2.5G G.709 Transponder
--                        Wrapper FPGA.
--
--                        The 'Mode' inputs indicate the mode of operation of the module, and relate to the data format on
--                        'Din'. For example, these controls affect the way that code-group or transmission word
--                        'synchronisation' is achieved.
--
--                            mode bit 0 : When '0', 10-bit alignment is sought on comma+ disparity; when '1', any comma 
--                                         pattern is used i.e. comma+ or comma-.
--
--                            mode bit 1 : When '0', link synchronisation is performed using the 'Gigabit Ethernet' state
--                                         machine (reference 1); when '1', synchonisation is based on the Fibrechannel
--                                         procedure (reference 2).
--
--                            mode bits 2 to 7 : Reserved for future use to distinguish other 8B10B formats, set to '0'.
--                                     
--                        For Gigabit Ethernet operation, 'Mode' bits should be set to "00", for Fibrechannel operation,
--                        'Mode' should be set to "11".
--
--                        Note that for Fibrechannel, synchronisation is based on comma+ or comma- sequences, and the state
--                        machine operates at the 'transmission word' granularity (four 8B10B characters). For Gigabit Ethernet,
--                        'code-group alignment' is based on the comma+ pattern only, and the 'synchronisation' state machine
--                        operates at code-group granularity (one 8B10B character).
--
--                        CodeErrors count. This count value is updated from an internal counter when a '0' to '1' transition
--                        is observed on 'Freeze'. The internal counter will roll around from X"ffff" to X"0000", but will stop
--                        if it reaches the value before the current 'frozen' value on the CodeErrors output.
--
--                        BlockErrors count. A block is defined to be fixed at 125 us for all Din client rates. The Ref19M44
--                        clock is used to generate the 125us timing reference. The count value is updated from an internal
--                        counter when a '0' to '1' transition is observed on 'Freeze'. The internal counter will roll around
--                        from X"ff" to X"00". Unlike the ionternal CodeErrors counter, the internal counter for BlockErrors
--                        will have no check on incrementing; this is because it is not anticipated that it will overrun in the
--                        software polling period  e.g. 10ms / 125us << 256
--
--                        The error counts will be operational when 'InSync' is asserted, otherwise they will be stopped at their
--                        current value.
--
--                        An asserted value on 'LOS' forces the 'InSync' output to be negated unless an external loopback is
--                        applied as indicated by the 'Loopback' input.
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

library ieee;
library monitor_8b10b_lib;
use ieee.std_logic_1164.all;
use monitor_8b10b_lib.monitor_8b10b_p.all;


entity monitor_8b10b_e is
  port (Clock       : in  std_logic;                      -- Rising edge samples Din
        Reset       : in  std_logic;                      -- Active high synchronous
        Mode        : in  std_logic_vector(7 downto 0);   -- Mode of operation, see table above.
        LOS         : in  std_logic;                      -- Loss of Signal
        Loopback    : in  std_logic;                      -- Indicates that an external loopback is applied
        Din         : in  std_logic_vector(31 downto 0);  -- Unaligned 32-bit 8b10b data-in
        Freeze      : in  std_logic;                      -- Freezes the Error counter values
        CodeErrors  : out std_logic_vector(15 downto 0);  -- 8b10b invalid code count (see note)
        Ref19M44    : in  std_logic;                      -- The Stand-by reference clock at 19.44 MHz
        BlockErrors : out std_logic_vector(7 downto 0);   -- 8b10b invalid block count (see note)
        InSync      : out std_logic);                     -- Active high sychronisation flag
end entity monitor_8b10b_e;
