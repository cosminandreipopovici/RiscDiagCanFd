library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity data_memory is
    generic (
        ADDRESS_WIDTH: natural := 12;
        DATA_WIDTH: natural := 32
    );
    
    port (
        clk: in std_logic;
        
        write_en: in std_logic;
        write_data: in std_logic_vector(DATA_WIDTH-1 downto 0);
        address: in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
        read_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
        
        can_write_en: in std_logic;
        can_write_data: in std_logic_vector(DATA_WIDTH-1 downto 0);
        can_address: in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
        
        dbg_write_en: in std_logic;
        dbg_write_data: in std_logic_vector(DATA_WIDTH-1 downto 0);
        dbg_address: in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
        dbg_read_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
        
        udp_ip_data : out std_logic_vector(DATA_WIDTH-1 downto 0)
        
    );
end data_memory;

architecture behavioral of data_memory is

    signal ip_addr: std_logic_vector(ADDRESS_WIDTH-1 downto 0) :=x"03A";

    constant MEMORY_DEPTH: natural := 2 ** ADDRESS_WIDTH;
    
    type ram_type is array (0 to MEMORY_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ram: ram_type := (
        others => "00000000000000000000000000000000"
    );
    signal wr_opt: std_logic_vector(2 downto 0);
begin
    
    wr_opt <= dbg_write_en & can_write_en & write_en;
    
    data_ram: process (clk) is
    begin
        if rising_edge(clk) then
            if dbg_write_en = '1' then
                ram(to_integer(unsigned(dbg_address))) <= dbg_write_data;
            elsif can_write_en = '1' then
                ram(to_integer(unsigned(can_address))) <= can_write_data;    
            elsif write_en = '1' then
                ram(to_integer(unsigned(address))) <= write_data;
            end if;
        end if;
    end process data_ram;
    
--    data_ram: process (clk) is
--    begin
--        if rising_edge(clk) then
--            if wr_opt = "1XX" then
--                ram(to_integer(unsigned(dbg_address))) <= dbg_write_data;
--            elsif wr_opt = "01X" then
--                ram(to_integer(unsigned(can_address))) <= can_write_data;    
--            elsif wr_opt = "001" then
--                ram(to_integer(unsigned(address))) <= write_data;
--            end if;
--        end if;
--    end process data_ram;
    
    dbg_read_data <= ram(to_integer(unsigned(dbg_address)));
    read_data     <= ram(to_integer(unsigned(address)));
    udp_ip_data   <= ram(to_integer(unsigned(ip_addr)));
end behavioral;
