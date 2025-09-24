import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OrderDetailsShimmerWidget extends StatelessWidget {
  const OrderDetailsShimmerWidget({super.key, required this.enabled});
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);
    final double height = MediaQuery.sizeOf(context).height;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(children: [

        ConstrainedBox(
          constraints: BoxConstraints(minHeight: !isDesktop && height < 600 ? height : height - 400, maxWidth: Dimensions.webScreenWidth),
          child: SizedBox(width: Dimensions.webScreenWidth, child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 3, child: Shimmer(
                enabled: enabled,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if(isDesktop) ...[
                    Container(
                      height: 200, width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        // boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: Dimensions.radiusSmall, spreadRadius: 1)],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                      margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Center(child: Container(color: Theme.of(context).hintColor.withValues(alpha:0.3), width: 80, height: 80)),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Row(children: [
                          const Expanded(child: SizedBox()),

                          Expanded(flex: 7, child: Column(children: [
                            Container(
                              width: 200, height: 20,
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha:0.5),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Container(
                              width: 150, height: 20,
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha:0.5),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),
                          ])),

                          Container(
                            width: 40, height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withValues(alpha:0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                            ),
                          ),
                        ]),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    ListView.builder(
                      itemCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          width: 180, height: 20,
                          // margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withValues(alpha:0.2),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        Container(
                          height: 100,
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withValues(alpha:0.2),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                          ),
                          child: Row(children: [
                            Container(
                              width: 80, height: 80,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha:0.5),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),

                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Container(
                                width: 100, height: 20,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Container(
                                width: 80, height: 20,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                ),
                              ),
                            ])),

                            Container(
                              width: 40, height: 20,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),

                            Container(
                              width: 60, height: 20,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Container(
                          height: 100,
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withValues(alpha:0.2),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                          ),
                          child: Row(children: [
                            Container(
                              width: 80, height: 80,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha:0.5),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),

                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Container(
                                width: 100, height: 20,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Container(
                                width: 80, height: 20,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                ),
                              ),
                            ])),

                            Container(
                              width: 40, height: 20,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),

                            Container(
                              width: 60, height: 20,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ]),
                    ),
                  ],

                  if(!isDesktop) ...[
                    Container(
                      height: 160,
                      color: Theme.of(context).hintColor.withValues(alpha:0.2),
                      child: Center(child: Container(color: Theme.of(context).hintColor.withValues(alpha:0.4), width: 80, height: 80)),
                    ),

                    Container(
                      width: double.maxFinite,
                      transform: Matrix4.translationValues(0, -25, 0),
                      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withValues(alpha:0.2),
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                        boxShadow: [BoxShadow(
                          color: Theme.of(context).shadowColor.withValues(alpha:0.5),
                          blurRadius: Dimensions.radiusDefault, spreadRadius: 1,
                          offset: const Offset(2, 2),
                        )],
                      ),
                      child: Row(children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            width: 200,
                            height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withValues(alpha:0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Container(
                            width: 150,
                            height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withValues(alpha:0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                            ),
                          ),
                        ])),

                        Container(
                          width: 40, height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withValues(alpha:0.5),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                          ),
                        ),
                      ]),
                    ),

                    ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          width: 180, height: 20,
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withValues(alpha:0.2),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withValues(alpha:0.2),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                          ),
                          child: Row(children: [
                            Container(
                              width: 80, height: 80,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha:0.5),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),

                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Container(
                                width: 100, height: 20,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Container(
                                width: 80, height: 20,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                ),
                              ),
                            ])),

                            Container(
                              width: 40, height: 20,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),

                            Container(
                              width: 60, height: 20,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withValues(alpha:0.2),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                          ),
                          child: Row(children: [
                            Container(
                              width: 80, height: 80,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha:0.5),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),

                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Container(
                                width: 100, height: 20,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Container(
                                width: 80, height: 20,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                ),
                              ),
                            ])),

                            Container(
                              width: 40, height: 20,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),

                            Container(
                              width: 60, height: 20,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha:0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      ]),
                    ),
                  ],
                ]),
              )),

              if(isDesktop) ...[
                const SizedBox(width: Dimensions.paddingSizeLarge),
                Expanded(flex: 2, child: Shimmer(enabled: enabled, child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                  child: Column(children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) => SizedBox(
                        height: 40,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Container(
                            width: 200, height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withValues(alpha:0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                            ),
                          ),

                          Container(
                            width: 80, height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withValues(alpha:0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                            ),
                          ),
                        ]),
                      ),
                    ),

                    Center(child: Container(
                      height: 40, width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withValues(alpha:0.3),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      margin: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                    )),
                  ]),
                ))),
              ],
            ],
          )),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        if(isDesktop) const FooterWidget(),
      ]),
    );
  }
}