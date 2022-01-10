----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2021 08:10:39 AM
-- Design Name: 
-- Module Name: ID - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID is
    Port ( clk: in std_logic;
           RegWrite : in STD_LOGIC;
           Instr: in std_logic_vector(15 downto 0);
           RegDst: in std_logic;
           ExtOp: in std_logic;
           WriteData: in std_logic_vector(15 downto 0);
           WriteAddress: in std_logic_vector(2 downto 0);
           ReadData1: out std_logic_vector(15 downto 0);
           ReadData2: out std_logic_vector(15 downto 0);
           ExtImm: out std_logic_vector(15 downto 0);
           Func: out std_logic_vector(2 downto 0);
           Sa: out std_logic;
           DecodedWriteAddress: out std_logic_vector(2 downto 0);
           ReadAddressRS: out std_logic_vector(2 downto 0);
           ReadAddressRT: out std_logic_vector(2 downto 0));
end ID;

architecture Behavioral of ID is

Component registerfile is
    Port ( clk : in STD_LOGIC;
           RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           RegWr : in STD_LOGIC;
           WD: in STD_LOGIC_VECTOR(15 downto 0);
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0));
End component;  

signal ReadAddress1, ReadAddress2: std_logic_vector(2 downto 0);
signal ExtendedImmediate, ExtendedSa: std_logic_vector(16 downto 0);
signal s: std_logic;

begin

REG_FILE_MEM: registerfile port map ( clk => clk,
           RA1 => ReadAddress1,
           RA2 => ReadAddress2,
           WA => WriteAddress,
           RegWr => RegWrite,
           WD => WriteData,
           RD1 => ReadData1,
           RD2 => ReadData2);
           
ReadAddress1 <= Instr(12 downto 10);
ReadAddress2 <= Instr(9 downto 7);

ReadAddressRS <= ReadAddress1;
ReadAddressRT <= ReadADdress2;

DecodedWriteAddress <= Instr(6 downto 4) when RegDst = '1' else Instr(9 downto 7);

s <= instr(6);
ExtImm <= s&s&s&s&s&s&s&s&s&Instr(6 downto 0) when ExtOp = '1' else "000000000" & Instr(6 downto 0);
Sa <= Instr(3);

Func <= Instr(2 downto 0);

end Behavioral;
