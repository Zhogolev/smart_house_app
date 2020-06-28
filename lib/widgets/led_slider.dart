import 'package:flutter/cupertino.dart';

typedef LedSliderValueChangeCallback = void Function(int value);

class LedSlider extends StatefulWidget {
  final LedSliderValueChangeCallback onSliderValueChange;
  final double initValue;

  const LedSlider({Key key, @required this.onSliderValueChange, this.initValue = 0})
      : super(key: key);

  @override
  LedSliderState createState() => LedSliderState();
}

class LedSliderState extends State<LedSlider> {
  double value;
  bool isActive = false;

  @override
  void didUpdateWidget(LedSlider oldWidget) {
    if(widget.initValue != oldWidget.initValue && !isActive && value != widget.initValue){
      value = widget.initValue;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    value = widget.initValue.toDouble();
  }

  void _onSliderValueChanged(double newValue) => setState(() {
        if (mounted) {
          value = newValue;
          widget.onSliderValueChange(value.floor());
        }
      });

  @override
  Widget build(BuildContext context) {
    return CupertinoSlider(
      min: 0,
      max: 255,
      value: value,
      onChangeStart: _onSliderValueChangeStart,
      onChangeEnd: _onSliderValueChangedEnd,
      onChanged: _onSliderValueChanged,
    );
  }

  void _onSliderValueChangedEnd(double value) {
    isActive = false;
  }

  void _onSliderValueChangeStart(double value) {
    isActive = true;
  }
}
