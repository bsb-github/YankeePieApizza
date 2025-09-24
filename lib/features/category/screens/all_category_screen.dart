import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/on_hover_widget.dart';
import 'package:flutter_restaurant/common/widgets/paginated_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/category/domain/category_model.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/home/widgets/category_pop_up_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/debounce_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AllCategoryScreen extends StatefulWidget {

  const AllCategoryScreen({super.key});

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> with TickerProviderStateMixin {

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _searchBarKey = GlobalKey();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _appbarSearchFocusNode = FocusNode();

  final DebounceHelper debounce = DebounceHelper(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryProvider>(Get.context!, listen: false).getCategoryList(false);
    Provider.of<CategoryProvider>(Get.context!, listen: false).searchController.clear();
    Provider.of<CategoryProvider>(Get.context!, listen: false).getSearchText("", isUpdate: false);
  }




  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showSearchDialog({required CategoryProvider categoryProvider}) async {
    RenderBox renderBox = _searchBarKey.currentContext!.findRenderObject() as RenderBox;
    final searchBarPosition = renderBox.localToGlobal(Offset.zero);

    double topPadding = MediaQuery.of(context).padding.top;
    double leftPadding = MediaQuery.of(context).padding.left;

    final isDesktop = ResponsiveHelper.isDesktop(context);


    Future.delayed(const Duration(milliseconds: 200)).then((_){
      _searchFocusNode.requestFocus();
    });

   if( categoryProvider.suggestionList !=null && categoryProvider.suggestionList!.isNotEmpty){

     await showDialog(
       context: context,
       barrierColor: Colors.transparent,
       builder: (context) => Stack(children: [
         Positioned(
           top: searchBarPosition.dy - topPadding,
           left: searchBarPosition.dx - leftPadding,
           width: renderBox.size.width ,
           child: Material(
             color: Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Theme.of(context).cardColor : null,
             elevation: 0,
             borderRadius: BorderRadius.circular(30),
             child: Consumer<CategoryProvider>(builder: (context, categoryProvider,_) => Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 SizedBox(
                   width:!isDesktop ? null :  410, height: 50,
                   child: CustomTextFieldWidget(
                     radius: isDesktop ? 50 : Dimensions.radiusSeven,
                     hintText: getTranslated('search_category', context),
                     isShowBorder: true,
                     fillColor: Theme.of(context).cardColor,
                     isShowPrefixIcon:  isDesktop  && categoryProvider.searchLength == 0,
                     prefixIconUrl: Images.search,
                     prefixIconColor: Theme.of(context).hintColor,
                     suffixIconColor: Theme.of(context).hintColor,
                     onChanged: (str){
                       categoryProvider.getSearchText(str);
                       debounce.run(() {
                         if(str.isNotEmpty) {
                           categoryProvider.getSuggestionCategoryList();
                         }
                       });

                     },
                     focusNode: _searchFocusNode,
                     controller: categoryProvider.searchController,
                     inputAction: TextInputAction.search,
                     isIcon: true,
                     isShowSuffixIcon: categoryProvider.searchLength > 0,
                     suffixIconUrl: Images.cancelSvg,
                     onSuffixTap: (){
                       categoryProvider.searchController.clear();
                       categoryProvider.getSearchText('');
                       context.pop();
                     },

                     onSubmit: (text) async {
                       if (categoryProvider.searchController.text.isNotEmpty) {
                         await categoryProvider.getSearchCategoryList(offset: 1, query: text);
                         categoryProvider.searchDone();
                         Get.context!.pop();
                         FocusScope.of( Get.context!).unfocus();
                       }
                     },
                   ),
                 ),
                 // Recent Searches and Recommendations
                 const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                 categoryProvider.suggestionList != null && categoryProvider.suggestionList!.isNotEmpty ? Container(
                   width: !isDesktop ? null : 400,
                   decoration: BoxDecoration(
                     color: Theme.of(context).cardColor,
                     boxShadow: [BoxShadow(
                       color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.1),
                       offset: const Offset(0, 5),
                       spreadRadius: 0,
                       blurRadius: 15,
                     )],
                     borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                   ),
                   padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                   child:
                   _CategorySearchSuggestionWidget(queryText: categoryProvider.searchController.text,) ,
                 ) : const SizedBox(),
               ],
             )
             ),
           ),
         ),
       ]),
     );

   }

  }

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.sizeOf(context);
    final double realSpaceNeeded = (size.width - Dimensions.webScreenWidth) / 2;
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Consumer<CategoryProvider>(builder: (ctx,categoryProvider, _){
      return Scaffold(
        appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(
          preferredSize: Size.fromHeight(100), child: WebAppBarWidget(),
        ) : CustomAppBarWidget(
            context: context,
            title: "${getTranslated('dish_discoveries', context)}",
          additionalTitle: categoryProvider.searchCategoryModel != null ? "  (${categoryProvider.searchCategoryModel?.totalSize} ${getTranslated('result_found', context)})  " : null,
        )) as PreferredSizeWidget?,
        body: Consumer<CategoryProvider>(
          builder: (context, category, child) {
            return PaginatedListWidget(
              scrollController: _scrollController,
              onPaginate: (int? offset) async {
                if(category.searchCategoryList != null){
                  await category.getSearchCategoryList(offset: offset ?? 1);
                }else{
                  await category.getCategoryList(false, offset: offset ?? 1);
                }
              },
              totalSize: category.searchCategoryModel?.totalSize ??  category.categoryModel?.totalSize,
              offset: category.searchCategoryModel?.offset ?? category.categoryModel?.offset,
              limit: category.searchCategoryModel?.limit ?? category.categoryModel?.limit,
              isDisableWebLoader: !ResponsiveHelper.isDesktop(context),
              builder:(Widget loaderWidget)=> Expanded(child: CustomScrollView(
                controller: _scrollController,
                slivers: [

                  SliverAppBar(
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Theme.of(context).cardColor,
                    toolbarHeight: 80 + MediaQuery.of(context).padding.top,
                    pinned: true,
                    floating: false,
                    leading:  const SizedBox() ,
                    leadingWidth: 0,
                    title: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? realSpaceNeeded : 0,
                        vertical: Dimensions.paddingSizeSmall,
                      ),
                      child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                        isDesktop ? Row(
                          children: [
                            Text(getTranslated("dish_discoveries", context) ?? "", style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                            if(categoryProvider.searchCategoryModel != null) Text("  (${categoryProvider.searchCategoryModel?.totalSize} ${getTranslated('result_found', context)})  ",
                              style: rubikSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.5),
                              ),
                            )
                          ],
                        ) : const SizedBox(),

                        Flexible(
                          child: SizedBox(
                            key: _searchBarKey,
                            width: !isDesktop ? null : 400, height: 50,
                            child: Consumer<CategoryProvider>(builder: (context,categoryController,_)=> CustomTextFieldWidget(
                              onTap: () {
                                _showSearchDialog(categoryProvider: categoryController);
                              },
                              focusNode: _appbarSearchFocusNode,
                              radius: isDesktop ? 50 : Dimensions.radiusSeven,
                              hintText: getTranslated('search_category', context),
                              isShowBorder: true,
                              fillColor: Theme.of(context).cardColor,
                              isShowPrefixIcon: isDesktop && categoryController.searchLength == 0,
                              prefixIconUrl: Images.search,
                              prefixIconColor: Theme.of(context).hintColor,
                              suffixIconColor: Theme.of(context).hintColor,
                              onChanged: (str){
                                categoryController.getSearchText(str);
                                debounce.run(() async {
                                  if(str.isNotEmpty) {
                                    await  categoryController.getSuggestionCategoryList();
                                    _showSearchDialog(categoryProvider: categoryController);
                                  }
                                });
                              },

                              controller: categoryController.searchController,
                              inputAction: TextInputAction.search,
                              isIcon: true,
                              isShowSuffixIcon: categoryController.searchLength > 0,
                              suffixIconUrl: Images.cancelSvg,
                              onSuffixTap: (){
                                categoryController.searchController.clear();
                                categoryController.getSearchText('');
                              },

                              onSubmit: (text)  {
                                if (categoryController.searchController.text.isNotEmpty) {
                                  categoryController.getSearchCategoryList( query: text);
                                  context.pop();

                                }
                              },
                            )),
                          ),
                        ),
                      ]),
                    ),

                  ),


                  SliverPadding(
                    padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.symmetric(
                      horizontal: realSpaceNeeded,
                      vertical: Dimensions.paddingSizeSmall,
                    ) : const EdgeInsets.symmetric(
                      horizontal :Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall,
                    ),
                    sliver: category.searchCategoryList !=null && category.searchCategoryList!.isEmpty ? const _NoDataWidget() :
                    category.isLoading || category.categoryList != null  ? SliverGrid.builder(
                      itemCount:  category.searchCategoryList?.length ?? category.categoryList?.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isDesktop ? 6 : ResponsiveHelper.isTab(context) ? 5 : 3,
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) {
                        return _CategoryItemWidget(index: index, category: category.searchCategoryList?[index] ?? category.categoryList![index]);
                      },
                    ) : const CategoryShimmer(),
                  ),


                  if(ResponsiveHelper.isDesktop(context)) SliverToBoxAdapter(child: loaderWidget),


                  if(isDesktop) const SliverToBoxAdapter(child: FooterWidget()),

                ],
              )),
            );
          },
        ),
      );
    });
  }

}

class _CategorySearchSuggestionWidget extends StatelessWidget {
  final String? queryText;
  const _CategorySearchSuggestionWidget({this.queryText});

  @override
  Widget build(BuildContext context) {
    return  Consumer<CategoryProvider>(builder: (ctx, categoryProvider,_){
      return ListView.separated(
        itemCount: categoryProvider.suggestionList!.length,
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => OnHoverWidget(
          builder: (isHover){
            return InkWell(
              onTap: () {
                categoryProvider.searchController.text = categoryProvider.suggestionList![index].name ?? "";
                categoryProvider.getSearchCategoryList(offset: 1, query: categoryProvider.suggestionList![index].name ?? "");
                categoryProvider.getSearchText(categoryProvider.suggestionList![index].name ??"");
                context.pop();
              },
              highlightColor:  Theme.of(context).primaryColor.withValues(alpha: 0.05),
              hoverColor: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: isHover ? Theme.of(context).primaryColor.withValues(alpha:0.1) : Theme.of(context).cardColor,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                  Row(mainAxisSize: MainAxisSize.min, children: [

                    RichText(
                      text: _highlightText(categoryProvider.suggestionList![index].name ?? '', queryText?.trim() ?? '', context),
                    ),
                  ]),

                ]),
              ),
            );
          } ,
        ),
        separatorBuilder: (ctx, index){
          return Divider(height: 0.4, thickness: 0.4, color: Theme.of(context).disabledColor.withValues(alpha: 0.5));
        },
      );
    });
  }

  TextSpan _highlightText(String source, String query, BuildContext context) {
    if (query.isEmpty) {
      return TextSpan(text: source, style: rubikSemiBold.copyWith(
        color: Theme.of(context).hintColor,
        fontSize: Dimensions.fontSizeSmall,
      ));
    }

    // Find start and end of the match
    int startIndex = source.toLowerCase().indexOf(query.toLowerCase());
    if (startIndex == -1) {
      return TextSpan(text: source, style: rubikSemiBold.copyWith(
        color: Theme.of(context).hintColor,
        fontSize: Dimensions.fontSizeSmall,
      ));
    }

    int endIndex = startIndex + query.length;

    return TextSpan(
      children: [
        TextSpan(text: source.substring(0, startIndex), style: rubikSemiBold.copyWith(
          color: Theme.of(context).hintColor,
          fontSize: Dimensions.fontSizeSmall,
        )),
        TextSpan(
          text: source.substring(startIndex, endIndex),
          style: rubikSemiBold.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: Dimensions.fontSizeSmall,
          ),
        ),
        TextSpan(text: source.substring(endIndex), style: rubikSemiBold.copyWith(
          color: Theme.of(context).hintColor,
          fontSize: Dimensions.fontSizeSmall,
        )),
      ],
    );
  }
}


class _CategoryItemWidget extends StatelessWidget {
  const _CategoryItemWidget({ this.index, required this.category,});
  final int? index;
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {

    bool isDesktop =  ResponsiveHelper.isDesktop(context);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Expanded(
        child: InkWell(
          onTap: () => RouterHelper.getCategoryRoute(category),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          child:  OnHoverWidget(builder: (isHoverActive) {
            return AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding:  EdgeInsets.all(isDesktop ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
                  color: Colors.white,
                  border: isHoverActive ? Border.all(color: Theme.of(context).primaryColor) : null,
                  boxShadow: [BoxShadow(
                    color: Theme.of(context).hintColor.withValues(alpha:0.13),
                    spreadRadius: Dimensions.radiusSmall, blurRadius: Dimensions.radiusLarge,
                  )],
                ),
                child: CustomImageWidget(
                  fit: BoxFit.contain,
                  image: splashProvider.baseUrls != null
                      ? '${splashProvider.baseUrls!.categoryImageUrl}/${category.image}' : '',
                ),
              ),
            );
          })
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Text (category.name ?? "", maxLines: 1, textAlign: TextAlign.center,  style: rubikSemiBold.copyWith(
        fontSize: isDesktop ? Dimensions.fontSizeDefault : Dimensions.fontSizeSmall,
      )),
    ]);
  }
}


class _NoDataWidget  extends StatelessWidget {
  const _NoDataWidget();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(children: [

        SizedBox(height: MediaQuery.of(context).size.height* 0.2),

        const SizedBox(
          height: 110, width: 110,
          child: CustomAssetImageWidget(
             Images.emptyCategory,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        Text(getTranslated('no_category_found' , context)!,
          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.8)),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: MediaQuery.of(context).size.height* 0.2),
      ]),
    );
  }
}

