-- debouncer.vhd
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY debouncer IS
    GENERIC (
        counter_size : INTEGER := 19  -- 10.5ms a 50MHz
    );
    PORT (
        clk     : IN  STD_LOGIC;
        reset   : IN  STD_LOGIC;
        button  : IN  STD_LOGIC;
        result  : OUT STD_LOGIC
    );
END debouncer;

ARCHITECTURE behavioral OF debouncer IS
    SIGNAL flipflops   : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL counter_set : STD_LOGIC;
    SIGNAL counter_out : STD_LOGIC_VECTOR(counter_size DOWNTO 0) := (OTHERS => '0');
BEGIN
    counter_set <= flipflops(0) XOR flipflops(1);
    
    PROCESS(clk, reset)
    BEGIN
        IF reset = '1' THEN
            flipflops <= (OTHERS => '0');
            result <= '0';
        ELSIF rising_edge(clk) THEN
            flipflops(0) <= button;
            flipflops(1) <= flipflops(0);
            
            IF counter_set = '1' THEN
                counter_out <= (OTHERS => '0');
            ELSIF counter_out(counter_size) = '0' THEN
                counter_out <= STD_LOGIC_VECTOR(unsigned(counter_out) + 1);
            ELSE
                result <= flipflops(1);
            END IF;
        END IF;
    END PROCESS;
END behavioral;