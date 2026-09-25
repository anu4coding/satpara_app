import 'package:flutter/material.dart';

import '../utils/constants.dart';

class BrandLogo extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const BrandLogo({
    super.key,
    this.size = 44,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      AppConstants.logoAsset,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: AppConstants.appName,
    );

    if (padding == null && backgroundColor == null) {
      return SizedBox(width: size, height: size, child: image);
    }

    return Container(
      width: size,
      height: size,
      padding: padding,
      decoration: backgroundColor == null
          ? null
          : BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: image,
    );
  }
}

class BrandTitle extends StatelessWidget {
  final Color textColor;
  final double logoSize;
  final double fontSize;

  const BrandTitle({
    super.key,
    required this.textColor,
    this.logoSize = 38,
    this.fontSize = 17,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrandLogo(size: logoSize),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            AppConstants.appName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w800,
              fontSize: fontSize,
              letterSpacing: .4,
            ),
          ),
        ),
      ],
    );
  }
}
