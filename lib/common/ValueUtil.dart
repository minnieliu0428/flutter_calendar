class ValueUtil{
  static bool strIsNullOrEmpty(String value){
    return ["", null].contains(value);
  }

  static bool intIsNullOrZero(int value){
    return [null, 0].contains(value);
  }
}