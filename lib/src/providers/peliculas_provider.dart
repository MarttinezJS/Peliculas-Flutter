import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {

  String _apiKey     = '5eea1ee25132d7cc8cbb1bd9c2a8a40b';
  String _url        = 'api.themoviedb.org';
  String _languje    = 'es-MX';
  int _popularesPage = 0;
  bool _cargando     = false;

  List<Pelicula> _populares = new List();
  final _popularesStream = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStream.sink.add;
  Stream<List<Pelicula>> get popularesStream => _popularesStream.stream;

  void disposeStreams(){
    _popularesStream?.close();
  }

  Future<List<Pelicula>> _query( Uri url ) async {

    

    final resp = await http.get( url );
    final decodedData = json.decode( resp.body );

    final peliculas = new Peliculas.fromJsonList( decodedData['results'] );

    return peliculas.items;

  }
  
  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing', {

      'api_key'  : _apiKey,
      'language' : _languje

    });

    return await _query( url );
    
  }

  Future<List<Pelicula>> getPopulares() async {

    if ( _cargando ) return [];

    _cargando = true;
    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {

      'api_key'  : _apiKey,
      'language' : _languje,
      'page'     : _popularesPage.toString()

    });
  
    final resp = await _query( url );
    _populares.addAll( resp );
    popularesSink( _populares );

    _cargando = false;
    return resp;

  }

  Future<List<Actor>> getActores( String peliId ) async {

    final url = Uri.https(_url, '3/movie/$peliId/credits', {

      'api_key'  : _apiKey,
      'language' : _languje,

    });

    final resp = await http.get(url);
    final decodedData = json.decode( resp.body );

    final cast = Cast.fromJsonList( decodedData['cast'] );
    return cast.actores;

  }

  Future<List<Pelicula>> buscarPelicula( String query ) async {

    final url = Uri.https(_url, '3/search/movie', {

      'api_key'  : _apiKey,
      'language' : _languje,
      'query'    : query,

    });

    return await _query( url );
    
  }

}
