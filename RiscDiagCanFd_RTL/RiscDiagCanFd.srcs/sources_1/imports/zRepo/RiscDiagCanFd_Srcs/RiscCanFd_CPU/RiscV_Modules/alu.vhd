library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 

entity alu is
    generic(DATA_WIDTH: integer := 32);

    port(
        control: in std_logic_vector(2 downto 0);
        left_operand: in std_logic_vector(DATA_WIDTH-1 downto 0);
        right_operand: in std_logic_vector(DATA_WIDTH-1 downto 0);
        zero: out std_logic;
        result: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end alu;

architecture behavioral of alu is

    signal alu_result: std_logic_vector(DATA_WIDTH-1 downto 0);
    signal res_L: std_logic_vector(DATA_WIDTH-1 downto 0);
    signal res_R: std_logic_vector(DATA_WIDTH-1 downto 0);
    constant ALU_AND: std_logic_vector(2 downto 0) := "000"; --0
    constant ALU_OR: std_logic_vector(2 downto 0) := "001";  --1
    constant ALU_ADD: std_logic_vector(2 downto 0) := "010"; --2
    constant ALU_SUB: std_logic_vector(2 downto 0) := "110"; --6
    constant ALU_SLL: std_logic_vector(2 downto 0) := "011"; --3  --added by CoPo
    constant ALU_SRL: std_logic_vector(2 downto 0) := "101";  --5 --added by CoPo
    constant ALU_XOR: std_logic_vector(2 downto 0) := "100";  --4 --added by CoPo
    constant CONST_0: std_logic_vector(31 downto 0):= x"00000000";
    constant REG_LIM: natural:= 31;
begin

    shift_unit: entity work.shift_module 
        port map (
            op1 => left_operand,
            op2 => right_operand,
            res_L => res_L,
            res_R => res_R
        );

    process(control, left_operand, right_operand, res_L, res_R)
    begin
        case control is
            when ALU_AND => 
                alu_result <= left_operand and right_operand;
            when ALU_OR => 
                alu_result <= left_operand or right_operand;
            when ALU_ADD =>
                alu_result <= std_logic_vector(signed(left_operand) + signed(right_operand));
            when ALU_SUB => 
                alu_result <= std_logic_vector(signed(left_operand) - signed(right_operand));
            when ALU_SLL => 
                alu_result <= res_L;
            when ALU_SRL => 
                alu_result <= res_R;
            when ALU_XOR => 
                alu_result <= left_operand xor right_operand;
            when others => 
                alu_result <= left_operand and right_operand;
        end case;
    end process;

    result <= alu_result;
    zero <= '1' when signed(alu_result) = 0 else '0';

end behavioral;


