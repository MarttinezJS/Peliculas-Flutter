import 'package:flutter/material.dart';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _crearAppBar( pelicula ),
          SliverList(

            delegate: SliverChildListDelegate(
              [
                SizedBox( height: 10.0 ),
                _posterTitulo( pelicula, context ),
                Divider(),
                SizedBox( height: 10.0 ),
                _descripcion( pelicula ),
                Divider(),
                SizedBox( height: 10.0 ),
                _crearCasting( pelicula )
              ]
            ),
          )
        ],
      ),
    );
  }

  Widget _crearAppBar(Pelicula pelicula) {

    return SliverAppBar(
      elevation: 60.0,
      backgroundColor: Colors.brown,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle( color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage( pelicula.getBackDropimg() ),
          placeholder: AssetImage('assets/img/loading_circular_dots.gif'),
          fadeInDuration: Duration( milliseconds: 200),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _posterTitulo( Pelicula pelicula, BuildContext context ) {

    return Container(
      child: Row(
        children: [
          Hero(
            tag: pelicula.uniqueId ,
            child: ClipRRect(
              borderRadius: BorderRadius.circular( 20.0 ),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox( width: 20.0 ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( 
                  pelicula.title,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  pelicula.originalTitle,
                  style: Theme.of(context).textTheme.caption,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox( height: 10.0 ),
                Row(
                  children: [

                    Icon( Icons.sentiment_very_satisfied, color: Colors.brown, ),
                    Text( pelicula.voteCount.toString(), style: Theme.of(context).textTheme.subtitle1 ),
                    SizedBox( width: 10.0 ),
                    Icon( Icons.star_border, color: Colors.brown, ),
                    Text( pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subtitle1, ),
                    
                  ],
                )
              ],
            )
          )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {

    return Container(
      padding: EdgeInsets.symmetric( horizontal: 10.0, vertical: 20.0),
      child: Text( pelicula.overview, textAlign: TextAlign.justify, style: TextStyle( color: Colors.brown[600] ), ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {

    final peliProvider = PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getActores( pelicula.id.toString() ),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

        return snapshot.hasData ? _crearActoresPageView( snapshot.data ) : Center(
                child: CircularProgressIndicator(),
        );

      },
    );

  }

  Widget _crearActoresPageView( List<Actor> actores ) {

    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        itemCount: actores.length,
        pageSnapping: false,
        itemBuilder: (context, index) {
          return _actorTargeta( actores[index] );
        },
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
      ),
    );

  }

  Widget _actorTargeta( Actor actor ) {

    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular( 15.0 ),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/loading_circular_dots.gif'),
              image: NetworkImage( actor.getFoto() ),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox( height: 15.0 ),
          Text( actor.name )
        ],
      ),
    );
  }
}