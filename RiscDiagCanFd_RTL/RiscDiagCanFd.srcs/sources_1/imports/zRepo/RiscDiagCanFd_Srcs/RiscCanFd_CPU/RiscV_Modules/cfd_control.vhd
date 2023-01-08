----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/13/2022 09:53:18 PM
-- Design Name: 
-- Module Name: cfd_control - Behavioral
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

entity cfd_control is
    Port ( id_ex_reg_control_cfd_enb : in STD_LOGIC;
           id_ex_reg_control_cfd_fct : in STD_LOGIC_VECTOR (6 downto 0);
           ex_control_cfd_enb : out STD_LOGIC;
           ex_control_cfd_fct : out STD_LOGIC_VECTOR (6 downto 0));
end cfd_control;

architecture Behavioral of cfd_control is

begin
cfd_ctl: process (id_ex_reg_control_cfd_enb, id_ex_reg_control_cfd_fct) is

    begin   
        ex_control_cfd_enb <= id_ex_reg_control_cfd_enb; 
        
        if id_ex_reg_control_cfd_enb = '1' then
            ex_control_cfd_fct <= id_ex_reg_control_cfd_fct;
        else
            ex_control_cfd_fct <= "0000000";    
        end if;
    end process cfd_ctl;

end Behavioral;
