import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';

import '../../common_widget/text_field_widget.dart';
import '../../utils/toast_utils.dart';

class UserChangePassPage extends StatefulWidget {
  const UserChangePassPage({Key? key}) : super(key: key);

  @override
  _UserChangePassPageState createState() => _UserChangePassPageState();
}

class _UserChangePassPageState extends State<UserChangePassPage> {
  late TextEditingController newPassController;
  late TextEditingController rePassController;

  @override
  void initState() {
    super.initState();
    newPassController = TextEditingController();
    rePassController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Đổi mật khẩu của bạn',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Iconsax.arrow_left,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextFieldWidget(
                        label: 'Mật khẩu mới',
                        controller: newPassController,
                        isPassword: true,
                        hintText: 'Nhập mật khẩu mới',
                      ),
                      const SizedBox(height: 12),
                      TextFieldWidget(
                        label: 'Nhập lại',
                        controller: rePassController,
                        isPassword: true,
                        hintText: 'Nhập mật khẩu mới lại',
                      ),
                      const SizedBox(height: 40),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).primaryColor,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        width: double.infinity,
                        child: InkWell(
                          child: const Text(
                            'Lưu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onTap: () async {
                            if (newPassController.text ==
                                rePassController.text) {
                              EasyLoading.show();
                              User? user = FirebaseAuth.instance.currentUser;
                              try {
                                await user
                                    ?.updatePassword(newPassController.text);
                                EasyLoading.dismiss();
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
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
