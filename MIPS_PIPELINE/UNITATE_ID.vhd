----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2023 10:58:57 AM
-- Design Name: 
-- Module Name: UNITATE_ID - Behavioral
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

entity UNITATE_ID is
    Port(   clk: in std_logic;
            RegWrite: in std_logic;
            Instr: in std_logic_vector(12 downto 0);
            ExtOp: in std_logic;
            WD: in std_logic_vector(15 downto 0);
            en: in std_logic;
            WA: in std_logic_vector(2 downto 0);
            RD1: out std_logic_vector(15 downto 0);
            RD2: out std_logic_vector(15 downto 0);
            Ext_Imm: out std_logic_vector(15 downto 0);
            func: out std_logic_vector(2 downto 0);
            rt: out std_logic_vector(2 downto 0);
            rd: out std_logic_vector(2 downto 0);
            sa: out std_logic );
end UNITATE_ID;

architecture Behavioral of UNITATE_ID is

type reg_array is array(0 to 7) of std_logic_vector(15 downto 0);
signal reg_file: reg_array := (others => x"0000");

begin

process(clk)			
begin
    if falling_edge(clk) then
        if en = '1' and RegWrite = '1' then
            reg_file(conv_integer(WA)) <= WD;		
        end if;
    end if;
end process;		
    
RD1 <= reg_file(conv_integer(Instr(12 downto 10)));
RD2 <= reg_file(conv_integer(Instr(9 downto 7)));
    
Ext_Imm(6 downto 0) <= Instr(6 downto 0); 

process(ExtOp, Instr(6))
begin
    case ExtOp is
        when '0' => Ext_Imm(15 downto 7) <= (others => '0');
        when '1' => Ext_Imm(15 downto 7) <= (others => Instr(6));
        when others => Ext_Imm(15 downto 7) <= (others => '0');
    end case;
end process;

sa <= Instr(3);
func <= Instr(2 downto 0);
rt <= Instr(9 downto 7);
rd <= Instr(6 downto 4);
    
end Behavioral;