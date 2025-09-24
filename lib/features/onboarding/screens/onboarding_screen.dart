import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<OnBoardingProvider>(context, listen: false).initBoardingList(context);

    final size = MediaQuery.sizeOf(context);

    return Consumer<OnBoardingProvider>(
        builder: (context, onBoardingProvider, child) => CustomPopScopeWidget(
          child: Scaffold(
            body:  onBoardingProvider.onBoardingList.isNotEmpty ? SafeArea(
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [ColorResources.onBoardingBgColor, Theme.of(context).cardColor],
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Center(child: SizedBox(width: Dimensions.webScreenWidth, child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        onBoardingProvider.selectedIndex < onBoardingProvider.onBoardingList.length - 1 ? Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
                            child: InkWell(
                              onTap: () => RouterHelper.getLoginRoute(action: RouteAction.pushNamedAndRemoveUntil),
                              child: Padding(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                child: Text(getTranslated('skip', context)!, style: rubikRegular.copyWith(color: Theme.of(context).primaryColor)),
                              ),
                            ),
                          ),
                        ) : const SizedBox(height: 48),

                        SizedBox(height: size.height * 0.2),

                        SizedBox(
                          height: size.height * 0.5,
                          child: PageView.builder(
                            itemCount: onBoardingProvider.onBoardingList.length,
                            controller: _pageController,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: CustomAssetImageWidget(
                                      onBoardingProvider.onBoardingList[index].imageUrl,
                                      width: 250, height: 190, fit: BoxFit.cover,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                                    child: Text(
                                      onBoardingProvider.selectedIndex == 0
                                          ? onBoardingProvider.onBoardingList[0].title
                                          : onBoardingProvider.selectedIndex == 1
                                          ? onBoardingProvider.onBoardingList[1].title
                                          : onBoardingProvider.onBoardingList[2].title,
                                      style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                    child: Text(
                                      onBoardingProvider.selectedIndex == 0
                                          ? onBoardingProvider.onBoardingList[0].description
                                          : onBoardingProvider.selectedIndex == 1
                                          ? onBoardingProvider.onBoardingList[1].description
                                          : onBoardingProvider.onBoardingList[2].description,
                                      style: rubikRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha:0.7),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              );
                            },
                            onPageChanged: (index) {
                              onBoardingProvider.changeSelectIndex(index);
                            },
                          ),
                        ),

                        Center(
                          child: InkWell(
                            onTap: () {
                              if(onBoardingProvider.selectedIndex < onBoardingProvider.onBoardingList.length - 1) {
                                _pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.ease);
                              }else{
                                RouterHelper.getLoginRoute(action: RouteAction.pushNamedAndRemoveUntil);
                              }
                            },
                            child: Stack(children: [

                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.2), width: 2),
                                ),
                                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
                                child: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor),
                              ),

                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(width: 100, height: 65,
                                    child: CircularProgressIndicator(
                                      value: (onBoardingProvider.selectedIndex) / (onBoardingProvider.onBoardingList.length - 1),
                                      color: Theme.of(context).primaryColor,
                                      backgroundColor: Colors.transparent,
                                      strokeCap: StrokeCap.round,
                                    ),
                                  ),
                                ),
                              ),

                            ]),
                          ),
                        ),
                      ],
                    ))),
                  ),
                ),
            ) : const SizedBox(),
          ),
        ),
    );
  }

}
