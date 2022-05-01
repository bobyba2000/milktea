import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SearchWidget extends StatefulWidget {
  final String? hintTextSearch;
  final int? flex;
  final Function(String?)? onSearch;
  const SearchWidget({
    Key? key,
    this.onSearch,
    this.flex,
    this.hintTextSearch,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  InputBorder _inputBorder(Color color) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      );
  String? _value;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex ?? 1,
      child: FormBuilderTextField(
        name: '',
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Color.fromRGBO(41, 35, 63, 1.0),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        maxLength: 500,
        initialValue: _value,
        onChanged: (value) {
          setState(() {
            _value = value;
          });
          EasyDebounce.debounce(
              'debounceTagSearch',
              const Duration(milliseconds: 700),
              () => widget.onSearch?.call(value));
        },
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          border: _inputBorder(Colors.transparent),
          enabledBorder: _inputBorder(Colors.transparent),
          focusedBorder: _inputBorder(Theme.of(context).primaryColor),
          errorBorder: _inputBorder(Colors.red),
          focusedErrorBorder: _inputBorder(Colors.transparent),
          disabledBorder: _inputBorder(Colors.transparent),
          counterText: '',
          hintText: widget.hintTextSearch,
          hintStyle: const TextStyle(
            color: Color.fromRGBO(41, 35, 63, 0.5),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
