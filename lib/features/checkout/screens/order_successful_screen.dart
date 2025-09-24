import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/home/screens/home_screen.dart';
import 'package:provider/provider.dart';

class OrderSuccessfulScreen extends StatefulWidget {
  final String? orderID;
  final int status;
  const OrderSuccessfulScreen({super.key, required this.orderID, required this.status});

  @override
  State<OrderSuccessfulScreen> createState() => _OrderSuccessfulScreenState();
}

class _OrderSuccessfulScreenState extends State<OrderSuccessfulScreen> {
  bool _isReload = true;

  @override
  void initState() {
    ///delay for widget tree load and fix issue for notify controller
    Future.delayed(const Duration(milliseconds: 300)).then((_){
      HomeScreen.loadData(true);
    });    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if(_isReload && widget.status == 0) {
      Provider.of<OrderProvider>(context, listen: false).trackOrder(widget.orderID, fromTracking: false);
      _isReload = false;
    }
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) : null,
      body: SafeArea(
        child: Consumer<OrderProvider>(
            builder: (context, orderProvider, _) {
              double total = 0;


              if(orderProvider.trackModel != null && Provider.of<SplashProvider>(context, listen: false).configModel!.loyaltyPointItemPurchasePoint != null) {
                total = ((orderProvider.trackModel?.orderAmount ?? 1) * (Provider.of<SplashProvider>(context, listen: false).configModel?.loyaltyPointItemPurchasePoint ?? 1) / 100);
              }

            return orderProvider.isLoading ? const Center(child: CircularProgressIndicator()) : ResponsiveHelper.isWeb() ? CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: OrderSuccessfulWidget(widget: widget, total: total, size: size)),

                if(ResponsiveHelper.isDesktop(context))  const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    SizedBox(height: Dimensions.paddingSizeLarge),

                    FooterWidget(),
                  ]),
                ),
              ],
            ) : OrderSuccessfulWidget(widget: widget, total: total, size: size);
          }
        ),
      ),
    );
  }
}

class OrderSuccessfulWidget extends StatelessWidget {
  const OrderSuccessfulWidget({
    super.key,
    required this.widget,
    required this.total,
    required this.size,
  });

  final OrderSuccessfulScreen widget;
  final double total;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen:false);
    final bool isLoyaltyPointAvailable = widget.status == 0 && Provider.of<AuthProvider>(context, listen: false).isLoggedIn() && Provider.of<SplashProvider>(context).configModel!.loyaltyPointStatus!  && total.floor() > 0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Center(child: SizedBox(
          width: Dimensions.webScreenWidth,
          child: orderProvider.isLoading ? const CircularProgressIndicator() :  Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              widget.status == 0 ? Icon(Icons.check_circle, color: Theme.of(context).secondaryHeaderColor, size: 80) :
              Container(
                height: 100, width: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha:0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.status == 1 ? Icons.sms_failed : widget.status == 2 ? Icons.question_mark : Icons.cancel,
                  color: Theme.of(context).primaryColor, size: 80,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Column(children: [

                isLoyaltyPointAvailable ?
                Text(getTranslated('congratulations', context)! , style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)) : const SizedBox(),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                isLoyaltyPointAvailable ? Text(
                  getTranslated('your_order_was_placed_successfully', context)!,
                  style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                ) : widget.status == 0 ? Text.rich(TextSpan(children: [
                  TextSpan(text: getTranslated('your_order', context)),

                  TextSpan(text: ' #${widget.orderID} ', style: rubikSemiBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)),

                  TextSpan(text: '${getTranslated('was_placed_successfully', context)}'),

                ]),
                  style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                  textAlign: TextAlign.center,
                ) : Text(
                  getTranslated(widget.status == 1 ? 'payment_failed' : widget.status == 2 ? 'order_failed' : 'payment_cancelled', context)!,
                  style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

               if(isLoyaltyPointAvailable) Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: getTranslated('order', context)),

                    TextSpan(text: ' #${widget.orderID} ', style: rubikBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),

                    TextSpan(text: '${getTranslated('placed_successfully', context)} ${getTranslated('complete_it_to_earn', context)} $total ${getTranslated('points', context)}, '),

                    TextSpan(text: '${getTranslated('which_will_be_added_to_your_wallet', context)}'),
                  ]),
                    style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                    textAlign: TextAlign.center,
                  ),
                ),

              ]),

              const SizedBox(height: Dimensions.paddingSizeDefault),

              if((orderProvider.trackModel?.orderType !='take_away') && widget.status == 0) SizedBox(
                width: ResponsiveHelper.isDesktop(context) ? 400 : size.width,
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: CustomButtonWidget(
                      btnTxt: getTranslated('track_order' , context),
                      onTap: () {
                        RouterHelper.getOrderTrackingRoute(int.tryParse('${widget.orderID}'));
                  }),
                ),
              ),


              InkWell(
                onTap: ()=> RouterHelper.getDashboardRoute('home', action: RouteAction.pushNamedAndRemoveUntil),
                child: Text(getTranslated('back_home', context)!, style: rubikBold),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
