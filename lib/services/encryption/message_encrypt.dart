import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_application_1/services/encryption/fille_encrypt.dart';
import 'package:flutter_application_1/services/encryption/keys.dart';
import 'package:path_provider/path_provider.dart';

class CryptoEncrpt {
  var random = new Random();

  //decrypt
  static String decryptText(EnText enText) {
    final key = Key.fromUtf8(enText.key);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final decryptedText = encrypter.decrypt64(enText.msg, iv: iv);
    print(decryptedText);

    return decryptedText;
  }

//encrypt
  static EnText ecryptText(String text, String keyit) {
    String keytext = keyit;
    final key = Key.fromUtf8(keytext);
    final iv = IV.fromLength(16);
    // print(iv.base64);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(text, iv: iv);

    print(encrypted.base64);

    String encryptedText = encrypted.base64;

    return EnText(key: keytext, msg: encryptedText);
  }

  static Future<EncryptedItem> encryptFile(File video) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File outFile = new File("$dir/enfile.aes");
    String keytext = KeyStore.genaratekeycode();

    bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      outFile.create();
      print("created");
    }

    final videoFileContents = video.readAsStringSync(encoding: latin1);

    final key = Key.fromUtf8(keytext);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(videoFileContents, iv: iv);
    await outFile.writeAsBytes(encrypted.bytes);

    print("encrypted");

    return (EncryptedItem(file: outFile, key: keytext));
  }

  static Future<File> decryptFile(
      File inFile, String keycode, String extension) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File outFile = File("$dir/filedec" + extension);

    bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      outFile.create();
    }

    final videoFileContents = inFile.readAsBytesSync();

    final key = Key.fromUtf8(keycode);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encryptedFile = Encrypted(videoFileContents);
    final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

    final decryptedBytes = latin1.encode(decrypted);
    await outFile.writeAsBytes(decryptedBytes);
    print("decrypted");
    return outFile;
  }

  bool isencrypt(String text) {
    bool isen = false;
    if (text[0] == "initensymbol") {
      isen = true;
    } else {
      isen = false;
    }
    print(isen);
    return isen;
  }
}

class EnText {
  final String key;
  final String msg;

  EnText({required this.key, required this.msg});
}
