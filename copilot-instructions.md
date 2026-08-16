# ⚠️ REGRAS CRÍTICAS DE SEGURANÇA PARA ARQUIVOS GRANDES

Estas regras se aplicam a QUALQUER prompt dentro deste projeto.

## 1. Limite de tamanho de arquivo

**Você NUNCA deve processar arquivos com mais de 10.000 linhas.**

Este projeto contém arquivos muito grandes (ex.: `data/items/items.xml`, scripts de dados, etc.). Antes de ler, analisar ou modificar qualquer arquivo, verifique o tamanho dele.

## 2. Pergunte antes de processar arquivos grandes

Se eu mencionar um arquivo grande, você deve **ANTES** me perguntar qual trecho específico eu quero analisar ou modificar.

Nunca processe o arquivo inteiro automaticamente sem antes confirmar o escopo comigo.

## 3. Você pode (e deve) me corrigir

Você tem permissão para **ME CORRIGIR** se eu pedir algo que vai gastar muitos tokens.

- Me avise sobre o custo provável.
- Sugira uma alternativa mais eficiente (ex.: ler/apontar um trecho específico, usar busca por palavra-chave, etc.).

## 4. Sempre avise antes de processar arquivo grande

**Sempre me avise ANTES de processar qualquer arquivo grande**, informando o número aproximado de tokens que serão usados.

## Resumo do comportamento esperado

| Situação                                  | Ação obrigatória                                       |
| ----------------------------------------- | ------------------------------------------------------ |
| Arquivo tem mais de 10.000 linhas         | Nunca processar inteiro; perguntar o trecho específico |
| Usuário pede algo que gasta muitos tokens | Corrigir, avisar o custo e sugerir alternativa         |
| Vai processar arquivo grande              | Avisar antecipadamente com estimativa de tokens        |
