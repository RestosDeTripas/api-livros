import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/models/livro_model.dart';

void main() {
  test('JSON completo', () {
    final json = {
      'id': 'abc',
      'volumeInfo': {
        'title': 'Título',
        'authors': ['Autor A'],
        'categories': ['Ficção'],
        'averageRating': 4.5,
        'ratingsCount': 100,
        'imageLinks': {'thumbnail': 'http://capa'},
        'publishedDate': '2019-05-01',
        'description': 'Descrição'
      }
    };

    final livro = LivroModel.fromJson(json);
    expect(livro.id, 'abc');
    expect(livro.titulo, 'Título');
    expect(livro.autor, 'Autor A');
    expect(livro.genero, 'Ficção');
    expect(livro.classificacao, 4.5);
    expect(livro.quantidadeAvaliacoes, 100);
    expect(livro.capaUrl, 'http://capa');
    expect(livro.dataPublicacao, '2019-05-01');
    expect(livro.descricao, 'Descrição');
  });

  test('JSON sem autor', () {
    final json = {
      'id': 'a',
      'volumeInfo': {'title': 'T', 'categories': ['X']}
    };
    final livro = LivroModel.fromJson(json);
    expect(livro.autor, 'Desconhecido');
    expect(livro.genero, 'X');
  });

  test('JSON sem categoria', () {
    final json = {
      'id': 'b',
      'volumeInfo': {'title': 'T', 'authors': ['A']}
    };
    final livro = LivroModel.fromJson(json);
    expect(livro.genero, 'Sem categoria');
  });

  test('JSON sem avaliação', () {
    final json = {
      'id': 'c',
      'volumeInfo': {'title': 'T', 'authors': ['A'], 'categories': ['G']}
    };
    final livro = LivroModel.fromJson(json);
    expect(livro.classificacao, null);
    expect(livro.quantidadeAvaliacoes, null);
  });

  test('JSON sem capa', () {
    final json = {
      'id': 'd',
      'volumeInfo': {'title': 'T', 'authors': ['A'], 'categories': ['G']}
    };
    final livro = LivroModel.fromJson(json);
    expect(livro.capaUrl, null);
  });

  test('JSON com data incompleta', () {
    final json = {
      'id': 'e',
      'volumeInfo': {'title': 'T', 'authors': ['A'], 'publishedDate': '2020'}
    };
    final livro = LivroModel.fromJson(json);
    expect(livro.dataPublicacao, '2020');
  });
}

