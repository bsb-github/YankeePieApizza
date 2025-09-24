import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/models/review_model.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_zoom_widget.dart';
import 'package:flutter_restaurant/common/widgets/paginated_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/rating_bar.dart';
import 'package:flutter_restaurant/common/widgets/rating_bar_widget.dart';
import 'package:flutter_restaurant/features/home/enums/trim_mode_enum.dart';
import 'package:flutter_restaurant/features/home/widgets/read_more_text.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProductReviewWidget extends StatefulWidget {
  final Product? product;
  const ProductReviewWidget({super.key, this.product});

  @override
  State<ProductReviewWidget> createState() => _ProductReviewWidgetState();
}

class _ProductReviewWidgetState extends State<ProductReviewWidget> {

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).getReviewData(id : widget.product!.id!, offset: 1);
  }


  @override
  Widget build(BuildContext context) {

    final ScrollController scrollController = ScrollController();

    return SafeArea(
      child: Consumer<ProductProvider>(builder: (ctx, productProvider, _){

        return Column(
          children: [

            const SizedBox(height: Dimensions.paddingSizeDefault ),

            !ResponsiveHelper.isDesktop(context) ? Padding(
              padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeLarge, right:  Dimensions.paddingSizeLarge,
              ),
              child: Row( spacing: 20,mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column( crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Text("${widget.product?.name}", style: rubikBold.copyWith(fontSize: Dimensions.paddingSizeDefault),),
                  const SizedBox(height: 1,),
                  Text("${widget.product?.reviewCount} ${getTranslated("reviews", context)}", style: rubikRegular,),
                ]),
                InkWell(onTap: () => context.pop(),
                  child: const Icon(Icons.close, size: 20),
                )
              ]),
            ) : const SizedBox(),

            const SizedBox(height: Dimensions.paddingSizeDefault),


            Flexible(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  child: Column( mainAxisSize:  MainAxisSize.min, children: [

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
                      ),
                      padding: const EdgeInsets.symmetric( vertical: Dimensions.paddingSizeDefault),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(width: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge * 3 : Dimensions.paddingSizeLarge,),
                            Center(
                              child: Column(spacing: 3,mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                RatingBarWidget(
                                  size: 18, fontSize: 20,
                                  rating: widget.product!.rating!.isNotEmpty ? widget.product!.rating![0].average! : 0.0
                                ),

                                Text("${widget.product?.reviewCount} ${getTranslated("reviews", context)}"),
                              ]),
                            ),

                            SizedBox(width:  ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraLarge * 3 : Dimensions.paddingSizeExtraLarge,),

                            Expanded(child: Padding(
                              padding:  EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : 0),
                              child: ReviewLinearChart(
                                rating: productProvider.reviewModel?.rating ?? Rating(ratingCount: 0,averageRating: 0,ratingGroupCount: []),
                              ),
                            )),

                            if(ResponsiveHelper.isDesktop(context)) const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                            if(ResponsiveHelper.isDesktop(context)) InkWell(
                              onTap: () => productProvider.updateProductReviewShowStatus(value: false),
                              child: Row(children: [
                                Icon(Icons.arrow_back, size: 17, color: Theme.of(context).primaryColor),
                               Text("  ${getTranslated("back_to_details", context)}", style: rubikRegular.copyWith(decoration: TextDecoration.underline, fontSize: Dimensions.fontSizeSmall),),
                              ]),
                            ),

                            const SizedBox(width: Dimensions.paddingSizeDefault,),

                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault,),

                    productProvider.reviewModel == null ? const ProductReviewShimmer() :
                    productProvider.reviewModel != null && productProvider.reviewModel?.reviews !=null && productProvider.reviewModel!.reviews!.reviewList!.isNotEmpty?
                    PaginatedListWidget(
                      scrollController:  scrollController,
                      onPaginate: (int? offset) async {
                        await productProvider.getReviewData(id: widget.product!.id!, offset: offset);
                      },
                      totalSize: productProvider.reviewModel?.reviews?.totalSize,
                      offset: productProvider.reviewModel?.reviews?.offset,
                      limit: productProvider.reviewModel?.reviews?.limit,
                      builder: (loaderWidget) {
                        return Column(
                          children: [
                            ListView.separated(itemBuilder: (ctx, index){
                              return  ReviewItemWidget(review: productProvider.reviewModel?.reviews?.reviewList?[index]);
                            },
                              itemCount:  productProvider.reviewModel!.reviews!.reviewList!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (ctx, index){
                              return Column(children: [
                                Divider(height: 0.4, thickness: 0.4, color: Theme.of(context).disabledColor.withValues(alpha: 0.6)),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                              ]);
                              },
                            ),


                            loaderWidget
                          ],
                        );
                      },
                    ) : const SizedBox(),


                  ]),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}


class ReviewItemWidget extends StatelessWidget {
  final Review? review;
  const ReviewItemWidget({super.key, this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
       Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column( spacing: 2, crossAxisAlignment: CrossAxisAlignment.start, children: [
          review?.user != null ?Text( "${review?.user?.fName ?? ''} ${review?.user?.lName ?? ''} ",
            style:  rubikBold.copyWith(fontSize: Dimensions.fontSizeDefault),
          ) : Text( "${getTranslated("customer_not_available", context)}",
            style: rubikMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.9),
            ),
          ),

          Text(DateConverterHelper.estimatedDate(DateTime.parse(review!.createdAt!)), style:  rubikRegular.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
            fontSize: Dimensions.fontSizeSmall,
          )),
        ]),
         RatingBar(rating: review?.rating?.toDouble(), color: ColorResources.getSecondaryColor(context)),
       ]),

        Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeDefault),
          child: ReadMoreText( review?.comment?.toCapitalized() ?? "" ,
            trimCollapsedText : "${getTranslated("see_more", context)}",
            trimExpandedText: "  ${"${getTranslated("see_less", context)}"}",
            trimMode: TrimMode.line,
            trimLines: 3,
            style: rubikRegular.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: Dimensions.fontSizeDefault,
                height: 1.5
            ),
            textAlign: TextAlign.justify,
            moreStyle: rubikMedium.copyWith(color: Theme.of(context).indicatorColor),
            lessStyle: rubikMedium.copyWith(color: Theme.of(context).indicatorColor),
          ),
        ),
        review!.attachment != null && review!.attachment!.isNotEmpty ?
        SizedBox( height: 100,
          child: ListView.separated(itemBuilder: (ctx, index){
            String image = "${Provider.of<SplashProvider>(context).configModel?.baseUrls?.reviewImageUrl}/${review!.attachment?[index]}";
            return InkWell(
              onTap: ResponsiveHelper.isDesktop(context) ? null : ()=>   RouterHelper.getProductImageScreen(
                title : getTranslated("review_image", context) ??"",
                image: image,
              ),
              child: CustomZoomWidget(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
                  child: CustomImageWidget(
                    placeholder: Images.placeholderRectangle,
                    fit: BoxFit.cover, height: 90, width: 90,
                    image: image,
                  ),
                ),
              ),
            );
          }, itemCount: review!.attachment!.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: Dimensions.paddingSizeSmall,);
            },
          ),

        ) : const SizedBox()

      ]),
    );
  }
}

class ProductReviewShimmer extends StatelessWidget {
  const ProductReviewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(vertical: 10),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          width: Dimensions.webScreenWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,

            borderRadius: BorderRadius.circular(10),
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: false,
            child:  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Column(spacing: Dimensions.paddingSizeExtraSmall, crossAxisAlignment: CrossAxisAlignment.start, children: [

                Container(height: 15, width: 100, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),


                Container(height: 15, width: 80, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),


                const SizedBox(),

                Container(height: 10, width: 200, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),


                Container(height: 10, width: 150, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
              ]),

              Divider(color: Theme.of(context).hintColor.withValues(alpha:0.2), thickness: 0.5),

            ]),
          ),
        );
      },
    );
  }
}






class ReviewLinearChart extends StatelessWidget {
  final Rating rating;
  const ReviewLinearChart({super.key,required this.rating});

  @override
  Widget build(BuildContext context) {

    double fiveStar = 0.0, fourStar = 0.0, threeStar = 0.0,twoStar = 0.0, oneStar = 0.0;

    for(int i =0 ; i< rating.ratingGroupCount!.length; i++){
      if(rating.ratingGroupCount![i].reviewRating == 1){
        oneStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
      }
      if(rating.ratingGroupCount![i].reviewRating == 2){
        twoStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
      }
      if(rating.ratingGroupCount![i].reviewRating == 3){
        threeStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
      }
      if(rating.ratingGroupCount![i].reviewRating == 4){
        fourStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
      }
      if(rating.ratingGroupCount![i].reviewRating == 5){
        fiveStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
      }
    }

    return Column(children: [
      _progressBar(
        percent: fiveStar,
        total: 5,
      ),
      _progressBar(
        percent: fourStar,
        total: 4,
      ),
      _progressBar(
        percent: threeStar,
        total: 3,
      ),
      _progressBar(
        percent: twoStar,
        total: 2,
      ),
      _progressBar(
          percent: oneStar,
          total: 1
      ),
    ]);
  }

  Widget _progressBar({required double percent, required int total}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 25, height: 15,
            child: FittedBox(child: Text("$total", style: rubikMedium)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              minHeight: 7,
              value: percent,
              borderRadius: BorderRadius.circular(2),
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(Get.context!).primaryColor.withValues(alpha: 0.9)),
              backgroundColor: const Color(0xFFEAEAEA),
            ),
          ),
        ],
      ),
    );
  }
}


