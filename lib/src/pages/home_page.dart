import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {

  final peliculasProvider = PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: Icon( Icons.search ),
            onPressed: (){
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            }
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _swiperTargetas(),
            _footer( context )
          ],
        ),
      )
    );
  }

  Widget _swiperTargetas() {

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

        return snapshot.hasData ? CardSwiper( peliculas: snapshot.data ) : Center(
          child: CircularProgressIndicator(),
          heightFactor: 10.0,
        );

      },
    );
  }

  Widget _footer( BuildContext context ) {

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only( left: 20.0 ),
            child: Text('Populares', style: Theme.of( context ).textTheme.subtitle1,)
          ),
          SizedBox( height: 5.0 ),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

              return snapshot.hasData ? MovieHorizontal( peliculas: snapshot.data, siguientePagina: peliculasProvider.getPopulares ) : Center(
                child: CircularProgressIndicator(),
              );
              
            },
          ),
        ],
      ),
    );

  }

}