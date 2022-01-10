----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2021 02:56:56 AM
-- Design Name: 
-- Module Name: registerfile - Behavioral
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

entity registerfile is
    Port ( clk : in STD_LOGIC;
           RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           RegWr : in STD_LOGIC;
           WD: in STD_LOGIC_VECTOR(15 downto 0);
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0));
end registerfile;

architecture Behavioral of registerfile is

type reg_array is array(0 to 7) of std_logic_vector(15 downto 0);
signal reg_file: reg_array := (
        x"0000",
        x"0001",
        x"0022",
        x"0033",
        x"1235",
        others => x"0000"
);

begin
    process(clk) -- synchronous write
    begin
        if falling_edge(clk) then
            if RegWr='1' then
                if conv_integer(WA) /= 0 then
                    reg_file(conv_integer(WA)) <= WD;
                end if;
            end if;
        end if;
    end process;
    
    RD1 <= reg_file(conv_integer(RA1)); --asynchronous read
    RD2 <= reg_file(conv_integer(RA2)); --asynchronous read

end Behavioral;
