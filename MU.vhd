----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2021 08:57:48 PM
-- Design Name: 
-- Module Name: MU - Behavioral
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

entity MU is
    Port ( clk: in std_logic;
           Address: in std_logic_vector(15 downto 0);
           WriteData: in std_logic_vector(15 downto 0);
           MemWrite: in std_logic;
           MemData: out std_logic_vector(15 downto 0));
end MU;

architecture Behavioral of MU is

Component ram is
  Port (clk: in std_logic;
        we: in std_logic;
        addr: in std_logic_vector(15 downto 0);
        di: in std_logic_vector(15 downto 0);
        do: out std_logic_vector(15 downto 0));
end component;

begin

DataMemory: ram port map (
                clk => clk,
                we => MemWrite,
                addr => Address,
                di => WriteData,
                do => MemData);
end Behavioral;
