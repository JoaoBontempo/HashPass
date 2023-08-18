import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hashpass/dto/desktop/desktopAuthDTO.dart';
import 'package:hashpass/dto/desktop/desktopPublicKeyDTO.dart';
import 'package:hashpass/util/http.dart';
import 'package:web_socket_channel/io.dart';
import 'package:fast_rsa/fast_rsa.dart';

class HashPassDesktopProvider extends ChangeNotifier {
  final String serverPort = "3000";
  bool isConnected;
  static late HashPassDesktopProvider instance;
  IOWebSocketChannel? socket;
  late String serverIp;
  bool isLoading;
  late KeyPair rsaKey;
  late String serverPublicKey;
  String get serverPath => '$serverIp:$serverPort';

  HashPassDesktopProvider({
    this.isConnected = false,
    this.isLoading = true,
  }) {
    HashPassDesktopProvider.instance = this;
  }

  void connect({int ipRange = 0}) {
    if (isConnected) return;

    if (ipRange == 255) {
      isConnected = false;
      notifyListeners();
      return;
    }

    ipRange = ipRange + 1;
    serverIp = '192.168.0.$ipRange';
    String socketPath = 'ws://$serverIp:$serverPort';
    print(socketPath);
    socket = IOWebSocketChannel.connect(
      socketPath,
      connectTimeout: const Duration(seconds: 3),
    );
    socket!.stream.listen(
      (message) {
        String data = '';
        if (!(message is String)) {
          message = utf8.decode(message);
        }
        if (data == '') {
          isLoading = false;
          isConnected = true;
          print('Connected!');
          establishConnection();
          notifyListeners();
        } else {
          print(message);
        }
      },
      onError: (error) => connect(ipRange: ipRange),
      onDone: () {
        print('Connection closed.');
      },
      cancelOnError: true,
    );
  }

  void cancelConnection() {
    socket?.sink.close();
    socket = null;
    notifyListeners();
  }

  void establishConnection() async {
    await generateKeyPair();
    String desktopPublicKeyJson = await HTTPRequest.postRequest(
      'http://$serverPath/',
      DesktopAuthDTO(id: 'sadhjfkashjk', publicKey: rsaKey.publicKey).toJson(),
    );

    DesktopPublicKeyDTO desktopPublicKey =
        DesktopPublicKeyDTO.fromJson(desktopPublicKeyJson);

    serverPublicKey = desktopPublicKey.publicKey;
    isLoading = false;
    isConnected = true;
    notifyListeners();
  }

  Future<void> generateKeyPair() async {
    rsaKey = await RSA.generate(2048);
    return;
  }
}
