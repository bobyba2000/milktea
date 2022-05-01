import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milktea_server/common_widgets/network_image_widget.dart';
import 'package:milktea_server/common_widgets/text_field_widget.dart';
import 'package:milktea_server/utils/storage_service.dart';
import 'package:milktea_server/utils/toast_utils.dart';

class UserInfoDialog extends StatefulWidget {
  const UserInfoDialog({Key? key}) : super(key: key);

  @override
  _UserInfoDialogState createState() => _UserInfoDialogState();
}

class _UserInfoDialogState extends State<UserInfoDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isImageLocal = false;
  Uint8List bytes = Uint8List(0);
  String photoUrl = '';

  @override
  void initState() {
    super.initState();
    nameController.text = FirebaseAuth.instance.currentUser?.displayName ?? '';
    emailController.text = FirebaseAuth.instance.currentUser?.email ?? '';
    photoUrl = FirebaseAuth.instance.currentUser?.photoURL ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildImageWidget(),
          const SizedBox(height: 12),
          TextFieldWidget(
            label: 'Email',
            controller: emailController,
            hintText: 'Email',
            readOnly: true,
          ),
          const SizedBox(height: 12),
          TextFieldWidget(
            label: 'User Name',
            controller: nameController,
            hintText: 'User Name',
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Hủy',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () async {
                  EasyLoading.show();
                  try {
                    await FirebaseAuth.instance.currentUser
                        ?.updateDisplayName(nameController.text);
                    if (isImageLocal) {
                      String url = await Storage.uploadFile(
                            bytes,
                            '${DateTime.now().toString()}.png',
                            '/user_image',
                          ) ??
                          '';
                      await FirebaseAuth.instance.currentUser
                          ?.updatePhotoURL(url);
                    }
                    EasyLoading.dismiss();
                    ToastUtils.showToast(msg: 'Cập nhật thành công.');
                  } catch (e) {
                    EasyLoading.dismiss();
                    debugPrint(e.toString());
                    ToastUtils.showToast(
                      msg: 'Cập nhật thông tin thất bại. Vui lòng thử lại.',
                      isError: true,
                    );
                  }
                },
                child: Text(
                  'Lưu thông tin',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildImageWidget() {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png'],
        );
        if (result != null) {
          setState(() {
            bytes = result.files.single.bytes ?? Uint8List(0);
            isImageLocal = true;
          });
        }
      },
      child: SizedBox(
        height: 120,
        width: 120,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(60)),
          child: isImageLocal
              ? Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                )
              : NetworkImageWidget(url: photoUrl),
        ),
      ),
    );
  }
}
