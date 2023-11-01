----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2023 11:54:49 PM
-- Design Name: 
-- Module Name: UNITATE_EX - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UNITATE_EX is
    Port(   RD1: in std_logic_vector(15 downto 0);
            ALUSrc: in std_logic;
            RD2: in std_logic_vector(15 downto 0);
            Ext_Imm: in std_logic_vector(15 downto 0);
            sa: in std_logic;
            func: in std_logic_vector(2 downto 0);
            ALUOp: in std_logic_vector(2 downto 0);
            RegDst: in std_logic;
            rt: in std_logic_vector(2 downto 0);
            rd: in std_logic_vector(2 downto 0);
            PC_incremented: in std_logic_vector(15 downto 0);
            zero: out std_logic;
            ALURes: out std_logic_vector(15 downto 0);
            Branch_Address: out std_logic_vector(15 downto 0);
            rWA: out std_logic_vector(2 downto 0));
end UNITATE_EX;

architecture Behavioral of UNITATE_EX is

signal out_mux: std_logic_vector(15 downto 0) := x"0000";
signal ALUCtrl: std_logic_vector(2 downto 0) := "000";
signal ALUResult: std_logic_vector(15 downto 0) := x"0000";

begin

process(ALUSrc, RD2, Ext_Imm)
begin
    case ALUSrc is
        when '0' => out_mux <= RD2;
        when '1' => out_mux <= Ext_Imm;
        when others => out_mux <= x"0000";
    end case;
end process;

process(ALUOp, func)
begin
    case ALUOp is
        when "000" => --Tip R
            case func is
                when "000" => ALUCtrl <= "000"; -- ADD
                when "001" => ALUCtrl <= "001"; -- SUB
                when "010" => ALUCtrl <= "010"; -- SLL
                when "011" => ALUCtrl <= "011"; -- SRL
                when "100" => ALUCtrl <= "100"; -- AND
                when "101" => ALUCtrl <= "101"; -- OR
                when "110" => ALUCtrl <= "110"; -- XOR
                when others => ALUCtrl <= (others => 'X');
            end case;
        when "001" => ALUCtrl <= "000"; -- +
        when "010" => ALUCtrl <= "001"; -- -
        when "101" => ALUCtrl <= "100"; -- &
        when "110" => ALUCtrl <= "101"; -- |
        when others => ALUCtrl <= (others => 'X');
    end case;
end process;

process(RD1, out_mux, ALUCtrl, sa, ALUResult)
begin
    case ALUCtrl is
        when "000" => ALUResult <= RD1 + out_mux; -- ADD
        when "001" =>  ALUResult <= RD1 - out_mux; -- SUB                                   
        when "010" => 
            case sa is
                when '0' => ALUResult <= out_mux;
                when '1' => ALUResult <= out_mux(14 downto 0) & "0";
                when others => ALUResult <= (others => '0'); -- SLL
            end case;
        when "011" =>
            case sa is 
                when '0' => ALUResult <= out_mux;
                when '1' => ALUResult <= "0" & out_mux(15 downto 1);
                when others => ALUResult <= (others => '0'); -- SRL
            end case;
        when "100" => ALUResult <= RD1 and out_mux;	-- AND	
        when "101" => ALUResult <= RD1 or out_mux; -- OR
        when "110" => ALUResult <= RD1 xor out_mux;	-- XOR	
        when others => ALUResult <= (others => '0'); -- other          
    end case;
    
      case ALUResult is
            when x"0000" => zero <= '1';
            when others => zero <= '0';
      end case;
end process;

ALURes <= ALUResult;
Branch_Address <= PC_incremented + Ext_Imm;

process(RegDst, rt, rd)
begin
    case RegDst is
        when '0' => rWA <= rt;
        when '1' => rWA <= rd;
        when others => rWA <= x"0";
    end case;
end process;

end Behavioral;