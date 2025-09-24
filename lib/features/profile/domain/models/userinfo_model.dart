class UserInfoModel {
  int? id;
  String? fName;
  String? lName;
  String? email;
  String? image;
  int? isPhoneVerified;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? emailVerificationToken;
  String? phone;
  String? cmFirebaseToken;
  double? point;
  String? loginMedium;
  String? referCode;
  double? walletBalance;
  int? ordersCount;
  int? wishListCount;
  ReferralCustomerDetails? referralCustomerDetails;

  UserInfoModel(
      {this.id,
        this.fName,
        this.lName,
        this.email,
        this.image,
        this.isPhoneVerified,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.emailVerificationToken,
        this.phone,
        this.point,
        this.cmFirebaseToken,
        this.loginMedium,
        this.referCode,
        this.walletBalance,
        this.ordersCount,
        this.wishListCount,
        this.referralCustomerDetails
      });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    isPhoneVerified = json['is_phone_verified'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    emailVerificationToken = json['email_verification_token'];
    phone = json['phone'];
    cmFirebaseToken = json['cm_firebase_token'];
    point = json['point'].toDouble();
    loginMedium = '${json['login_medium']}';
    referCode = json['refer_code'];
    walletBalance = double.tryParse('${json['wallet_balance']}');
    ordersCount = int.tryParse(json['orders_count'].toString());
    wishListCount = int.tryParse(json['wishlist_count'].toString());
    if(json['referral_customer_details'] != null) {
      referralCustomerDetails = ReferralCustomerDetails.fromJson(json['referral_customer_details']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['email'] = email;
    data['image'] = image;
    data['is_phone_verified'] = isPhoneVerified;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['email_verification_token'] = emailVerificationToken;
    data['phone'] = phone;
    data['cm_firebase_token'] = cmFirebaseToken;
    data['point'] = point;
    data['login_medium'] = loginMedium;
    data['refer_code'] = referCode;
    data['wallet_balance'] = walletBalance;
    data['orders_count'] = ordersCount;
    data['wishlist_count'] = wishListCount;
    return data;
  }
}

class ReferralCustomerDetails {
  int? id;
  int? userId;
  int? referBy;
  double? refByEarningAmount;
  double? customerDiscountAmount;
  String? customerDiscountAmountType;
  int? customerDiscountValidity;
  String? customerDiscountValidityType;
  int? isUsed;
  int? isChecked;
  String? createdAt;
  String? updatedAt;

  ReferralCustomerDetails(
      {this.id,
        this.userId,
        this.referBy,
        this.refByEarningAmount,
        this.customerDiscountAmount,
        this.customerDiscountAmountType,
        this.customerDiscountValidity,
        this.customerDiscountValidityType,
        this.isUsed,
        this.isChecked,
        this.createdAt,
        this.updatedAt});

  ReferralCustomerDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    referBy = json['refer_by'];
    refByEarningAmount = double.tryParse(json['ref_by_earning_amount'].toString());
    customerDiscountAmount = double.tryParse( json['customer_discount_amount'].toString());
    customerDiscountAmountType = json['customer_discount_amount_type'];
    customerDiscountValidity = json['customer_discount_validity'];
    customerDiscountValidityType = json['customer_discount_validity_type'];
    isUsed = int.tryParse(json['is_used'].toString());
    isChecked = int.tryParse(json['is_checked'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['refer_by'] = referBy;
    data['ref_by_earning_amount'] = refByEarningAmount;
    data['customer_discount_amount'] = customerDiscountAmount;
    data['customer_discount_amount_type'] = customerDiscountAmountType;
    data['customer_discount_validity'] = customerDiscountValidity;
    data['customer_discount_validity_type'] = customerDiscountValidityType;
    data['is_used'] = isUsed;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}


