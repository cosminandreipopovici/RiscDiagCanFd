library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common.all;


entity RiscDiag_CanFd is
    generic (
        PROGRAM_ADDRESS_WIDTH: natural := 12;
        DATA_ADDRESS_WIDTH: natural := 12;
        CPU_DATA_WIDTH: natural := 32
    );
    
    port (
        clk: in std_logic;
        reset_n: in std_logic; 
        --redundant: out std_logic;
        can_rx: in std_logic;
        can_tx: out std_logic;
        uart_rx: in std_logic;
        uart_tx: out std_logic;
        
        ETH_MDC     : out std_logic;
        ETH_MDIO    : inout std_logic;
        ETH_RSTN    : out std_logic;
        ETH_CRSDV   : in  std_logic;
        ETH_RXERR   : in  std_logic;
        ETH_RXD     : in  std_logic_vector(1 downto 0);
        ETH_TXEN    : out std_logic;
        ETH_TXD     : out std_logic_vector(1 downto 0);
        ETH_REFCLK  : out std_logic;
        
        gpo: out std_logic_vector(3 downto 0);
        sseg: out std_logic_vector(7 downto 0);
        sseg_an: out std_logic_vector(7 downto 0);
        reset_out: out std_logic;
        
        meas_perf_pin_0: out std_logic;
        meas_perf_pin_1: out std_logic;
        
        erc_capture_out: out std_logic_vector(7 downto 0);
        erc_int        : out std_logic
    );
end RiscDiag_CanFd;

architecture structural of RiscDiag_CanFd is
    
    signal program_address: std_logic_vector(PROGRAM_ADDRESS_WIDTH-1 downto 0);
    signal program_data: std_logic_vector(INSTRUCTION_WIDTH-1 downto 0);
    
    signal dbg_prog_write_en: std_logic;
    signal dbg_prog_address: std_logic_vector(DATA_ADDRESS_WIDTH-1 downto 0);
    signal dbg_prog_read: std_logic_vector(CPU_DATA_WIDTH-1 downto 0);
    signal dbg_prog_write: std_logic_vector(CPU_DATA_WIDTH-1 downto 0);
   
    signal data_write_en: std_logic;
    signal data_address: std_logic_vector(DATA_ADDRESS_WIDTH-1 downto 0);
    signal data_read: std_logic_vector(CPU_DATA_WIDTH-1 downto 0);
    signal data_write: std_logic_vector(CPU_DATA_WIDTH-1 downto 0);    

    signal dbg_data_write_en: std_logic;
    signal dbg_data_address: std_logic_vector(DATA_ADDRESS_WIDTH-1 downto 0);
    signal dbg_data_read: std_logic_vector(CPU_DATA_WIDTH-1 downto 0);
    signal dbg_data_write: std_logic_vector(CPU_DATA_WIDTH-1 downto 0);
    
    signal can_data_write_en: std_logic;
    signal can_data_address: std_logic_vector(DATA_ADDRESS_WIDTH-1 downto 0);
    signal can_data_write: std_logic_vector(CPU_DATA_WIDTH-1 downto 0); 
    
    signal udp_data_write_en: std_logic;
    signal udp_data_address: std_logic_vector(4 downto 0);
    signal udp_data_write: std_logic_vector(CPU_DATA_WIDTH-1 downto 0); 
     
    signal reset_n_neg: std_logic;
    signal reset_out_riscv: std_logic;
    signal reset_for_riscv: std_logic; 
    
    signal dbg_data_address_OUT: std_logic_vector(15 downto 0);
    signal dbg_prog_address_OUT: std_logic_vector(15 downto 0);
    
    signal udp_ip: std_logic_vector(CPU_DATA_WIDTH-1 downto 0);
    
    signal dis: std_logic_vector(CPU_DATA_WIDTH-1 downto 0);
    signal gpo32: std_logic_vector(CPU_DATA_WIDTH-1 downto 0);
    
begin

    reset_n_neg <= (not reset_n);
    reset_for_riscv <= not(reset_n_neg or reset_out_riscv);
    reset_out <= not (reset_for_riscv);
    
    dbg_data_address <= dbg_data_address_OUT(DATA_ADDRESS_WIDTH-1 downto 0);
    dbg_prog_address <= dbg_prog_address_OUT(PROGRAM_ADDRESS_WIDTH-1 downto 0);
    
    gpo <= gpo32(3 downto 0);
    
    RiscCanFd_CPU: entity work.RiscCanFdCPU 
        generic map (
            PROGRAM_ADDRESS_WIDTH => PROGRAM_ADDRESS_WIDTH,
            DATA_ADDRESS_WIDTH => DATA_ADDRESS_WIDTH,
            CPU_DATA_WIDTH => CPU_DATA_WIDTH,
            REGISTER_FILE_ADDRESS_WIDTH => 5
        )
        port map (
            clk => clk,
            reset_n => reset_for_riscv,
            program_read => program_data,
            pc => program_address,
            data_address => data_address,
            data_read => data_read,
            data_write_en => data_write_en,
            data_write => data_write,
            can_tx => can_tx,
            can_rx => can_rx,
            can_data_write_en => can_data_write_en,
            can_data_address => can_data_address,
            can_data_write => can_data_write,
            udp_data_write_en => udp_data_write_en,
            udp_data_address => udp_data_address,
            udp_data_write => udp_data_write,
            gpo_out => gpo32,
            dis_out => dis,
            erc_capture_out => erc_capture_out,
            erc_int => erc_int
        );
    
    Program_Memory: entity work.program_memory 
        generic map (
                ADDRESS_WIDTH => PROGRAM_ADDRESS_WIDTH,
                DATA_WIDTH => INSTRUCTION_WIDTH
            )    
        port map (
            clk => clk,
            write_en => '0',
            write_data => (others => '0'),
            address => program_address,
            read_data => program_data,
            dbg_write_en => dbg_prog_write_en,
            dbg_write_data => dbg_prog_write,
            dbg_address => dbg_prog_address,
            dbg_read_data => dbg_prog_read 
        );

    Data_Memory: entity work.data_memory 
        generic map (
            ADDRESS_WIDTH => DATA_ADDRESS_WIDTH,
            DATA_WIDTH => CPU_DATA_WIDTH
        )
        port map (
            clk => clk,
            write_en => data_write_en,
            write_data => data_write,
            address => data_address,
            read_data => data_read,
            dbg_write_en => dbg_data_write_en,
            dbg_write_data => dbg_data_write,
            dbg_address => dbg_data_address,
            dbg_read_data => dbg_data_read,
            can_write_en => can_data_write_en,
            can_write_data => can_data_write,
            can_address => can_data_address,
            udp_ip_data => udp_ip
        );
            
    Diagnose_Module: entity work.DiagnoseModule
        port map(
            clk => clk,
            --reset => reset_n,
            reset => reset_for_riscv,
            CAN_2_UDP_EN => udp_data_write_en,
            CAN_2_UDP_ADDR =>  udp_data_address,
            CAN_2_UDP_DATA => udp_data_write,
            ETH_MDC => ETH_MDC,
            ETH_MDIO => ETH_MDIO,
            ETH_RSTN => ETH_RSTN,
            ETH_CRSDV => ETH_CRSDV,
            ETH_RXERR => ETH_RXERR,
            ETH_RXD => ETH_RXD,
            ETH_TXEN => ETH_TXEN,
            ETH_TXD => ETH_TXD,
            ETH_REFCLK => ETH_REFCLK,
            udp_ip_config => udp_ip,
            meas_perf_eth_transmitting => meas_perf_pin_0,
            meas_perf_outisempty => meas_perf_pin_1                       
        );    
    
    Uart_Debugger: entity work.UartDebugger
        port map (
            reset => reset_n_neg,
            clock => clk,
            uart_tx => uart_tx,
            uart_rx => uart_rx,
            reset_out_riscv => reset_out_riscv,
            datamem_enbl => dbg_data_write_en,
            datamem_addr => dbg_data_address_OUT,
            datamem_wdat => dbg_data_write,
            datamem_rdat => dbg_data_read,
            progmem_enbl => dbg_prog_write_en,
            progmem_addr => dbg_prog_address_OUT,
            progmem_wdat => dbg_prog_write,
            progmem_rdat => dbg_prog_read
        );
        
    SevenSegmentDisplay_8: entity work.SevenSegDisplay
        port map(
            reset   => reset_n_neg,
            clock   => clk,
            reg_in  => dis,
            sseg    => sseg,
            sseg_an => sseg_an
        );
end structural;