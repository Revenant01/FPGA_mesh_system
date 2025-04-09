LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

--! UART transmitter entity declaration
ENTITY uart_txj IS
  PORT (
    Clock     : IN STD_LOGIC;                     --! System clock
    Reset     : IN STD_LOGIC;                     --! Asynchronous reset (currently unused)
    Enable    : IN STD_LOGIC;                     --! Enable signal for data transmission
    DATA_BIT  : IN STD_LOGIC_VECTOR(127 DOWNTO 0); --! Data to transmit (ASCII value for 'X')
    Txd       : OUT STD_LOGIC;                     --! UART serial output
    send_done : OUT STD_LOGIC                      --! Transmission complete signal
  );
END uart_txj;

--! UART transmitter architecture
ARCHITECTURE Behavioral OF uart_txj IS
  --! Constants for baud rate generation
  CONSTANT BAUD_RATE  : INTEGER := 9600;
  CONSTANT CLOCK_FREQ : INTEGER := 100000000;      --! 100 MHz input clock

  --! Internal signals
  SIGNAL baud_clock    : STD_LOGIC;                --! Clock for baud rate timing
  SIGNAL bit_counter   : INTEGER RANGE 0 TO 129 := 0; --! Counter for transmitted bits (start + 128 data + stop)

BEGIN

  --! Baud rate clock generation process
  PROCESS (Clock)
    VARIABLE clksperbit : INTEGER RANGE 0 TO ((CLOCK_FREQ / BAUD_RATE) - 1); --! Prescaler for baud timing
  BEGIN
    IF rising_edge(Clock) THEN
      IF clksperbit = 0 THEN
        baud_clock <= NOT baud_clock;            --! Toggle baud clock
        clksperbit := ((CLOCK_FREQ / BAUD_RATE) - 1); --! Reset prescaler
      ELSE
        clksperbit := clksperbit - 1;            --! Decrement prescaler
      END IF;
    END IF;
  END PROCESS;

  --! UART data transmission process triggered on baud clock edge
  PROCESS (baud_clock)
  BEGIN
    IF rising_edge(baud_clock) THEN
      IF Enable = '1' THEN
        CASE bit_counter IS
          WHEN 0 => --! Start bit
            Txd <= '0';                     --! Start bit is low
            send_done <= '0';                --! Transmission not yet done
            bit_counter <= bit_counter + 1;  --! Move to next bit
          
          WHEN 1 TO 128 => --! Data bits
            Txd <= DATA_BIT(bit_counter - 1); --! Transmit the data bit
            bit_counter <= bit_counter + 1;   --! Move to next bit

          WHEN 129 => --! Stop bit
            Txd <= '1';                      --! Stop bit is high (default idle state)
            bit_counter <= 0;                 --! Reset bit counter
            send_done <= '1';                 --! Transmission completed

          WHEN OTHERS =>
            bit_counter <= 0;                 --! Default case: reset counter
        END CASE;
      ELSE
        Txd <= '1';                         --! Idle state when not enabled
        bit_counter <= 0;                    --! Reset bit counter
      END IF;
    END IF;
  END PROCESS;

END Behavioral;
