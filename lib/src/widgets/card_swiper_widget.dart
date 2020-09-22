import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;

  CardSwiper({ @required this.peliculas });
  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only( top: 10.0),
      child: Swiper(
          itemBuilder: (BuildContext context,int index){

            peliculas[index].uniqueId = '${ peliculas[index].id }-swiper';
            final targeta = Hero(
              tag: peliculas[index].uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular( 25.0 ),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/loading_dots.gif'),
                  image: NetworkImage( peliculas[index].getPosterImg() ),
                  fit: BoxFit.cover,
                )
              ),
            );


            return GestureDetector(
              child: targeta,
              onTap: () {
                Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]);
              },
            );

          },
          itemCount: peliculas.length,
          layout: SwiperLayout.STACK,
          itemHeight: _screenSize.height * 0.45,
          itemWidth: _screenSize.width * 0.7,
          // pagination: SwiperPagination(),
          // control: SwiperControl(),
      ),
    );
  }
}