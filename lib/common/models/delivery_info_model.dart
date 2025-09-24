class DeliveryInfoModel {
  int? id;
  String? name;
  int? status;
  DeliveryChargeSetup? deliveryChargeSetup;
  List<DeliveryChargeByArea>? deliveryChargeByArea;

  DeliveryInfoModel({
    this.id,
    this.name,
    this.status,
    this.deliveryChargeSetup,
    this.deliveryChargeByArea,
  });

  DeliveryInfoModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        status = json['status'],
        deliveryChargeSetup = json['delivery_charge_setup'] != null
            ? DeliveryChargeSetup.fromJson(json['delivery_charge_setup'])
            : null,
        deliveryChargeByArea = (json['delivery_charge_by_area'] as List?)
            ?.map((v) => DeliveryChargeByArea.fromJson(v))
            .toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
    'delivery_charge_setup': deliveryChargeSetup?.toJson(),
    'delivery_charge_by_area':
    deliveryChargeByArea?.map((v) => v.toJson()).toList(),
  };
}

class DeliveryChargeSetup {
  int? id;
  int? branchId;
  String? deliveryChargeType;
  double? deliveryChargePerKilometer;
  double? minimumDeliveryCharge;
  double? minimumDistanceForFreeDelivery;
  String? createdAt;
  String? updatedAt;
  double? fixedDeliveryCharge;
  double? freeDeliveryOverAmount;
  bool? freeDeliveryStatus;

  DeliveryChargeSetup({
    this.id,
    this.branchId,
    this.deliveryChargeType,
    this.deliveryChargePerKilometer,
    this.minimumDeliveryCharge,
    this.minimumDistanceForFreeDelivery,
    this.createdAt,
    this.updatedAt,
    this.fixedDeliveryCharge,
    this.freeDeliveryOverAmount,
    this.freeDeliveryStatus
  });

  DeliveryChargeSetup.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        branchId = json['branch_id'],
        deliveryChargeType = json['delivery_charge_type'],
        deliveryChargePerKilometer =
        double.tryParse('${json['delivery_charge_per_kilometer']}'),
        minimumDeliveryCharge =
        double.tryParse('${json['minimum_delivery_charge']}'),
        minimumDistanceForFreeDelivery =
        double.tryParse('${json['minimum_distance_for_free_delivery']}'),
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        fixedDeliveryCharge =double.tryParse('${json['fixed_delivery_charge']}'),
        freeDeliveryStatus = '${json['free_delivery_over_status']}'.contains('1'),
        freeDeliveryOverAmount = double.tryParse('${json['free_delivery_over_amount']}');

  Map<String, dynamic> toJson() => {
    'id': id,
    'branch_id': branchId,
    'delivery_charge_type': deliveryChargeType,
    'delivery_charge_per_kilometer': deliveryChargePerKilometer,
    'minimum_delivery_charge': minimumDeliveryCharge,
    'minimum_distance_for_free_delivery': minimumDistanceForFreeDelivery,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'fixedDeliveryCharge': fixedDeliveryCharge,
    'free_delivery_over_status': freeDeliveryStatus,
    'free_delivery_over_amount': freeDeliveryOverAmount,
  };
}

class DeliveryChargeByArea {
  int? id;
  int? branchId;
  String? areaName;
  double? deliveryCharge;
  String? createdAt;
  String? updatedAt;

  DeliveryChargeByArea({
    this.id,
    this.branchId,
    this.areaName,
    this.deliveryCharge,
    this.createdAt,
    this.updatedAt,
  });

  DeliveryChargeByArea.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        branchId = json['branch_id'],
        areaName = json['area_name'],
        deliveryCharge = double.tryParse("${json['delivery_charge']}"),
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'branch_id': branchId,
    'area_name': areaName,
    'delivery_charge': deliveryCharge,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
