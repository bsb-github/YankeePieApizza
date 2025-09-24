import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_loader_widget.dart';
import 'package:flutter_restaurant/features/coupon/domain/models/coupon_model.dart';
import 'package:flutter_restaurant/features/coupon/widgets/coupon_bottom_sheet_widget.dart';
import 'package:flutter_restaurant/features/coupon/widgets/coupon_card_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:provider/provider.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}
late bool _isLoggedIn;
class _CouponScreenState extends State<CouponScreen> {

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    if(_isLoggedIn || splashProvider.configModel!.isGuestCheckout!) {
      Provider.of<CouponProvider>(context, listen: false).getCouponList();
    }
    Provider.of<CouponProvider>(context, listen: false).clearSearchController(shouldUpdate: false);
  }
  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) : CustomAppBarWidget(context: context, title: getTranslated('coupon', context))) as PreferredSizeWidget?,
      body: (splashProvider.configModel!.isGuestCheckout! || _isLoggedIn) ? Consumer<CouponProvider>(
        builder: (context, coupon, child) {

          List<CouponModel> ? couponList = coupon.isActiveSuffixIcon ? coupon.searchedCouponList : coupon.availableCouponList;

          return couponList == null && !coupon.isActiveSuffixIcon ? CustomLoaderWidget(color: Theme.of(context).primaryColor)  : RefreshIndicator(
            onRefresh: () async {
              await coupon.getCouponList();
            },
            backgroundColor: Theme.of(context).primaryColor,
            color: Theme.of(context).cardColor,
            child: SingleChildScrollView(
              child: Column(children: [
                Center(child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
                      child: Container(
                        padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeLarge) : EdgeInsets.zero,
                        child: Container(
                          width: width > 700 ? Dimensions.webScreenWidth : width,
                          padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                          decoration: width > 700 ? BoxDecoration(
                            color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                            boxShadow: [ BoxShadow(
                              color: Theme.of(context).shadowColor,
                              offset: const Offset(10, 18),
                              blurRadius: 35,
                            )],
                          ) : null,
                          child: Column(children: [

                            ResponsiveHelper.isDesktop(context) ? Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                Text(getTranslated('coupon_list', context)!, style: rubikBold.copyWith(
                                  fontSize: Dimensions.paddingSizeLarge,
                                  fontWeight: FontWeight.w800,
                                )),

                                const _SearchTextFieldWidget(),
                              ]),
                            ) : const Padding(
                              padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
                              child: _SearchTextFieldWidget(),
                            ),

                            couponList!.isEmpty ?  const Center(child: NoDataWidget())  : ResponsiveHelper.isDesktop(context) ? GridView.builder(
                              itemCount: couponList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeLarge,
                                vertical: Dimensions.paddingSizeSmall,
                              ),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // Change this value based on desired column count
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                childAspectRatio: 2.8, // Adjust based on desired item shape
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    ResponsiveHelper.showDialogOrBottomSheet(
                                      context,
                                      CouponBottomSheetWidget(coupon: couponList[index]),
                                    );
                                  },
                                  child: CouponCardWidget(coupon: couponList[index]),
                                );
                              },
                            ) :
                            ListView.builder(
                              itemCount: couponList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: (){
                                    ResponsiveHelper.showDialogOrBottomSheet(context, CustomAlertDialogWidget(
                                      isHeaderBarExist: false,
                                      height: ResponsiveHelper.isDesktop(context) ? 600 : null,
                                      isPadding: false, child: CouponBottomSheetWidget(coupon: couponList[index]),
                                    ));
                                  },
                                  child: CouponCardWidget(coupon: couponList[index]),
                                );
                              },
                            ),

                          ]),
                        ),
                      ),
                    )),
                  if(ResponsiveHelper.isDesktop(context))  const FooterWidget()
                ]),
            ),
          );
        },
      ) : const NotLoggedInWidget(),
    );
  }
}

class _SearchTextFieldWidget extends StatefulWidget {

  const _SearchTextFieldWidget();

  @override
  State<_SearchTextFieldWidget> createState() => _SearchTextFieldWidgetState();
}

class _SearchTextFieldWidgetState extends State<_SearchTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CouponProvider>(builder: (context, coupon, child){
      return SizedBox(
        width: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.width * 0.2 : null,
        child: TextField(

          controller: coupon.searchController,
          style: robotoRegular.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeDefault,
          ),

          cursorColor: Theme.of(context).hintColor,
          autofocus: false,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.search,
          onChanged: (text)  {
            coupon.showSuffixIcon(context,text);
            if(text.isNotEmpty) {
              coupon.searchCoupon(query : text.trim());
            }
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            fillColor: Theme.of(context).cardColor,
            border:  OutlineInputBorder(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(10,),left: Radius.circular(10)),
              borderSide: BorderSide( width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
            ),
            errorBorder:  OutlineInputBorder(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(10,),left: Radius.circular(10)),
              borderSide: BorderSide( width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
            ),

            focusedBorder:  OutlineInputBorder(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(10,),left: Radius.circular(10)),
              borderSide: BorderSide( width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
            ),
            enabledBorder :  OutlineInputBorder(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(10,),left: Radius.circular(10)),
              borderSide: BorderSide( width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
            ),

            isDense: true,
            hintText: getTranslated('search_by_name_code', context),
            hintStyle: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor,
            ),
            filled: true,
            prefixIcon: Icon(Icons.search_outlined,color: Theme.of(context).hintColor, size: 22,),
            suffixIcon: coupon.isActiveSuffixIcon ? IconButton(
              color: Theme.of(context).hintColor,
              onPressed: () {
                if(coupon.searchController.text.trim().isNotEmpty) {
                  coupon.clearSearchController();
                }
                FocusScope.of(context).unfocus();
              },
              icon: Icon(
                  Icons.cancel_outlined, size: 18,color: Theme.of(context).hintColor
              ),
            ) : const SizedBox(),
          ),
        ),
      );
    });
  }
}

