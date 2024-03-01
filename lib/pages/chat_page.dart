import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'items_list_view_page.dart';

/// チャット画面
/// 出品者と、商品をほしい側のユーザーとのチャット画面
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
  String _authorNickName = "";
  String _candidateNickName = "";

  /// 出品者と、商品をほしい側のユーザーのニックネームを取得する
  void _fetchNickName() async {
    _authorNickName = await FirebaseFirestore.instance
        .collection("user_info_list")
        .doc(widget.item.author)
        .get()
        .then((value) {
      var data = value.data();
      return data?["name"];
    });
    _candidateNickName = await FirebaseFirestore.instance
        .collection("user_info_list")
        .doc(widget.candidateId)
        .get()
        .then((value) {
      var data = value.data();
      return data?["name"];
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchNickName();
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
        .orderBy("timestamp")
        .snapshots();
  }

  /// メッセージを送信する
  void _sendMessage() {
    if (_messageController.text.isEmpty) return;
    FirebaseFirestore.instance
        .collection("idea_items")
        .doc(widget.item.id)
        .collection("candidates")
        .doc(widget.candidateId)
        .collection("messages")
        .add({
      "message": _messageController.text,
      "sender": FirebaseAuth.instance.currentUser?.uid ?? "",
      "timestamp": Timestamp.now(),
    });
    _messageController.clear();
  }

  Center _buildBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                    ChatMessage chatMessage = ChatMessage(
                      message: doc["message"],
                      sender: doc["sender"],
                      timestamp: doc["timestamp"],
                    );
                    return _buildMessageText(chatMessage);
                  }).toList(),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: _messageBar(),
          ),
        ],
      ),
    );
  }

  /// 1つのメッセージ領域を作る
  Widget _buildMessageText(ChatMessage chatMessage) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(chatMessage.message),
      decoration: BoxDecoration(
        color: chatMessage.sender == FirebaseAuth.instance.currentUser?.uid
            ? CupertinoColors.systemBlue
            : CupertinoColors.inactiveGray,
        borderRadius: BorderRadius.circular(8.0),
      ),
      height: 50,
      margin: const EdgeInsets.all(8.0),
      alignment: chatMessage.sender == FirebaseAuth.instance.currentUser?.uid
          ? Alignment.centerRight
          : Alignment.centerLeft,
    );
  }

  Widget _messageBar() {
    return Row(
      children: [
        Expanded(
          child: CupertinoTextField(
            controller: _messageController,
            placeholder: "Message",
          ),
        ),
        CupertinoButton(
          child: const Text("送信"),
          onPressed: _sendMessage,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
            '${widget.item.title} の取引画面 出品者: $_authorNickName ほしい側: $_candidateNickName'),
      ),
      child: _buildBody(),
    );
  }
}

class ChatMessage {
  ChatMessage(
      {required this.message, required this.sender, required this.timestamp});
  final String message;
  final String sender;
  final Timestamp timestamp;
}
