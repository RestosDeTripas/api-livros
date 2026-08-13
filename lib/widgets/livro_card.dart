import 'package:flutter/material.dart';

import '../models/livro_model.dart';
import 'estrelas_avaliacao.dart';

class LivroCard extends StatelessWidget {
  final LivroModel livro;
  final VoidCallback? onTap;

  const LivroCard({Key? key, required this.livro, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCapa(),
              const SizedBox(width: 12),
              Expanded(child: _buildInfo()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCapa() {
    if (livro.capaUrl == null) {
      return Container(
        width: 72,
        height: 100,
        color: Colors.grey[300],
        child: const Icon(Icons.book, size: 40, color: Colors.white70),
      );
    }

    return Image.network(
      livro.capaUrl!,
      width: 72,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: 72,
        height: 100,
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, color: Colors.white70),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(livro.titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 6),
        Text(livro.autor, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 6),
        Text(livro.genero, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        EstrelasAvaliacao(rating: livro.classificacao, quantidade: livro.quantidadeAvaliacoes),
        const SizedBox(height: 6),
        Text(livro.dataPublicacao != null ? 'Publicado em ${livro.dataPublicacao}' : 'Data desconhecida', style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

