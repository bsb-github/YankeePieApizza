import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class ThemeSwitchButtonWidget extends StatefulWidget {
  final bool fromWebBar;
  const ThemeSwitchButtonWidget({super.key, this.fromWebBar = true});

  @override
  State<ThemeSwitchButtonWidget> createState() => _ThemeSwitchButtonWidgetState();
}

class _ThemeSwitchButtonWidgetState extends State<ThemeSwitchButtonWidget> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return InkWell(
          hoverColor: Colors.transparent,
          onTap: ()=> themeProvider.toggleTheme(),
          child: AnimatedContainer(
            curve: Curves.easeInOutCirc,
            duration: const Duration(seconds: 1),
            child: Row(children: [

             if(widget.fromWebBar) Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Text(getTranslated(themeProvider.darkTheme ? 'dark_theme' : 'light_theme', context)!, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
              ),

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor.withValues(alpha:0.05)),
                child: CustomAssetImageWidget(themeProvider.darkTheme ? Images.lightModeSvg : Images.darkModeSvg),
              ),

            ]),
          ),
        );
      }
    );
  }
}
