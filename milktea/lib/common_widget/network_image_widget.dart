import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? url;
  final double? width;
  const NetworkImageWidget({Key? key, this.url, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url ?? '',
      fit: BoxFit.cover,
      width: width,
      height: width,
      placeholder: (context, item) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => Container(
        child: const Icon(Iconsax.image),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
