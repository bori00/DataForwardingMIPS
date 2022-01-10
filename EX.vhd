----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2021 08:11:33 AM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
    Port (NextInstrAddress: in std_logic_vector(15 downto 0);
           ReadData1: in std_logic_vector(15 downto 0);
           ReadData2: in std_logic_vector(15 downto 0);
           ALUSrc: in std_logic;
           ExtImm: in std_logic_vector(15 downto 0);
           Sa: in std_logic;
           ALUOp: in std_logic_vector(2 downto 0);
           Func: in std_logic_vector(2 downto 0);
           BranchAddress: out std_logic_vector(15 downto 0);
           Zero: out std_logic;
           ALURes: out std_logic_vector(15 downto 0));
end EX;

architecture Behavioral of EX is

signal ALUResBuf: std_logic_vector(15 downto 0);
signal A, B: std_logic_vector(15 downto 0);
signal ALUCtrl: std_logic_vector(2 downto 0);

begin

Zero <= '1' when ALUResBuf = x"0000" else '0';
ALURes <= ALUResBuf;
BranchAddress <= NextInstrAddress + ExtImm;

-- operands
A <= ReadData1;
B <= ReadData2 when AluSrc = '0' else ExtImm;

ALUCtrl <= Func when ALUOp = "111" else AluOp; --ALUOp = 111 only for the R type instructions --todo

ALU: process(A, B, Sa, ALUCtrl)
begin
    case AlUCtrl is
        when "000" => AluResBuf <= A + B;
        when "001" => AluResBuf <= A - B;
        when "010" => if sa = '1' then AluResBuf <= A(14 downto 0) & '1'; else ALUResBuf <= A; end if;
        when "011" => if sa = '1' then AluResBuf <= '0' & A(15 downto 1); else ALUResBuf <= A; end if;
        when "100" => AluResBuf <= A and B;
        when "101" => AluResBuf <= A or B;
        when "110" => AluResBuf <= A xor B;
        when "111" => AluResBuf <= A nand B;
        when others => AluResBuf <= x"0000";
    end case;
end process;


end Behavioral;
