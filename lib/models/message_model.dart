import 'package:chat_app/constants.dart';

class Message {
  Message(this.message, this.id);
  final String message;
  final String id;

  factory Message.fromJson(jsonData) {
    return Message(jsonData[kMessage], jsonData[kId]);
  }
}
