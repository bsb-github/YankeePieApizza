class CustomMaskInfo{

  static String maskedEmail (String email){
    List<String> parts = email.split('@');
    String user = parts[0];
    String domain = parts[1];

    int visibleLength = (user.length > 3) ? 3 : 1;
    String visiblePart = user.substring(0, visibleLength);
    String maskedPart = '*' * (user.length - visibleLength);

    return '$visiblePart$maskedPart$domain';
  }

  static String maskedPhone (String phone){
    int maskedNumber = (phone.length * 0.7).floor();
    int remaining = phone.length - maskedNumber;

    int visiblePart = 0;

    if(remaining % 2 == 0){
      visiblePart = remaining ~/ 2;
    }else{
      visiblePart = (remaining / 2).ceil();
    }

    return "${phone.substring(0, visiblePart)}${'*' * (maskedNumber)}${phone.substring((maskedNumber + visiblePart), phone.length)}";
  }

}