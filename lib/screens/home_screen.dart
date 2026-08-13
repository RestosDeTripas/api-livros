import 'package:flutter/material.dart';

import '../models/livro_model.dart';
import '../services/google_books_service.dart';
import '../widgets/livro_card.dart';
import 'detalhes_livro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleBooksService _service = GoogleBooksService();
  late Future<List<LivroModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.buscarLivrosPopulares();
  }

  void _reload() {
    if (!mounted) return;
    setState(() {
      _future = _service.buscarLivrosPopulares();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top 25 Livros')),
      body: FutureBuilder<List<LivroModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Carregando livros...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            final msg = snapshot.error.toString();
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Erro ao carregar livros:\n$msg', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: _reload, child: const Text('Tentar novamente')),
                  ],
                ),
              ),
            );
          }

          final livros = snapshot.data ?? [];
          if (livros.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Nenhum livro encontrado.'),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _reload, child: const Text('Tentar novamente')),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: livros.length,
            itemBuilder: (context, index) {
              final livro = livros[index];
              return LivroCard(
                livro: livro,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetalhesLivroScreen(livro: livro))),
              );
            },
          );
        },
      ),
    );
  }
}

