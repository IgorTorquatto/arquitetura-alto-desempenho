# THE SNAKE GAME 🐍

O **Snake Game** é um clássico dos jogos eletrônicos em que o jogador controla uma cobra que cresce ao consumir itens, devendo evitar colisões com as paredes e com o próprio corpo. Apesar de sua mecânica simples, o jogo exige raciocínio rápido e estratégia, tornando-se um excelente exemplo para implementação e estudo em sistemas digitais para arquitetura de computadores.

Este projeto foi implementado utilizando VHDL em uma placa Altera DE1 utilizando Quartus V.13.0. 

## 📋 Pré-requisitos

- Placa Altera DE1 (Cyclone II)
- Monitor VGA
- Teclado PS/2 (opcional, pode usar os botões da placa)
- Software Quartus Prime V.13.0 

## 🚀 Instalação e Execução

1. Instale o Quartus Prime V.13.0 no seu computador.
2. Conecte a placa DE1 ao computador via cabo USB.
3. Baixe ou clone este repositório.
4. Abra o Quartus e carregue o projeto: `File > Open Project > the_snake_game.qpf`
5. Compile o projeto: `Processing > Start Compilation`
6. Conecte o monitor VGA à placa.
7. Programe a FPGA: `Tools > Programmer`
   - Hardware Setup: USB-Blaster, Mode: JTAG
   - Selecionar `output_files/the_snake_game.sof`
   - Marque `Program/Configure`
   - Clique em `Start`

**Nota:** Se ocorrer erro de arquivo corrompido, delete as pastas `db`, `incremental_db` e `output_files`, recompile e tente novamente.

## 🎮 Controles

### Botões da Placa DE1:
- **SW[0]**: RESET (sempre ativo)
- **SW[1]**: ENTER/OK/SELECT (menus) / SPACE (jogo)
- **SW[2]**: PAUSE
- **KEY[0]**: UP (menu) / LEFT (seleção de fase)
- **KEY[1]**: DOWN (menu) / RIGHT (seleção de fase)
- **KEY[2]**: LEFT (jogo)
- **KEY[3]**: RIGHT (jogo)

### Teclado PS/2 (se conectado):
- Setas para movimento
- Espaço para pause/enter

## 📁 Estrutura do Projeto

```
.
├── botões.txt                          # Descrição dos controles
├── cleanDirectory.bat                  # Script para limpar pastas de compilação
├── DE1_pin_assignments.csv             # Atribuições de pinos da placa DE1
├── LICENSE                             # Licença do projeto
├── passo a passo.txt                   # Guia passo-a-passo de instalação
├── README.md                           # Este arquivo
├── the_snake_game.qpf                  # Arquivo de projeto Quartus
├── the_snake_game.qsf                  # Arquivo de configurações Quartus
├── the_snake_game.qws                  # Workspace Quartus
├── the_snake_game_assignment_defaults.qdf  # Defaults do projeto
├── docs/                               # Documentação adicional
├── romEditor/                          # Editor de ROMs
│   ├── romEditorAsGui.py               # Script Python para editar ROMs
│   ├── backups/                        # Backups de mapas e estágios
│   └── resources/                      # Recursos
└── vhdl_files/                         # Arquivos VHDL
    ├── applLogic/
    │   └── the_snake_game.vhd          # Arquivo principal do jogo
    ├── libs/
    │   └── the_snake_game_package.vhd  # Pacote com constantes e tipos
    ├── logic/
    │   ├── finite_state_machine.vhd    # Máquina de estados finita
    │   ├── items.vhd                   # Lógica dos itens
    │   ├── lives.vhd                   # Sistema de vidas
    │   └── gui/
    │       ├── snake.vhd               # Renderização da cobra
    │       ├── stages.vhd              # Mapas das fases
    │       └── texts.vhd               # Textos na tela
    ├── peripherals/
    │   ├── button_controller.vhd       # Controle dos botões
    │   ├── ps2kb.vhd                   # Interface PS/2
    │   └── vga_sync.vhd                # Sincronização VGA
    ├── roms/
    │   └── font_rom.vhd                # ROM da fonte
    └── utils/
        ├── difficulty.vhd              # Controle de dificuldade
        ├── four_digit_counter.vhd      # Contador de 4 dígitos
        ├── level.vhd                   # Sistema de níveis
        ├── score.vhd                   # Sistema de pontuação
        ├── timer.vhd                   # Temporizador principal
        └── timer2.vhd                  # Segundo temporizador
```

## 🏗️ Arquitetura do Sistema

O jogo é implementado em VHDL com uma arquitetura modular:

- **the_snake_game.vhd**: Módulo principal que conecta todos os componentes
- **finite_state_machine.vhd**: Controla os estados do jogo (menu, jogo, pause, game over)
- **vga_sync.vhd**: Gera sinais de sincronização VGA para display 640x480
- **ps2kb.vhd**: Interface com teclado PS/2
- **snake.vhd**: Lógica de movimento e renderização da cobra
- **stages.vhd**: Define os mapas das fases e detecção de colisões
- **items.vhd**: Geração e renderização dos itens coletáveis
- **texts.vhd**: Renderização de textos na tela (score, menus)
- **score.vhd**: Cálculo e display da pontuação
- **level.vhd**: Progressão de níveis e fases
- **difficulty.vhd**: Ajuste da velocidade baseado no nível e fase
- **lives.vhd**: Sistema de vidas
- **timer.vhd** e **timer2.vhd**: Temporizadores para mecânicas do jogo

### Constantes Principais (the_snake_game_package.vhd):
- Resolução VGA: 640x480
- Tamanho do bloco: 16 pixels
- Comprimento máximo da cobra: 128 blocos
- Máximo de fases: 4
- Cores definidas para cobra, itens, paredes

## 🎯 Funcionalidades

- **4 Fases** com mapas únicos
- **Sistema de níveis** com dificuldade progressiva
- **3 Vidas** por jogo
- **Pontuação** baseada nos itens coletados
- **Temporizadores** para itens temporários
- **Pause** durante o jogo
- **Seleção de fase** no menu
- **Display VGA** com gráficos pixelados
- **LEDs** indicadores de status

### Resumo geral das melhorias
- O jogo passou a ter mais fases.
- A movimentação ficou mais dinâmica.
- O spawn da cobra e dos itens ficou mais seguro.
- Melhor aprendizado sobre o conteúdo

