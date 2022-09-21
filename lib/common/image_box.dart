import 'dart:io';

import 'package:flutter/material.dart';
import 'package:serviceprovider/common/common_styles.dart';

class ProductImageBox extends StatelessWidget {
  const ProductImageBox({
    Key? key,
    required this.title,
    required this.imageFile,
    required this.radius,
    required this.circleRadius,
    this.borderColor = Colors.black,
    this.borderWidth = 0.5,
    required this.onPressed,
  }) : super(key: key);
  final String title;
  final File imageFile;
  final double radius;
  final double circleRadius;
  final Color borderColor;
  final double borderWidth;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: imageFile.path == File('').path
            ? Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(circleRadius)),
                  border: Border.all(color: borderColor, width: borderWidth),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: CommonStyles.black13thin(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Image.file(
                imageFile,
                cacheHeight: 200,
                cacheWidth: 200,
              ));
  }
}
