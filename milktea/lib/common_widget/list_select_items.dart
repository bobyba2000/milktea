import 'package:flutter/material.dart';

class ListSelectItemWidget extends StatefulWidget {
  final String title;
  final List<String> listOptions;
  final List<String>? listPrices;
  final int initValue;
  final bool isShowSubtitle;
  final Function(String) onChange;
  const ListSelectItemWidget({
    Key? key,
    required this.title,
    required this.listOptions,
    this.listPrices,
    this.initValue = 0,
    required this.onChange,
    this.isShowSubtitle = true,
  }) : super(key: key);

  @override
  _ListSelectItemWidgetState createState() => _ListSelectItemWidgetState();
}

class _ListSelectItemWidgetState extends State<ListSelectItemWidget> {
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          itemCount: widget.listOptions.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedValue = index;
                widget.onChange.call(widget.listOptions[index]);
              });
            },
            child: ItemOption(
              label: widget.listOptions[index],
              subTitle: !widget.isShowSubtitle
                  ? ''
                  : widget.listPrices?[index] ?? '0 VND',
              value: _selectedValue == index,
            ),
          ),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
        )
      ],
    );
  }
}

class ItemOption extends StatelessWidget {
  final String label;
  final bool value;
  final String? subTitle;
  const ItemOption({
    Key? key,
    required this.label,
    this.value = false,
    this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        value ? Theme.of(context).primaryColor : Colors.black,
                  ),
                  color: Colors.white,
                ),
                width: 20,
                height: 20,
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value ? Theme.of(context).primaryColor : null,
                  ),
                  height: 8,
                  width: 8,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subTitle ?? '',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.end,
                ),
              )
            ],
          ),
          const SizedBox(height: 4),
          Divider(
            color: Theme.of(context).primaryColor.withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}
