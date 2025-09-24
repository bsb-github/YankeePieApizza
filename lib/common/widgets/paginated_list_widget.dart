import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_loader_widget.dart';
import 'package:flutter_restaurant/helper/debounce_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class PaginatedListWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final Function(int? offset) onPaginate;
  final int? totalSize;
  final int? offset;
  final int? limit;
  final bool isDisableWebLoader;
  final Widget Function(Widget loaderWidget) builder;

  final bool enabledPagination;
  final bool reverse;
  const PaginatedListWidget({
    super.key, this.scrollController, required this.onPaginate, required this.totalSize,
    required this.offset, required this.builder, this.enabledPagination = true, this.reverse = false, this.limit = 10,
    this.isDisableWebLoader = false,
  });

  @override
  State<PaginatedListWidget> createState() => _PaginatedListWidgetState();
}

class _PaginatedListWidgetState extends State<PaginatedListWidget> {
  int? _offset;
  late List<int?> _offsetList;
  bool _isLoading = false;
  bool _isDisableLoader = true;

  @override
  void initState() {
    super.initState();

    _offset = 1;
    _offsetList = [1];

   if(widget.scrollController != null){
     widget.scrollController!.addListener(() {
       if (widget.scrollController!.position.pixels == widget.scrollController!.position.maxScrollExtent
           && widget.totalSize != null && !_isLoading && widget.enabledPagination) {
         if(mounted && (!ResponsiveHelper.isDesktop(context))) {
           _paginate();
         }
       }
     });
   }
  }

  void _paginate() async {
    int pageSize = (widget.totalSize! / widget.limit!).ceil();
    if (_offset! < pageSize && !_offsetList.contains(_offset!+1)) {

      setState(() {
        _offset = _offset! + 1;
        _offsetList.add(_offset);
        _isLoading = true;
      });
      await widget.onPaginate(_offset);

      if(mounted) {
        setState(() {
          _isLoading = false;
        });
      }

    }else {
      if(_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.offset != null) {
      _offset = widget.offset;
      _offsetList = [];
      for(int index=1; index<=widget.offset!; index++) {
        _offsetList.add(index);
      }
    }

    _isDisableLoader = (ResponsiveHelper.isDesktop(context)
        && (widget.totalSize == null
            || _offset! >= (widget.totalSize! / (widget.limit ?? 10)).ceil()
            || _offsetList.contains(_offset!+1)));

    final DebounceHelper debounce = DebounceHelper(milliseconds: 500);


    return _OnNotificationListenerWidget(
      isEnabled: widget.scrollController == null,
      onNotification: (scrollNotification){
        if (scrollNotification!.metrics.pixels >= scrollNotification.metrics.maxScrollExtent
            && widget.totalSize != null && !_isLoading && widget.enabledPagination) {

          if(mounted) {
            debounce.run((){
              _paginate();
            });
          }
        }
      },
      child: Column(children: [
      
        widget.reverse ? const SizedBox() : widget.builder(_LoadingWidget(
          onTap: _paginate,
          isLoading: _isLoading,
          totalSize: widget.totalSize,
          isDisabledLoader: _isDisableLoader,
        )),
      
       if(widget.isDisableWebLoader) _LoadingWidget(
          onTap: _paginate,
          isLoading: _isLoading,
          totalSize: widget.totalSize,
          isDisabledLoader: _isDisableLoader,
        ),
      
        widget.reverse ? widget.builder(_LoadingWidget(
          onTap: _paginate,
          isLoading: _isLoading,
          totalSize: widget.totalSize,
          isDisabledLoader: _isDisableLoader,
        )) : const SizedBox(),
      
      ]),
    );
  }

}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({
    required  this.isLoading,
    required this.totalSize,
    required this.isDisabledLoader,
    required this.onTap,
  });

  final bool isLoading;
  final bool isDisabledLoader;
  final int? totalSize;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return isDisabledLoader ?  SizedBox(
      height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0,
    ) :  Center(child: Padding(
      padding: (isLoading || ResponsiveHelper.isDesktop(context)) ?  const EdgeInsets.all(Dimensions.paddingSizeDefault) : EdgeInsets.zero,
      child: isLoading ? CustomLoaderWidget(color: Theme.of(context).primaryColor) : (ResponsiveHelper.isDesktop(context) && totalSize != null) ? InkWell(
        onTap: ()=> onTap(),
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeSmall,
            horizontal: Dimensions.paddingSizeLarge,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
          child: Text(getTranslated('see_more', context)!, style: rubikSemiBold.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Theme.of(context).primaryColor,
          )),

        ),
      ) : const SizedBox(),
    ));
  }
}

class _OnNotificationListenerWidget extends StatelessWidget {
  final bool isEnabled;
  final Widget child;
  final Function(ScrollNotification? scrollNotification) onNotification;
  const _OnNotificationListenerWidget({required this.isEnabled, required this.child, required this.onNotification});

  @override
  Widget build(BuildContext context) {
    return isEnabled ? NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        onNotification(scrollNotification);

        return false;
      },
      child: child,
    ) : child;
  }
}
