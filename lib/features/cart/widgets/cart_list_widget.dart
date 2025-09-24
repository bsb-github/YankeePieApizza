import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/cart/widgets/cart_product_widget.dart';

class CartListWidget extends StatelessWidget {
  final CartProvider cart;
  final List<List<AddOns>> addOns;
  final List<bool> availableList;
  const CartListWidget({super.key, required this.cart, required this.addOns, required this.availableList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: cart.cartList.length,
      itemBuilder: (context, index) {
        return CartProductWidget(cart: cart.cartList[index], cartIndex: index, addOns: addOns[index], isAvailable: availableList[index]);
      },
    );
  }
}