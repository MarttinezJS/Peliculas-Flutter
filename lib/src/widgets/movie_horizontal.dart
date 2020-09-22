import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({ @required this.peliculas, @required this.siguientePagina });
  final _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    _pageController.addListener(() {
      
      if ( _pageController.position.pixels >= _pageController.position.maxScrollExtent - 200 ) {
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context, index) => _targeta(context, peliculas[index] )
      ),
    );
  }

  Widget _targeta( BuildContext context, Pelicula pelicula ){

    pelicula.uniqueId = '${ pelicula.id }-targeta';
    final targeta = Container(
        margin: EdgeInsets.only( right: 15.0),
        child: Column(
          children: [
            Hero(
              tag: pelicula.uniqueId, 
              child: ClipRRect(
                borderRadius: BorderRadius.circular( 10.0 ),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/loading_dots.gif'),
                  image: NetworkImage( pelicula.getPosterImg() ),
                  fit: BoxFit.cover,
                  height: 149.68,
                ),
              ),
            ),
            SizedBox( height: 5.0),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of( context ).textTheme.caption,
            )
          ],
        ),
      );





      return GestureDetector(
        child: targeta,
        onTap: () {

          Navigator.pushNamed(context, 'detalle', arguments: pelicula);
        },
      );
  }
 
}