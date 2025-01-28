import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:meu_onibus_app/widgets/FullScreenImage.dart';

class carrossel_imgs extends StatefulWidget {
  final List<String> images;

  carrossel_imgs({super.key, required this.images});

  @override
  State<carrossel_imgs> createState() => _carrossel_imgsState();
}

class _carrossel_imgsState extends State<carrossel_imgs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _openFullScreenImage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(
          imageUrl: widget.images,
          index: index,
        ),
      ),
    );
  }

  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.images.isNotEmpty && widget.images.length > 1)
          // Carrossel no topo
          Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider(
                items: widget.images.asMap().entries.map((entry) {
                  int index = entry.key;
                  String item = entry.value;
                  return GestureDetector(
                      onDoubleTap: () => _openFullScreenImage(index),
                      child: ClipRRect(
                        child: Image.network(item,
                            fit: BoxFit.cover, width: double.infinity),
                      ));
                }).toList(),
                options: CarouselOptions(
                  height: 200, // Defina a altura do carrossel
                  viewportFraction: 1.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                carouselController: _controller,
              ),

              // Botão Anterior

              Positioned(
                left: 10,
                child: IconButton(
                  icon:
                      Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                  onPressed: () => _controller.previousPage(),
                ),
              ),

              // Botão Próximo

              Positioned(
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios,
                      color: Colors.white, size: 30),
                  onPressed: () => _controller.nextPage(),
                ),
              ),

              // Indicador de posição do carrossel

              Positioned(
                bottom: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.images.asMap().entries.map((entry) {
                    return Container(
                      width: _currentIndex == entry.key ? 12.0 : 8.0,
                      height: _currentIndex == entry.key ? 12.0 : 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == entry.key
                            ? Colors.orange
                            : Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          )
        else if (widget.images.isEmpty)
          ClipRRect(
            child: Image.asset(
              'assets/images/no-image.jpg', // Pega a única imagem disponível
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          )
        else
          GestureDetector(
            onDoubleTap: widget.images.isEmpty
                ? () => _openFullScreenImage(0)
                : () => {},
            child: ClipRRect(
                child: Image.network(widget.images.first,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200, errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/no-image.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200, // Mantém a altura igual ao carrossel
              );
            })),
          ),
      ],
    );
  }
}
