----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/13/2022 09:19:19 PM
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

entity control_unit is
    Port ( opcode : in STD_LOGIC_VECTOR (6 downto 0);
           funct7 : in STD_LOGIC_VECTOR (6 downto 0);
           id_control_alu_op : out STD_LOGIC_VECTOR (1 downto 0);
           id_control_alu_src : out STD_LOGIC;
           id_control_mem_read : out STD_LOGIC;
           id_control_mem_write : out STD_LOGIC;
           id_control_reg_write : out STD_LOGIC;
           id_control_mem_to_reg : out STD_LOGIC;
           id_control_is_branch : out STD_LOGIC;
           id_control_cfd_enb : out STD_LOGIC;
           id_control_cfd_fct : out STD_LOGIC_VECTOR (6 downto 0));
end control_unit;

architecture Behavioral of control_unit is

begin
    control_un: process (opcode) is
        constant R_FORMAT: std_logic_vector(6 downto 0) := "0110011";
        constant ADDI: std_logic_vector(6 downto 0) := "0010011";
        constant LOAD: std_logic_vector(6 downto 0) := "0000011";
        constant STORE: std_logic_vector(6 downto 0) := "0100011";
        constant BEQ: std_logic_vector(6 downto 0) := "1100011";
        constant CANFD: std_logic_vector(6 downto 0) := "1111000"; --added by CoPo
    begin
        id_control_alu_op <= "00";
        id_control_alu_src <= '0';
        id_control_mem_read <= '0';
        id_control_mem_write <= '0';
        id_control_reg_write <= '0';
        id_control_mem_to_reg <= '0';
        id_control_is_branch <= '0';
        id_control_cfd_enb <= '0';         --added by CoPo
        id_control_cfd_fct <= "0000000";   --added by CoPo
        
        if opcode = R_FORMAT then
            id_control_alu_op <= "10";
            id_control_reg_write <= '1';
        elsif opcode = ADDI then
            id_control_alu_op <= "10";
            id_control_reg_write <= '1';
            id_control_alu_src <= '1';
        elsif opcode = LOAD then
            id_control_alu_src <= '1';
            id_control_mem_read <= '1';
            id_control_reg_write <= '1';
            id_control_mem_to_reg <= '1';
        elsif opcode = STORE then
            id_control_alu_src <= '1';
            id_control_mem_write <= '1';
        elsif opcode = BEQ then
            id_control_alu_op <= "01"; 
            id_control_is_branch <= '1';          
        elsif opcode = CANFD then         --added by CoPo
            id_control_alu_op <= "11";
            id_control_reg_write <= '1';
            id_control_cfd_enb <= '1'; 
            id_control_cfd_fct <= funct7;
        end if;
    end process control_un;

end Behavioral;
