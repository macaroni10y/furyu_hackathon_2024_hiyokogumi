import 'dart:io';

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
  String _uploadedImageUrl = '';

  /// 端末のカメラから画像を選択する
  /// 画像を選択したら、Firebase Storageにアップロードする
  /// アップロードが成功したら、アップロードした画像のURLを取得して状態(_uploadedImageUrl)として保持する
  Future<void> selectImage() async {
    final XFile? selectedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      print('Selected image path: ${selectedImage.path}');
      var imagePath =
          'images/TODO_firebase_userId/${DateTime.now()}.png'; // TODO firebaseのユーザーIDを取得して、そのIDを使って画像を保存する
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

  /// 登録ページのボディを生成する
  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('RegisterItemPage'),
          _buildForm(),
          CupertinoButton(
            child: const Text('投稿する'),
            onPressed: () {
              // バリデーションチェック
              if (!_formKey.currentState!.validate()) {
                return;
              }
              if (_uploadedImageUrl.isEmpty) {
                // 画像が選択されていない場合はエラーを表示
                return;
              }
              // TODO: 投稿処理を実装する
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
