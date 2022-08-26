import 'package:flutter/material.dart';

import '../../model/place.dart';
import 'widget/animated_detail_header.dart';

class PlaceDetailScreen extends StatefulWidget {
  const PlaceDetailScreen({
    Key? key,
    required this.place,
    required this.screenHight,
  }) : super(key: key);

  final TravelPlace place;
  final double screenHight;

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  late ScrollController _controller;

  late ValueNotifier<double> bottomPercentNotifier;

  bool _isAnimatingScroll = false;

  void _scrollListener() {
    var percent =
        _controller.position.pixels / MediaQuery.of(context).size.height;
    bottomPercentNotifier.value = (percent / .3).clamp(0, 1);
  }

  void _isScrollingListener() {
    var percent = _controller.position.pixels / widget.screenHight;

    if (!_controller.position.isScrollingNotifier.value) {
      if (percent < .3 && percent > .15) {
        setState(() => _isAnimatingScroll = true);
        _controller
            .animateTo(
              widget.screenHight * .3,
              duration: kThemeAnimationDuration,
              curve: Curves.decelerate,
            )
            .then((value) => setState(() => _isAnimatingScroll = false));
      }
      if (percent < .1 && percent > 0) {
        setState(() => _isAnimatingScroll = true);
        _controller
            .animateTo(
              0,
              duration: kThemeAnimationDuration,
              curve: Curves.decelerate,
            )
            .then((value) => setState(() => _isAnimatingScroll = false));
      }
      if (percent < .5 && percent > .3) {
        setState(() => _isAnimatingScroll = true);
        _controller
            .animateTo(
              widget.screenHight * .3,
              duration: kThemeAnimationDuration,
              curve: Curves.decelerate,
            )
            .then((value) => setState(() => _isAnimatingScroll = false));
      }
    }
  }

  @override
  void initState() {
    _controller =
        ScrollController(initialScrollOffset: widget.screenHight * .3);
    bottomPercentNotifier = ValueNotifier(1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.position.isScrollingNotifier
          .addListener(_isScrollingListener);
    });

    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: _isAnimatingScroll,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: BuilderPersistentDelegate(
                    maxExtent: MediaQuery.of(context).size.height,
                    minExtent: 240,
                    builder: (percent) {
                      final bottomPercent = (percent / .3).clamp(0.0, 1.0);

                      return AnimatedDetailHeader(
                        topPercent: ((1 - percent) / .7).clamp(0.0, 1.0),
                        bottomPercent: bottomPercent,
                        place: widget.place,
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: TranslateAnimation(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.black26,
                              ),
                              Flexible(
                                child: Text(
                                  widget.place.locationDesc,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.blue),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(widget.place.description),
                          const SizedBox(height: 10),
                          Text(widget.place.description),
                          const SizedBox(height: 10),
                          Text(widget.place.description),
                          const SizedBox(height: 20),
                          const Text(
                            "PLACES IN THIS COLLECTION",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 180,
                    child: ListView.builder(
                      itemCount: TravelPlace.collectionPlaces.length,
                      scrollDirection: Axis.horizontal,
                      itemExtent: 150,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (BuildContext context, int index) {
                        final collectionPlace =
                            TravelPlace.collectionPlaces[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              collectionPlace.imagesUrl.first,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 150,
                  ),
                )
              ],
            ),
          ),
          ValueListenableBuilder<double>(
            valueListenable: bottomPercentNotifier,
            builder: (context, value, child) {
              return Positioned.fill(
                top: null,
                bottom: -130 * (1 - value),
                child: child!,
              );
            },
            child: Container(
              height: 130,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0),
                    Colors.white,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade800,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        for (var i = 0; i < 3; i++)
                          Align(
                            widthFactor: .7,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 15,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    TravelUser.users[1].urlPhoto,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        const Text(
                          'Comments',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '120',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuilderPersistentDelegate extends SliverPersistentHeaderDelegate {
  BuilderPersistentDelegate({
    required double maxExtent,
    required double minExtent,
    required this.builder,
  })  : _maxExtent = maxExtent,
        _minExtent = minExtent;

  final double _maxExtent;
  final double _minExtent;
  final Widget Function(double) builder;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(shrinkOffset / _maxExtent);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => _maxExtent;

  @override
  // TODO: implement minExtent
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
