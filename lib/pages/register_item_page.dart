import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

/// アイデア登録ページ
class RegisterItemPage extends StatefulWidget {
  const RegisterItemPage({super.key});

  @override
  _RegisterItemPageState createState() => _RegisterItemPageState();
}

class _RegisterItemPageState extends State<RegisterItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  final _ideaNameController = TextEditingController();
  final _ideaDescriptionController = TextEditingController();
  String _uploadedImageUrl = '';
  String _userId = "";
  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? "";
  }

  /// 端末のカメラから画像を選択する
  /// 画像を選択したら、Firebase Storageにアップロードする
  /// アップロードが成功したら、アップロードした画像のURLを取得して状態(_uploadedImageUrl)として保持する
  Future<void> selectImage() async {
    final XFile? selectedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      print('Selected image path: ${selectedImage.path}');
      var imagePath = 'images/$_userId/${DateTime.now()}.png';
      print('try to upload imagePath: $imagePath');
      await FirebaseStorage.instance
          .ref(imagePath)
          .putFile(File(selectedImage.path));
      // 登録したてほやほやの画像のURLを取得
      _uploadedImageUrl =
          await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
      print('upload successful. uploadedImageUrl: $_uploadedImageUrl');
    } else {
      print('No image selected.');
    }
  }

  /// Firestoreにアイデアを登録する
  Future<void> _registerItemToDB() async {
    debugPrint('Sending message to Firestore');
    await FirebaseFirestore.instance.collection('idea_items').add({
      'author': _userId,
      'title': _ideaNameController.text,
      'description': _ideaDescriptionController.text,
      'imageUrl': _uploadedImageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// 登録ページのボディを生成する
  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildForm(),
          CupertinoButton(
            child: Image.asset(
              'assets/images/register/登録する.png',
              width: 180,
            ),
            onPressed: () async {
              // バリデーションチェック
              if (!_formKey.currentState!.validate()) {
                return;
              }
              if (_uploadedImageUrl.isEmpty) {
                // 画像が選択されていない場合はエラーを表示
                return;
              }
              if (_userId.isEmpty) {
                Navigator.popUntil(context, (route) => route.isFirst);
                return;
              }
              await _registerItemToDB();
              // 投稿処理が成功したら、一覧画面に戻る
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  /// アイデア登録フォームを生成する
  Widget _buildForm() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await selectImage();
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              _uploadedImageUrl.isNotEmpty
                  ? _uploadedImageUrl
                  : "https://placehold.jp/72/c2c2c2/ffffff/150x150.png?text=%EF%BC%8B",
              width: 300,
              height: 200,
              fit: BoxFit.cover,
            ), // 画像が選択されていない場合はデフォルト画像を表示
          ),
        ),
        Column(children: [
          Container(
            margin:
                const EdgeInsets.only(left: 36, right: 36, top: 16, bottom: 16),
            decoration: BoxDecoration(
              border: Border.all(color: CupertinoColors.white, width: 2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: CupertinoTextFormFieldRow(
              controller: _ideaNameController,
              placeholder: 'アイデア名',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'アイデア名を入力してください';
                }
                if (value.length > 20) {
                  return 'アイデア名は20文字以内で入力してください';
                }
                return null;
              },
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 36, right: 36, top: 16, bottom: 16),
            decoration: BoxDecoration(
              border: Border.all(color: CupertinoColors.white, width: 2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: CupertinoTextFormFieldRow(
              controller: _ideaDescriptionController,
              placeholder:
                  '概要（400文字以内）\n\n\n\n\n\n\n', // placeholderの上寄せが指定できないので8行分の高さを確保する力技
              minLines: 6,
              maxLines: 6,
              maxLength: 400,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '概要を入力してください';
                }
                if (value.length > 400) {
                  return '概要は400文字以内で入力してください';
                }
                return null;
              },
            ),
          ),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.activeGreen,
        middle: const Text('出品する'),
      ),
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/register/外枠.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: _buildBody()),
    );
  }
}
