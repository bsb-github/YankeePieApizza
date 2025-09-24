
import 'package:flutter/material.dart';

class CustomSingleChildListWidget extends StatefulWidget {
  final Axis? scrollDirection;
  final Widget Function(int index) itemBuilder;
  final int itemCount;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool isWrap;
  final double? wrapSpacing;
  final double? runSpacing;


  CustomSingleChildListWidget({
    Key? key, this.scrollDirection = Axis.vertical,
    required this.itemCount, required this.itemBuilder,
    this.mainAxisAlignment, this.crossAxisAlignment,
    this.physics,
    this.controller, this.isWrap = false, this.wrapSpacing, this.runSpacing,
  }) :  assert(
  !(itemCount > 1000),
  'Do not use this widget if your itemCount is lots',
  ), super(key: UniqueKey());

  @override
  State<CustomSingleChildListWidget> createState() => _CustomSingleChildListWidgetState();
}

class _CustomSingleChildListWidgetState extends State<CustomSingleChildListWidget> {

  List<int> indexList = [];

  @override
  void initState() {
    for(int i = 0; i < widget.itemCount; i++){
      indexList.add(i);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  SingleChildScrollView(
      controller: widget.controller,
      scrollDirection: widget.scrollDirection ?? Axis.vertical,
      physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
      child: widget.isWrap ? Wrap(
        spacing: widget.wrapSpacing ?? 0,
        runSpacing: widget.runSpacing ?? 0,
        children: indexList.map((index) => widget.itemBuilder(index)).toList(),
      ) : widget.scrollDirection == Axis.vertical ? Column(
        mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.center,
        children: indexList.map((index) => widget.itemBuilder(index)).toList(),
      ) : Row(
        mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.center,
        children: indexList.map((index) => widget.itemBuilder(index)).toList(),
      ),
    );
  }
}