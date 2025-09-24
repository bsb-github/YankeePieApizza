import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';

class InputModel {
  InputModel({
    required this.locationTextController,
    required this.streetNumberController,
    required this.houseNumberController,
    required this.florNumberController,
    required this.addressNode,
    required this.nameNode,
    required this.stateNode,
    required this.houseNode,
    required this.floorNode,
    required this.branches,
    this.countryCode,
    required this.updateAddress,
    required this.isEnableUpdate,
    required this.fromCheckout,
    this.address,
  });

  final TextEditingController locationTextController;
  final TextEditingController streetNumberController;
  final TextEditingController houseNumberController;
  final TextEditingController florNumberController;

  final FocusNode addressNode;
  final FocusNode nameNode;
  final FocusNode stateNode;
  final FocusNode houseNode;
  final FocusNode floorNode;

  final List<Branches?> branches;
  final bool updateAddress;
  final String? countryCode;

  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel? address;
}