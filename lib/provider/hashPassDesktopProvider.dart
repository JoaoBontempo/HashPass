import 'dart:convert';
import 'package:crypton/crypton.dart';
import 'package:flutter/material.dart';
import 'package:hashpass/dto/desktop/desktopAuthDTO.dart';
import 'package:hashpass/dto/desktop/desktopGuidDTO.dart';
import 'package:hashpass/dto/desktop/desktopOperationDTO.dart';
import 'package:hashpass/dto/desktop/desktopPublicKeyDTO.dart';
import 'package:hashpass/util/http.dart';
import 'package:web_socket_channel/io.dart';

class HashPassDesktopProvider extends ChangeNotifier {
  final String serverPort = "3000";
  bool isConnected;
  static late HashPassDesktopProvider instance;
  IOWebSocketChannel? socket;
  late String serverIp;
  bool isLoading;
  late String serverGuid;
  late RSAKeypair appKeys;
  late RSAPublicKey serverPublicKey;
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
        if (message == '') {
          isLoading = false;
          isConnected = true;
          print('Connected!');
          establishConnection();
          notifyListeners();
        } else {
          print(_decypherAssymetricMessage(message));
        }
      },
      onError: (error) => connect(ipRange: ipRange),
      onDone: () {
        isConnected = false;
        print('Connection closed.');
        notifyListeners();
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
    generateKeyPair();

    final serverApiPath = 'http://$serverPath/';
    String desktopPublicKeyJson = await HTTPRequest.postRequest(
      serverApiPath,
      DesktopAuthDTO(id: 'sadhjfkashjk', publicKey: appKeys.publicKey.toPEM())
          .toJson(),
    );

    DesktopPublicKeyDTO desktopPublicKey =
        DesktopPublicKeyDTO.fromJson(desktopPublicKeyJson);
    serverPublicKey = RSAPublicKey.fromPEM(
        utf8.decode(base64.decode(desktopPublicKey.publicKey)));

    String desktopChyperedGuidJson =
        await HTTPRequest.getRequest('${serverApiPath}key');

    ExchangeKeyDTO keyDTO = ExchangeKeyDTO.fromJson(desktopChyperedGuidJson);

    print('Keys exchanged!');
    String json = _decypherAssymetricMessage(keyDTO.key);
    print(json);
    DesktopOperationDTO<DesktopGuidDTO> guidDTO =
        DesktopOperationDTO<DesktopGuidDTO>.fromJson(
      json,
      (guidJSON) => DesktopGuidDTO.fromMap(guidJSON),
    );
    serverGuid = guidDTO.data.guid;
    print('GUID dechypered and ready to use!');
    isLoading = false;
    isConnected = true;
    notifyListeners();
  }

  void generateKeyPair() {
    appKeys = RSAKeypair.fromRandom(keySize: 2048);
  }

  String _cypherAssymetricMessage(DesktopOperationDTO dto) {
    return serverPublicKey.encrypt(dto.toJson());
  }

  String _decypherAssymetricMessage(String message) {
    return appKeys.privateKey.decrypt(message);
  }

  void sendMessage(DesktopOperationDTO messageDto) {
    print(messageDto.toJson());
    print(serverPublicKey);
    if (isConnected) {
      socket!.sink.add(_cypherAssymetricMessage(messageDto));
    }
  }
}
