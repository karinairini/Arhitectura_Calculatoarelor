----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2023 11:25:52 AM
-- Design Name: 
-- Module Name: UNITATE_UC - Behavioral
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

entity UNITATE_UC is
    Port(   opcode: in std_logic_vector(2 downto 0);
            RegDst: out std_logic;
            ExtOp: out std_logic;
            ALUSrc: out std_logic;
            Branch: out std_logic;
            BranchNotEqual: out std_logic;
            Jump: out std_logic;
            MemWrite: out std_logic;
            MemToReg: out std_logic;
            RegWrite: out std_logic;
            ALUOp: out std_logic_vector(2 downto 0));
end UNITATE_UC;

architecture Behavioral of UNITATE_UC is

begin

process(opcode)
begin
        RegDst <= '0'; 
        ExtOp <= '0'; 
        ALUSrc <= '0'; 
        Branch <= '0'; 
        BranchNotEqual <= '0';
        Jump <= '0';
        MemWrite <= '0';
        MemtoReg <= '0'; 
        RegWrite <= '0';
        ALUOp <= "000";
        case(opcode) is
            when "000" => RegDst <= '1'; -- tip R
                RegWrite <= '1';
                ALUOp <= "000";
            when "001" =>  ExtOp <= '1'; -- addi 
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "001";
            when "010" => ExtOp <= '1'; -- lw
                ALUSrc <= '1';
                MemtoReg <= '1';
                RegWrite <= '1';
                ALUOp <= "001";
            when "011" => ExtOp <= '1'; -- sw
                ALUSrc <= '1';
                MemWrite <= '1';
                ALUOp <= "001";
            when "100" => ExtOp <= '1'; -- beq
                Branch <= '1';
                ALUOp <= "010";
            when "101" => ExtOp <= '1'; -- subi
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "010";
            when "110" => ExtOp <= '1'; -- bne
                BranchNotEqual <= '1';
                ALUOp <= "010";
            when "111" => Jump <= '1'; -- j
            when others => 
                RegDst <= '0'; ExtOp <= '0'; ALUSrc <= '0'; 
                Branch <= '0'; Jump <= '0'; MemWrite <= '0';
                MemtoReg <= '0'; RegWrite <= '0';
                ALUOp <= "000";
        end case;
end process;

end Behavioral;