import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_slider_list_widget.dart';
import 'package:flutter_restaurant/features/branch/widgets/branch_shimmer_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/common/widgets/title_widget.dart';
import 'package:flutter_restaurant/features/branch/widgets/branch_item_widget.dart';
import 'package:provider/provider.dart';

class BranchListWidget extends StatefulWidget {
  final bool? isItemChange;
  final ScrollController controller;

  const BranchListWidget({
    super.key, required this.controller, this.isItemChange = false,
  });

  @override
  State<BranchListWidget> createState() => _BranchListWidgetState();
}

class _BranchListWidgetState extends State<BranchListWidget> {

  @override
  void initState() {
    final BranchProvider branchProvider = Provider.of<BranchProvider>(context, listen: false);

    if(branchProvider.branchValueList == null){
      branchProvider.getBranchValueList(context);

    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min,children: [

      Consumer<BranchProvider>(builder: (context, branchProvider, _){
        return branchProvider.branchValueList == null ? const BranchShimmerWidget(isEnabled: true) : Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeSmall),
              child: TitleWidget(
                title: getTranslated('find_food_form_our_branches', context),
                subTitle: getTranslated('discover_all', context),
                onTap: ()=> RouterHelper.getBranchListScreen(),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            ResponsiveHelper.isDesktop(context) ? SizedBox(height: 200, child: CustomSliderListWidget(
              controller: widget.controller,
              verticalPosition: 80,
              horizontalPosition: 5,
              isShowForwardButton: ResponsiveHelper.isDesktop(context),
              child: ListView.builder(
                controller: widget.controller,
                itemCount: branchProvider.branchValueList?.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                  child: BranchItemWidget(
                    branchesValue: branchProvider.branchValueList![index],
                    isItemChange: widget.isItemChange ?? false,
                  ),
                ),
              ),
            )) : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              shrinkWrap: true,
              itemCount: (branchProvider.branchValueList?.length ?? 0) > 4 ? 4 : branchProvider.branchValueList?.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => BranchItemWidget(branchesValue: branchProvider.branchValueList?[index], isItemChange: widget.isItemChange ?? false,),
            ),
          ],
        );
      }),
      // const SizedBox(height: Dimensions.paddingSizeLarge),

    ]);
  }
}
