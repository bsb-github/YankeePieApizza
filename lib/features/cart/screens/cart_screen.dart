import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/cart/providers/frequently_bought_provider.dart' show FrequentlyBoughtProvider;
import 'package:flutter_restaurant/features/cart/widgets/item_view_widget.dart';
import 'package:flutter_restaurant/features/cart/widgets/add_more_item_button_widget.dart';
import 'package:flutter_restaurant/features/cart/widgets/cart_list_widget.dart';
import 'package:flutter_restaurant/features/cart/widgets/checkout_button_widget.dart';
import 'package:flutter_restaurant/features/cart/widgets/coupon_add_widget.dart';
import 'package:flutter_restaurant/features/cart/widgets/cutlery_widget.dart';
import 'package:flutter_restaurant/features/cart/widgets/delivery_time_estimation_widget.dart';
import 'package:flutter_restaurant/features/cart/widgets/frequently_bought_widget.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/checkout_helper.dart';
import 'package:flutter_restaurant/helper/custom_extension_helper.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import '../../../helper/custom_snackbar_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  final ScrollController _frequentlyBoughtScrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    final FrequentlyBoughtProvider frequentlyBoughtProvider = Provider.of<FrequentlyBoughtProvider>(Get.context!, listen: false);
    frequentlyBoughtProvider.getFrequentlyBoughtProduct(1, false);
  }

  @override
  void dispose() {
    _frequentlyBoughtScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBarWidget(context: context, title: getTranslated('cart', context),
        isBackButtonExist: false,
      ),
      body: Consumer<CheckoutProvider>(
        builder: (context, checkoutProvider, child) {
          return Consumer<CartProvider>(
            builder: (context, cart, child) {

              List<List<AddOns>> addOnsList = [];
              List<bool> availableList = [];
              double itemPrice = 0;
              double discount = 0;
              double tax = 0;
              double addOns = 0;
              double addOnsTax = 0;


              for (var cartModel in cart.cartList) {
                List<AddOns> addOnList = [];

                for (var addOnId in cartModel!.addOnIds!) {
                  for(AddOns addOns in cartModel.product!.addOns!) {
                    if(addOns.id == addOnId.id) {
                      addOnList.add(addOns);
                      break;
                    }
                  }
                }
                addOnsList.add(addOnList);


                availableList.add(DateConverterHelper.isAvailable(cartModel.product!.availableTimeStarts!, cartModel.product!.availableTimeEnds!));

                for(int index=0; index<addOnList.length; index++) {
                  addOns = addOns + (addOnList[index].price! * cartModel.addOnIds![index].quantity!);
                  addOnsTax = addOnsTax + ((PriceConverterHelper.addonTaxCalculation(
                      taxPercentage : addOnList[index].tax,
                      addonItemPrice: addOnList[index].price,
                      quantity: (cartModel.addOnIds?[index].quantity ?? 1),
                      discountType: "percent"
                  )));
                }



                itemPrice = itemPrice + (cartModel.price! * cartModel.quantity!);
                discount = discount + (cartModel.discountAmount! * cartModel.quantity!);

                tax = tax + (cartModel.taxAmount! * cartModel.quantity!) + addOnsTax;
              }


              double couponDiscount = Provider.of<CouponProvider>(context).discount!;

              double orderAmount = itemPrice + addOns;
              double amountAfterDiscount = orderAmount - (discount + couponDiscount);

              double subTotal = itemPrice + tax  + addOns;

              double referralDiscount = CheckOutHelper.getReferralDiscount(
                totalAmount: amountAfterDiscount, referralDetails: profileProvider.userInfoModel?.referralCustomerDetails,
              );

              double total = subTotal - discount -  couponDiscount - referralDiscount;


              bool kmWiseCharge = CheckOutHelper.isKmWiseCharge(deliveryInfoModel: splashProvider.deliveryInfoModel);

              bool isFreeDelivery = total >= (splashProvider.deliveryInfoModel?.deliveryChargeSetup?.freeDeliveryOverAmount ?? 0) && (splashProvider.deliveryInfoModel?.deliveryChargeSetup?.freeDeliveryStatus ?? false) ;


              return cart.cartList.isNotEmpty ? Column(children: [

                Expanded(child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(children: [
                    Center(child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
                      child: SizedBox(width: Dimensions.webScreenWidth, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        if(ResponsiveHelper.isDesktop(context)) Expanded(flex: 3, child: Container(
                          padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: Dimensions.radiusSmall)],
                              ),
                              padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeLarge),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                /// for web Delivery time Estimation
                                const DeliveryTimeEstimationWidget(),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                /// for web car item list
                                CartListWidget(cart: cart,addOns: addOnsList, availableList: availableList),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                /// for web Add more item button
                                const AddMoreItemButtonWidget(),
                              ]),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            /// for web Frequently bought section
                            FrequentlyBoughtWidget(scrollController: _frequentlyBoughtScrollController),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                          ]),

                        )),
                        if(ResponsiveHelper.isDesktop(context))  const SizedBox(width: Dimensions.paddingSizeDefault),

                        Expanded(flex: 2, child: Container(
                          decoration:ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10)],
                          ) : const BoxDecoration(),
                          margin: ResponsiveHelper.isDesktop(context)
                              ? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge)
                              : const EdgeInsets.all(0),
                          padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall)
                              : const EdgeInsets.all(0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                if(!ResponsiveHelper.isDesktop(context)) ... [
                                  /// Delivery time Estimation
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                  const DeliveryTimeEstimationWidget(),
                                  const SizedBox(height: Dimensions.paddingSizeLarge),

                                  /// Product
                                  CartListWidget(cart: cart,addOns: addOnsList, availableList: availableList),

                                  /// for Add more item button
                                  const AddMoreItemButtonWidget(),
                                  const SizedBox(height: Dimensions.paddingSizeLarge),
                                ],
                              ]),
                            ),

                            /// for Frequently bought section
                            if(!ResponsiveHelper.isDesktop(context)) ...[
                              FrequentlyBoughtWidget(scrollController: _frequentlyBoughtScrollController),
                              const SizedBox(height: Dimensions.paddingSizeDefault),
                            ],


                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                Consumer<CouponProvider>(
                                    builder: (context, couponProvider, _) {
                                    return Container(
                                      padding: couponProvider.coupon != null ?
                                      const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault) : null,
                                      decoration: couponProvider.coupon != null ? BoxDecoration(
                                        color: context.customThemeColors.ongoingCardColor.withValues(alpha: 0.1),
                                        border: Border.all(width: 1, color: context.customThemeColors.ongoingCardColor.withValues(alpha: 0.15)),
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall)
                                      ) : null,
                                      child: Column(children: [

                                        if(couponProvider.coupon != null)...[
                                          Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                                            Icon(Icons.check_circle, color: Theme.of(context).secondaryHeaderColor, size:  Dimensions.paddingSizeDefault),
                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                            Text(
                                              '${getTranslated('applied_you_saved', context)} - ${PriceConverterHelper.convertPrice(couponDiscount)}',
                                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                            ),

                                            const Spacer(),

                                            InkWell(
                                              onTap: () {
                                                ResponsiveHelper.showDialogOrBottomSheet(context, CouponAddWidget(
                                                    couponController: _couponController, amountWithoutTax: amountAfterDiscount
                                                ));
                                              },
                                                child: Text(getTranslated('change', context)!, style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
                                            ),
                                          ]),
                                          const SizedBox(height: Dimensions.paddingSizeSmall),
                                        ],

                                        InkWell(
                                          onTap: () {
                                            ResponsiveHelper.showDialogOrBottomSheet(context, CouponAddWidget(
                                                couponController: _couponController, amountWithoutTax: amountAfterDiscount
                                            ));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
                                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                              color: Theme.of(context).cardColor,
                                              boxShadow: [BoxShadow(
                                                offset: const Offset(12, 12),
                                                blurRadius: 30,
                                                color: Theme.of(context).hintColor.withValues(alpha:0.1),
                                              )],
                                            ),
                                            child: Row(children: [
                                              const CustomAssetImageWidget(Images.couponIcon, width: Dimensions.paddingSizeLarge, height: Dimensions.paddingSizeLarge),
                                              const SizedBox(width: Dimensions.paddingSizeSmall),

                                              couponProvider.coupon != null ? Row(children: [
                                                Text('${couponProvider.coupon?.code}', style: rubikBold),
                                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                                Text(
                                                  '( -${PriceConverterHelper.getDiscountType(discount: couponProvider.coupon?.discount, discountType: couponProvider.coupon?.discountType)} )',
                                                  style: rubikRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
                                                ),
                                              ]) :
                                              Text(getTranslated('apply_promo', context)!, style: rubikSemiBold),
                                              
                                              const Spacer(),

                                              couponProvider.coupon != null ? InkWell(
                                                onTap: (){
                                                  _couponController.clear();
                                                  couponProvider.removeCouponData(true);
                                                  showCustomSnackBarHelper(getTranslated('coupon_removed_successfully', context),isError: false);
                                                },
                                                child: Icon(Icons.close, color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7)),
                                              ) :
                                              Row(children: [
                                                Text(getTranslated('add', context)!, style: rubikBold.copyWith(
                                                    color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault
                                                )),

                                                if(couponProvider.coupon == null)
                                                  Icon(Icons.add, color: Theme.of(context).primaryColor, size: Dimensions.fontSizeExtraLarge)
                                              ])
                                            ]),
                                          ),
                                        ),
                                      ]),
                                    );
                                  }
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                /// Total
                                ItemViewWidget(
                                  title: getTranslated('items_price', context)!,
                                  subTitle: PriceConverterHelper.convertPrice(itemPrice),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                ItemViewWidget(
                                  title: getTranslated('discount', context)!,
                                  subTitle: '(-) ${PriceConverterHelper.convertPrice(discount)}',
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                ItemViewWidget(
                                  title: getTranslated('addons', context)!,
                                  subTitle: '(+) ${PriceConverterHelper.convertPrice(addOns)}',
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),


                                ItemViewWidget(
                                  title: getTranslated('coupon_discount', context)!,
                                  subTitle: '(-) ${PriceConverterHelper.convertPrice(couponDiscount)}',
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                if(referralDiscount > 0)
                                  ItemViewWidget(
                                    title: getTranslated('referral_discount', context)!,
                                    subTitle: '(-) ${PriceConverterHelper.convertPrice(referralDiscount)}',
                                  ),
                                if(referralDiscount > 0)
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                ItemViewWidget(
                                  title: getTranslated('tax', context)!,
                                  subTitle: '(+) ${PriceConverterHelper.convertPrice(tax)}',
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),


                                Divider(color: Theme.of(context).hintColor.withValues(alpha:0.5)),

                                ItemViewWidget(
                                  title: getTranslated(kmWiseCharge ? 'total' : 'total_amount', context)!,
                                  subTitle: PriceConverterHelper.convertPrice(total),
                                  subTitleStyle: rubikSemiBold,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                const CutleryWidget(),

                                if(ResponsiveHelper.isDesktop(context)) const SizedBox(height: Dimensions.paddingSizeDefault),

                                if(ResponsiveHelper.isDesktop(context))
                                  CheckOutButtonWidget(orderAmount: orderAmount, totalWithoutDeliveryFee: total, isFreeDelivery: isFreeDelivery,),

                              ]),
                            ),

                          ]),
                        )),

                      ])),
                    )),

                    if(ResponsiveHelper.isDesktop(context))  const FooterWidget(),
                  ]),
                )),

               if(!ResponsiveHelper.isDesktop(context))
                 CheckOutButtonWidget(orderAmount: orderAmount, totalWithoutDeliveryFee: total, isFreeDelivery: isFreeDelivery,),

              ])
                  :  ResponsiveHelper.isDesktop(context) ? const NoDataWidget(
                isCart: true,
              ) : const Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NoDataWidget(isCart: true),
                ],
              );
            },
          );
        },
      ),
    );
  }
}





