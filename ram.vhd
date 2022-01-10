----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2021 09:03:18 PM
-- Design Name: 
-- Module Name: ram - Behavioral
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

entity ram is
  Port (clk: in std_logic;
        we: in std_logic;
        addr: in std_logic_vector(15 downto 0);
        di: in std_logic_vector(15 downto 0);
        do: out std_logic_vector(15 downto 0));
end ram;

architecture Behavioral of ram is
    type ram_type is array(0 to 32768) of std_logic_vector(15 downto 0); --64k * 16bit memory
    signal ram_data: ram_type := (
-- for tester code 1
--        x"0005",
--        others => x"0000"

-- for tester code 2
        x"0006",
        x"0002",
        x"000A",
        x"000C",
        x"0000",
        x"00AA",
        x"0007",
        others => x"0000"
    );
begin

    process(clk) 
    begin
        if clk'event and clk='1' then
            if we='1' then
                ram_data(conv_integer(addr)) <= di; 
            end if;
        end if;
    end process;
    
    do <= ram_data(conv_integer(addr)) when conv_integer(addr) < 32768 else x"0000";
end Behavioral;
