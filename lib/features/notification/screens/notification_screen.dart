import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_loader_widget.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/notification/providers/notification_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/notification/widgets/notification_dialog_widget.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  final bool fromSplash;
  const NotificationScreen({super.key, this.fromSplash = false});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    Provider.of<NotificationProvider>(context, listen: false).getNotificationList(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if(widget.fromSplash) {
          RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
          return;
        }

        if(didPop) return;

        if(context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(
          preferredSize: Size.fromHeight(100), child: WebAppBarWidget(),
        ) : CustomAppBarWidget(
          context: context,
          title: getTranslated('notification', context),
          onBackPressed: (){
            if(widget.fromSplash) {
              RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
            } else if(context.mounted) {
              Navigator.of(context).pop();
            }
          },
        )) as PreferredSizeWidget?,
        body: Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              List<DateTime> dateTimeList = [];
              return notificationProvider.notificationList != null ? notificationProvider.notificationList!.isNotEmpty ? RefreshIndicator(
                onRefresh: () async {
                  await notificationProvider.getNotificationList(context);
                },
                backgroundColor: Theme.of(context).primaryColor,
                color: Theme.of(context).cardColor,
                child: SingleChildScrollView(child: Column(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context) ?  Dimensions.paddingSizeLarge : 0.0),
                    child: Center(child: Container(
                      constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
                      width: width > Dimensions.webScreenWidth ? Dimensions.webScreenWidth : width,
                      padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                      child: ListView.builder(
                          itemCount: notificationProvider.notificationList?.length,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            DateTime originalDateTime = DateConverterHelper.isoStringToLocalDate(notificationProvider.notificationList![index].createdAt!);
                            DateTime convertedDate = DateTime(originalDateTime.year, originalDateTime.month, originalDateTime.day);
                            bool addTitle = false;

                            if(!dateTimeList.contains(convertedDate)) {
                              addTitle = true;
                              dateTimeList.add(convertedDate);
                            }

                            return InkWell(
                              onTap: () => ResponsiveHelper.showDialogOrBottomSheet(
                                context, NotificationDialogWidget(notificationModel: notificationProvider.notificationList![index]),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  addTitle ? Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
                                    child: Text(DateConverterHelper.isoStringToLocalDateOnly(notificationProvider.notificationList![index].createdAt!)),
                                  ) : const SizedBox(),

                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(children: [
                                      const SizedBox(height: Dimensions.paddingSizeDefault),

                                      Row(children: [
                                        SizedBox(height: 50,width: 50, child: CustomImageWidget(
                                          image: '${splashProvider.baseUrls?.notificationImageUrl}/${notificationProvider.notificationList?[index].image}',
                                          height: 60,width: 60,fit: BoxFit.cover,
                                        )),
                                        const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                                        Expanded(child: Text(
                                          notificationProvider.notificationList![index].title!,
                                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )),

                                        Text(
                                          DateConverterHelper.isoStringToLocalTimeOnly(notificationProvider.notificationList![index].createdAt!),
                                          style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                                        ),

                                      ]),
                                      const SizedBox(height: Dimensions.paddingSizeLarge),

                                      Container(height: 1, color: Theme.of(context).hintColor.withValues(alpha:0.7).withValues(alpha:.2))
                                    ]),
                                  ),
                                ],
                              ),
                            );
                          }),
                    )),
                  ),

                  if(ResponsiveHelper.isDesktop(context)) const FooterWidget(),

                ])),
              ) : const NoDataWidget() : Center(
                child: CustomLoaderWidget(color: Theme.of(context).primaryColor),
              );
            }
        ),
      ),
    );
  }
}
