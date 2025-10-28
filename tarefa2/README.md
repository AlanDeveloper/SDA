# Projeto ULA e Banco de Registradores

## Descrição

Implementação de um datapath de propósito geral contendo uma Unidade Lógico-Aritmética (ULA), banco de registradores e controlador de micro-operações, desenvolvido em VHDL com arquitetura hierárquica.

## Arquitetura

O projeto segue uma estrutura hierárquica modular composta pelos seguintes componentes:

- **Banco de Registradores**: 8 registradores de 32 bits com seleção de entrada e saída
- **ULA (Unidade Lógico-Aritmética)**: 16 operações diferentes (transfer, soma, subtração, operações lógicas)
- **Shifter**: Deslocamento de bits à esquerda e direita
- **Multiplexadores**: Seleção de operandos e resultados
- **Decoder 3-para-8**: Decodificação para seleção de registrador destino

### Sinais de Controle (19 bits)

| Bits | Nome | Função |
|------|------|--------|
| 18:16 | AS (A Select) | Seleciona registrador A (3 bits) |
| 15:13 | BS (B Select) | Seleciona registrador B (3 bits) |
| 12:10 | DS (Destination Select) | Seleciona registrador destino (3 bits) |
| 9 | LE (Latch Enable) | Habilita escrita nos registradores |
| 8 | MB (Mux B) | Seleciona entre registrador B ou constante |
| 7:4 | GS (G Select) | Seleciona operação da ULA (4 bits) |
| 3:2 | HS (H Select) | Seleciona tipo de deslocamento (2 bits) |
| 1 | MF (Mux F) | Seleciona entre resultado da ULA ou shifter |
| 0 | MD (Mux Data) | Seleciona entre ALU/shifter ou entrada externa |

### Flags de Saída

- **V (Overflow)**: Detecta transbordamento em operações aritméticas
- **C (Carry)**: Detecta carry out da operação
- **N (Negativo)**: Indica se o resultado é negativo (bit 31)
- **Z (Zero)**: Detecta se o resultado é zero

## Arquivos do Projeto

```
.
├── PROJETO.vhd           # Entidade principal (datapath)
├── register32BITS.vhd    # Registrador de 32 bits
├── alu.vhd               # Unidade Lógico-Aritmética
├── shifter.vhd           # Deslocador de bits
├── mux2to1.vhd           # Multiplexador 2-para-1
├── mux8to1.vhd           # Multiplexador 8-para-1
├── decoder3to8.vhd       # Decodificador 3-para-8
├── PROJETO_TB.vhd        # Testbench
├── script.do             # Script de compilação e simulação
├── wave.do               # Configuração de visualização de waveforms
└── README.md             # Este arquivo
```

## Como Executar

### Pré-requisitos

- ModelSim instalado e configurado
- Todos os arquivos `.vhd`, `script.do` e `wave.do` **na mesma pasta**

### Passos para Simular

1. Abra o ModelSim
2. Navegue até a pasta contendo os arquivos
3. No terminal do ModelSim, execute:
   ```
   do script.do
   ```

O script irá:
- Compilar automaticamente todos os arquivos VHDL
- Inicializar a simulação com o testbench
- Carregar a configuração de visualização dos sinais
- Executar a simulação por 285 ns

### Visualização dos Waveforms

Após a execução de `script.do`, o ModelSim exibirá automaticamente os waveforms com os sinais de interesse já configurados para análise.

## Micro-operações Testadas

O testbench valida as seguintes micro-operações:

```
R0 ← 10
R1 ← 15
R2 ← R0 + R1
R3 ← R0 - R1
R4 ← R0 + 2
R5 ← R2 xor R1
R6 ← R2 and R1
R7 ← sll R2
R6 ← srl R6
R2 ← R2 + (not R1)
R0 ← R2 xor (not R3)
R1 ← not R0
R4 ← R2 or (not R0)
```

## Notas Importantes

- Os caminhos de compilação foram configurados para procurar arquivos na **mesma pasta** do script
- Não modifique a estrutura de diretórios ou os scripts deixarão de funcionar
- A simulação está configurada para 285 ns, suficiente para executar todas as micro-operações

## Referência de Operações da ULA

| Código | Operação |
|--------|----------|
| 0000 | A |
| 0001 | B |
| 0010 | A + B |
| 0011 | A + 1 |
| 0100 | A - B |
| 0101 | A + 2 |
| 0110 | A + (not B) |
| 0111 | A - (not B) |
| 1000 | A and B |
| 1001 | A or B |
| 1010 | A xor B |
| 1011 | not A |
| 1100 | not B |
| 1101 | A or (not B) |
| 1110 | A and (not B) |
| 1111 | A xor (not B) |
