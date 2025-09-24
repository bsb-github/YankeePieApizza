import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

class CustomSliderListWidget extends StatefulWidget {
  final ScrollController controller;
  final double  verticalPosition;
  final double  horizontalPosition;
  final bool isShowForwardButton;
  final Widget child;

  const CustomSliderListWidget({
    super.key,
    required this.controller,
    required this.verticalPosition,
    this.horizontalPosition = 0,
    required this.child,
    this.isShowForwardButton = true,
  });

  @override
  State<CustomSliderListWidget> createState() => _CustomSliderListWidgetState();
}

class _CustomSliderListWidgetState extends State<CustomSliderListWidget> {

  bool showBackButton = false;
  bool showForwardButton = false;
  bool isFirstTime = true;

  @override
  void initState() {
    widget.controller.addListener(_checkScrollPosition);
    super.initState();
  }

  @override
  void dispose() {
    // widget.controller.dispose();
    super.dispose();
  }

  void _checkScrollPosition() {
    if (widget.controller.position.pixels <= 0) {
      showBackButton = false;
    } else {
      showBackButton = true;
    }

    if (widget.controller.position.pixels >= widget.controller.position.maxScrollExtent) {
      showForwardButton = false;
    } else {
      showForwardButton = true;
    }
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    if(widget.isShowForwardButton && isFirstTime){
      setState(() {
        showForwardButton = true;
      });
    }
    isFirstTime = false;

    return ResponsiveHelper.isDesktop(context) ?  Stack(children: [
      widget.child,

      if(showBackButton) Positioned(
        top: widget.verticalPosition, left: widget.horizontalPosition,
        child: ArrowIconButtonWidget(
          isRight: false,
          onTap: () => widget.controller.animateTo(widget.controller.offset - (Dimensions.webScreenWidth / 2),
              duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
        ),
      ),

      if(showForwardButton) Positioned(
        top: widget.verticalPosition, right: widget.horizontalPosition,
        child: ArrowIconButtonWidget(
          onTap: () => widget.controller.animateTo(widget.controller.offset + (Dimensions.webScreenWidth / 2),
              duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
        ),
      ),
    ]) : widget.child;
  }
}

