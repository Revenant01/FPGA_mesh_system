LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

--! Entity Declaration
ENTITY control_unit IS
  GENERIC (
    DATA_WIDTH : INTEGER := 128;                     --! Width of data buses
    entity_x   : STD_LOGIC_VECTOR := x"02";          --! Expected X address
    entity_y   : STD_LOGIC_VECTOR := x"01"           --! Expected Y address
  );
  PORT (
    clk            : IN  STD_LOGIC;                                 --! System clock
    reset          : IN  STD_LOGIC;                                 --! Asynchronous reset
    ps2_data       : IN  STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0); --! Input data from PS2 device
    ps2_vld        : IN  STD_LOGIC;                                 --! PS2 data valid signal
    vga_data       : OUT STD_LOGIC_VECTOR(112 DOWNTO 0);            --! Output to VGA display
    vga_done       : IN  STD_LOGIC;                                 --! VGA processing done
    uart_tx_data   : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0); --! Data to be transmitted over UART
    uart_tx_enable : OUT STD_LOGIC;                                 --! UART transmit enable
    uart_tx_done   : IN  STD_LOGIC;                                 --! UART transmission completed
    uart_rx_data   : IN  STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0); --! Data received via UART
    uart_rx_done   : IN  STD_LOGIC                                  --! UART reception completed
  );
END control_unit;

--! Architecture definition
ARCHITECTURE Behavioral OF control_unit IS

  --! FSM States
  TYPE state_type IS (IDLE, PS2, RX, DEC, TX, VGA);
  SIGNAL current_state, next_state : state_type;

  --! FSM control signals
  SIGNAL fsm_idle, fsm_ps2, fsm_rx, fsm_tx, fsm_dec, fsm_vga : STD_LOGIC;

  --! Destination match signal
  SIGNAL dst_matched : STD_LOGIC;

BEGIN

  --! Sequential process for state transition
  PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      current_state <= IDLE;
    ELSIF rising_edge(clk) THEN
      current_state <= next_state;
    END IF;
  END PROCESS;

  --! Destination address checking logic
  PROCESS (fsm_dec)
  BEGIN
    IF uart_rx_data(DATA_WIDTH - 1 DOWNTO DATA_WIDTH - 8) = entity_x AND 
       uart_rx_data(DATA_WIDTH - 9 DOWNTO DATA_WIDTH - 16) = entity_y AND 
       fsm_dec = '1' THEN
      dst_matched <= '1'; --! Match found
    ELSE
      dst_matched <= '0'; --! No match
    END IF;
  END PROCESS;

  --! Combinational process to determine next state
  PROCESS (current_state, ps2_vld, uart_rx_done, uart_tx_done, dst_matched, vga_done)
  BEGIN
    CASE current_state IS
      WHEN IDLE =>
        IF ps2_vld = '1' THEN
          next_state <= PS2; --! If PS2 input is valid, go to PS2 state
        ELSE
          next_state <= RX;  --! Otherwise, check UART input
        END IF;

      WHEN PS2 =>
        IF ps2_vld = '1' THEN
          next_state <= PS2; --! Stay in PS2 state while input is valid
        ELSE
          next_state <= TX;  --! Move to transmission after PS2 input is done
        END IF;

      WHEN RX =>
        IF uart_rx_done = '1' THEN
          next_state <= DEC; --! Data received, move to decoding
        ELSIF ps2_vld = '1' THEN
          next_state <= PS2; --! Interrupt by PS2 input
        ELSE
          next_state <= RX;  --! Wait for UART data
        END IF;

      WHEN TX =>
        IF uart_tx_done = '1' THEN
          next_state <= IDLE; --! Go back to IDLE when transmission is done
        ELSE
          next_state <= TX;   --! Wait until transmission is finished
        END IF;

      WHEN DEC =>
        IF dst_matched = '1' THEN
          next_state <= VGA; --! If destination matches, move to VGA
        ELSE
          next_state <= TX;  --! Otherwise, retransmit
        END IF;

      WHEN VGA =>
        IF vga_done = '1' THEN
          next_state <= IDLE; --! VGA processing done, go to IDLE
        ELSE
          next_state <= VGA;  --! Continue VGA
        END IF;

      WHEN OTHERS =>
        next_state <= IDLE; --! Default fallback state
    END CASE;
  END PROCESS;

  --! FSM output signal logic based on current state
  PROCESS (current_state)
  BEGIN
    CASE current_state IS
      WHEN IDLE =>
        fsm_idle <= '1'; fsm_ps2 <= '0'; fsm_dec <= '0';
        fsm_rx   <= '0'; fsm_tx  <= '0'; fsm_vga <= '0';

      WHEN PS2 =>
        fsm_idle <= '0'; fsm_ps2 <= '1'; fsm_dec <= '0';
        fsm_rx   <= '0'; fsm_tx  <= '0'; fsm_vga <= '0';

      WHEN RX =>
        fsm_idle <= '0'; fsm_ps2 <= '0'; fsm_dec <= '0';
        fsm_rx   <= '1'; fsm_tx  <= '0'; fsm_vga <= '0';

      WHEN TX =>
        fsm_idle <= '0'; fsm_ps2 <= '0'; fsm_dec <= '0';
        fsm_rx   <= '0'; fsm_tx  <= '1'; fsm_vga <= '0';

      WHEN DEC =>
        fsm_idle <= '0'; fsm_ps2 <= '0'; fsm_dec <= '1';
        fsm_rx   <= '0'; fsm_tx  <= '0'; fsm_vga <= '0';

      WHEN VGA =>
        fsm_idle <= '0'; fsm_ps2 <= '0'; fsm_dec <= '0';
        fsm_rx   <= '0'; fsm_tx  <= '0'; fsm_vga <= '1';

      WHEN OTHERS =>
        fsm_idle <= '0'; fsm_ps2 <= '0'; fsm_dec <= '0';
        fsm_rx   <= '0'; fsm_tx  <= '0'; fsm_vga <= '0';
    END CASE;
  END PROCESS;

END Behavioral;
