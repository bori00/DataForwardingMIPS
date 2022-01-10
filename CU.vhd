----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2021 08:12:48 AM
-- Design Name: 
-- Module Name: CU - Behavioral
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

entity CU is
    Port ( OpCode : in std_logic_vector(2 downto 0);
           RegDst : out std_logic;
           ExtOp: out std_logic;
           AluSrc: out std_logic;
           BranchEqual: out std_logic;
           BranchGreaterEqual: out std_logic;
           BranchGreater: out std_logic;
           Jump: out std_logic;
           AluOp: out std_logic_vector(2 downto 0);
           MemWrite: out std_logic;
           MemToReg: out std_logic;
           RegWrite: out std_logic);
end CU;

architecture Behavioral of CU is

begin
    process(OpCode) 
    begin
        case OpCode is
            when "000" => RegDst <= '1'; RegWrite <= '1'; ExtOp <= '1'; MemToReg <= '0';
                        AluSrc <= '0'; MemWrite <= '0'; Jump <= '0'; BranchEqual <= '0'; 
                        BranchGreaterEqual <= '0'; BranchGreater <= '0'; AluOp <= "111"; --R type
            when "001" => RegDst <= '0'; RegWrite <= '1'; ExtOp <= '1';  MemToReg <= '0';
                        AluSrc <= '1'; MemWrite <= '0'; Jump <= '0'; BranchEqual <= '0'; 
                        BranchGreaterEqual <= '0'; BranchGreater <= '0'; AluOp <= "000"; --ADDI
            when "010" => RegDst <= '0'; RegWrite <= '1'; ExtOp <= '1'; MemToReg <= '1';
                         AluSrc <= '1'; MemWrite <= '0'; Jump <= '0'; BranchEqual <= '0'; 
                         BranchGreaterEqual <= '0'; BranchGreater <= '0'; AluOp <= "000"; -- LW
            when "011" => RegDst <= '-'; RegWrite <= '0'; ExtOp <= '1'; MemToReg <= '-';
                         AluSrc <= '1'; MemWrite <= '1'; Jump <= '0'; BranchEqual <= '0'; 
                         BranchGreaterEqual <= '0'; BranchGreater <= '0'; AluOp <= "000"; -- SW
            when "100" => RegDst <= '-'; RegWrite <= '0'; ExtOp <= '1'; MemToReg <= '-';
                         AluSrc <= '0'; MemWrite <= '0'; Jump <= '0'; BranchEqual <= '1'; 
                         BranchGreaterEqual <= '0'; BranchGreater <= '0'; AluOp <= "001"; -- BE
            when "101" => RegDst <= '-'; RegWrite <= '0'; ExtOp <= '1'; MemToReg <= '-';
                         AluSrc <= '0'; MemWrite <= '0'; Jump <= '0'; BranchEqual <= '0'; 
                         BranchGreaterEqual <= '1'; BranchGreater <= '0'; AluOp <= "001"; -- BGE
            when "110" => RegDst <= '-'; RegWrite <= '0'; ExtOp <= '1'; MemToReg <= '-';
                         AluSrc <= '0'; MemWrite <= '0'; Jump <= '0'; BranchEqual <= '0'; 
                         BranchGreaterEqual <= '0'; BranchGreater <= '1'; AluOp <= "001"; -- BG
            when "111" => RegDst <= '-'; RegWrite <= '0'; ExtOp <= '-'; MemToReg <= '-';
                         AluSrc <= '-'; MemWrite <= '0'; Jump <= '1'; BranchEqual <= '0'; 
                         BranchGreaterEqual <= '0'; BranchGreater <= '0'; AluOp <= "000"; -- JUMP
            when others => RegDst <= '-'; RegWrite <= '0'; ExtOp <= '-'; MemToReg <= '-';
                         AluSrc <= '-'; MemWrite <= '0'; Jump <= '0'; BranchEqual <= '0'; 
                         BranchGreaterEqual <= '0'; BranchGreater <= '0'; AluOp <= "000"; -- JUMP
          end case;
    end process;           
end Behavioral;
