# Top 25 Livros (exercício Flutter)

Projeto de aprendizado em Flutter que consulta a Google Books API e monta um ranking "Top 25" a partir de múltiplas consultas por gêneros populares.

Principais características:
- Consulta a Google Books API (https://www.googleapis.com/books/v1/volumes)
- Realiza múltiplas buscas (fiction, fantasy, romance, etc.) e agrega resultados
- Remove duplicados (ID do volume)
- Calcula um ranking simples baseado em: quantidade de avaliações (peso alto), média de avaliação (peso médio), presença em múltiplas consultas e posição nos resultados (relevância)
- Exibe capa, título, autor, gênero, avaliação (estrelas) e data de publicação
- Tela de detalhes com descrição e informações completas

Arquitetura simples (diretórios):

lib/
├── main.dart
├── models/
│   └── livro_model.dart
├── screens/
│   ├── home_screen.dart
│   └── detalhes_livro_screen.dart
├── services/
│   └── google_books_service.dart
└── widgets/
	├── livro_card.dart
	└── estrelas_avaliacao.dart

Dependências principais:
- http

Como executar:
1. Tenha o Flutter instalado e configurado.
2. No diretório do projeto, rode:

```bash
flutter pub get
flutter run
```

Testes:

```bash
flutter test
```

Explicação curta do ranking:
- O aplicativo realiza múltiplas pesquisas por gêneros/termos populares.
- Para cada volume encontrado, o app soma informações de presença (quantas consultas retornaram o mesmo volume), posição (relevância inferida pela posição nos resultados) e dados de avaliação (quantidade e média).
- A pontuação final é uma soma ponderada (quantidade de avaliações com peso alto, média com peso médio, presença e relevância com peso médio).
- Ordena-se pela pontuação e selecionam-se os 25 primeiros.

Limitações conhecidas da API / do app:
- A Google Books API não fornece um ranking global de "livros mais populares"; o ranking aqui é uma heurística do aplicativo e pode diferir de listas oficiais.
- Nem todos os livros possuem avaliações, capas ou categorias — o app trata esses casos defensivamente.
- Resultados dependem dos termos de pesquisa e da disponibilidade da API.
- A estratégia de relevância usa a posição nos resultados como proxy, o que não é perfeito.
- Não há paginação extensa: cada consulta usa `maxResults=20`.
