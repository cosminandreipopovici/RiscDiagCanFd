----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/13/2022 09:37:00 PM
-- Design Name: 
-- Module Name: alu_control - Behavioral
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

entity alu_control is
    Port ( id_ex_reg_alu_control : in STD_LOGIC_VECTOR (3 downto 0);
           id_ex_reg_control_alu_op : in STD_LOGIC_VECTOR (1 downto 0);
           ex_alu_control : out STD_LOGIC_VECTOR (2 downto 0));
end alu_control;

architecture Behavioral of alu_control is

begin

alu_ctl: process (id_ex_reg_alu_control, id_ex_reg_control_alu_op) is
        constant ALU_AND: std_logic_vector(2 downto 0) := "000"; --0
        constant ALU_OR:  std_logic_vector(2 downto 0) := "001";  --1
        constant ALU_ADD: std_logic_vector(2 downto 0) := "010"; --2
        constant ALU_SUB: std_logic_vector(2 downto 0) := "110"; --6
        constant ALU_SLL: std_logic_vector(2 downto 0) := "011"; --3  --added by CoPo
        constant ALU_SRL: std_logic_vector(2 downto 0) := "101";  --5 --added by CoPo
        constant ALU_XOR: std_logic_vector(2 downto 0) := "100";  --4 --added by CoPo
    begin    
        ex_alu_control <= ALU_AND;
             
        if id_ex_reg_control_alu_op = "00" then
            ex_alu_control <= ALU_ADD;
        elsif id_ex_reg_control_alu_op = "01" then
            ex_alu_control <= ALU_SUB;
        elsif id_ex_reg_control_alu_op = "11" then    --added by CoPo --add for debug purpose
            ex_alu_control <= ALU_ADD;
        elsif id_ex_reg_alu_control = "0000" then
            ex_alu_control <= ALU_ADD;
        elsif id_ex_reg_alu_control = "1000" then
            ex_alu_control <= ALU_SUB;       
        elsif id_ex_reg_alu_control = "0111" then
            ex_alu_control <= ALU_AND;
        elsif id_ex_reg_alu_control = "0110" then
            ex_alu_control <= ALU_OR;
        elsif id_ex_reg_alu_control = "0001" then  --added by CoPo
            ex_alu_control <= ALU_SLL;
        elsif id_ex_reg_alu_control = "0101" then  --added by CoPo
            ex_alu_control <= ALU_SRL;
        elsif id_ex_reg_alu_control = "0100" then  --added by CoPo
            ex_alu_control <= ALU_XOR;                                         
        end if;
    end process alu_ctl;

end Behavioral;
