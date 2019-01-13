import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

class BoxedTextField extends StatefulWidget {
  final TextStyle hintTextStyle;
  final String hintText;
  final TextStyle textStyle;
  final double boxWidth;
  final int maxLines;
  final bool alignRight;
  final InputBorder border;
  final TextEditingController controller;

  const BoxedTextField({
    Key key,
    this.hintText = "",
    @required this.textStyle,
    this.boxWidth = 100.0,
    this.maxLines = 1,
    this.alignRight = false,
    this.border = InputBorder.none,
    this.controller,
    this.hintTextStyle,
  }) : super(key: key);

  @override
  _BoxedTextFieldState createState() => new _BoxedTextFieldState();
}

class _BoxedTextFieldState extends State<BoxedTextField>
    with AfterLayoutMixin<BoxedTextField> {
  String _text = "";
  FocusNode _textfocusNode = new FocusNode();
  TextStyle _hintTextStyle;

  bool _hintTextVisible = true;
  double _contentPadding = 0.0;

  double calcPadding(double width) =>
      (width > widget.boxWidth) ? 0.0 : (widget.boxWidth - width);
  void _centerCursor() {
    setState(() {
      _contentPadding =
          _text.length == 0 ? calcPadding(_getTextWidth("i", false)) : _contentPadding;
          //Because "i" is the thinnest
    });
  }

  double _getTextWidth(String text, bool isHint) {
    TextPainter tp = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: isHint?_hintTextStyle:widget.textStyle));
    tp.layout();
    return tp.size.width;
  }

  void _adjustPadding(String input) {
    if (input.length == 0) {
      setState(() {
        _text = input;
        _contentPadding = calcPadding(_getTextWidth("i", false));
      });
    } else {
      setState(() {
        _text = input;
        _contentPadding = calcPadding(
            _getTextWidth(widget.maxLines > 1 ? "W" + input : input, false));
        //New line being buggy with multi lines Text Field
      });
    }
  }

  @override
  void initState() {
    _hintTextStyle = widget.hintTextStyle??TextStyle(fontSize: widget.textStyle.fontSize);
    _text = "";
    _textfocusNode.addListener(() {
      if (!_textfocusNode.hasFocus) {
        if (_text.length == 0) {
          setState(() {
            _contentPadding = calcPadding(_getTextWidth(widget.hintText, true));
            _hintTextVisible = true;
          });
        }
      } else {
        setState(() {
          _hintTextVisible = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      height: (widget.textStyle.fontSize * widget.maxLines) + 2.0,
      width: widget.boxWidth,
      child: TextField(
        controller: widget.controller,
        maxLines: widget.maxLines,
        style: widget.textStyle,
        focusNode: _textfocusNode,
        onTap: _centerCursor,
        onSubmitted: _adjustPadding,
        onChanged: (value) {
          _adjustPadding(value);
        },
        decoration: new InputDecoration(
            border: widget.border,
            contentPadding: widget.alignRight
                ? EdgeInsets.only(left: _contentPadding - (_text.length==0?_hintTextStyle.fontSize:widget.textStyle.fontSize))
                : EdgeInsets.symmetric(horizontal: _contentPadding / 2),
            hintText: _hintTextVisible ? widget.hintText : '',
            hintStyle: _hintTextStyle),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      _contentPadding = calcPadding(_getTextWidth(widget.hintText, true));
    });
  }
}
