import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/order_details_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
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

class ProductReviewWidget extends StatefulWidget {
  final List<OrderDetailsModel> orderDetailsList;
  const ProductReviewWidget({super.key, required this.orderDetailsList,});

  @override
  State<ProductReviewWidget> createState() => _ProductReviewWidgetState();
}

class _ProductReviewWidgetState extends State<ProductReviewWidget> {
  List<TextEditingController> textControllerList = [];

  @override
  void initState() {
    super.initState();
    final ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    reviewProvider.setRatingIndex(-1, isUpdate: false);

    reviewProvider.setProductWiseRating(0, 0, isFromInit: true, orderDetailsList: widget.orderDetailsList);


    for(int i = 0; i < widget.orderDetailsList.length; i++) {
      textControllerList.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {

    final isDesktop = ResponsiveHelper.isDesktop(context);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final Size size = MediaQuery.of(context).size;

    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        return CustomScrollView(slivers: [
          SliverToBoxAdapter(child: Center(child: Container(
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
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviewProvider.ratingList.length,
                itemBuilder: (ctx, index) {
                  return Column(children: [

                    if(isDesktop) ...[
                      Text(getTranslated('submit_a_review', context)!, style: rubikSemiBold.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                      )),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    ],

                    CustomImageWidget(
                      image:  '${splashProvider.baseUrls?.productImageUrl}/${widget.orderDetailsList[index].productDetails?.image ?? ''}',
                      width: 80, height: 80,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    /// for Rate
                    Text(
                      "${getTranslated("rate_the_food", context)!} ${widget.orderDetailsList[index].productDetails?.name}",
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
                              onTap: !reviewProvider.submitList[index] ?  () {
                                reviewProvider.setProductWiseRating(index, i, orderDetailsList: widget.orderDetailsList);
                              } : null,
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                decoration: BoxDecoration(
                                  color: reviewProvider.productWiseReview[index].rating == i
                                      ? ColorResources.getSecondaryColor(context).withValues(alpha:0.1) : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                  decoration: BoxDecoration(
                                    color: reviewProvider.productWiseReview[index].rating == i
                                        ? ColorResources.getSecondaryColor(context).withValues(alpha:0.2) : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: reviewProvider.productWiseReview[index].rating == i
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
                      controller: textControllerList[index],
                      maxLines: 3,
                      capitalization: TextCapitalization.sentences,
                      isEnabled: !reviewProvider.submitList[index],
                      hintText: getTranslated('write_your_review_here', context),
                      fillColor: Theme.of(context).cardColor,
                      isShowBorder: true,
                      borderColor: Theme.of(context).hintColor.withValues(alpha:0.5),
                      onChanged: (text) {
                        reviewProvider.setReview(index, text);
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    SizedBox(height: 70, child: CustomScrollView(scrollDirection: Axis.horizontal, slivers: [
                      SliverList.builder(
                        itemCount: reviewProvider.productWiseReview[index].image!.isNotEmpty && reviewProvider.productWiseReview[index].image!.length < 4 ?
                        reviewProvider.productWiseReview[index].image!.length + 1
                            : reviewProvider.productWiseReview[index].image!.isNotEmpty && reviewProvider.productWiseReview[index].image!.length >= 4 ? 4
                            : 1,
                        itemBuilder: (context, ind) {

                          return
                            ind == reviewProvider.productWiseReview[index].image!.length
                              && reviewProvider.productWiseReview[index].image!.length < 4
                              || reviewProvider.productWiseReview[index].image!.isEmpty
                              ? Container(width: 70, height: 70, margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall), child: InkWell(
                            onTap: () {
                              reviewProvider.pickImage(false, reviewProvider.productWiseReview[index].productId);
                            },
                            child: DottedBorder(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              radius: const Radius.circular(Dimensions.radiusSmall),
                              borderType: BorderType.RRect,
                              dashPattern: const [4, 4],
                              color: Theme.of(context).hintColor.withValues(alpha:0.7),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Icon(Icons.camera_alt_outlined, color: Theme.of(context).hintColor, size: Dimensions.paddingSizeDefault),

                                Text(getTranslated('upload_image', context)!, textAlign: TextAlign.center, style: rubikRegular.copyWith(
                                  color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall,
                                )),
                              ]),
                            ),
                          ))
                              :
                            Container(margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall), child: Stack(children: [

                            Container(width: 70, height: 70,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                                child: kIsWeb ? Image.network(
                                  reviewProvider.productWiseReview[index].image![ind].path,
                                  width: 70, height: 70, fit: BoxFit.cover,
                                ) : Image.file(
                                  File(reviewProvider.productWiseReview[index].image![ind].path),
                                  width: 70, height: 70, fit: BoxFit.cover,
                                ),
                              ) ,
                            ),

                            Positioned(top:0, right:0, child: InkWell(
                              onTap: () => reviewProvider.removeImage(ind, reviewProvider.productWiseReview[index].productId),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Icon(Icons.clear, color: Theme.of(context).primaryColor, size: Dimensions.paddingSizeDefault),
                                ),
                              ),
                            )),

                          ]));

                        },
                      ),
                    ])),

                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    /// for Submit button
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? size.width * 0.1 : Dimensions.paddingSizeExtraLarge
                      ),
                      child: CustomButtonWidget(
                        isLoading: reviewProvider.loadingList[index],
                        btnTxt: getTranslated(reviewProvider.submitList[index] ? 'submitted' : 'submit', context),
                        backgroundColor: reviewProvider.submitList[index] ? Theme.of(context).hintColor.withValues(alpha:0.7)
                            : Theme.of(context).primaryColor,
                        onTap: () {
                          if(!reviewProvider.submitList[index]) {
                            if(reviewProvider.productWiseReview[index].rating == -1) {
                              showCustomSnackBarHelper(getTranslated(getTranslated('select_rate_first', context), context));
                            } else if (reviewProvider.reviewList[index].isEmpty) {
                              showCustomSnackBarHelper(getTranslated('write_a_review', context));
                            } else {
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              ReviewBody reviewBody = ReviewBody(
                                productId: reviewProvider.productWiseReview[index].productId.toString(),
                                rating: (reviewProvider.productWiseReview[index].rating + 1).toString(),
                                comment: reviewProvider.reviewList[index],
                                orderId: widget.orderDetailsList[index].orderId.toString(),
                              );


                              reviewProvider.submitReview(index, reviewBody).then((value) {
                                if (value.isSuccess) {
                                  showCustomSnackBarHelper(value.message, isError: false);
                                  reviewProvider.setReview(index, '');
                                } else {
                                  showCustomSnackBarHelper(value.message);
                                }
                              });
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                  ]);
                },
              ),
            )),
          ))),

          if(ResponsiveHelper.isDesktop(context)) const SliverToBoxAdapter(child: FooterWidget()),
        ]);
      },
    );
  }
}