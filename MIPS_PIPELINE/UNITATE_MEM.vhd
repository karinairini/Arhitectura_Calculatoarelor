----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2023 01:43:32 AM
-- Design Name: 
-- Module Name: UNITATE_MEM - Behavioral
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

entity UNITATE_MEM is
    Port(   clk: in std_logic;
            MemWrite: in std_logic;
            en: in std_logic;
            ALURes: in std_logic_vector(15 downto 0);
            RD2: in std_logic_vector(15 downto 0);
            MemData: out std_logic_vector(15 downto 0);
            ALUResOut: out std_logic_vector(15 downto 0));
end UNITATE_MEM;

architecture Behavioral of UNITATE_MEM is

type ram is array(0 to 31) of std_logic_vector(15 downto 0);
signal RAM_MEMORY: ram := (
X"0001", -- 1
X"0002", -- 2
X"0004", -- 4
X"0005", -- 5
X"000B", -- 11
X"0010", -- 16
X"0019", -- 25
X"0020", -- 32
X"0030", -- 48
others => X"0000");

begin

process(clk)
begin
    if rising_edge(clk) then
        if en = '1' and MemWrite = '1' then 
            RAM_MEMORY(conv_integer(ALURes(4 downto 0))) <= RD2;
        end if;
    end if;
end process;

MemData <= RAM_MEMORY(conv_integer(ALURes(4 downto 0)));
ALUResOut <= ALURes;

end Behavioral;
