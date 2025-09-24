import 'dart:convert';

class ConversationModel {
  int? totalSize;
  int? limit;
  int? offset;
  AdminLastConversation? adminLastConversation;
  List<DeliverymanConversation>? deliverymanConversations;

  ConversationModel({
    this.totalSize,
    this.limit,
    this.offset,
    this.adminLastConversation,
    this.deliverymanConversations,
  });

  factory ConversationModel.fromJson(String str) => ConversationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConversationModel.fromMap(Map<String, dynamic> json) => ConversationModel(
    totalSize: json["total_size"],
    limit: json["limit"],
    offset: json["offset"],
    adminLastConversation: json["admin_last_conversation"] == null ? null : AdminLastConversation.fromMap(json["admin_last_conversation"]),
    deliverymanConversations: json["deliveryman_conversations"] == null ? [] : List<DeliverymanConversation>.from(json["deliveryman_conversations"]!.map((x) => DeliverymanConversation.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "total_size": totalSize,
    "limit": limit,
    "offset": offset,
    "admin_last_conversation": adminLastConversation?.toMap(),
    "deliveryman_conversations": deliverymanConversations == null ? [] : List<dynamic>.from(deliverymanConversations!.map((x) => x.toMap())),
  };
}

class AdminLastConversation {
  int? id;
  int? userId;
  dynamic message;
  String? reply;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? checked;
  String? image;
  bool? isReply;

  AdminLastConversation({
    this.id,
    this.userId,
    this.message,
    this.reply,
    this.createdAt,
    this.updatedAt,
    this.checked,
    this.image,
    this.isReply,
  });

  factory AdminLastConversation.fromJson(String str) => AdminLastConversation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AdminLastConversation.fromMap(Map<String, dynamic> json) => AdminLastConversation(
    id: json["id"],
    userId: json["user_id"],
    message: json["message"],
    reply: json["reply"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    checked: int.tryParse('${json["checked"]}'),
    image: json["image"],
    isReply: json["is_reply"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "message": message,
    "reply": reply,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "checked": checked,
    "image": image,
    "is_reply": isReply,
  };
}

class DeliverymanConversation {
  int? id;
  int? orderId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Order? order;
  List<Message>? messages;

  DeliverymanConversation({
    this.id,
    this.orderId,
    this.createdAt,
    this.updatedAt,
    this.order,
    this.messages,
  });

  factory DeliverymanConversation.fromJson(String str) => DeliverymanConversation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DeliverymanConversation.fromMap(Map<String, dynamic> json) => DeliverymanConversation(
    id: json["id"],
    orderId: json["order_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    order: json["order"] == null ? null : Order.fromMap(json["order"]),
    messages: json["messages"] == null ? [] : List<Message>.from(json["messages"]!.map((x) => Message.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "order_id": orderId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "order": order?.toMap(),
    "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x.toMap())),
  };
}

class Message {
  int? id;
  int? conversationId;
  int? customerId;
  dynamic deliverymanId;
  String? message;
  String? attachment;
  DateTime? createdAt;
  DateTime? updatedAt;

  Message({
    this.id,
    this.conversationId,
    this.customerId,
    this.deliverymanId,
    this.message,
    this.attachment,
    this.createdAt,
    this.updatedAt,
  });

  factory Message.fromJson(String str) => Message.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Message.fromMap(Map<String, dynamic> json) => Message(
    id: json["id"],
    conversationId: json["conversation_id"],
    customerId: json["customer_id"],
    deliverymanId: json["deliveryman_id"],
    message: json["message"],
    attachment: json["attachment"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "conversation_id": conversationId,
    "customer_id": customerId,
    "deliveryman_id": deliverymanId,
    "message": message,
    "attachment": attachment,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Order {
  int? id;
  int? userId;
  int? isGuest;
  double? orderAmount;
  int? couponDiscountAmount;
  dynamic couponDiscountTitle;
  String? paymentStatus;
  String? orderStatus;
  double? totalTaxAmount;
  String? paymentMethod;
  dynamic transactionReference;
  int? deliveryAddressId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? checked;
  int? deliveryManId;
  double? deliveryCharge;
  String? orderType;
  int? branchId;

  DateTime? deliveryDate;
  String? deliveryTime;
  String? extraDiscount;
  DeliveryAddress? deliveryAddress;
  int? preparationTime;

  int? isCutleryRequired;
  Customer? deliveryMan;
  Customer? customer;

  Order({
    this.id,
    this.userId,
    this.isGuest,
    this.orderAmount,
    this.couponDiscountAmount,
    this.couponDiscountTitle,
    this.paymentStatus,
    this.orderStatus,
    this.totalTaxAmount,
    this.paymentMethod,
    this.transactionReference,
    this.deliveryAddressId,
    this.createdAt,
    this.updatedAt,
    this.checked,
    this.deliveryManId,
    this.deliveryCharge,
    this.orderType,
    this.branchId,
    this.deliveryDate,
    this.deliveryTime,
    this.extraDiscount,
    this.deliveryAddress,
    this.preparationTime,
    this.isCutleryRequired,
    this.deliveryMan,
    this.customer,
  });

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Order.fromMap(Map<String, dynamic> json) => Order(
    id: json["id"],
    userId: json["user_id"],
    isGuest: json["is_guest"],
    orderAmount: double.tryParse('${json["order_amount"]}'),
    couponDiscountAmount: json["coupon_discount_amount"],
    couponDiscountTitle: json["coupon_discount_title"],
    paymentStatus: json["payment_status"],
    orderStatus: json["order_status"],
    totalTaxAmount: double.tryParse('${json["total_tax_amount"]}'),
    paymentMethod: json["payment_method"],
    transactionReference: json["transaction_reference"],
    deliveryAddressId: json["delivery_address_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    checked: json["checked"],
    deliveryManId: json["delivery_man_id"],
    deliveryCharge: json["delivery_charge"]?.toDouble(),
    orderType: json["order_type"],
    branchId: json["branch_id"],
    deliveryDate: json["delivery_date"] == null ? null : DateTime.parse(json["delivery_date"]),
    deliveryTime: json["delivery_time"],
    extraDiscount: json["extra_discount"],
    deliveryAddress: json["delivery_address"] == null ? null : DeliveryAddress.fromMap(json["delivery_address"]),
    preparationTime: json["preparation_time"],
    isCutleryRequired: json["is_cutlery_required"],
    deliveryMan: json["delivery_man"] == null ? null : Customer.fromMap(json["delivery_man"]),
    customer: json["customer"] == null ? null : Customer.fromMap(json["customer"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "is_guest": isGuest,
    "order_amount": orderAmount,
    "coupon_discount_amount": couponDiscountAmount,
    "coupon_discount_title": couponDiscountTitle,
    "payment_status": paymentStatus,
    "order_status": orderStatus,
    "total_tax_amount": totalTaxAmount,
    "payment_method": paymentMethod,
    "transaction_reference": transactionReference,
    "delivery_address_id": deliveryAddressId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "checked": checked,
    "delivery_man_id": deliveryManId,
    "delivery_charge": deliveryCharge,
    "order_type": orderType,
    "branch_id": branchId,
    "delivery_date": "${deliveryDate!.year.toString().padLeft(4, '0')}-${deliveryDate!.month.toString().padLeft(2, '0')}-${deliveryDate!.day.toString().padLeft(2, '0')}",
    "delivery_time": deliveryTime,
    "extra_discount": extraDiscount,
    "delivery_address": deliveryAddress?.toMap(),
    "preparation_time": preparationTime,
    "is_cutlery_required": isCutleryRequired,
    "delivery_man": deliveryMan?.toMap(),
    "customer": customer?.toMap(),
  };
}

class Customer {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? image;

  Customer({
    this.id,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.image,
  });

  factory Customer.fromJson(String str) => Customer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Customer.fromMap(Map<String, dynamic> json) => Customer(
    id: json["id"],
    fName: json["f_name"],
    lName: json["l_name"],
    phone: json["phone"],
    email: json["email"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "f_name": fName,
    "l_name": lName,
    "phone": phone,
    "email": email,
    "image": image,
  };
}

class DeliveryAddress {
  int? id;
  String? addressType;
  String? contactPersonNumber;
  dynamic floor;
  dynamic house;
  dynamic road;
  String? address;
  double? latitude;
  double? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? userId;
  int? isGuest;
  String? contactPersonName;

  DeliveryAddress({
    this.id,
    this.addressType,
    this.contactPersonNumber,
    this.floor,
    this.house,
    this.road,
    this.address,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.isGuest,
    this.contactPersonName,
  });

  factory DeliveryAddress.fromJson(String str) => DeliveryAddress.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DeliveryAddress.fromMap(Map<String, dynamic> json) => DeliveryAddress(
    id: json["id"],
    addressType: json["address_type"],
    contactPersonNumber: json["contact_person_number"],
    floor: json["floor"],
    house: json["house"],
    road: json["road"],
    address: json["address"],
    latitude: double.tryParse(json["latitude"].toString()),
    longitude: double.tryParse(json["longitude"].toString()),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    userId: json["user_id"],
    isGuest: json["is_guest"],
    contactPersonName: json["contact_person_name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "address_type": addressType,
    "contact_person_number": contactPersonNumber,
    "floor": floor,
    "house": house,
    "road": road,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user_id": userId,
    "is_guest": isGuest,
    "contact_person_name": contactPersonName,
  };
}
