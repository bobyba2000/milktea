import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milktea_server/common_widgets/text_field_widget.dart';
import 'package:milktea_server/utils/toast_utils.dart';

class ChangePassDialog extends StatefulWidget {
  const ChangePassDialog({Key? key}) : super(key: key);

  @override
  _ChangePassDialogState createState() => _ChangePassDialogState();
}

class _ChangePassDialogState extends State<ChangePassDialog> {
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _rePassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldWidget(
            controller: _newPassController,
            label: 'Mật khẩu mới',
            hintText: 'Nhập mật khẩu mới của bạn',
            isPassword: true,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            controller: _rePassController,
            label: 'Nhập lại mật khẩu mới',
            hintText: 'Nhập lại mật khẩu mới của bạn',
            isPassword: true,
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
                  if (_newPassController.text == _rePassController.text) {
                    EasyLoading.show();
                    User? user = FirebaseAuth.instance.currentUser;
                    try {
                      EasyLoading.dismiss();
                      await user?.updatePassword(_newPassController.text);
                      ToastUtils.showToast(
                        msg: 'Mật khẩu đã được đổi',
                      );
                      Navigator.pop(context);
                      return;
                    } on FirebaseAuthException catch (e) {
                      EasyLoading.dismiss();
                      debugPrint(e.toString());
                      if (e.code == 'weak-password') {
                        ToastUtils.showToast(
                          msg: 'Mật khẩu yếu, hãy thử lại',
                          isError: true,
                        );
                      } else if (e.code == 'requires-recent-login') {
                        ToastUtils.showToast(
                          msg: 'Đăng nhập lại',
                          isError: true,
                        );
                        FirebaseAuth.instance.signOut();
                      }
                    } catch (e) {
                      EasyLoading.dismiss();
                      ToastUtils.showToast(
                        msg: 'Đã có lỗi, mời nhập lại.',
                        isError: true,
                      );
                    }
                  }
                },
                child: Text(
                  'Đổi mật khẩu',
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
}
