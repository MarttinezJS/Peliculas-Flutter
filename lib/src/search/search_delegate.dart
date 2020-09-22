import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {


  final peliculas = [
    'Superman',
    'Aquaman',
    'Los vengadores',
    'Deadpool',
    'Deadshot',
    'Batman',
    'Mulan',
    'Spiderman'
  ];
  final peliculasRecientes = [
    'Spiderman',
    'Capitan America'
  ];

  final _provider = PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () {
        query = '';
      },)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation
      ),
      onPressed: () {
        close( context, null );
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return query.isEmpty ? Container() 
    : FutureBuilder(
      future: _provider.buscarPelicula( query ),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {

        final peliculas = snapshot.data;

        return !snapshot.hasData ? Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: peliculas.length,
          itemBuilder :(context, index) {
            
            return ListTile(
              leading: FadeInImage(
                placeholder: AssetImage('assets/img/loading_dots.gif'),
                image: NetworkImage( peliculas[index].getPosterImg() ),
                width: 50.0,
                fit: BoxFit.contain,
              ),
              title: Text( peliculas[index].title ),
              subtitle: Text( peliculas[index].originalTitle ),
              onTap: () {
                close(context, null);
                peliculas[index].uniqueId = '';
                Navigator.pushNamed(context, 'detalle', arguments: peliculas[index] );
              },
            );

        });
      },
    );
  }


}