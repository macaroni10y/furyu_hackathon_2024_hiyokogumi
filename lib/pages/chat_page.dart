import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'items_list_view_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.item, required this.candidateId});
  final Item item;
  // 商品をほしい側のユーザーID
  final String candidateId;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  /// チャットのメッセージをstreamで取得する
  Stream<QuerySnapshot> _subscribeToChatRoom() {
    // idea_items/itemId/candidates/candidateId/messages
    return FirebaseFirestore.instance
        .collection("idea_items")
        .doc(widget.item.id)
        .collection("candidates")
        .doc(widget.candidateId)
        .collection("messages")
        .snapshots();
  }

  /// メッセージを送信する
  void _sendMessage() {
    FirebaseFirestore.instance
        .collection("idea_items")
        .doc(widget.item.id)
        .collection("candidates")
        .doc(widget.candidateId)
        .collection("messages")
        .add({
      "message": _messageController.text,
      "sender": FirebaseAuth.instance.currentUser?.uid ?? "",
      "timestamp": FieldValue.serverTimestamp(),
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Chat Page'),
      ),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _subscribeToChatRoom(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading...");
                }
                print("received data: ${snapshot.data!.docs.length}");
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    var data = doc.data();
                    return Text("data");
                  }).toList(),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CupertinoTextField(
                  controller: _messageController,
                  placeholder: "Message",
                ),
              ),
              CupertinoButton(
                child: const Text("Send"),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
