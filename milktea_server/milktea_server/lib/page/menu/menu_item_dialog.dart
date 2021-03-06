import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milktea_server/common_widgets/dropdown_widget.dart';
import 'package:milktea_server/common_widgets/text_field_widget.dart';
import 'package:milktea_server/model/category_item_model.dart';
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
  List<CategoryItemModel> listCategory = [];

  @override
  void initState() {
    super.initState();
    _menuItemModel = widget.menuItemModel ?? MenuItemModel();
    nameController.text = _menuItemModel.name ?? '';
    priceController.text = _menuItemModel.price?.toString() ?? '';
    descriptionController.text = _menuItemModel.description ?? '';
    photoUrl = _menuItemModel.imageUrl ?? '';
    getListCategoryItem();
  }

  Future<void> getListCategoryItem() async {
    EasyLoading.show();
    DataSnapshot response =
        await FirebaseDatabase.instance.ref('category').get();
    EasyLoading.dismiss();
    List<CategoryItemModel> listCategoryItems = [];
    for (var element in response.children) {
      CategoryItemModel categoryItemModel =
          CategoryItemModel.fromJson(element.value);
      listCategoryItems.add(categoryItemModel);
    }
    setState(() {
      listCategory = listCategoryItems;
    });
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
            label: 'T??n s???n ph???m',
            hintText: '??i???n t??n s???n ph???m',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropDownWidget(
                  label: 'Lo???i s???n ph???m',
                  hintText: 'Ch???n lo???i s???n ph???m',
                  items: listCategory.map((e) => e.name ?? '').toList(),
                  initialValue: (_menuItemModel.type?.isNotEmpty ?? false)
                      ? _menuItemModel.type
                      : listCategory[0].name,
                  onSelect: (value) {
                    _menuItemModel.type = value;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFieldWidget(
                  controller: priceController,
                  label: 'Gi?? s???n ph???m',
                  hintText: '??i???n gi?? s???n ph???m',
                  suffixText: 'VND',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFieldWidget(
            controller: descriptionController,
            label: 'M?? t??? v??? m??n ??n',
            hintText: '??i???n m???t s??? th??ng tin v??? m??n ??n',
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
                  'Tho??t',
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
                      ToastUtils.showToast(msg: 'X??a th??nh c??ng.');
                      Navigator.pop(context);
                    } catch (e) {
                      EasyLoading.dismiss();
                      ToastUtils.showToast(msg: 'X??a th???t b???i, h??y th??? l???i.');
                    }
                  },
                  child: const Text(
                    'X??a',
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
                              '${widget.menuItemModel != null ? "C???p nh???t" : "T???o"} m??n th??nh c??ng.');
                      Navigator.pop(context);
                    } catch (e) {
                      EasyLoading.dismiss();
                      ToastUtils.showToast(
                        msg:
                            'C?? l???i trong vi???c ${widget.menuItemModel != null ? "c???p nh???t" : "t???o"} s???n ph???m n??y. Vui l??ng th??? l???i.',
                        isError: true,
                      );
                    }
                  } else {
                    ToastUtils.showToast(
                      msg: 'Vui l??ng ??i???n ?????y ????? th??ng tin.',
                      isError: true,
                    );
                  }
                },
                child: Text(
                  widget.menuItemModel == null ? 'T???o' : 'C???p nh???t',
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
