import 'package:flutter/cupertino.dart';

class HashPassValidator {
  static FormFieldValidator empty(String message) {
    return _ValidationMethods.empty(message);
  }
}

class _ValidationMethods {
  static FormFieldValidator empty(String message) {
    return (value) {
      if (value.isEmpty) return message;
      if (value.trim() == '') return message;
      return null;
    };
  }
}
