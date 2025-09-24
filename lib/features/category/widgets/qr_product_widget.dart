
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/cart_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/features/category/widgets/price_stack_tag_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/cart_bottom_sheet_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



class QrProductWidget extends StatefulWidget {
  final Product product;

  const QrProductWidget({super.key, required this.product,});

  @override
  State<QrProductWidget> createState() => _QrProductWidgetState();
}

class _QrProductWidgetState extends State<QrProductWidget> {

  void _addToCart(int cartIndex) {
    ResponsiveHelper.isMobile() ? showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (con) => CartBottomSheetWidget(
        product: widget.product,
        callback: (CartModel cartModel) {
          showCustomSnackBarHelper(getTranslated('added_to_cart', context), isError: false);
        },
      ),
    ) : showDialog(context: context, builder: (con) => Dialog(
      backgroundColor: Colors.transparent,
      child: CartBottomSheetWidget(
        product: widget.product,
        fromSetMenu: false,
        callback: (CartModel cartModel) {
          showCustomSnackBarHelper(getTranslated('added_to_cart', context), isError: false);
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Consumer<ProductProvider>(builder: (ctx, productProvider, _) {

      DateTime currentTime = Provider.of<SplashProvider>(context, listen: false).currentTime;
      DateTime start = DateFormat('hh:mm:ss').parse(widget.product.availableTimeStarts!);
      DateTime end = DateFormat('hh:mm:ss').parse(widget.product.availableTimeEnds!);
      DateTime startTime =
      DateTime(currentTime.year, currentTime.month, currentTime.day, start.hour, start.minute, start.second);
      DateTime endTime = DateTime(currentTime.year, currentTime.month, currentTime.day, end.hour, end.minute, end.second);
      if (endTime.isBefore(startTime)) {
        endTime = endTime.add(const Duration(days: 1));
      }
      bool isAvailable = currentTime.isAfter(startTime) && currentTime.isBefore(endTime);


      double productPrice = widget.product.price ?? 0;
      if(widget.product.branchProduct != null) {
        productPrice = widget.product.branchProduct?.price ?? 0;
      }



      return InkWell(
        onTap:() => _addToCart(cartProvider.getCartIndex(widget.product)),
        child: Stack(
          children: [

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    offset: const Offset(0, 3.75), blurRadius: 9.29,
                  )
                ],
              ),
              child: Column(
                  children: [

                    const SizedBox(height: 3),

                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          child: Text(widget.product.name ?? '', style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault ,
                            color: Theme.of(context).textTheme.titleLarge!.color,
                          ),
                              maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),

                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Stack(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                  child: CustomImageWidget(
                                    height: double.infinity, width: double.infinity,
                                    image: '${Provider.of<SplashProvider>(context, listen: false).configModel?.baseUrls?.productImageUrl}/${widget.product.image}',
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                PriceStackTagWidget(value: PriceConverterHelper.convertPrice(double.parse('$productPrice')),)
                              ],
                            ),


                          ],
                        ),
                      ),
                    ),



                  ]),
            ),

            if(!isAvailable)  Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all( Radius.circular(5),
                ),
                color: Colors.black.withValues(alpha:0.7),
                // color:Theme.of(context).textTheme.bodyText1?.color?.withValues(alpha:0.7),
                boxShadow: [BoxShadow(
                  // color: Theme.of(context).textTheme.bodyText1!.color!.withValues(alpha:0.1),
                  color: Colors.black.withValues(alpha:0.1),
                  blurRadius: 9.23,
                  offset: const Offset(0,3.71),
                )],
              ),
              child: Center(child: Text(
                getTranslated('not_available', context)!.replaceAll(' ', '\n'), style: rubikBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.white,),
                textAlign: TextAlign.center,
              )),
            ),
          ],
        ),
      );

    });
  }
}



