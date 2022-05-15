import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DropDownIconWidget extends StatelessWidget {
  final String? hintText;
  final bool readOnly;
  final List<IconData> items;
  final String label;
  final IconData? initialValue;
  final Function(IconData?) onSelect;
  InputBorder _inputBorder(Color color) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      );
  const DropDownIconWidget({
    Key? key,
    this.readOnly = false,
    this.hintText,
    required this.label,
    this.initialValue,
    required this.items,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 4),
        FormBuilderDropdown<IconData>(
          name: '',
          style: const TextStyle(
            color: Color.fromRGBO(41, 35, 63, 1.0),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          onChanged: (value) {
            onSelect.call(value);
          },
          initialValue: initialValue,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            border: _inputBorder(Colors.transparent),
            enabledBorder: _inputBorder(Colors.transparent),
            focusedBorder: _inputBorder(const Color.fromRGBO(245, 179, 66, 1)),
            errorBorder: _inputBorder(Colors.red),
            focusedErrorBorder: _inputBorder(Colors.transparent),
            disabledBorder: _inputBorder(Colors.transparent),
            counterText: '',
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color.fromRGBO(41, 35, 63, 0.5),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem<IconData>(
                  child: Icon(
                    e,
                  ),
                  value: e,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
