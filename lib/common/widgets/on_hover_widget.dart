import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:provider/provider.dart';

class OnHoverWidget extends StatefulWidget {

  final Widget Function(bool isHovered) builder;

  const OnHoverWidget({super.key, required this.builder});

  @override
  State<OnHoverWidget> createState() => _OnHoverWidgetState();
}

class _OnHoverWidgetState extends State<OnHoverWidget> {

  bool isHovered = false;
  @override
  Widget build(BuildContext context) {

    if(!kIsWeb) {
      return widget.builder(isHovered);
    }
    final isLtr = Provider.of<LocalizationProvider>(context).isLtr;
    // on hover animation movement matrix translation
    final matrixLtr =  Matrix4.identity()..translate(2,0,0);
    final matrixRtl =  Matrix4.identity()..translate(-2,0,0);
    final transform = isHovered ? isLtr ? matrixLtr : matrixRtl : Matrix4.identity();

    // when user enter the mouse pointer onEnter method will work
    // when user exit the mouse pointer from MouseRegion onExit method will work
    return MouseRegion(
      onEnter: (_) {
        //debugPrint('On Entry hover');
        onEntered(true);
      },
      onExit: (_){
        onEntered(false);
       // debugPrint('On Exit hover');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: transform,             // animation transformation hovered.
        child: widget.builder(isHovered,),   // build the widget passed from main.dart
      ),
    );
  }

  //used to set bool isHovered to true/false
  void onEntered(bool isHovered){
    setState(() {
      this.isHovered = isHovered;
    });
  }
}