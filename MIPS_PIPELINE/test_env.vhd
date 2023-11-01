----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2023 01:26:12 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk: in std_logic;
           btn: in std_logic_vector(4 downto 0);
           sw: in std_logic_vector(15 downto 0);
           led: out std_logic_vector(15 downto 0);
           an: out std_logic_vector(3 downto 0);
           cat: out std_logic_vector(6 downto 0));
end test_env;

architecture Behavioral of test_env is

signal en, en_reset: std_logic;
signal digits: std_logic_vector(15 downto 0);

signal next_instruction_address, instruction: std_logic_vector(15 downto 0);

signal func: std_logic_vector(2 downto 0);
signal sa: std_logic;
signal Ext_Imm, RD1, RD2: std_logic_vector(15 downto 0) := x"0000";

signal zero: std_logic;
signal ALURes: std_logic_vector(15 downto 0);
signal Branch_address, Jump_address: std_logic_vector(15 downto 0);

signal MemData, WD_regFile: std_logic_vector(15 downto 0);
signal ALUResOut: std_logic_vector(15 downto 0);

signal RegWrite, RegDst, ExtOp, ALUSrc, MemWrite, Branch, Bne, Jump, MemToReg: std_logic;
signal ALUOp: std_logic_vector(2 downto 0);
signal PCSrc_aux1, PCSrc_aux2, PCSrc: std_logic;

signal rt, rd, rWA: std_logic_vector(2 downto 0);

--IF/ID
signal PCInc_IF_ID, Instruction_IF_ID: std_logic_vector(15 downto 0);
--ID/EX
signal PCInc_ID_EX, RD1_ID_EX, RD2_ID_EX, Ext_Imm_ID_EX: std_logic_vector(15 downto 0);
signal func_ID_EX, rt_ID_EX, rd_ID_EX, ALUOp_ID_EX: std_logic_vector(2 downto 0);
signal sa_ID_EX, MemToReg_ID_EX, RegWrite_ID_EX, MemWrite_ID_EX, Branch_ID_EX, Bne_ID_EX, ALUSrc_ID_EX, RegDst_ID_EX: std_logic;
--EX_MEM
signal MemToReg_EX_MEM, RegWrite_EX_MEM, MemWrite_EX_MEM, Branch_EX_MEM, Bne_EX_MEM, zero_EX_MEM: std_logic;
signal Branch_address_EX_MEM, ALURes_EX_MEM, RD2_EX_MEM: std_logic_vector(15 downto 0);
signal rd_EX_MEM: std_logic_vector(2 downto 0);
--MEM/WB
signal MemToReg_MEM_WB, RegWrite_MEM_WB: std_logic;
signal MemData_MEM_WB, ALURes_MEM_WB: std_logic_vector(15 downto 0);
signal rd_MEM_WB: std_logic_vector(2 downto 0);

begin

mpg_PC:entity WORK.MPG port map(en => en, input => btn(0), clock => clk);
mpg_RESET:entity WORK.MPG port map(en => en_reset, input => btn(1), clock => clk);

ssd:entity WORK.SSD port map(digit0 => digits(3 downto 0), digit1 => digits(7 downto 4), digit2 => digits(11 downto 8), digit3 => digits(15 downto 12), clk => clk, cat => cat, an => an);

unit_IF:entity WORK.UNITATE_IF port map(
    clk => clk, 
    en_PC => en,
    en_reset => en_reset, 
    branch_address => Branch_address_EX_MEM, 
    jump_address => Jump_address, 
    jump => Jump, 
    PCSrc => PCSrc, 
    instruction => instruction, 
    next_instruction_address => next_instruction_address);
    
unit_ID:entity work.UNITATE_ID port map(
    clk => clk, 
    RegWrite => RegWrite_MEM_WB,
    Instr => Instruction_IF_ID(12 downto 0), 
    ExtOp => ExtOp, 
    WD => WD_regFile, 
    en => en,
    WA => rd_MEM_WB,
    RD1 => RD1, 
    RD2 => RD2, 
    Ext_imm => Ext_imm, 
    func => func, 
    sa => sa,
    rt => rt,
    rd => rd);
    
unit_UC: entity work.UNITATE_UC port map(
    opcode => Instruction_IF_ID(15 downto 13), 
    RegDst => RegDst, 
    ExtOp => ExtOp, 
    ALUSrc => ALUSrc, 
    Branch => Branch, 
    BranchNotEqual => Bne,
    Jump => Jump, 
    MemWrite => MemWrite, 
    MemtoReg => MemtoReg, 
    RegWrite => RegWrite,
    ALUOp => ALUOp);
    
unit_EX:entity work.UNITATE_EX port map(
    RD1 => RD1_ID_EX,
    ALUSrc => ALUSrc_ID_EX, 
    RD2 => RD2_ID_EX, 
    Ext_imm => Ext_Imm_ID_EX, 
    sa => sa_ID_EX,
    func => func_ID_EX,  
    ALUOp => ALUOp_ID_EX, 
    RegDst => RegDst_ID_EX,
    rt => rt_ID_EX,
    rd => rd_ID_EX,
    PC_incremented => PCInc_ID_EX, 
    zero => zero,
    ALURes => ALURes, 
    Branch_Address => Branch_address, 
    rWA => rWA); 
    
unit_MEM:entity work.UNITATE_MEM port map(
    clk => clk, 
    MemWrite => MemWrite_EX_MEM, 
    en => en, 
    ALURes => ALURes_EX_MEM, 
    RD2 => RD2_EX_MEM,
    MemData => MemData,
    ALUResOut => ALUResOut);
    
unit_write_back: process(MemToReg_MEM_WB, ALURes_MEM_WB, MemData_MEM_WB)
begin
    case MemToReg_MEM_WB is
        when '0' => WD_regFile <= ALURes_MEM_WB;
        when '1' => WD_regFile <= MemData_MEM_WB;
        when others => WD_regFile <= (others => 'X');
    end case;
end process;

PCSrc <= (Zero_EX_MEM and Branch_EX_MEM) or ((not Zero_EX_MEM) and Bne_EX_MEM);

Jump_address <= PCinc_IF_ID(15 downto 13) & Instruction_IF_ID(12 downto 0);
    
process(clk)
begin
    if rising_edge(clk) then 
        if en = '1' then 
            --IF/ID
            PCinc_IF_ID <= next_instruction_address;
            Instruction_IF_ID <= instruction;
            --ID/EX
            PCinc_ID_EX <= PCinc_IF_ID;
            RD1_ID_EX <= RD1;
            RD2_ID_EX <= RD2;
            Ext_Imm_ID_EX <= Ext_Imm;
            sa_ID_EX <= sa;
            func_ID_EX <= func;
            rt_ID_EX <= rt;
            rd_ID_EX <= rd;
            MemToReg_ID_EX <= MemToReg;
            RegWrite_ID_EX <= RegWrite;
            MemWrite_ID_EX <= MemWrite;
            Branch_ID_EX <= Branch;
            Bne_ID_EX <= Bne;
            ALUSrc_ID_EX <= ALUSrc;
            ALUOp_ID_EX <= ALUOp;
            RegDst_ID_EX <= RegDst;
            --EX/MEM
            Branch_address_EX_MEM <= Branch_address;
            Zero_EX_MEM <= Zero;
            ALURes_EX_MEM <= ALURes;
            RD2_EX_MEM <= RD2_ID_EX;
            rd_EX_MEM <= rWA;
            MemToReg_EX_MEM <= MemToReg_ID_EX;
            RegWrite_EX_MEM <= RegWrite_ID_EX;
            MemWrite_EX_MEM <= MemWrite_ID_EX;
            Branch_EX_MEM <= Branch_ID_EX;
            Bne_EX_MEM <= Bne_ID_EX;
            --MEM/WB
            MemData_MEM_WB <= MemData;
            ALURes_MEM_WB <= ALUResOut;
            rd_MEM_WB <= rd_EX_MEM;
            MemToReg_MEM_WB <= MemToReg_EX_MEM;
            RegWrite_MEM_WB <= RegWrite_EX_MEM;
        end if;
    end if;
end process;

process(sw(7 downto 5), instruction, next_instruction_address, RD1_ID_EX, RD2_ID_EX, Ext_Imm_ID_EX, ALURes, MemData, WD_regFile)
begin
    case sw(7 downto 5) is
        when "000" => digits <= instruction;
        when "001" => digits <= next_instruction_address;
        when "010" => digits <= RD1_ID_EX;
        when "011" => digits <= RD2_ID_EX;
        when "100" => digits <= Ext_Imm_ID_EX;
        when "101" => digits <= ALURes;
        when "110" => digits <= MemData;
        when "111" => digits <= WD_regFile;
        when others => digits <= (others => 'X');
    end case;
end process;

led(11 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Bne & Jump & MemWrite & MemtoReg & RegWrite;
    
end Behavioral;