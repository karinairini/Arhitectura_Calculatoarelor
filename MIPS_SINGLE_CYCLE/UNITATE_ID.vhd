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
            --RegDst: in std_logic;
            ExtOp: in std_logic;
            WD: in std_logic_vector(15 downto 0);
            en: in std_logic;
            rWA: in std_logic_vector(2 downto 0);
            RD1: out std_logic_vector(15 downto 0);
            RD2: out std_logic_vector(15 downto 0);
            Ext_Imm: out std_logic_vector(15 downto 0);
            func: out std_logic_vector(2 downto 0);
            rt: out std_logic_vector(2 downto 0);
            rd: out std_logic_vector(2 downto 0);
            sa: out std_logic );
end UNITATE_ID;

architecture Behavioral of UNITATE_ID is

--signal out_mux_instr: std_logic_vector(2 downto 0) := "000";

begin

--process(RegDst, Instr(9 downto 7), Instr(6 downto 4))
--begin
--    case RegDst is
--        when '0' => out_mux_instr <= Instr(9 downto 7);
--        when '1' => out_mux_instr <= Instr(6 downto 4);
--        when others => out_mux_instr <= "000";
--    end case;
--end process;

Reg_File: entity WORK.REG_FILE port map(clk => clk, ra1 => Instr(12 downto 10), ra2 => Instr(9 downto 7), wa => rWA, wd => WD, wen => RegWrite, en => en, rd1 => RD1, rd2 => RD2);
 
Ext_Imm(6 downto 0) <= Instr(6 downto 0);

process(ExtOp, Instr(6))
begin
    case ExtOp is
        when '1' => Ext_Imm(15 downto 7) <= (others => Instr(6));
        when '0' => Ext_Imm(15 downto 7) <= "000000000";
        when others => Ext_Imm(15 downto 7) <= "000000000";
    end case;
end process;

func <= Instr(2 downto 0);
sa <= Instr(3);
rt <= Instr(9 downto 7);
rd <= Instr(6 downto 4);

end Behavioral;
