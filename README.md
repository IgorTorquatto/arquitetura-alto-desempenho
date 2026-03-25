# the_snake_game
The Snake Game Made in VHDL for Altera DE1 using Quartus V.13

Made by Luca Cesarano and Andrea Croce.

Brief video with the content: https://youtu.be/dKl4xL8vZxY

ROM Editor written in Python.

Documentation written using LATEX.

## Mudanças realizadas

### [vhdl_files/applLogic/the_snake_game.vhd](vhdl_files/applLogic/the_snake_game.vhd)
- Ajuste da integração geral para repassar corretamente os sinais de fase e dificuldade.

### [vhdl_files/logic/gui/stages.vhd](vhdl_files/logic/gui/stages.vhd)
- Expansão do jogo para 4 fases jogáveis.
- Melhoria dos mapas das fases 1 e 2.
- Adição de novas configurações de fase para aumentar a variedade do jogo.

### [vhdl_files/logic/gui/snake.vhd](vhdl_files/logic/gui/snake.vhd)
- Spawn da cobrinha ajustado para posições mais seguras.
- Redução da chance de nascer sobre áreas inválidas ou de colisão.
- Melhorias no comportamento de reinício da cobra.

### [vhdl_files/logic/items.vhd](vhdl_files/logic/items.vhd)
- Spawn dos itens refinado para ficar mais variado.
- Ajuste para respeitar melhor a fase atual.
- Maior controle sobre posições válidas de aparecimento.

### [vhdl_files/utils/difficulty.vhd](vhdl_files/utils/difficulty.vhd)
- Velocidade da cobrinha passando a variar conforme nível e fase.

### [vhdl_files/utils/level.vhd](vhdl_files/utils/level.vhd)
- Progressão de fases ajustada para usar o limite centralizado.
- Correção do problema relacionado ao limite máximo de fases.

### [vhdl_files/libs/the_snake_game_package.vhd](vhdl_files/libs/the_snake_game_package.vhd)
- Criação/centralização da constante `MAX_STAGE` para definir o máximo de fases do jogo.

### [vhdl_files/logic/gui/texts.vhd](vhdl_files/logic/gui/texts.vhd)
- Troca do nome do professor para o de Ramon.
- Troca do nome do sistema exibido na tela para o de Ramon.
- Manutenção do texto de `score` na interface.

### Resumo geral
- O jogo passou a ter mais fases.
- A movimentação ficou mais dinâmica.
- O spawn da cobra e dos itens ficou mais seguro.
- Os textos da interface foram atualizados para refletir o novo nome do professor e do sistema.

For any questions contact me and also for using this project.

Enjoy!
