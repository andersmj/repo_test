----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--
--      Title           : 8b10b Monitor Core Component, 1sbb60063aaf
--
--      Author(s)       : Steve Betteley
--
--      Version         : @(#)monitor_8b10b_core_e.vhd	1.16
--                        The version number is maintained by XEmacs Version Control, and is based on SCCS
--                        Use 'C-x v l' to view version history.
--
--      Remarks         : Generic re-usable module design. Initially designed for the Photonix Multihaul 2.5G Transponder
--                        Wrapper FPGA.
--
--                        The 'mode' input indicates the mode of operation of the module, and relate to the data format on
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
--                        Note on code_error_count count. This count value is updated from an internal counter when a '0' to '1'
--                        transition is observed on 'freeze'. The internal counter will roll around from X"ffff" to X"0000", but
--                        will stop if it reaches the value before the current 'frozen' value on the code_error_count output.
--
--                        Note on block_error_count count. This count value is updated from an internal counter when a '0' to '1'
--                        transition is observed on 'freeze'. The internal counter will roll around from X"ff" to X"00". Unlike
--                        the internal code_error_count counter, the internal counter for block_error_count will have no check on
--                        incrementing; this is because it is not anticipated that it will overrun in the software polling period,
--                        e.g. 10ms / 125us << 256
--
--                        Code Error Count Width (for IEEE802.3):
--
--                        An examination of the 'Synchronisation' state machine shows that the maximum code-violation rate that
--                        could occur without losing 8B10B synchronisation is 1 in 5. If synchronisation is lost then the count
--                        stops.
--
--                        We require to ensure that the counter does not roll past its starting point before the software next
--                        polls it. If the software polling interval is 'p', the counter width is 'n', and the 10B bit rate is
--                        'r', then : 2**n > 0.2 * r/10 * p
--
--                            e.g. for 8ms polling period, 2125 Mbit/s data (double fibrechannel), then
--
--                                 2**n > 0.2 * 2125 * 10**6 * 10**-1 * 8 * 10**-3
--                                 2**n > 20 * 2125 * 8
--                                 2**n > 340000
--
--                                 from which an examination of a powers of two table shows that a 19 bit counter is needed.
--     
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

library monitor_8b10b_lib;
library work;
use monitor_8b10b_lib.monitor_8b10b_p.all;


entity monitor_8b10b_core_e is
  generic (code_error_count_width  : integer := 16;                                   -- The 'code_error_count' width
           block_error_count_width : integer := 8);                                   -- The 'block_error_count' width
  port (clock             : in     bit;                                               -- Clock for the 'data' input
        reset             : in     boolean;                                           -- Reset for the module
        mode              : in     bit_vector(7 downto 0);                            -- Operational mode (see above)
        data              : in     bit_vector(31 downto 0);                           -- 8b10b data input (unaligned)
        block_strobe      : in     boolean;                                           -- true for 1 'clock' indicates block period
        freeze            : in     boolean;                                           -- Update Error Count outputs
        signal_detect_ok  : in     boolean;                                           -- Signal is present on the link
        mr_loopback       : in     boolean;                                           -- Data is looped back in the PHY
        code_error_count  : buffer bit_vector(code_error_count_width - 1 downto 0);   -- 8b10b invalid code count (see above)
        block_error_count : buffer bit_vector(block_error_count_width - 1 downto 0);  -- 8b10b invalid block count (see above)
        sync_status_ok    : buffer boolean);                                          -- Module has acquired 8b10b sync
end entity monitor_8b10b_core_e;
