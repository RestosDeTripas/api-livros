import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../models/livro_model.dart';

class GoogleBooksService {
  final http.Client _client;
    static const String _apiKey = 'AIzaSyAEefE3XwYBlBb3nJ3l1QD8mcyF8uHTM5k';

  GoogleBooksService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<LivroModel>> buscarLivrosPopulares() async {
    final queries = [
      'fiction',
      'fantasy',
      'romance',
      'mystery',
      'thriller',
      'science fiction',
      'horror',
      'biography',
      'history',
      'self help',
      'classics',
      'young adult',
      'adventure',
    ];

    try {
      final List<Map<String, dynamic>> results = [];

      for (final q in queries) {
        final res = await _fetchForQuery(q);
        results.add(res);
        // Wait 150ms between requests to stay friendly with Google API limiters
        await Future.delayed(const Duration(milliseconds: 150));
      }

      final Map<String, _Aggregate> agg = {};

      for (var res in results) {
        final items = res['items'] as List<dynamic>;
        for (var i = 0; i < items.length; i++) {
          final item = items[i] as Map<String, dynamic>;
          final id = (item['id'] ?? '').toString();
          if (id.isEmpty) continue;

          final model = LivroModel.fromJson(item);

          final entry = agg.putIfAbsent(id, () => _Aggregate(model: model));

          entry.occurrences += 1;
          entry.relevance += 1.0 / (i + 1);
          if (model.quantidadeAvaliacoes != null) entry.totalRatings = model.quantidadeAvaliacoes!;
          if (model.classificacao != null) entry.averageRating = model.classificacao!;
        }
      }

      final scored = agg.values.map((a) => MapEntry(a.model, _score(a))).toList();
      scored.sort((a, b) => b.value.compareTo(a.value));

      return scored.take(25).map((e) => e.key).toList();
    } on SocketException catch (e) {
      throw Exception('Sem conexão: ${e.message}');
    } on TimeoutException catch (e) {
      throw Exception('Timeout ao conectar: ${e.message ?? ''}');
    } on FormatException catch (e) {
      throw Exception('Resposta inválida: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _fetchForQuery(String query) async {
    final uri = Uri.https('www.googleapis.com', '/books/v1/volumes', {
      'q': query,
      'maxResults': '20',
      'key': _apiKey,
    });

    final resp = await _client.get(uri).timeout(const Duration(seconds: 10));

    if (resp.statusCode != 200) throw Exception('Erro HTTP: ${resp.statusCode}');

    final Map<String, dynamic> json = jsonDecode(resp.body) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>? ?? <dynamic>[];
    return {'query': query, 'items': items};
  }

  double _score(_Aggregate a) {
    final double wRatingsCount = 4.0;
    final double wAvgRating = 3.0;
    final double wOccurrences = 2.0;
    final double wRelevance = 2.0;

    double score = 0.0;
    if (a.totalRatings > 0) score += (1 + math.log(a.totalRatings.toDouble())) * wRatingsCount;
    if (a.averageRating > 0) score += a.averageRating * wAvgRating;
    score += a.occurrences * wOccurrences;
    score += a.relevance * wRelevance;
    return score;
  }
}

class _Aggregate {
  final LivroModel model;
  int occurrences = 0;
  double relevance = 0.0;
  int totalRatings = 0;
  double averageRating = 0.0;

  _Aggregate({required this.model}) {
    totalRatings = model.quantidadeAvaliacoes ?? 0;
    averageRating = model.classificacao ?? 0.0;
  }
}