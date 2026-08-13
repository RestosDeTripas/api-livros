import 'package:flutter/material.dart';

class EstrelasAvaliacao extends StatelessWidget {
  final double? rating;
  final int? quantidade;

  const EstrelasAvaliacao({Key? key, this.rating, this.quantidade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rating == null) {
      return Row(
        children: [
          Row(
            children: List.generate(5, (_) => const Icon(Icons.star_border, size: 16, color: Colors.amber)),
          ),
          const SizedBox(width: 8),
          const Text('☆☆☆☆☆ Sem avaliação', style: TextStyle(fontSize: 12)),
        ],
      );
    }

    final full = rating!.floor();
    final hasHalf = (rating! - full) >= 0.5;
    final empty = 5 - full - (hasHalf ? 1 : 0);

    final stars = <Widget>[];
    for (var i = 0; i < full; i++) {
      stars.add(const Icon(Icons.star, size: 16, color: Colors.amber));
    }
    if (hasHalf) stars.add(const Icon(Icons.star_half, size: 16, color: Colors.amber));
    for (var i = 0; i < empty; i++) {
      stars.add(const Icon(Icons.star_border, size: 16, color: Colors.amber));
    }

    return Row(
      children: [
        Row(children: stars),
        const SizedBox(width: 8),
        Text('${rating!.toStringAsFixed(1)}', style: const TextStyle(fontSize: 12)),
        if (quantidade != null) ...[
          const SizedBox(width: 6),
          Text('($quantidade)', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ]
      ],
    );
  }
}

