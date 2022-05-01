import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AdjustNumberWidget extends StatefulWidget {
  final int initValue;
  final Function(int) onChange;
  final double? iconSize;
  final bool isEditable;
  const AdjustNumberWidget({
    Key? key,
    this.initValue = 0,
    this.iconSize,
    required this.onChange,
    this.isEditable = true,
  }) : super(key: key);

  @override
  _AdjustNumberWidgetState createState() => _AdjustNumberWidgetState();
}

class _AdjustNumberWidgetState extends State<AdjustNumberWidget> {
  int _currentValue = 0;
  @override
  void initState() {
    super.initState();
    _currentValue = widget.initValue;
  }

  @override
  void didUpdateWidget(AdjustNumberWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initValue != widget.initValue) {
      setState(() {
        _currentValue = widget.initValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Row(
        children: [
          Visibility(
            visible: widget.isEditable,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                child: Icon(
                  Iconsax.minus,
                  size: widget.iconSize ?? 24,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() {
                    _currentValue--;
                    widget.onChange.call(_currentValue);
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              _currentValue.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 4),
          Visibility(
            visible: widget.isEditable,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                child: Icon(
                  Iconsax.add,
                  size: widget.iconSize ?? 24,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() {
                    _currentValue++;
                    widget.onChange.call(_currentValue);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
