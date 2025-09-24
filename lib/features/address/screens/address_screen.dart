import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/enum/route_tyep_enum.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/address/widgets/address_card_widget.dart';
import 'package:flutter_restaurant/features/address/widgets/address_custom_painter_widget.dart';
import 'package:flutter_restaurant/features/address/widgets/address_web_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<LocationProvider>(context, listen: false).initAddressList();
    }
  }

  @override
  Widget build(BuildContext context) {

    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
     appBar: (ResponsiveHelper.isDesktop(context)
        ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
        : CustomAppBarWidget(context: context, title: getTranslated('my_address', context), centerTitle: true)) as PreferredSizeWidget?,
      floatingActionButton: _isLoggedIn && Provider.of<LocationProvider>(context, listen: false).addressList != null
         && Provider.of<LocationProvider>(context, listen: false).addressList!.isNotEmpty ? Padding(
        padding:  EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ?  Dimensions.paddingSizeLarge : 0),
        child: !ResponsiveHelper.isDesktop(context) ? FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () =>   RouterHelper.getAddAddressRoute(page: 'address', action:  'add', addressModel:  AddressModel(), routeType: RouteTypeEnum.address),
          child: const Icon(
              Icons.add, color: Colors.white),
        ) : null,
      ) : null,
      body: CustomScrollView(
        slivers: [

          _isLoggedIn ? SliverToBoxAdapter(
            child: Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<LocationProvider>(context, listen: false).initAddressList();
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  color: Theme.of(context).cardColor,

                  child: ResponsiveHelper.isDesktop(context) ? AddressWebWidget(locationProvider: locationProvider) :
                  CustomPaint(
                    size: const Size(Dimensions.webScreenWidth, 150),
                    painter: locationProvider.addressList == null || locationProvider.addressList!.isEmpty ? null : AddressCustomPrinterWidget(isDark: themeProvider.darkTheme),

                    child: locationProvider.addressList == null
                        ? _AddressShimmerWidget(isEnabled: locationProvider.addressList == null)
                        : locationProvider.addressList!.isNotEmpty
                        ? ListView.builder(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                      itemCount: locationProvider.addressList?.length ?? 0,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: index == (locationProvider.addressList?.length ?? 0) - 1 ? 50 : Dimensions.paddingSizeDefault,
                        ),
                        child: AddressCardWidget(
                          addressModel: locationProvider.addressList![index],
                          index: index,
                        ),
                      ),
                    ) : SizedBox(height: size.height * 0.7, child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NoDataWidget(isFooter: false, isAddress: true),
                      ],
                    )),
                  ),
                );
              },
            ),
          ) : const SliverToBoxAdapter(child: NotLoggedInWidget()),

          if(ResponsiveHelper.isDesktop(context)) const SliverFillRemaining(
            hasScrollBody: false,
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              SizedBox(height: Dimensions.paddingSizeLarge),

              FooterWidget(),
            ]),
          ),

        ],
      )
    );
  }
}

class _AddressShimmerWidget extends StatelessWidget {
  const _AddressShimmerWidget({required this.isEnabled});
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
          ? 0 : Dimensions.paddingSizeSmall),
      itemCount: 5,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).hintColor.withValues(alpha:0.1),
        ),
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        clipBehavior: Clip.hardEdge,
        child: Shimmer(enabled: isEnabled, child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Row(children: [

            Container(width: 20, height: 20, color: Theme.of(context).hintColor.withValues(alpha:0.2)),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(
              child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 150, height: 20, color: Theme.of(context).hintColor.withValues(alpha:0.2)),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Container(width: 200, height: 20, color: Theme.of(context).hintColor.withValues(alpha:0.2)),
                ],
              )),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Container(width: 20, height: 20, color: Theme.of(context).hintColor.withValues(alpha:0.2)),
          ]),
        )),
      ),
    );
  }
}
