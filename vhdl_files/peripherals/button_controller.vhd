-- button_controller.vhd
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY button_controller IS
    PORT (
        clk         : IN  STD_LOGIC;
        reset       : IN  STD_LOGIC;
        KEY         : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- KEY[3..0] (ativos em LOW)
        buttons     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- Mesmo formato que ps2kb
    );
END button_controller;

ARCHITECTURE behavioral OF button_controller IS
    SIGNAL key_debounced : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL key_prev      : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL buttons_reg   : STD_LOGIC_VECTOR(6 DOWNTO 0);
    
    -- Debouncer para cada botão
    COMPONENT debouncer IS
        PORT (
            clk     : IN  STD_LOGIC;
            reset   : IN  STD_LOGIC;
            button  : IN  STD_LOGIC;
            result  : OUT STD_LOGIC
        );
    END COMPONENT;
    
BEGIN
    -- Instanciar debouncers para cada botão
    gen_debouncers: FOR i IN 0 TO 3 GENERATE
        debouncer_inst: debouncer
            PORT MAP (
                clk    => clk,
                reset  => reset,
                button => KEY(i),
                result => key_debounced(i)
            );
    END GENERATE;
    
    -- Processo principal
    PROCESS(clk, reset)
        VARIABLE direction_counter : INTEGER := 0;
        CONSTANT DIRECTION_DELAY : INTEGER := 5000000;  -- 0.1s a 50MHz
    BEGIN
        IF reset = '1' THEN
            key_prev <= (OTHERS => '1');
            buttons_reg <= (OTHERS => '0');
            direction_counter := 0;
        ELSIF rising_edge(clk) THEN
            -- Reset os bits de botão (são ativos apenas por um ciclo)
            buttons_reg <= (OTHERS => '0');
            
            -- Detectar borda de descida (1->0) - botão pressionado
            FOR i IN 0 TO 3 LOOP
                IF key_prev(i) = '1' AND key_debounced(i) = '0' THEN
                    -- Mapeamento:
                    -- buttons[0] = direita
                    -- buttons[1] = esquerda  
                    -- buttons[2] = cima
                    -- buttons[3] = baixo
                    -- buttons[4] = reset (F2)
                    -- buttons[5] = pause (F1)
                    -- buttons[6] = special (F3) - não usado
                    
                    CASE i IS
                        WHEN 0 =>    -- KEY[0] - Reset (F2)
                            buttons_reg(4) <= '1';
                        WHEN 1 =>    -- KEY[1] - Pause (F1)
                            buttons_reg(5) <= '1';
                        WHEN 2 =>    -- KEY[2] - Cima/Baixo
                            -- Alternar entre cima e baixo
                            IF buttons_reg(2) = '0' THEN
                                buttons_reg(2) <= '1';  -- Cima
                                buttons_reg(3) <= '0';
                            ELSE
                                buttons_reg(2) <= '0';
                                buttons_reg(3) <= '1';  -- Baixo
                            END IF;
                        WHEN 3 =>    -- KEY[3] - Esquerda/Direita
                            -- Alternar entre esquerda e direita
                            IF buttons_reg(0) = '0' THEN
                                buttons_reg(0) <= '1';  -- Direita
                                buttons_reg(1) <= '0';
                            ELSE
                                buttons_reg(0) <= '0';
                                buttons_reg(1) <= '1';  -- Esquerda
                            END IF;
                        WHEN OTHERS =>
                            NULL;
                    END CASE;
                END IF;
            END LOOP;
            
            key_prev <= key_debounced;
            
            -- Controle contínuo de direção (se mantiver pressionado)
            direction_counter := direction_counter + 1;
            IF direction_counter >= DIRECTION_DELAY THEN
                direction_counter := 0;
                
                -- Se KEY[2] está pressionado, alterna direção vertical
                IF key_debounced(2) = '0' THEN
                    IF buttons_reg(2) = '0' THEN
                        buttons_reg(2) <= '1';
                        buttons_reg(3) <= '0';
                    ELSE
                        buttons_reg(2) <= '0';
                        buttons_reg(3) <= '1';
                    END IF;
                END IF;
                
                -- Se KEY[3] está pressionado, alterna direção horizontal
                IF key_debounced(3) = '0' THEN
                    IF buttons_reg(0) = '0' THEN
                        buttons_reg(0) <= '1';
                        buttons_reg(1) <= '0';
                    ELSE
                        buttons_reg(0) <= '0';
                        buttons_reg(1) <= '1';
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
    buttons <= buttons_reg;
    
END behavioral;