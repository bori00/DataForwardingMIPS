----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2021 11:11:39 PM
-- Design Name: 
-- Module Name: IF - Behavioral
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

entity IFC is
    Port ( clk : in STD_LOGIC;
           BranchAddress : in STD_LOGIC_VECTOR (15 downto 0);
           JumpAddress : in STD_LOGIC_VECTOR (15 downto 0);
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Stall: in STD_LOGIC;
           Instr : out STD_LOGIC_VECTOR (15 downto 0);
           NextInstrAddress: out STD_LOGIC_VECTOR (15 downto 0));
end IFC;

architecture Behavioral of IFC is

-- for the Instruction memory (ROM)
-- functionality; adds up the numbers from 1 to M[0] - 1 and stores the result in M[1] and RF[4]
type rom_type is array(0 to 255) of std_logic_vector(15 downto 0); --todo
signal rom_data: rom_type := (

-- Tester code 1: compute the sum 1 + 2 + 3 + ... + (M[0]-1) and store it in RF[4} and M[1]
--    "0010000100000001", --0: $2 <= $0 + 1                   | 0x2101
--    "0100000010000000", --1: $1 <= M[$0 + 0]                | 0x4080 
--    "0000000000110000", --2: $3 <= $0 + $0                  | 0x0030
--    "1000100010000011", --3: beq if $2 == $1 jump forward 3 | 0x8883 *RAW($1) the first time --> Forward_WB_EX_RT, (Note: RAW($2) in the next iterations, because instruction 7 is in the pipeline and then flushed)
--    "0000110100110000", --4: $3 <= $3 + $2                  | 0x0D30 *RAW($3) the first time.  --> Forward WB_EX_RS
--    "0010100100000001", --5: $2 <= $2 + 1                   | 0x2901 
--    "1110000000000011", --6: jump 3                         | 0xE003
--    "0110000110000001", --7: M[$0 + 1] <= $3                | 0x6181
--    "0100001000000001", --8: $4 <= M[$0 + 1] --> for check  | 0x4201 
--    "0001000001000001", --9: $4 <= $4 - $0 --> for check    | 0x1041 *RAW($4). --> STALL 1x and then FORWARD_WB_EX_RS
--    "0000000000000000", --10: NOP                           | 0x0000
--    others => x"0000"
    
-- Tester code 2: count the number of values < 10 in an array starting from M[1] with length M[0]
    "0010000110000000", --2: $3 <= $0 + 0  ($3 = the result)                    | 0x2180
    "0010111010001010", --3: $5 <= $3 + 10 ($5 = the threshold)                 | 0x2E8A *RAW($3): Forward_MEM_EX_RS
    "0010110100000001", --0: $2 <= $3 + 1  ($2 = the memory address)            | 0x2D01 *RAW($3): Forward_WB_EX_RS
    "0100000010000000", --1: $1 <= M[$0 + 0]  ($1 = the array's cardinality)    | 0x4080 
    "1100100010000101", --4: bg $2 > $1 jump forward 5                          | 0xC885 *The first time: RAW($2 and $1): Stall 1x, then Forward_WB_EX_RT
    "0100101000000000", --5: $4 <= M[$2+0]                                      | 0x4A00 (No RAW($1) the first time because of the previous stall)
    "1011001010000001", --6: bg2 $4 >= $5 jump forward 1                        | 0xB281 *RAW($4): Stall 1x, then Forward_WB_EX_RS
    "0010110110000001", --7: $3 <= $3 + 1                                       | 0x2D81
    "0010100100000001", --8: $2 <= $2 + 1                                       | 0x2901
    "1110000000000100", --9: jump 4                                             | 0xE004
    others => x"0000"
);

signal Instr_with_branch_addr, Instr_with_jump_addr, inner_NextInstrAddress: std_logic_vector(15 downto 0);
signal Instr_address: std_logic_vector(15 downto 0) := x"0000";

begin

Instr <= rom_data(conv_integer(Instr_address(7 downto 0))); --todo

PC: process(clk) 
begin
    if clk'event and clk = '1' then
        if Stall='0' or PCsrc='1' then
            Instr_address <= Instr_with_branch_addr;
        end if;
    end if;
end process;

PC_ADDER: process(Instr_address) 
begin
    inner_NextInstrAddress <= Instr_address + 1;
end process;

-- branching has higher priority than jump, because it happened earlier!
BRANCH_MUX: process(PCSrc, BranchAddress, Instr_with_jump_addr) 
begin
    if PCSrc = '1' then
        Instr_with_branch_addr <= BranchAddress;
    else
        Instr_with_branch_addr <= Instr_with_jump_addr;
    end if;
end process;

JUMP_MUX: process(Jump, JumpAddress, inner_NextInstrAddress) 
begin
    if Jump = '1' then
        Instr_with_jump_addr <= JumpAddress;
    else
        Instr_with_jump_addr <= inner_NextInstrAddress;
    end if;
end process;

NextInstrAddress <= inner_NextInstrAddress;

end Behavioral;
