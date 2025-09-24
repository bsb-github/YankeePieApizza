import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/features/search/providers/search_provider.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class SearchSuggestionWidget extends StatelessWidget {
  final String? searchedText;
  const SearchSuggestionWidget({super.key, this.searchedText});

  TextSpan _highlightText(String source, String query, BuildContext context) {
    if (query.isEmpty) {
      return TextSpan(text: source, style: rubikSemiBold.copyWith(
        color: Theme.of(context).hintColor,
        fontSize: Dimensions.fontSizeSmall,
      ));
    }

    // Find start and end of the match
    int startIndex = source.toLowerCase().indexOf(query.toLowerCase());
    if (startIndex == -1) {
      return TextSpan(text: source, style: rubikSemiBold.copyWith(
        color: Theme.of(context).hintColor,
        fontSize: Dimensions.fontSizeSmall,
      ));
    }

    int endIndex = startIndex + query.length;

    return TextSpan(
      children: [
        TextSpan(text: source.substring(0, startIndex), style: rubikSemiBold.copyWith(
          color: Theme.of(context).hintColor,
          fontSize: Dimensions.fontSizeSmall,
        )),
        TextSpan(
          text: source.substring(startIndex, endIndex),
          style: rubikSemiBold.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: Dimensions.fontSizeSmall,
          ),
        ),
        TextSpan(text: source.substring(endIndex), style: rubikSemiBold.copyWith(
          color: Theme.of(context).hintColor,
          fontSize: Dimensions.fontSizeSmall,
        )),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
        builder: (ctx, searchProvider, _) {
          return (searchProvider.autoCompletedName?.isNotEmpty ?? false) ? ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            itemCount: searchProvider.autoCompletedName?.length,
            primary: false,
            // reverse: true,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                searchProvider.searchProduct(name: searchProvider.autoCompletedName?[index] ?? '', offset: 1, context: context);
                RouterHelper.getSearchResultRoute(searchProvider.autoCompletedName?[index].replaceAll(' ', '-') ?? '');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      searchProvider.historyMap[searchProvider.autoCompletedName?[index]] == null ? Icons.search : Icons.history,
                      size: Dimensions.paddingSizeDefault, color: Theme.of(context).hintColor,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    RichText(
                      text: _highlightText(searchProvider.autoCompletedName?[index] ?? '', searchedText ?? '', context),
                    ),
                  ]),

                  Icon(CupertinoIcons.arrow_up_left, size: Dimensions.fontSizeExtraLarge, color: Theme.of(context).hintColor),

                ]),
              ),
            ),
          ) : (searchProvider.autoCompletedName?.isEmpty ?? false) ? const NoDataWidget(isFooter: false) : const Center(child: CircularProgressIndicator());
        }
    );
  }
}
