import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class HashPassCard extends StatelessWidget {
  final Widget child;
  const HashPassCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      );
}

class ShowcaseHashPassCard extends StatelessWidget {
  final Widget child;
  final GlobalKey showcaseKey;
  final String description;
  final bool useShadow;
  const ShowcaseHashPassCard({
    super.key,
    required this.child,
    required this.showcaseKey,
    required this.description,
    this.useShadow = true,
  });

  @override
  Widget build(BuildContext context) => Showcase(
        key: showcaseKey,
        description: description,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: useShadow
                ? [
                    BoxShadow(
                      color: Get.theme.shadowColor,
                      spreadRadius: 0,
                      blurRadius: 7,
                    ),
                  ]
                : [],
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: child,
            ),
          ),
        ),
      );
}
