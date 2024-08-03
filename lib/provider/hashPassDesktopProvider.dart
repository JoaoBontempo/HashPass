import 'dart:convert';
import 'package:crypton/crypton.dart';
import 'package:flutter/material.dart';
import 'package:hashpass/dto/desktop/desktopAuthDTO.dart';
import 'package:hashpass/dto/desktop/desktopGuidDTO.dart';
import 'package:hashpass/dto/desktop/desktopOperationDTO.dart';
import 'package:hashpass/dto/desktop/desktopPublicKeyDTO.dart';
import 'package:hashpass/util/http.dart';
import 'package:hashpass/util/security/aes.dart';
import 'package:hashpass/util/security/hash.dart';
import 'package:hashpass/util/security/rsa.dart';
import 'package:web_socket_channel/io.dart';

class HashPassDesktopProvider extends ChangeNotifier {
  final String serverPort = "3000";

  bool isConnected;
  bool connectionFailure;
  IOWebSocketChannel? socket;
  bool isLoading;

  static late HashPassDesktopProvider instance;
  late String serverIp;
  late int currentRange = 0;
  late String serverGuid;
  late RSAKeypair appKeys;
  late RSAPublicKey serverPublicKey;
  VoidCallback? onConnect;

  String get serverPath => '$serverIp:$serverPort';

  HashPassDesktopProvider({
    this.isConnected = false,
    this.isLoading = true,
    this.connectionFailure = false,
  }) {
    HashPassDesktopProvider.instance = this;
  }

  void cancel() {
    connectionFailure = true;
    notifyListeners();
  }

  void reconnect() {
    isConnected = false;
    connectionFailure = false;
    connect();
  }

  void connect({int ipRange = 0}) {
    if (isConnected || connectionFailure) {
      return;
    }

    if (ipRange > 255) {
      ipRange = 0;
      isConnected = false;
      connectionFailure = true;
      currentRange = 0;
      notifyListeners();
      return;
    }

    isLoading = true;
    ipRange = ipRange + 1;
    currentRange = ipRange;
    serverIp = '192.168.0.$ipRange';
    notifyListeners();
    String socketPath = 'ws://$serverIp:$serverPort';
    socket = IOWebSocketChannel.connect(
      socketPath,
      connectTimeout: const Duration(seconds: 3),
    );
    socket!.stream.listen(
      (message) {
        print(message);
        if (message == '') {
          establishConnection();
          notifyListeners();
        } else {
          processMessage(message);
        }
      },
      onError: (error) => connect(ipRange: ipRange),
      onDone: () {
        isConnected = false;
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
    appKeys = RSA.generateKeyPair();

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

    String json = RSA.decrypt(appKeys.privateKey, keyDTO.key);

    DesktopOperationDTO<DesktopGuidDTO> guidDTO =
        DesktopOperationDTO<DesktopGuidDTO>.fromJson(
      json,
      serialize: (guidJSON) => DesktopGuidDTO.fromMap(guidJSON),
    );
    serverGuid = guidDTO.data.guid;
    onConnect?.call();
    onConnect = null;
    isLoading = false;
    isConnected = true;
    notifyListeners();
  }

  void sendMessage(DesktopOperationDTO messageDto) {
    if (isConnected) {
      String encryptedData =
          AES.encryptServer(messageDto.toJson(), _getServerKey);
      print('Data: ' + encryptedData);
      socket!.sink.add(encryptedData);
    }
  }

  void processMessage(String serverMessage) async {
    String serverKey = _getServerKey;
    print('KEY: ' + serverKey);
    print('AES:' + serverMessage);
    String aesEncryptedMessage =
        AES.decryptServer(serverMessage, _getServerKey);
    print('Decrypt AES:' + aesEncryptedMessage);
    /*DesktopOperationDTO<List<dynamic>> operation =
        DesktopOperationDTO<List<dynamic>>.fromJson(aesEncryptedMessage);

    print('OPERATION DTO:' + operation.toJson());*/
  }

  String get _getServerKey =>
      Hash.applyHashPass(HashAlgorithm.SHA256, serverGuid).substring(32);
}
