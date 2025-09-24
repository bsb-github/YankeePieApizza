import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/language_model.dart';
import 'package:flutter_restaurant/features/language/providers/language_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({
    super.key,
    required BuildContext context,
    required this.languageModel,
    required this.languageProvider,
    this.index,
  });

  final LanguageProvider languageProvider;
  final LanguageModel languageModel;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          languageProvider.setSelectIndex(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: languageProvider.selectIndex == index ? Theme.of(context).primaryColor.withValues(alpha:0.05) : null,
            border: Border.all(width: 1.0, color: languageProvider.selectIndex == index ? Theme.of(context).primaryColor : Colors.transparent),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Row(children: [
              Image.asset(languageModel.imageUrl!, width: 34, height: 34),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Text(
                languageModel.languageName!,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
              ),
            ]),

          ]),
        ),
      ),
    );
  }
}