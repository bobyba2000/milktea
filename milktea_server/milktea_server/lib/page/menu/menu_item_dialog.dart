import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milktea_server/common_widgets/dropdown_widget.dart';
import 'package:milktea_server/common_widgets/text_field_widget.dart';
import 'package:milktea_server/model/menu_item_model.dart';
import 'package:milktea_server/utils/toast_utils.dart';

import '../../common_widgets/network_image_widget.dart';
import '../../utils/storage_service.dart';

class MenuItemDialog extends StatefulWidget {
  final MenuItemModel? menuItemModel;
  final DatabaseReference? menuItemReference;
  const MenuItemDialog({Key? key, this.menuItemModel, this.menuItemReference})
      : super(key: key);

  @override
  _MenuItemDialogState createState() => _MenuItemDialogState();
}

class _MenuItemDialogState extends State<MenuItemDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late MenuItemModel _menuItemModel;
  bool isImageLocal = false;
  Uint8List bytes = Uint8List(0);
  String photoUrl = '';

  @override
  void initState() {
    super.initState();
    _menuItemModel = widget.menuItemModel ?? MenuItemModel();
    nameController.text = _menuItemModel.name ?? '';
    priceController.text = _menuItemModel.price?.toString() ?? '';
    descriptionController.text = _menuItemModel.description ?? '';
    photoUrl = _menuItemModel.imageUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildImageWidget(),
          const SizedBox(height: 24),
          TextFieldWidget(
            controller: nameController,
            label: 'Tên sản phẩm',
            hintText: 'Điền tên sản phẩm',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropDownWidget(
                  label: 'Loại sản phẩm',
                  hintText: 'Chọn loại sản phẩm',
                  items: const ['Cake', 'Drink', 'Smoothie', "Other"],
                  initialValue: _menuItemModel.type,
                  onSelect: (value) {
                    _menuItemModel.type = value;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFieldWidget(
                  controller: priceController,
                  label: 'Giá sản phẩm',
                  hintText: 'Điền giá sản phẩm',
                  suffixText: 'VND',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFieldWidget(
            controller: descriptionController,
            label: 'Mô tả về món ăn',
            hintText: 'Điền một số thông tin về món ăn',
            maxLines: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Thoát',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Visibility(
                visible: widget.menuItemReference != null,
                child: TextButton(
                  onPressed: () async {
                    try {
                      EasyLoading.show();
                      await widget.menuItemReference?.remove();
                      EasyLoading.dismiss();
                      ToastUtils.showToast(msg: 'Xóa thành công.');
                      Navigator.pop(context);
                    } catch (e) {
                      EasyLoading.dismiss();
                      ToastUtils.showToast(msg: 'Xóa thất bại, hãy thử lại.');
                    }
                  },
                  child: const Text(
                    'Xóa',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () async {
                  if (descriptionController.text != '' &&
                      priceController.text != '' &&
                      nameController.text != '' &&
                      (bytes.isNotEmpty || photoUrl != '')) {
                    EasyLoading.show();
                    try {
                      if (isImageLocal) {
                        photoUrl = await Storage.uploadFile(
                              bytes,
                              '${DateTime.now().toString()}.png',
                              '/food_image',
                            ) ??
                            photoUrl;
                      }
                      _menuItemModel.description = descriptionController.text;
                      _menuItemModel.imageUrl = photoUrl;
                      _menuItemModel.name = nameController.text;
                      _menuItemModel.price = int.tryParse(priceController.text);
                      if (widget.menuItemModel != null) {
                        await widget.menuItemReference
                            ?.update(_menuItemModel.toJson());
                      } else {
                        DatabaseReference ref =
                            FirebaseDatabase.instance.ref('menu');
                        await ref.push().set(_menuItemModel.toJson());
                      }
                      EasyLoading.dismiss();
                      ToastUtils.showToast(
                          msg:
                              '${widget.menuItemModel != null ? "Cập nhật" : "Tạo"} món thành công.');
                      Navigator.pop(context);
                    } catch (e) {
                      EasyLoading.dismiss();
                      ToastUtils.showToast(
                        msg:
                            'Có lỗi trong việc ${widget.menuItemModel != null ? "cập nhật" : "tạo"} sản phẩm này. Vui lòng thử lại.',
                        isError: true,
                      );
                    }
                  } else {
                    ToastUtils.showToast(
                      msg: 'Vui lòng điền đầy đủ thông tin.',
                      isError: true,
                    );
                  }
                },
                child: Text(
                  widget.menuItemModel == null ? 'Tạo' : 'Cập nhật',
                  style: const TextStyle(
                    color: Colors.blue,
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
