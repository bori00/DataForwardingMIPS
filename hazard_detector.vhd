----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 03:25:05 PM
-- Design Name: 
-- Module Name: hazard_detector - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hazard_detector is
    Port ( IF_ID_OpCode : in STD_LOGIC_VECTOR(2 downto 0);
           IF_ID_rs : in STD_LOGIC_VECTOR(2 downto 0);
           IF_ID_rt : in STD_LOGIC_VECTOR(2 downto 0);
           ID_EX_OpCode: in STD_LOGIC_VECTOR(2 downto 0);
           ID_EX_RegDst: in STD_LOGIC_VECTOR(2 downto 0);
           ID_EX_flushed: in STD_LOGIC;
           EX_MEM_OpCode: in STD_LOGIC_VECTOR(2 downto 0);
           EX_MEM_RegDst: in STD_LOGIC_VECTOR(2 downto 0);
           EX_MEM_flushed: in STD_LOGIC;
           Stall: out STD_LOGIC;
           Forward_MEM_EX_RS: out STD_LOGIC;
           Forward_MEM_EX_RT: out STD_LOGIC;
           Forward_WB_MEM_RS: out STD_LOGIC;
           Forward_WB_MEM_RT: out STD_LOGIC;
           Forward_WB_EX_RS: out STD_LOGIC;
           Forward_WB_EX_RT: out STD_LOGIC);
end hazard_detector;

architecture Behavioral of hazard_detector is

signal ID_needs_rs, ID_needs_rs_in_ex, ID_needs_rt, ID_needs_rt_in_ex, ID_needs_rt_in_mem: boolean;
signal EX_writes_to_reg_file, MEM_writes_to_reg_file: boolean;
signal EX_computes_res_in_ex, EX_computes_res_in_mem: boolean; --refers only to instructions which write to the register file
signal ID_rs_depends_on_ex, ID_rt_depends_on_ex, ID_rs_depends_on_mem, ID_rt_depends_on_mem: boolean;

begin

-- Compute output signals
Stall <= '1' when (ID_needs_rs_in_ex and EX_computes_res_in_mem and ID_rs_depends_on_ex) or 
         (ID_needs_rt_in_ex and EX_computes_res_in_mem and ID_rt_depends_on_ex)
         else '0';
         
Forward_MEM_EX_RS <= '1' when ID_rs_depends_on_ex and EX_computes_res_in_ex else '0';
Forward_MEM_EX_RT <= '1' when ID_rt_depends_on_ex and EX_computes_res_in_ex else '0';

Forward_WB_MEM_RS <= '0';
Forward_WB_MEM_RT <= '1' when ID_rt_depends_on_ex and ID_needs_rt_in_mem and EX_computes_res_in_mem else '0';

Forward_WB_EX_RS <= '1' when (not ID_rs_depends_on_ex) and ID_rs_depends_on_mem else '0';
Forward_WB_EX_RT <= '1' when (not ID_rt_depends_on_ex) and ID_rt_depends_on_mem else '0';
    
-- Compute helper signals
ID_needs_rs <= IF_ID_OpCode /= "111";
ID_needs_rs_in_ex <= ID_needs_rs;

ID_needs_rt <= IF_ID_OpCode = "000" or IF_ID_OpCode = "011" or IF_ID_OpCode = "100" or IF_ID_OpCode = "101" or IF_ID_OpCode = "110";
ID_needs_rt_in_ex <= IF_ID_OpCode = "000" or IF_ID_OpCode = "100" or IF_ID_OpCode = "101" or IF_ID_OpCode = "110";
ID_needs_rt_in_mem <= IF_ID_OpCode = "011";

EX_writes_to_reg_file <= ID_EX_flushed = '0' and (ID_EX_OpCode = "000" or ID_EX_OpCode = "001" or ID_EX_OpCode = "010");
MEM_writes_to_reg_file <= EX_MEM_flushed = '0' and (EX_MEM_OpCode = "000" or EX_MEM_OpCode = "001" or EX_MEM_OpCode = "010");

EX_computes_res_in_ex <= ID_EX_OpCode = "000" or ID_EX_OpCode = "001";
EX_computes_res_in_mem <= ID_EX_OpCode = "010";

ID_rs_depends_on_ex <= ID_needs_rs and EX_writes_to_reg_file and ID_EX_RegDst = IF_ID_rs;
ID_rt_depends_on_ex <= ID_needs_rt and EX_writes_to_reg_file and ID_EX_RegDst = IF_ID_rt;

ID_rs_depends_on_mem <= ID_needs_rs and MEM_writes_to_reg_file and EX_MEM_RegDst = IF_ID_rs;
ID_rt_depends_on_mem <= ID_needs_rt and MEM_writes_to_reg_file and EX_MEM_RegDst = IF_ID_rt;

end Behavioral;
