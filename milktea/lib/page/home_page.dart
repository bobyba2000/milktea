import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:milktea/common_widget/network_image_widget.dart';
import 'package:milktea/utils/link_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    this.listImageUrls = const [],
    this.youtubeUrl = '',
    this.location = '',
  }) : super(key: key);
  final List<String> listImageUrls;
  final String youtubeUrl;
  final String location;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('images/logo.png'),
        const SizedBox(height: 20),
        Visibility(
          visible: widget.listImageUrls.isNotEmpty,
          child: Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
              ),
              CarouselSlider(
                items: imageSlidersWidget(),
                carouselController: _controller,
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {},
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 70),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    LinkUtils.openLink(widget.location);
                  },
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Iconsax.location,
                          size: 28,
                          color: Colors.grey,
                        ),
                        Text(
                          'Địa điểm',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).primaryColor,
                width: 1,
                height: 50,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    LinkUtils.openLink(widget.youtubeUrl);
                  },
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Iconsax.video,
                          size: 28,
                          color: Colors.grey,
                        ),
                        Text(
                          'Youtube',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> imageSlidersWidget() {
    return widget.listImageUrls
        .map(
          (item) => Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: NetworkImageWidget(url: item, width: 1000),
            ),
          ),
        )
        .toList();
  }
}
