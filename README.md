# Pesquisa Dinâmica e Dicas para PDV

## Este repositório contém o código-fonte do canal Infocotidiano com exemplos práticos para Ponto de Venda (PDV): pesquisa dinâmica de produtos, integração com balanças (ACBrBAL), leitura de etiquetas de balança e dicas de otimização de código.  

<a href="https://www.youtube.com/watch?v=pGf3Jvu0yUE"><img src="https://img.youtube.com/vi/pGf3Jvu0yUE/maxresdefault.jpg" alt="Vídeo 01 — Pesquisa Dinâmica" width="50%"></a>

## Resumo rápido
- **Plataformas:** Lazarus / Free Pascal (muita compatibilidade com Delphi)
- **Funcionalidades:** pesquisa dinâmica, leitura de peso, leitura de etiquetas de balança, otimizações para PDV
- **Banco de dados:** exemplo convertido para **SQLite** — arquivo `banco.db3` incluído
## Requisitos
- `Lazarus` / Free Pascal instalado
- Componentes:
	- **ACBr** — guias de instalação:
		- ACBr Lazarus (Linux): https://www.youtube.com/watch?v=DjdmedZgMTE
		- ACBr Lazarus (Windows): https://www.youtube.com/watch?v=o5oyqk-3kns
	- **Rx** e **Zeos** — guia de instalação: https://www.youtube.com/watch?v=XTQbjq5Puu0
- Emulador de balança (para testar sem hardware): configuração e uso: https://www.youtube.com/watch?v=PIfhubP1Sf8

## Guia rápido de uso
1. Abra o projeto no Lazarus: `PesqDinamica.lpi`.
2. Instale/compile os componentes listados (ACBr, Rx, Zeos) conforme os links acima.
3. O banco SQLite está em `banco.db3` — use um cliente SQLite para inspeção ou edição.
4. Teste a integração de balança com a pasta `EmuladorBalanca` se não tiver hardware disponível.

## Estrutura do repositório
- `PesqDinamica.lpi`, `PesqDinamica.lpr` — arquivos do projeto
- `uprincipal.pas`, `uprincipal.lfm` — unidade principal da aplicação
- `banco.db3` — banco SQLite usado nos exemplos
- `EmuladorBalanca/` — arquivos e configurações do emulador de balança

## Vídeos e recursos
- Vídeo 01 — Pesquisa dinâmica: https://www.youtube.com/watch?v=pGf3Jvu0yUE
- Vídeo 02 — Pesquisa dinâmica (consultas por código/código de barras/descrição): https://www.youtube.com/watch?v=_MyUCatSjWU
- Vídeo 03 — Ajustando códigos: https://youtu.be/e6Hf5rZoMeQ
- Vídeo 04 — Como integrar balança no PDV: https://youtu.be/DNyZXnKlJxs
- Vídeo 05 — Ler etiquetas de balanças: https://youtu.be/rflWAwWfZ3c

## Notas finais
- Os exemplos foram adaptados para facilitar testes offline (SQLite) e demonstrar conceitos práticos para PDVs.
- Posso adicionar miniaturas para os outros vídeos, detalhar instalação passo a passo ou criar um guia de deploy para Windows/Linux, se desejar.
