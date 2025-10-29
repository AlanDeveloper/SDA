# Somador CLA Hierárquico Genérico

## Descrição

Implementação de um somador binário Carry Lookahead (CLA) com arquitetura hierárquica e genérica, desenvolvido em VHDL. O projeto utiliza blocos CLA de 4 bits organizados hierarquicamente com geradores de carry lookahead para propagar carries de forma otimizada, reduzindo significativamente o atraso de propagação em relação a somadores ripple carry convencionais.

## Princípios do Carry Lookahead

O somador CLA reduz o caminho crítico calculando antecipadamente os carries através de funções de propagação (P) e geração (G) de carry:

**Propagate:** `pi = ai ⊕ bi`  
**Generate:** `gi = ai · bi`

**Carries:** 
- `c1 = g0 + p0 · c0`
- `c2 = g1 + p1 · g0 + p1 · p0 · c0`
- `c3 = g2 + p2 · g1 + p2 · p1 · g0 + p2 · p1 · p0 · c0`
- `c4 = g3 + p3 · g2 + p3 · p2 · g1 + p3 · p2 · p1 · g0 + p3 · p2 · p1 · p0 · c0`

**Soma:** `si = ai ⊕ bi ⊕ ci`

## Arquitetura Hierárquica

O projeto organiza-se em três níveis hierárquicos:

### Nível 1: Blocos CLA-4 (Carry Lookahead de 4 bits)
- Implementa somador CLA de 4 bits
- Calcula propagate e generate para o grupo
- Saídas: soma de 4 bits, P e G do bloco, carry out (c4)

### Nível 2: Blocos CLGB-4 (Carry Lookahead Generator para Blocos)
- Gera carries entre grupos de 4 blocos CLA-4
- Recebe P e G dos 4 blocos CLA-4
- Calcula carries intermediários (c1 a c4) para propagar entre CLAs
- Saídas: 4 carries intermediários, P e G do super-bloco

### Nível 3: CLA_Hierarchical (Somador CLA 32 bits)
- Integra N blocos CLA-4
- Integra blocos CLGB-4 para hierarquização
- Suporta tamanho genérico (múltiplos de 16 bits)
- Propaga carries entre super-blocos

## Vantagens da Abordagem Hierárquica

| Aspecto | Ripple Carry | CLA Hierárquico |
|--------|--------------|-----------------|
| Caminho Crítico | O(N) | O(log N) |
| Atraso de 32 bits | 32 atrasos | ~8 atrasos |
| Complexidade | Simples | Moderada |
| Velocidade | Lenta | Rápida |

## Genéricos

```vhdl
N_BITS : integer := 32  -- Tamanho da palavra (deve ser múltiplo de 16)
```

Exemplos de uso:
- `N_BITS => 16`: Somador de 16 bits (1 bloco CLGB)
- `N_BITS => 32`: Somador de 32 bits (2 blocos CLGB)
- `N_BITS => 64`: Somador de 64 bits (4 blocos CLGB)

## Interface

### Entradas
- `a`: Vetor de entrada A (N_BITS bits)
- `b`: Vetor de entrada B (N_BITS bits)
- `cin`: Carry de entrada (1 bit)

### Saídas
- `s`: Resultado da soma (N_BITS bits)
- `cout`: Carry de saída (1 bit)

## Estrutura de Arquivos

```
.
├── CLA_Hierarchical.vhd  # Entidade principal (somador 32 bits hierárquico)
├── CLA4.vhd              # Bloco CLA de 4 bits
├── CLGB4.vhd             # Gerador de carry lookahead para 4 blocos
├── CLA_TB.vhd            # Testbench
└── README.md             # Este arquivo
```

## Casos de Teste

O testbench valida:

- **Somas simples**: 5 + 3, 10 + 7
- **Valores máximos**: 2³¹-1 + 1 (com carry)
- **Casos com carry de entrada**: cin = 1
- **Zeros**: A=0, B=0 com e sem carry
- **Padrões alternados**: Aa = 0x55555555, B = 0xAAAAAAAA

## Equações de Carry Completas

Para um bloco CLA de 4 bits com entrada c0:

```
c1 = g0 + p0·c0
c2 = g1 + p1·g0 + p1·p0·c0
c3 = g2 + p2·g1 + p2·p1·g0 + p2·p1·p0·c0
c4 = g3 + p3·g2 + p3·p2·g1 + p3·p2·p1·g0 + p3·p2·p1·p0·c0
```

Para hierarquização com 2 blocos CLGB:

```
Cout1 = G0 + P0·Cin
Cout2 = G1 + P1·G0 + P1·P0·Cin
```

## Notas Importantes

- O tamanho N_BITS deve ser **múltiplo de 16** para hierarquia funcionar corretamente
- A implementação assume N_BITS = 32 por padrão
- Para alterar o tamanho, modifique o genérico na instanciação da entidade

## Referências Teóricas

- **Propagate (P)**: Indica se o grupo propagará um carry externo
- **Generate (G)**: Indica se o grupo gera um carry interno
- **Caminho Crítico**: Define a velocidade máxima de operação
- **Hierarquia**: Estrutura em árvore reduz profundidade lógica
