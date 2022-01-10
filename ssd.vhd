----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2021 01:02:06 AM
-- Design Name: 
-- Module Name: mpg - Behavioral
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

entity ssd is
  Port (clk: in std_logic;
        digit0: in std_logic_vector(3 downto 0);
        digit1: in std_logic_vector(3 downto 0);
        digit2: in std_logic_vector(3 downto 0);
        digit3: in std_logic_vector(3 downto 0);
        cat: out std_logic_vector(6 downto 0);
        an: out std_logic_vector(3 downto 0));
end ssd;

architecture Behavioral of ssd is
    signal counter_value: std_logic_vector(15 downto 0);
    signal digit_to_display: std_logic_vector(3 downto 0);
begin
   
    counter: process(clk) --16 bit counter
    begin
        if rising_edge(clk) then
            counter_value <= counter_value + 1;
        end if;
    end process;

    MUX_ANODE: process(counter_value)
    begin
        case counter_value(15 downto 14) is
            when "00" => an <= "1110";
            when "01" => an <= "1101";
            when "10" => an <= "1011";
            when "11" => an <= "0111";
            when others => an <= "1111";
        end case;
    end process;
    
    MUX_CATHODE: process(counter_value, digit0, digit1, digit2, digit3) 
    begin
    case counter_value(15 downto 14) is
            when "00" => digit_to_display <= digit0;
            when "01" => digit_to_display <= digit1;
            when "10" => digit_to_display <= digit2;
            when "11" => digit_to_display <= digit3;
            when others => digit_to_display <= digit3;
        end case;
    end process;
    
    HED_TO_7_SEG_DCD: process(digit_to_display)
    begin
        case digit_to_display is
           when "0001" => cat <= "1111001";   --1
           when "0010" => cat <= "0100100";   --2
           when "0011" => cat <= "0110000";   --3
           when "0100" => cat <= "0011001";   --4
           when "0101" => cat <= "0010010";   --5
           when "0110" => cat <= "0000010";   --6
           when "0111" => cat <= "1111000";   --7
           when "1000" => cat <= "0000000";   --8
           when "1001" => cat <= "0010000";   --9
           when "1010" => cat <= "0001000";   --A
           when "1011" => cat <= "0000011";   --b
           when "1100" => cat <= "1000110";   --C
           when "1101" => cat <= "0100001";   --d
           when "1110" => cat <= "0000110";   --E
           when "1111" => cat <= "0001110";   --F
           when others => cat <= "1000000";
        end case;
    end process; 
end Behavioral;