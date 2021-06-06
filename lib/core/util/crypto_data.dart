import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class IEncrypData {
  String crypteFile(String data);
  String decryptFile(String data);
}

class EncrypData implements IEncrypData {
  late final Key key;
  late final IV iv;

  final String _privateKey = 'privateKey';
  final String _privateINV = 'privateINV';

  EncrypData() {
    key = Key.fromUtf8(dotenv.env[_privateKey] ?? '');
    iv = IV.fromUtf8(utf8.decode((dotenv.env[_privateINV] ?? '').codeUnits));
  }

  @override
  String crypteFile(String data) {
    final encrypter = Encrypter(AES(key, padding: null));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  @override
  String decryptFile(String data) {
    final encrypter = Encrypter(AES(key, padding: null));
    final decrypted = encrypter.decrypt(Encrypted.from64(data), iv: iv);
    return decrypted;
  }
}
