import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  static String chatScreenId = 'ChatScreen';
  final listViewController = ScrollController();
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);

  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var userEmail = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy(kCreatedAtTime, descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messagesList = [];

            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(
                Message.fromJson(snapshot.data!.docs[i]),
              );
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: kSenderPrimaryColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      kLogoPath,
                      height: 50.0,
                    ),
                    const Text(
                      'chat',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: listViewController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) =>
                          messagesList[index].id == userEmail
                              ? ChatBubbleSender(
                                  message: messagesList[index],
                                )
                              : ChatBubbleReceiver(
                                  message: messagesList[index],
                                ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: messageController,
                      onSubmitted: (messageData) {
                        addMessageToDatabase(messageData, userEmail);
                        messageController.clear();
                        listViewAnimation();
                      },
                      decoration: InputDecoration(
                        hintText: "Send Message",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          color: kSenderPrimaryColor,
                          onPressed: () {
                            // sending message code
                            messageController.clear();
                            listViewAnimation();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: const BorderSide(
                            color: kSenderPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
        });
  }

  void listViewAnimation() {
    listViewController.animateTo(
      0,
      duration: const Duration(
        microseconds: 500,
      ),
      curve: Curves.easeIn,
    );
  }

  void addMessageToDatabase(String messageData, Object? userEmail) {
    messages.add({
      'message': messageData,
      'createdAtTime': DateTime.now(),
      'id': userEmail,
    });
  }
}
