import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import 'items_list_view_page.dart';

/// アイデア登録ページ
class EditItemPage extends StatefulWidget {
  const EditItemPage({super.key, required this.editTarget});
  final Item editTarget;

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
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
    _ideaNameController.text = widget.editTarget.title;
    _ideaDescriptionController.text = widget.editTarget.description;
    _uploadedImageUrl = widget.editTarget.imageUrl;
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
  Future<void> _updateItemToDB() async {
    debugPrint('Sending message to Firestore');
    await FirebaseFirestore.instance
        .collection('idea_items')
        .doc(widget.editTarget.id)
        .set({
      'author': _userId,
      'title': _ideaNameController.text,
      'description': _ideaDescriptionController.text,
      'imageUrl': _uploadedImageUrl,
      'timestamp': Timestamp.now(),
    });
  }

  /// 登録ページのボディを生成する
  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('EditItemPage'),
          _buildForm(),
          CupertinoButton(
            child: const Text('投稿する'),
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
              await _updateItemToDB();
              // 更新処理が成功したら、一覧画面に戻る
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }

  /// アイデア修正フォームを生成する
  Widget _buildForm() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await selectImage();
            setState(() {});
          },
          child: Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              _uploadedImageUrl.isNotEmpty
                  ? _uploadedImageUrl
                  : "https://placehold.jp/72/c2c2c2/ffffff/150x150.png?text=%EF%BC%8B",
              width: 100,
              height: 100,
            ), // 画像が選択されていない場合はデフォルト画像を表示
          ),
        ),
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: CupertinoFormSection.insetGrouped(children: [
            CupertinoTextFormFieldRow(
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
            CupertinoTextFormFieldRow(
              controller: _ideaDescriptionController,
              placeholder:
                  '概要（400文字以内）\n\n\n\n\n\n\n', // placeholderの上寄せが指定できないので8行分の高さを確保する力技
              minLines: 8,
              maxLines: 8,
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
          ]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('アイデア登録'),
      ),
      child: _buildBody(),
    );
  }
}