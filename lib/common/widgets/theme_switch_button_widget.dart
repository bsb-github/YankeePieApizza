import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
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
             if(widget.fromWebBar)
               Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall), child: Text(
                getTranslated(themeProvider.darkTheme ? 'light' : 'dark', context)!,
                style: rubikSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
               )),

              Container(
                transform: Matrix4.translationValues(0, themeProvider.darkTheme ? 0 : -1, 0),
                child: Icon(
                  themeProvider.darkTheme ? Icons.light_mode : Icons.dark_mode,
                  size: widget.fromWebBar ? Dimensions.paddingSizeLarge : 35,
                  color: widget.fromWebBar ? null : Colors.white,
                ),
              ),
            ]),
          ),
        );
      }
    );
  }
}
