import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milktea_server/common_widgets/dropdown_icon.dart';
import 'package:milktea_server/common_widgets/text_field_widget.dart';
import 'package:milktea_server/model/category_item_model.dart';
import 'package:milktea_server/utils/toast_utils.dart';

const listIcon = [
  Icons.cake,
  Icons.free_breakfast,
  Icons.local_cafe,
  Icons.local_bar,
  Icons.local_dining,
  Icons.local_drink,
  Icons.local_pizza,
  Icons.restaurant,
  Icons.restaurant_menu,
  Icons.room_service,
  Icons.widgets,
];

class CategoryItemDialog extends StatefulWidget {
  final CategoryItemModel? categoryItemModel;
  final DatabaseReference? categoryItemReference;
  const CategoryItemDialog(
      {Key? key, this.categoryItemModel, this.categoryItemReference})
      : super(key: key);

  @override
  _CategoryItemDialogState createState() => _CategoryItemDialogState();
}

class _CategoryItemDialogState extends State<CategoryItemDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late CategoryItemModel _categoryItemModel;

  @override
  void initState() {
    super.initState();
    _categoryItemModel = widget.categoryItemModel ?? CategoryItemModel();
    _categoryItemModel.icon ??= 0;
    nameController.text = _categoryItemModel.name ?? '';
    descriptionController.text = _categoryItemModel.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  controller: nameController,
                  label: 'Tên loại danh mục',
                  hintText: 'Điền tên danh mục',
                  readOnly: widget.categoryItemModel != null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropDownIconWidget(
                  label: 'Icon',
                  hintText: 'Chọn icon',
                  items: listIcon,
                  initialValue: listIcon[_categoryItemModel.icon ?? 0],
                  onSelect: (value) {
                    _categoryItemModel.icon =
                        listIcon.indexOf(value ?? listIcon[0]);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Đường',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Switch(
                      value: _categoryItemModel.isSugarOption,
                      onChanged: (value) {
                        setState(() {
                          _categoryItemModel.isSugarOption = value;
                        });
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Đá',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Switch(
                      value: _categoryItemModel.isIceOption,
                      onChanged: (value) {
                        setState(() {
                          _categoryItemModel.isIceOption = value;
                        });
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ],
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
                visible: widget.categoryItemReference != null,
                child: TextButton(
                  onPressed: () async {
                    try {
                      EasyLoading.show();
                      await widget.categoryItemReference?.remove();
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
                      nameController.text != '') {
                    EasyLoading.show();
                    try {
                      _categoryItemModel.description =
                          descriptionController.text;
                      _categoryItemModel.name = nameController.text;
                      if (widget.categoryItemModel != null) {
                        await widget.categoryItemReference
                            ?.update(_categoryItemModel.toJson());
                      } else {
                        DatabaseReference ref =
                            FirebaseDatabase.instance.ref('category');
                        await ref.push().set(_categoryItemModel.toJson());
                      }
                      EasyLoading.dismiss();
                      ToastUtils.showToast(
                          msg:
                              '${widget.categoryItemModel != null ? "Cập nhật" : "Tạo"} danh mục thành công.');
                      Navigator.pop(context);
                    } catch (e) {
                      EasyLoading.dismiss();
                      ToastUtils.showToast(
                        msg:
                            'Có lỗi trong việc ${widget.categoryItemModel != null ? "cập nhật" : "tạo"} danh mục này. Vui lòng thử lại.',
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
                  widget.categoryItemModel == null ? 'Tạo' : 'Cập nhật',
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
}
