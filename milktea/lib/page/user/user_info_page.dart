import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:milktea/bloc/user_info_bloc.dart';
import 'package:milktea/common_widget/network_image_widget.dart';
import 'package:milktea/common_widget/text_field_widget.dart';
import 'package:milktea/utils/toast_utils.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late UserInfoBloc bloc;
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    bloc = UserInfoBloc(const UserInfoState())..getUserInfo();
    nameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<UserInfoBloc>(
          create: (_) => bloc,
          child: BlocListener<UserInfoBloc, UserInfoState>(
            listener: (context, state) {},
            child: BlocBuilder<UserInfoBloc, UserInfoState>(
                bloc: bloc,
                builder: (context, state) {
                  nameController.text = state.name ?? '';
                  emailController.text = state.email ?? '';
                  return Column(
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
                                    'Cập nhật thông tin cá nhân',
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
                                buildImageWidget(state),
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
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
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
                                      EasyLoading.show();
                                      await bloc.updateUserInfo(
                                        name: nameController.text,
                                      );
                                      EasyLoading.dismiss();
                                      ToastUtils.showToast(
                                        msg: 'Cập nhật thông tin thành công',
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget buildImageWidget(UserInfoState state) {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png', 'jpeg'],
        );
        if (result != null) {
          bloc.updatePhotoUrl(
              result.files.single.path ?? '', nameController.text);
        }
      },
      child: SizedBox(
        height: 120,
        width: 120,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(60)),
          child: state.isImageLocal
              ? Image.file(
                  File(state.photoUrl ?? ''),
                  fit: BoxFit.cover,
                )
              : NetworkImageWidget(url: state.photoUrl),
        ),
      ),
    );
  }
}
