----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2021 01:47:18 AM
-- Design Name: 
-- Module Name: generic_mpg - Behavioral
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

entity generic_mpg is
      Generic(N : integer);
      Port (clk: in std_logic;
        btn: in std_logic_vector(N-1 downto 0);
        enable: out std_logic_vector(N-1 downto 0) );
end generic_mpg;

architecture Behavioral of generic_mpg is
signal counter_value: std_logic_vector(15 downto 0);
signal q1: std_logic_vector(N-1 downto 0);
signal q2: std_logic_vector(N-1 downto 0);
signal q3: std_logic_vector(N-1 downto 0);
begin

counter: process(clk) --16 bit counter
    begin
        if rising_edge(clk) then
            counter_value <= counter_value + 1;
        end if;
    end process;

    DFF1: process(clk)
    begin
        if rising_edge(clk) then
           if counter_value = x"FFFF" then
                q1 <= btn;
           end if;
        end if;
    end process;
    
    DFF2: process(clk)
    begin
        if rising_edge(clk) then
            q2 <= q1;
        end if;
    end process;
    
    DFF3: process(clk)
    begin
        if rising_edge(clk) then
            q3 <= q2;
        end if;
    end process;
    
    enable <= q2 and (not q3);

end Behavioral;
