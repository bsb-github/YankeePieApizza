import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/features/order/domain/models/order_model.dart';
import 'package:flutter_restaurant/features/rate_review/providers/review_provider.dart';
import 'package:flutter_restaurant/features/refer_and_earn/domain/models/review_body_model.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class DeliveryManReviewWidget extends StatefulWidget {
  final DeliveryMan? deliveryMan;
  final String orderID;
  const DeliveryManReviewWidget({super.key, required this.deliveryMan, required this.orderID});

  @override
  State<DeliveryManReviewWidget> createState() => _DeliveryManReviewWidgetState();
}

class _DeliveryManReviewWidgetState extends State<DeliveryManReviewWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    reviewProvider.setRatingIndex(-1, isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final Size size = MediaQuery.of(context).size;
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        return SingleChildScrollView(
          child: Column(children: [
          
            Center(child: Container(
              width: ResponsiveHelper.isDesktop(context) ? 650 : null,
              margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
              child: SizedBox(width: Dimensions.webScreenWidth, child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeSmall,
                ),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha:0.2), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 1))],
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                ) : null,
                child: Column(children: [
          
                  if(isDesktop) ...[
                    Text(getTranslated('submit_a_review', context)!, style: rubikSemiBold.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                    )),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                  ],
          
                  CustomImageWidget(image: '${splashProvider.baseUrls?.deliveryManImageUrl}/${widget.deliveryMan?.image}' , width: 80, height: 80),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
          
                  /// for Rate
                  Text(
                    getTranslated('rate_his_service', context)!,
                    style: rubikSemiBold.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
          
                  SizedBox(height: 70, child: ListView.builder(
                    itemCount: reviewProvider.rateList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          InkWell(
                            onTap: reviewProvider.isReviewSubmitted ? null : () {
                              reviewProvider.setRatingIndex(i);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: reviewProvider.rateIndex == i
                                    ? ColorResources.getSecondaryColor(context).withValues(alpha:0.1) : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                decoration: BoxDecoration(
                                  color: reviewProvider.rateIndex == i
                                      ? ColorResources.getSecondaryColor(context).withValues(alpha:0.2) : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: reviewProvider.rateIndex == i
                                        ? ColorResources.getSecondaryColor(context) : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    i == 0 ? Icons.sentiment_very_dissatisfied_rounded
                                        : i == 1 ? Icons.sentiment_dissatisfied_rounded
                                        : i == 2 ? Icons.sentiment_neutral_rounded
                                        : i == 3 ? Icons.sentiment_satisfied_rounded
                                        : Icons.sentiment_very_satisfied_rounded,
                                    size: Dimensions.paddingSizeLarge,
                                    color: Theme.of(context).textTheme.bodyLarge!.color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
          
                          Text(
                            '${getTranslated(i == 0 ? 'bad' : i == 1 ? 'okay' : i == 2 ? 'average' : i == 3 ? 'good' : 'excellent', context)!} !',
                            style: rubikRegular.copyWith(color: reviewProvider.rateIndex == i ? Theme.of(context).primaryColor : Colors.transparent),
                          ),
                        ]),
                      );
                    },
                  )),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
          
                  /// for opinion box
                  Text(
                    getTranslated('share_your_opinion', context)!,
                    style: rubikSemiBold.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
          
                  CustomTextFieldWidget(
                    capitalization: TextCapitalization.sentences,
                    hintText: getTranslated('write_your_review_here', context),
                    fillColor: Theme.of(context).cardColor,
                    isShowBorder: true,
                    borderColor: Theme.of(context).hintColor.withValues(alpha:0.5),
                    maxLines: 5,
                    controller: _controller,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
          
                  /// for Submit button
                  Column(children: [
                    !reviewProvider.isLoading ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: isDesktop ? size.width * 0.1 : Dimensions.paddingSizeExtraLarge),
                      child: CustomButtonWidget(
                        btnTxt: getTranslated(reviewProvider.isReviewSubmitted ? 'submitted' : 'submit', context),
                        onTap: reviewProvider.isReviewSubmitted ? null : () {
                          if (reviewProvider.rateIndex == -1) {
                            showCustomSnackBarHelper('Give a rating');
                          } else if (_controller.text.isEmpty) {
                            showCustomSnackBarHelper('Write a review');
                          } else {
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            ReviewBody reviewBody = ReviewBody(
                              deliveryManId: widget.deliveryMan!.id.toString(),
                              rating: '${reviewProvider.rateIndex + 1}',
                              comment: _controller.text,
                              orderId: widget.orderID,
                            );
                            reviewProvider.submitDeliveryManReview(reviewBody).then((value) {
                              if (value.isSuccess) {
                                showCustomSnackBarHelper(value.message, isError: false);
                                _controller.text = '';
                              } else {
                                showCustomSnackBarHelper(value.message);
                              }
                            });
                          }
                        },
                      ),
                    ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                  ]),
          
                ]),
              )),
            )),
          
            if(ResponsiveHelper.isDesktop(context)) const Padding(
              padding: EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              child: FooterWidget(),
            ),
          
          ]),
        );
      },
    );
  }
}


// class DeliveryManReviewWidget extends StatefulWidget {
//   final DeliveryMan? deliveryMan;
//   final String orderID;
//   const DeliveryManReviewWidget({Key? key, required this.deliveryMan, required this.orderID}) : super(key: key);
//
//   @override
//   State<DeliveryManReviewWidget> createState() => _DeliveryManReviewWidgetState();
// }
//
// class _DeliveryManReviewWidgetState extends State<DeliveryManReviewWidget> {
//   final TextEditingController _controller = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Consumer<ReviewProvider>(
//       builder: (context, reviewProvider, child) {
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               Center(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
//                   child: SizedBox(
//                     width: 1170,
//                     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//
//                       widget.deliveryMan != null ? DeliveryManWidget(deliveryMan: widget.deliveryMan) : const SizedBox(),
//                       const SizedBox(height: Dimensions.paddingSizeLarge),
//
//                       Container(
//                         padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).cardColor,
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: [BoxShadow(
//                             color: Theme.of(context).shadowColor,
//                             blurRadius: 5, spreadRadius: 1,
//                           )],
//                         ),
//                         child: Column(children: [
//                           Text(
//                             getTranslated('rate_his_service', context)!,
//                             style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: Dimensions.paddingSizeSmall),
//
//                           SizedBox(
//                             height: 30,
//                             child: ListView.builder(
//                               itemCount: 5,
//                               shrinkWrap: true,
//                               scrollDirection: Axis.horizontal,
//                               itemBuilder: (context, i) {
//                                 return InkWell(
//                                   child: Icon(
//                                     reviewProvider.deliveryManRating < (i + 1) ? Icons.star_border : Icons.star,
//                                     size: 25,
//                                     color: reviewProvider.deliveryManRating < (i + 1)
//                                         ? Theme.of(context).hintColor.withValues(alpha:0.7)
//                                         : Theme.of(context).primaryColor,
//                                   ),
//                                   onTap: () {
//                                     if(!reviewProvider.isReviewSubmitted) {
//                                       reviewProvider.setDeliveryManRating(i + 1);
//                                     }
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                           const SizedBox(height: Dimensions.paddingSizeLarge),
//
//                           Text(
//                             getTranslated('share_your_opinion', context)!,
//                             style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: Dimensions.paddingSizeLarge),
//                           CustomTextFieldWidget(
//                             maxLines: 5,
//                             capitalization: TextCapitalization.sentences,
//                             controller: _controller,
//                             hintText: getTranslated('write_your_review_here', context),
//                             fillColor: ColorResources.getSearchBg(context),
//                           ),
//                           const SizedBox(height: 40),
//
//                           // Submit button
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
//                             child: Column(
//                               children: [
//                                 !reviewProvider.isLoading ? CustomButtonWidget(
//                                   btnTxt: getTranslated(reviewProvider.isReviewSubmitted ? 'submitted' : 'submit', context),
//                                   onTap: reviewProvider.isReviewSubmitted ? null : () {
//                                     if (reviewProvider.deliveryManRating == 0) {
//                                       showCustomSnackBarHelper('Give a rating');
//                                     } else if (_controller.text.isEmpty) {
//                                       showCustomSnackBarHelper('Write a review');
//                                     } else {
//                                       FocusScopeNode currentFocus = FocusScope.of(context);
//                                       if (!currentFocus.hasPrimaryFocus) {
//                                         currentFocus.unfocus();
//                                       }
//                                       ReviewBody reviewBody = ReviewBody(
//                                         deliveryManId: widget.deliveryMan!.id.toString(),
//                                         rating: reviewProvider.deliveryManRating.toString(),
//                                         comment: _controller.text,
//                                         orderId: widget.orderID,
//                                       );
//                                       reviewProvider.submitDeliveryManReview(reviewBody).then((value) {
//                                         if (value.isSuccess) {
//                                           showCustomSnackBarHelper(value.message, isError: false);
//                                           _controller.text = '';
//                                         } else {
//                                           showCustomSnackBarHelper(value.message);
//                                         }
//                                       });
//                                     }
//                                   },
//                                 ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
//                               ],
//                             ),
//                           ),
//                         ]),
//                       ),
//
//                     ]),
//                   ),
//                 ),
//               ),
//
//               if(ResponsiveHelper.isDesktop(context)) const Padding(
//                 padding: EdgeInsets.only(top: Dimensions.paddingSizeDefault),
//                 child: FooterWidget(),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
