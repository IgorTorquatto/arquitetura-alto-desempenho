-- button_controller_alternative.vhd
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY button_controller IS
    PORT (
        clk     : IN  STD_LOGIC;
        SW      : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        KEY     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        buttons : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END button_controller;

ARCHITECTURE behavioral OF button_controller IS
    SIGNAL key_sync      : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL key_debounced : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL key_prev      : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL buttons_reg   : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL sw_sync       : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL sw_debounced  : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL sw_prev       : STD_LOGIC_VECTOR(9 DOWNTO 0);
    
    -- Edge detection
    SIGNAL sw1_rising, sw2_rising : STD_LOGIC;
    
BEGIN
    -- Sync inputs
    sync_proc: PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            key_sync <= KEY;
            sw_sync <= SW;
            key_debounced <= key_sync;
            sw_debounced <= sw_sync;
            key_prev <= key_debounced;
            sw_prev <= sw_debounced;
        END IF;
    END PROCESS;
    
    -- Edge detection for switches
    sw1_rising <= '1' WHEN sw_prev(1) = '0' AND sw_debounced(1) = '1' ELSE '0';
    sw2_rising <= '1' WHEN sw_prev(2) = '0' AND sw_debounced(2) = '1' ELSE '0';
    
    -- Main processing
    main_proc: PROCESS(clk)
        VARIABLE key_edge : STD_LOGIC_VECTOR(3 DOWNTO 0);
    BEGIN
        IF rising_edge(clk) THEN
            buttons_reg <= (OTHERS => '0');
            
            -- Key edges
            key_edge := key_prev AND (NOT key_debounced);
            
            -- KEY[0] = UP/LEFT
            IF key_edge(0) = '1' THEN
                buttons_reg(2) <= '1';  -- Up
            END IF;
            
            -- KEY[1] = DOWN/RIGHT  
            IF key_edge(1) = '1' THEN
                buttons_reg(3) <= '1';  -- Down
            END IF;
            
            -- KEY[2] = LEFT (in-game)
            IF key_edge(2) = '1' THEN
                buttons_reg(1) <= '1';  -- Left
            END IF;
            
            -- KEY[3] = RIGHT (in-game)
            IF key_edge(3) = '1' THEN
                buttons_reg(0) <= '1';  -- Right
            END IF;
            
            -- SW[0] = RESET (immediate)
            IF sw_debounced(0) = '1' THEN
                buttons_reg(6) <= '1';
            END IF;
            
            -- SW[1] = ENTER/OK/SELECT (menu) and SPACE (game)
            IF sw1_rising = '1' THEN
                buttons_reg(5) <= '1';  -- Enter/Space
                buttons_reg(4) <= '1';  -- Also as Space
            END IF;
            
            -- SW[2] = PAUSE (toggle in game)
            IF sw2_rising = '1' THEN
                -- This can be used as alternative pause
                -- Or map to another function
            END IF;
            
        END IF;
    END PROCESS;
    
    buttons <= buttons_reg;
    
END behavioral;