import 'package:flutter/material.dart';

import '../../../model/place.dart';

class GradientStatusTag extends StatelessWidget {
  const GradientStatusTag({
    Key? key,
    required this.statusTag,
  }) : super(key: key);

  final StatusTag statusTag;

  @override
  Widget build(BuildContext context) {
    String text = '';
    List<Color> colors = [];
    switch (statusTag) {
      case StatusTag.popular:
        text = "Popular places";
        colors = [Colors.amber, Colors.orange.shade600];
        break;
      case StatusTag.event:
        text = "Event";
        colors = [Colors.cyan, Colors.blue.shade600];
        break;
      default:
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: Colors.white),
      ),
    );
  }
}
