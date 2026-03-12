
class CustomKeyMaker {
  String customUserId(String name, String phoneNo) {
    String key = "$name-${phoneNo[phoneNo.length - 2]}${phoneNo[phoneNo.length - 1]}";
    return key;
  }
}
