----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/21/2022 08:08:33 PM
-- Design Name: 
-- Module Name: NetStackUdp - Behavioral
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

entity DiagnoseModule is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           
           CAN_2_UDP_EN   : in std_logic;
		   CAN_2_UDP_ADDR : in std_logic_vector( 4 downto 0);
		   CAN_2_UDP_DATA : in std_logic_vector(31 downto 0);
           
           ETH_REFCLK : out STD_LOGIC;
           ETH_RSTN : out STD_LOGIC;
           ETH_CRSDV : in STD_LOGIC;
           ETH_RXD : in STD_LOGIC_VECTOR(1 downto 0);
           ETH_RXERR : in STD_LOGIC;
           ETH_TXEN : out STD_LOGIC;
           ETH_TXD : out STD_LOGIC_VECTOR(1 downto 0);
           ETH_MDC : out STD_LOGIC;
           ETH_MDIO : inout STD_LOGIC;
           udp_ip_config : in std_logic_vector(31 downto 0);
           meas_perf_eth_transmitting : out STD_LOGIC;
           meas_perf_outisempty : out STD_LOGIC
     );
end DiagnoseModule;

architecture Behavioral of DiagnoseModule is

component FC1001_RMII is
    port (
        --Sys/Common
        Clk             : in  std_logic; --100 MHz
        Reset           : in  std_logic; --Active high
        UseDHCP         : in  std_logic; --'1' to use DHCP
        IP_Addr         : in  std_logic_vector(31 downto 0); --IP address if not using DHCP
        IP_Ok           : out std_logic; --DHCP ready

        --MAC/RMII
        RMII_CLK_50M    : out std_logic; --RMII continous 50 MHz reference clock
        RMII_RST_N      : out std_logic; --Phy reset, active low
        RMII_CRS_DV     : in  std_logic; --Carrier sense/Receive data valid
        RMII_RXD0       : in  std_logic; --Receive data bit 0
        RMII_RXD1       : in  std_logic; --Receive data bit 1
        RMII_RXERR      : in  std_logic; --Receive error, optional
        RMII_TXEN       : out std_logic; --Transmit enable
        RMII_TXD0       : out std_logic; --Transmit data bit 0
        RMII_TXD1       : out std_logic; --Transmit data bit 1
        RMII_MDC        : out std_logic; --Management clock
        RMII_MDIO       : inout std_logic; --Management data

        --UDP Basic Server
        UDP0_Reset      : in  std_logic; --Reset interface, active high
        UDP0_Service    : in  std_logic_vector(15 downto 0); --Service
        UDP0_ServerPort : in  std_logic_vector(15 downto 0); --UDP local server port
        UDP0_Connected  : out std_logic; --Client connected
        UDP0_OutIsEmpty : out std_logic; --All outgoing data acked
        UDP0_TxData     : in  std_logic_vector(7 downto 0); --Transmit data
        UDP0_TxValid    : in  std_logic; --Transmit data valid
        UDP0_TxReady    : out std_logic; --Transmit data ready
        UDP0_TxLast     : in  std_logic; --Transmit data last
        UDP0_RxData     : out std_logic_vector(7 downto 0); --Receive data
        UDP0_RxValid    : out std_logic; --Receive data valid
        UDP0_RxReady    : in  std_logic; --Receive data ready
        UDP0_RxLast     : out std_logic  --Transmit data last
        
        
    );
end component;

signal UDP00_Connected : STD_LOGIC;
signal UDP00_OutIsEmpty : STD_LOGIC;
signal UDP00_TxData : STD_LOGIC_VECTOR(7 downto 0);
signal UDP00_TxValid : STD_LOGIC;
signal UDP00_TxReady : STD_LOGIC;
signal UDP00_TxLast : STD_logic;
signal UDP00_RxData : STD_LOGIC_VECTOR(7 downto 0);
signal UDP00_RxValid : STD_LOGIC;
signal UDP00_RxReady : STD_LOGIC;
signal UDP00_RxLast : STD_LOGIC;

signal reset_pos : STD_LOGIC; 

signal ipok : std_logic :='0';
begin

reset_pos <= (not reset);
meas_perf_outisempty<=UDP00_OutIsEmpty;

i_CanUdpBridge : entity work.CanUdpBridge
    port map(
        clk => clk,
        reset => reset,
        udp_write_en => CAN_2_UDP_EN,
        udp_write_addr => CAN_2_UDP_ADDR,
        udp_write_data => CAN_2_UDP_DATA,
        UDP0_Connected => UDP00_Connected,
        UDP0_OutIsEmpty => UDP00_OutIsEmpty,
        UDP0_TxData => UDP00_TxData,
        UDP0_TxValid => UDP00_TxValid,
        UDP0_TxReady =>  UDP00_TxReady,
        UDP0_TxLast => UDP00_TxLast,
        UDP0_RxData => UDP00_RxData,
        UDP0_RxValid => UDP00_RxValid,
        UDP0_RxReady => UDP00_RxReady,
        UDP0_RxLast => UDP00_RxLast,
        txing => meas_perf_eth_transmitting
    );
    
i_FC1001_RMII : FC1001_RMII
    port map(
        Clk => clk,
        Reset => reset_pos,
        --Reset => '0',
        UseDHCP => '0',
        IP_Addr => udp_ip_config,
        --IP_Addr => x"A9FEF0F0",
        --IP_Addr => x"C0A86441",
        IP_Ok => ipok, 
        RMII_CLK_50M    => ETH_REFCLK,      -- RMII continous 50 MHz reference clock
        RMII_RST_N      => ETH_RSTN,        -- Phy reset, active low
        RMII_CRS_DV     => ETH_CRSDV,       -- Carrier sense/Receive data valid
        RMII_RXD0       => ETH_RXD(0),      -- Receive data bit 0
        RMII_RXD1       => ETH_RXD(1),      -- Receive data bit 1
        RMII_RXERR      => ETH_RXERR,       -- Receive error, optional
        RMII_TXEN       => ETH_TXEN,        -- Transmit enable
        RMII_TXD0       => ETH_TXD(0),      -- Transmit data bit 0
        RMII_TXD1       => ETH_TXD(1),      -- Transmit data bit 1
        RMII_MDC        => ETH_MDC,         -- Management clock
        RMII_MDIO       => ETH_MDIO,        -- Management data,
        UDP0_Reset => reset_pos,
        --UDP0_Reset => '0',
        UDP0_Service    => x"0112",
        UDP0_ServerPort => x"E001",
        --UDP0_ServerPort => x"0BC2",
        UDP0_Connected => UDP00_Connected,
        UDP0_OutIsEmpty => UDP00_OutIsEmpty,
        UDP0_TxData => UDP00_TxData,
        UDP0_TxValid => UDP00_TxValid,
        UDP0_TxReady =>  UDP00_TxReady,
        UDP0_TxLast => UDP00_TxLast,
        UDP0_RxData => UDP00_RxData,
        UDP0_RxValid => UDP00_RxValid,
        UDP0_RxReady => UDP00_RxReady,
        UDP0_RxLast => UDP00_RxLast
    );    
    

end Behavioral;
