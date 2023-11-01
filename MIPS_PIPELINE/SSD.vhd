----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/12/2023 06:40:19 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port(   digit0: in std_logic_vector(3 downto 0);
            digit1: in std_logic_vector(3 downto 0);
            digit2: in std_logic_vector(3 downto 0);
            digit3: in std_logic_vector(3 downto 0);
            clk: in std_logic;
            cat: out std_logic_vector(6 downto 0);
            an: out std_logic_vector(3 downto 0));
end SSD;

architecture Behavioral of SSD is

signal cnt: std_logic_vector(15 downto 0) := x"0000";
signal out_mux: std_logic_vector(3 downto 0) := x"0";
signal sel: std_logic_vector(1 downto 0) := "00";

begin

process(clk)
begin
    if rising_edge(clk) then
        cnt <= cnt + 1;
    end if;
end process;

sel <= cnt(15 downto 14);

process(sel, digit0, digit1, digit2, digit3)
begin
    case sel is
        when "00" => out_mux <= digit0;
        when "01" => out_mux <= digit1;
        when "10" => out_mux <= digit2;
        when others => out_mux <= digit3;
    end case;
end process;

process(out_mux)
begin
    case out_mux is 
        when "0000" => cat <= "1000000"; --0
        when "0001" => cat <= "1111001"; --1
        when "0010" => cat <= "0100100"; --2
        when "0011" => cat <= "0110000"; --3
        when "0100" => cat <= "0011001"; --4
        when "0101" => cat <= "0010010"; --5
        when "0110" => cat <= "0000010"; --6
        when "0111" => cat <= "1111000"; --7
        when "1000" => cat <= "0000000"; --8
        when "1001" => cat <= "0010000"; --9
        when "1010" => cat <= "0001000"; --A
        when "1011" => cat <= "0000011"; --b
        when "1100" => cat <= "1000110"; --C
        when "1101" => cat <= "0100001"; --d
        when "1110" => cat <= "0000110"; --E
        when others => cat <= "0001110"; --F
    end case;
end process;

process(sel)
begin
    case sel is
        when "00" => an <= "1110";
        when "01" => an <= "1101";
        when "10" => an <= "1011";
        when "11" => an <= "0111";
        when others => an <= "1111";
    end case;
end process;

end Behavioral;
