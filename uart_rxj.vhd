LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

--! UART receiver entity declaration
ENTITY uart_rxj IS
  PORT (
    Clock         : IN  STD_LOGIC;                        --! System clock
    Reset         : IN  STD_LOGIC;                        --! Asynchronous reset (currently unused)
    Rxd           : IN  STD_LOGIC;                        --! UART serial input
    Received_Data : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);   --! Parallel output data
    receive_done  : OUT STD_LOGIC                         --! Reception complete signal
  );
END uart_rxj;

--! UART receiver architecture
ARCHITECTURE Behavioral OF uart_rxj IS
  --! Constants for baud rate generation
  CONSTANT BAUD_RATE  : INTEGER := 9600;
  CONSTANT CLOCK_FREQ : INTEGER := 100000000;             --! 100 MHz input clock

  --! Internal signals
  SIGNAL Baud_Clock     : STD_LOGIC;                      --! Clock for baud rate timing
  SIGNAL bit_counter    : INTEGER RANGE 0 TO 129 := 0;    --! Counter for received bits (start + 128 data + stop)
  SIGNAL received_byte  : STD_LOGIC_VECTOR(127 DOWNTO 0); --! Buffer for received bits

BEGIN

  --! Baud rate clock generation process (reset logic removed)
  PROCESS (Clock)
    VARIABLE prescaler : INTEGER RANGE 0 TO ((CLOCK_FREQ / BAUD_RATE) - 1); --! Prescaler for baud timing
  BEGIN
    --! Removed reset logic
    IF rising_edge(Clock) THEN
      IF prescaler = 0 THEN
        Baud_Clock <= NOT Baud_Clock;
        prescaler := ((CLOCK_FREQ / BAUD_RATE) - 1);
      ELSE
        prescaler := prescaler - 1;
      END IF;
    END IF;
  END PROCESS;

  --! Data reception process triggered on Baud_Clock edge
  PROCESS (Baud_Clock)
  BEGIN
    IF rising_edge(Baud_Clock) THEN
      IF bit_counter = 0 THEN
        --! Wait for start bit
        receive_done <= '0';
        IF Rxd = '0' THEN
          bit_counter <= bit_counter + 1;
        END IF;

      ELSIF bit_counter >= 1 AND bit_counter <= 128 THEN
        --! Shift in data bits
        received_byte(bit_counter - 1) <= Rxd;
        bit_counter <= bit_counter + 1;

      ELSIF bit_counter = 129 THEN
        --! Stop bit received, signal completion
        receive_done  <= '1';
        bit_counter   <= 0;
        Received_Data <= received_byte;
      END IF;
    END IF;
  END PROCESS;

  --! Optional debug assignment (commented out)
  --! Received_Data <= x"ABCDEF1234567890ABCDEF1234567890";

END Behavioral;
