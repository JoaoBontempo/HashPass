import 'package:flutter/foundation.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/hashPassDesktopProvider.dart';

class UserPasswordsProvider extends ChangeNotifier {
  List<Password> _userPasswords = <Password>[];
  List<Password> filteredPasswords = <Password>[];
  bool isLoading = true;

  UserPasswordsProvider() {
    Password.findAll().then((passwords) {
      _userPasswords = passwords;
      filteredPasswords = passwords;
      isLoading = false;
      notifyListeners();
    });
    HashPassDesktopProvider.instance.passwordsProvider = this;
  }

  List<Password> getPasswords() => _userPasswords;

  void setPasswords(List<Password> passwords) {
    _userPasswords = passwords;
    filteredPasswords = passwords;
    notifyListeners();
  }

  void addPassword(Password password) {
    _userPasswords.add(password);
    filteredPasswords = _userPasswords;
    notifyListeners();
  }

  void removePassword(Password password) {
    _userPasswords.removeWhere((_password) => _password.id == password.id);
    filteredPasswords.removeWhere((_password) => _password.id == password.id);
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
