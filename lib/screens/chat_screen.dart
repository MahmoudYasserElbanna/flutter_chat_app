import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/models/messages.dart';
import 'package:scholar_chat/widgets/chat_bubble.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  static String pageId = 'ChatScreen';
  final CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessageReference);
  TextEditingController textEditingController = TextEditingController();
  ScrollController listController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    //* We Use FutureBuilder to build Message objects that comes from firestore
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedDate, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: kPrimaryColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    kLogo,
                    height: 50,
                  ),
                  const Text(
                    'Scholar Chat',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Container(
                  color: const Color(0xFF006488),
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: const Center(
                    child: Text(
                      'Mahmoud Elbanna',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: listController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBubble(
                              message: messagesList[index],
                            )
                          : ChatBubbleFromFriend(
                              message: messagesList[index],
                            );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: textEditingController,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        messages.add({
                          kMessage: value,
                          kCreatedDate: DateTime.now(),
                          kId: email,
                        });
                        textEditingController.clear();
                        listController.animateTo(
                          0.0, //can replace with: listController.position.minScrollExtent
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: 'Message',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.message,
                        color: kPrimaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
