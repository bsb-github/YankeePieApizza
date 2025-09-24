import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProfileShimmerWidget extends StatelessWidget {
  const ProfileShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.paddingSizeDefault,
        right: Dimensions.paddingSizeDefault,
        top: 50,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Shimmer(
          duration: const Duration(seconds: 2),
          enabled: profileProvider.userInfoModel == null,
          child: Container(height: 30, width: 90,
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha:0.5),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),
        ),
        const SizedBox(height: 50),

        Center(child: Shimmer(
          duration: const Duration(seconds: 2),
          enabled: profileProvider.userInfoModel == null,
          child: ClipOval(child: Container(height: 100, width: 100, color: Theme.of(context).hintColor.withValues(alpha:0.5))),
        )),
        const SizedBox(height: 50),

        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              child: Shimmer(
                duration: const Duration(seconds: 2),
                enabled: profileProvider.userInfoModel == null,
                child: Container(height: 50, width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha:0.5),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                ),
              ),
            ),
          ),
        ),

      ]),
    );
  }
}
