----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2023 10:52:07 PM
-- Design Name: 
-- Module Name: UNITATE_IF - Behavioral
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

entity UNITATE_IF is
    Port(   clk: in std_logic;
            en_PC: in std_logic;
            en_reset: in std_logic;
            branch_address: in std_logic_vector(15 downto 0);
            jump_address: in std_logic_vector(15 downto 0);
            jump: in std_logic;
            PCSrc: in std_logic;
            instruction: out std_logic_vector(15 downto 0);
            next_instruction_address: out std_logic_vector(15 downto 0));
end UNITATE_IF;

architecture Behavioral of UNITATE_IF is

signal PC: std_logic_vector(15 downto 0) := (others => '0');
signal out_MUX_JA: std_logic_vector(15 downto 0) := x"0000";
signal out_MUX_BA: std_logic_vector(15 downto 0) := x"0000";
signal out_sum: std_logic_vector(15 downto 0) := x"0000";

type ROM_array is array (0 to 255) of std_logic_vector(15 downto 0);
signal ROM: ROM_array := (
-- Program
B"001_000_010_0001001", -- X"2109" -- ADDI $2, $0, 9 numarul de interatii --2
B"000_000_000_001_0_000", -- X"0010" -- ADD $1, $0, $0 i=0, contorul buclei --1
B"000_000_000_011_0_000", -- X"0030" -- ADD $3, $0, $0 indexul locatiei de memorie --3
B"000_000_000_100_0_000", -- X"0040" -- ADD $4, $0, $0 suma=0 --4
B"000_000_000_000_0_000", -- X"0000" -- NoOp --6
B"100_010_001_0010111", -- X"8897" -- BEQ $1, $2, 23  verific daca am facut 9 iteratii si fac salt in afara buclei --5
B"000_000_000_000_0_000", -- X"0000" -- NoOp --6
B"000_000_000_000_0_000", -- X"0000" -- NoOp --7
B"000_000_000_000_0_000", -- X"0000" -- NoOp --8
B"010_011_101_0000000", -- X"4E80" -- LW $5, 0($3) incarc elementul curent --9
B"000_000_000_000_0_000", -- X"0000" -- NoOp --10
B"000_000_000_000_0_000", -- X"0000" -- NoOp --11
B"101_101_110_0000001", -- X"B701" -- SUBI $6, $5, 1 scad 1 pentru a verifica daca e putere a lui 2 --12
B"000_000_000_000_0_000", -- X"0000" -- NoOp --13
B"000_000_000_000_0_000", -- X"0000" -- NoOp --14
B"000_101_110_110_0_100", -- X"1764" -- AND $6, $5, $6 --15
B"000_000_000_000_0_000", -- X"0000" -- NoOp --16
B"000_000_000_000_0_000", -- X"0000" -- NoOp --17
B"110_000_110_0000111", -- X"C307" -- BNE $6, $0, 7 daca nu e putere a lui 2, trec la urmatorul element --18
B"000_000_000_000_0_000", -- X"0000" -- NoOp --19
B"000_000_000_000_0_000", -- X"0000" -- NoOp --20
B"000_000_000_000_0_000", -- X"0000" -- NoOp --21
B"000_101_001_111_0_110", -- X"14F6" -- XOR $7, $5, $1 daca e putere a lui 2 aplic xor cu pozitia --22
B"000_000_000_000_0_000", -- X"0000" -- NoOp --23
B"000_000_000_000_0_000", -- X"0000" -- NoOp --24
B"000_100_111_100_0_000", -- X"13C0" -- ADD $4, $4, $7 adun rezultatul la suma --25
B"001_011_011_0000001", -- X"2D81" -- ADDI $3, $3, 1 trec la noul element --26
B"001_001_001_0000001", -- X"2481" -- ADDI $1, $1, 1 trec la noua iteratie --27
B"111_0000000000100", -- X"E004" -- j 4 trec la urmatoarea iteratie --28
B"000_000_000_000_0_000", -- X"0000" -- NoOp --29
B"011_000_100_0001010", -- X"620A" -- sw $4, 10($0) salvez rezultatul sumei --30
others => X"0000"); --NoOp (ADD $0, $0, $0) --31)

begin

process(PCSrc, out_sum, branch_address)
begin
    case PCSrc is
        when '0' => out_MUX_BA <= out_sum;
        when '1' => out_MUX_BA <= branch_address;
        when others => out_MUX_BA <= x"0000";
    end case;
end process;

process(jump, out_MUX_BA, jump_address)
begin 
    case jump is
        when '0' => out_MUX_JA <= out_MUX_BA;
        when '1' => out_MUX_JA <= jump_address;
        when others => out_mux_BA <= x"0000";
    end case;
end process;

out_sum <= PC + 1;

next_instruction_address <= out_sum;

process(clk, en_PC, en_reset)
begin
    if rising_edge(clk) then
        if en_reset = '1' then 
            PC <= x"0000"; 
        elsif en_PC = '1' then
            PC <= out_MUX_JA;
        end if;
    end if;
end process;

instruction <= ROM(conv_integer(PC(7 downto 0)));

end Behavioral;
