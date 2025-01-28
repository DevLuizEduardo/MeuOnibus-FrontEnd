import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final List<String> imageUrl;
  final int index;
  const FullScreenImage(
      {super.key, required this.imageUrl, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Builder(
            builder: (context) {
              return CarouselSlider.builder(
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  initialPage: index,
                  // autoPlay: false,
                ),
                itemCount: imageUrl.length,
                itemBuilder: (context, i, realIndex) {
                  return Center(
                      child: InteractiveViewer(
                          panEnabled: true,
                          scaleEnabled: true,
                          minScale: 1.0,
                          maxScale: 5.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.network(
                              imageUrl[i],
                              fit: BoxFit
                                  .cover, // Garante que a imagem não seja cortada
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                            ),
                          )));
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
