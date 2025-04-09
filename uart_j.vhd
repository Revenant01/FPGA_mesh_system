LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

--! UART top-level entity declaration
ENTITY uart_j IS
  PORT (
    --! General I/O
    Clock : IN STD_LOGIC;               --! System clock
    reset : IN STD_LOGIC;               --! Asynchronous reset
    
    --! Seven-segment display interface
    seg  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);     --! Segment output
    an   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);     --! Digit enable
    an2  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);     --! Second digit enable
    
    --! UART Tx interface
    Txd       : OUT STD_LOGIC;                    --! UART transmit data
    Tx_done   : OUT STD_LOGIC;                    --! Transmission done
    Tx_enable : IN STD_LOGIC;                     --! Transmit enable
    Tx_data   : IN STD_LOGIC_VECTOR(127 DOWNTO 0);--! Data to be transmitted
    
    --! UART Rx interface 
    Rxd      : IN  STD_LOGIC;                     --! UART receive data
    Rx_done  : OUT STD_LOGIC;                     --! Reception done
    Rx_data  : OUT STD_LOGIC_VECTOR(127 DOWNTO 0) --! Received data output
  );
END uart_j;

--! Architecture implementing UART communication and display
ARCHITECTURE Behavioral OF uart_j IS

  --! Internal signal declarations
  SIGNAL ready : STD_LOGIC := '0';                            --! Ready signal for 7-segment
  SIGNAL decryptdone : STD_LOGIC;                             --! Placeholder for decrypt done

  --! Component declaration for 7-segment display
  COMPONENT seven_seg_display IS
    PORT (
      clk   : IN STD_LOGIC;                                   --! Clock input
      ready : IN STD_LOGIC;                                   --! Ready signal
      state : IN STD_LOGIC_VECTOR(127 DOWNTO 0);              --! Data to display
      seg   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);               --! Segment output
      an    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);               --! Anode control
      an2   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)                --! Second anode control
    );
  END COMPONENT;
  
  --! Component declaration for UART receiver
  COMPONENT uart_rxj IS
    PORT (
      Clock         : IN  STD_LOGIC;                          --! Clock input
      Reset         : IN  STD_LOGIC;                          --! Reset signal
      Rxd           : IN  STD_LOGIC;                          --! Serial input
      Received_Data : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);     --! Received parallel data
      receive_done  : OUT STD_LOGIC                           --! Reception done signal
    );
  END COMPONENT;
  
  --! Component declaration for UART transmitter
  COMPONENT uart_txj IS
    PORT (
      Clock     : IN  STD_LOGIC;                              --! Clock input
      Reset     : IN  STD_LOGIC;                              --! Reset signal
      Enable    : IN  STD_LOGIC;                              --! Enable signal
      Txd       : OUT STD_LOGIC;                              --! Serial output
      DATA_BIT  : IN  STD_LOGIC_VECTOR(127 DOWNTO 0);         --! Data to be sent
      send_done : OUT STD_LOGIC                               --! Transmission done signal
    );
  END COMPONENT;
  
  --! Internal signals for logic
  SIGNAL i                  : INTEGER := 0;                    --! Counter variable
  SIGNAL flag               : STD_LOGIC := '0';                --! Condition flag
  SIGNAL intermediate       : STD_LOGIC_VECTOR(127 DOWNTO 0); --! Temporary buffer for Rx
  SIGNAL decryptionoutput   : STD_LOGIC_VECTOR(127 DOWNTO 0); --! Placeholder for decryption
  SIGNAL Rx_done_tmp        : STD_LOGIC;                       --! Intermediate done signal

BEGIN

  --! UART transmitter instantiation
  transmitter : uart_txj PORT MAP(
    Clock     => Clock,
    Reset     => reset,
    Enable    => Tx_enable,
    DATA_BIT  => Tx_data,
    Txd       => Txd,
    send_done => Tx_done
  );

  --! UART receiver instantiation
  receiver : uart_rxj PORT MAP(
    Clock         => Clock,
    Reset         => reset,
    Rxd           => Rxd,
    Received_Data => intermediate,
    receive_done  => Rx_done_tmp
  );

  --! Seven-segment display controller instantiation
  seven_seg : seven_seg_display PORT MAP(
    clk   => Clock,
    ready => Rx_done_tmp,
    state => intermediate,
    seg   => seg,
    an    => an,
    an2   => an2
  );
  
  --! Process to forward Rx_done_tmp to Rx_done
  process (Clock)
  begin
    Rx_done <= Rx_done_tmp;
  end process;

  --! Set ready high after 2 seconds
  ready <= '1' AFTER 2000000000ns;
  
  --! Process to assert flag based on input value
  PROCESS (intermediate)
  BEGIN
    IF intermediate > x"01000000000000000000000000000000" THEN
      flag <= '1' AFTER 2000000000ns; --! Simulate delay on high flag
    ELSE
      flag <= '0';                   --! Otherwise, keep flag low
    END IF;
  END PROCESS;

END Behavioral;
