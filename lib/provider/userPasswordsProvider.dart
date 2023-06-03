import 'package:flutter/foundation.dart';
import 'package:hashpass/model/password.dart';

class UserPasswordsProvider extends ChangeNotifier {
  List<Password> _userPasswords = <Password>[];
  List<Password> filteredPasswords = <Password>[];

  UserPasswordsProvider() {
    Password.findAll().then((passwords) {
      print(passwords);
      _userPasswords = passwords;
      filteredPasswords = passwords;
      notifyListeners();
    });
  }

  List<Password> getPasswords() => _userPasswords;

  void setPasswords(List<Password> passwords) {
    _userPasswords = passwords;
    notifyListeners();
  }

  void addPassword(Password password) {
    _userPasswords.add(password);
    notifyListeners();
  }

  void removePassword(Password password) {
    _userPasswords.removeWhere((_password) => _password.id == password.id);
    notifyListeners();
  }

  void filterPasswords(String query) {
    query = query.toLowerCase().trim();
    filteredPasswords = _userPasswords.where((password) {
      return password.title.toLowerCase().contains(query) ||
          password.credential.toLowerCase().contains(query);
    }).toList();

    notifyListeners();
  }
}
