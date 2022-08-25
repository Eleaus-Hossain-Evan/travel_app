import 'package:flutter/material.dart';

import '../../../model/place.dart';

class AnimatedDetailHeader extends StatelessWidget {
  const AnimatedDetailHeader({
    Key? key,
    required this.place,
  }) : super(key: key);

  final TravelPlace place;

  @override
  Widget build(BuildContext context) {
    final imageUrl = place.imagesUrl;
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: place.imagesUrl.length,
            physics: const BouncingScrollPhysics(),
            controller: PageController(viewportFraction: .9),
            itemBuilder: (context, index) {
              final imageUrl = place.imagesUrl[index];
              return Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                      Colors.black26,
                      BlendMode.darken,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            imageUrl.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              color: Colors.black12,
              height: 3,
              width: 10,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
