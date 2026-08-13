import 'dart:convert';

class LivroModel {
  final String id;
  final String titulo;
  final String autor;
  final String genero;
  final double? classificacao;
  final String? dataPublicacao;
  final String? capaUrl;
  final int? quantidadeAvaliacoes;
  final String? descricao;

  LivroModel({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.genero,
    this.classificacao,
    this.dataPublicacao,
    this.capaUrl,
    this.quantidadeAvaliacoes,
    this.descricao,
  });

  /// Factory defensivo que converte o item retornado pela Google Books API
  /// para um [LivroModel]. A API pode retornar campos ausentes.
  factory LivroModel.fromJson(Map<String, dynamic> item) {
    final id = (item['id'] ?? '') as String;
    final volumeInfo = item['volumeInfo'] as Map<String, dynamic>? ?? {};

    final titulo = (volumeInfo['title'] ?? 'Sem título') as String;

    // autores: pode ser uma lista ou ausente
    String autor = 'Desconhecido';
    try {
      final authors = volumeInfo['authors'];
      if (authors is List && authors.isNotEmpty) {
        autor = (authors.first ?? 'Desconhecido').toString();
      }
    } catch (_) {}

    // categorias
    String genero = 'Sem categoria';
    try {
      final categories = volumeInfo['categories'];
      if (categories is List && categories.isNotEmpty) {
        genero = (categories.first ?? 'Sem categoria').toString();
      }
    } catch (_) {}

    double? classificacao;
    try {
      final avg = volumeInfo['averageRating'];
      if (avg != null) {
        classificacao = (avg is num) ? avg.toDouble() : double.tryParse(avg.toString());
      }
    } catch (_) {}

    int? quantidadeAvaliacoes;
    try {
      final cnt = volumeInfo['ratingsCount'];
      if (cnt != null) quantidadeAvaliacoes = (cnt is num) ? cnt.toInt() : int.tryParse(cnt.toString());
    } catch (_) {}

    String? capaUrl;
    try {
      final images = volumeInfo['imageLinks'] as Map<String, dynamic>?;
      capaUrl = images != null ? (images['thumbnail'] ?? images['smallThumbnail']) as String? : null;
    } catch (_) {
      capaUrl = null;
    }

    String? dataPublicacao;
    try {
      final published = volumeInfo['publishedDate'];
      if (published != null) dataPublicacao = published.toString();
    } catch (_) {}

    String? descricao;
    try {
      final desc = volumeInfo['description'];
      if (desc != null) descricao = desc.toString();
    } catch (_) {}

    return LivroModel(
      id: id,
      titulo: titulo,
      autor: autor,
      genero: genero,
      classificacao: classificacao,
      dataPublicacao: dataPublicacao,
      capaUrl: capaUrl,
      quantidadeAvaliacoes: quantidadeAvaliacoes,
      descricao: descricao,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'autor': autor,
        'genero': genero,
        'classificacao': classificacao,
        'dataPublicacao': dataPublicacao,
        'capaUrl': capaUrl,
        'quantidadeAvaliacoes': quantidadeAvaliacoes,
        'descricao': descricao,
      };

  @override
  String toString() => jsonEncode(toJson());
}

