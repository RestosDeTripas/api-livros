import 'package:flutter/material.dart';

import '../models/livro_model.dart';
import '../widgets/estrelas_avaliacao.dart';

class DetalhesLivroScreen extends StatelessWidget {
  final LivroModel livro;

  const DetalhesLivroScreen({Key? key, required this.livro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildCapa()),
            const SizedBox(height: 16),
            Text(livro.titulo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(livro.autor, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Gênero: ${livro.genero}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            EstrelasAvaliacao(rating: livro.classificacao, quantidade: livro.quantidadeAvaliacoes),
            const SizedBox(height: 8),
            Text('Publicado: ${livro.dataPublicacao ?? 'Desconhecido'}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Text('Avaliações: ${livro.quantidadeAvaliacoes ?? 0}'),
            const SizedBox(height: 12),
            const Text('Descrição', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(livro.descricao ?? 'Sem descrição disponível.'),
          ],
        ),
      ),
    );
  }

  Widget _buildCapa() {
    if (livro.capaUrl == null) {
      return Container(width: 140, height: 200, color: Colors.grey[300], child: const Icon(Icons.book, size: 60));
    }

    return Image.network(livro.capaUrl!, width: 140, height: 200, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 140, height: 200, color: Colors.grey[300], child: const Icon(Icons.broken_image)));
  }
}

