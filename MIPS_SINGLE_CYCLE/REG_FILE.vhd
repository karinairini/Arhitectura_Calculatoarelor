----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2023 07:16:54 PM
-- Design Name: 
-- Module Name: REG_FILE - Behavioral
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

entity REG_FILE is
    Port(   clk: in std_logic;
            ra1: in std_logic_vector(2 downto 0);
            ra2: in std_logic_vector(2 downto 0);
            wa: in std_logic_vector(2 downto 0);
            wd: in std_logic_vector(15 downto 0);
            wen: in std_logic;
            en: in std_logic;
            rd1: out std_logic_vector(15 downto 0);
            rd2: out std_logic_vector(15 downto 0));
end REG_FILE;

architecture Behavioral of REG_FILE is

type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
signal reg_file : reg_array := (others => x"0000");

begin

process(clk)
begin
    if falling_edge(clk) then
        if en = '1' and wen = '1' then
            reg_file(conv_integer(wa)) <= wd;
        end if;
    end if;
end process;

rd1 <= reg_file(conv_integer(ra1));
rd2 <= reg_file(conv_integer(ra2));

end Behavioral;
