import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/language_model.dart';
import 'package:flutter_restaurant/features/language/providers/language_provider.dart';
import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:flutter_restaurant/features/home/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../../../localization/language_constrants.dart';
import '../../../utill/dimensions.dart';
import '../../../helper/custom_snackbar_helper.dart';
import '../../../common/widgets/on_hover_widget.dart';

class LanguageHoverWidget extends StatefulWidget {
  final List<LanguageModel> languageList;
  const LanguageHoverWidget({super.key, required this.languageList});

  @override
  State<LanguageHoverWidget> createState() => _LanguageHoverWidgetState();
}

class _LanguageHoverWidgetState extends State<LanguageHoverWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
          child: Column(
            children: widget.languageList.map((language) => InkWell(
              onTap: () async {
                if(languageProvider.languages.isNotEmpty && languageProvider.selectIndex != -1) {
                  Provider.of<LocalizationProvider>(context, listen: false).setLanguage(
                      Locale(language.languageCode!, language.countryCode)
                  );
                  HomeScreen.loadData(true);

                }else {
                  showCustomSnackBarHelper(getTranslated('select_a_language', context));
                }
              },
              child: OnHoverWidget(
                builder: (isHover) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: isHover ? Theme.of(context).primaryColor.withValues(alpha:0.1) : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          child: Image.asset(language.imageUrl!,height: Dimensions.paddingSizeLarge, width: 40, fit: BoxFit.cover),
                        ),

                        Text(
                          language.languageName!, overflow: TextOverflow.ellipsis, maxLines: 1,
                          style: const TextStyle(fontSize: Dimensions.fontSizeSmall),
                        ),
                      ]),

                    ]),
                  );
                },
              ),
            )).toList(),
            // [
            //   Text(_categoryList[5].name),
            // ],
          ),
        );
      }
    );
  }
}
