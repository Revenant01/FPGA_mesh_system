LIBRARY IEEE;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

ENTITY clockDivider IS
  PORT (
    clk : IN STD_LOGIC;
    clock_out : OUT STD_LOGIC;
    an_ref : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END clockDivider;

ARCHITECTURE bhv OF clockDivider IS

  SIGNAL count : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL tmp : STD_LOGIC := '0';

BEGIN

  PROCESS (clk)
  BEGIN
    IF (clk'event AND clk = '1') THEN
      count <= count + 1;
      IF (count = 50000000) THEN
        tmp <= NOT tmp;
        count <= "00000000000000000000000000000001";
      END IF;
    END IF;
    clock_out <= tmp;
  END PROCESS;
  an_ref <= count(20 DOWNTO 19);
END bhv;