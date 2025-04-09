--! Include the IEEE standard logic library
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

--! Entity declaration for the top-level design
ENTITY top IS
  GENERIC (
    DATA_WIDTH : INTEGER := 128; --! Data width for UART and processing
    entity_x : INTEGER := 0; --! Entity X coordinate (user-defined)
    entity_y : INTEGER := 0 --! Entity Y coordinate (user-defined)
  );
  PORT (
    Clock : IN STD_LOGIC; --! System clock
    reset : IN STD_LOGIC; --! Synchronous reset
    Txd : OUT STD_LOGIC; --! UART transmitter output
    Rxd : IN STD_LOGIC; --! UART receiver input
    seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --! Seven segment display segments
    an : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); --! Seven segment anode control (group 1)
    an2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); --! Seven segment anode control (group 2)
    vgaRed : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --! VGA red output
    vgaGreen : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --! VGA green output
    vgaBlue : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --! VGA blue output
    Hsync : OUT STD_LOGIC; --! VGA horizontal sync
    Vsync : OUT STD_LOGIC; --! VGA vertical sync
    ps2_clk : IN STD_LOGIC; --! PS/2 clock line
    ps2_data : IN STD_LOGIC --! PS/2 data line
  );
END top;

--! Architecture body
ARCHITECTURE Behavioral OF top IS

  --! UART signal declarations
  SIGNAL uart_tx_data_sig : STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0); --! Data to be transmitted
  SIGNAL uart_tx_enable_sig : STD_LOGIC; --! Enable signal for UART TX
  SIGNAL uart_tx_done_sig : STD_LOGIC; --! UART TX done flag
  SIGNAL uart_rx_data_sig : STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0); --! Data received
  SIGNAL uart_rx_done_sig : STD_LOGIC; --! UART RX done flag

  --! Control unit signal declarations
  SIGNAL cu_vga_data_sig : STD_LOGIC_VECTOR (111 DOWNTO 0); --! VGA display data
  SIGNAL cu_vga_done_sig : STD_LOGIC; --! VGA data ready flag
  SIGNAL cu_uart_tx_data_sig : STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);--! Data to transmit from control unit
  SIGNAL cu_uart_tx_enable_sig : STD_LOGIC; --! UART TX enable from control unit
  SIGNAL cu_uart_tx_done_sig : STD_LOGIC; --! UART TX done signal to control unit
  SIGNAL cu_uart_rx_data_sig : STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);--! UART received data to control unit
  SIGNAL cu_uart_rx_done_sig : STD_LOGIC; --! UART RX done signal to control unit

  --! Display signal declarations
  SIGNAL display_flag_done_receiving_sig : STD_LOGIC; --! Flag indicating data reception is complete
  SIGNAL display_data_sig : STD_LOGIC_VECTOR (0 TO 111); --! Data to be displayed

  --! Keyboard signal declarations
  SIGNAL keyboard_flag_receive_sig : STD_LOGIC; --! PS/2 data reception flag
  SIGNAL keyboard_data_out_sig : STD_LOGIC_VECTOR (0 TO 127); --! Output data from keyboard

  --! UART component declaration
  COMPONENT uart_j IS
    PORT (
      Clock : IN STD_LOGIC; --! System clock
      reset : IN STD_LOGIC; --! Synchronous reset
      seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --! Seven segment segments
      an : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); --! Seven segment anode (group 1)
      an2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); --! Seven segment anode (group 2)
      Txd : OUT STD_LOGIC; --! UART TX output
      Tx_done : OUT STD_LOGIC; --! TX done signal
      Tx_enable : IN STD_LOGIC; --! TX enable input
      Tx_data : IN STD_LOGIC_VECTOR (127 DOWNTO 0); --! TX data input
      Rxd : IN STD_LOGIC; --! UART RX input
      Rx_done : OUT STD_LOGIC; --! RX done output
      Rx_data : OUT STD_LOGIC_VECTOR (127 DOWNTO 0) --! RX data output
    );
  END COMPONENT;

  --! Control unit component declaration
  COMPONENT control_unit IS
    GENERIC (
      DATA_WIDTH : INTEGER := 128; --! UART and PS/2 data width
      entity_x : INTEGER := 0; --! User-defined coordinate
      entity_y : INTEGER := 0 --! User-defined coordinate
    );
    PORT (
      clk : IN STD_LOGIC; --! System clock
      reset : IN STD_LOGIC; --! Synchronous reset
      ps2_data : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0); --! Keyboard data
      ps2_done : IN STD_LOGIC; --! Keyboard data done flag
      vga_data : OUT STD_LOGIC_VECTOR (111 DOWNTO 0); --! VGA pixel data
      vga_done : OUT STD_LOGIC; --! VGA data ready flag
      uart_tx_data : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0); --! UART TX data
      uart_tx_enable : OUT STD_LOGIC; --! UART TX enable
      uart_tx_done : IN STD_LOGIC; --! UART TX done signal
      uart_rx_data : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0); --! UART RX data
      uart_rx_done : IN STD_LOGIC --! UART RX done signal
    );
  END COMPONENT;

  --! Display component declaration
  COMPONENT Display IS
    PORT (
      clk : IN STD_LOGIC; --! System clock
      reset : IN STD_LOGIC; --! Synchronous reset
      flagDoneReceiving : IN STD_LOGIC; --! Data received flag
      data : IN STD_LOGIC_VECTOR (0 TO 111); --! Display data
      vgaRed : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); --! VGA red output
      vgaGreen : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); --! VGA green output
      vgaBlue : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); --! VGA blue output
      Hsync : OUT STD_LOGIC; --! VGA horizontal sync
      Vsync : OUT STD_LOGIC --! VGA vertical sync
    );
  END COMPONENT;

  --! Keyboard component declaration
  COMPONENT Keyboard IS
    PORT (
      clk : IN STD_LOGIC; --! System clock
      ps2_clk : IN STD_LOGIC; --! PS/2 clock
      ps2_data : IN STD_LOGIC; --! PS/2 data
      flag_receive : OUT STD_LOGIC; --! Data received flag
      data_out : OUT STD_LOGIC_VECTOR(0 TO 127) --! Output keyboard data
    );
  END COMPONENT;

BEGIN

  --! Instantiate Keyboard
  keyboard_inst : Keyboard
  PORT MAP(
    clk => Clock,
    ps2_clk => ps2_clk,
    ps2_data => ps2_data,
    flag_receive => keyboard_flag_receive_sig,
    data_out => keyboard_data_out_sig
  );

  --! Instantiate Control Unit
  control_unit_inst : control_unit
  GENERIC MAP(
    DATA_WIDTH => DATA_WIDTH,
    entity_x => entity_x,
    entity_y => entity_y
  )
  PORT MAP(
    clk => Clock,
    reset => reset,
    ps2_data => keyboard_data_out_sig,
    ps2_done => keyboard_flag_receive_sig,
    vga_data => cu_vga_data_sig,
    vga_done => cu_vga_done_sig,
    uart_tx_data => cu_uart_tx_data_sig,
    uart_tx_enable => cu_uart_tx_enable_sig,
    uart_tx_done => uart_tx_done_sig,
    uart_rx_data => uart_rx_data_sig,
    uart_rx_done => uart_rx_done_sig
  );

  --! Instantiate UART
  uart_inst : uart_j
  PORT MAP(
    Clock => Clock,
    reset => reset,
    seg => seg,
    an => an,
    an2 => an2,
    Txd => Txd,
    Tx_done => uart_tx_done_sig,
    Tx_enable => cu_uart_tx_enable_sig,
    Tx_data => cu_uart_tx_data_sig,
    Rxd => Rxd,
    Rx_done => uart_rx_done_sig,
    Rx_data => uart_rx_data_sig
  );

  --! Instantiate Display
  display_inst : Display
  PORT MAP(
    clk => Clock,
    reset => reset,
    flagDoneReceiving => cu_vga_done_sig,
    data => cu_vga_data_sig,
    vgaRed => vgaRed,
    vgaGreen => vgaGreen,
    vgaBlue => vgaBlue,
    Hsync => Hsync,
    Vsync => Vsync
  );

END Behavioral;