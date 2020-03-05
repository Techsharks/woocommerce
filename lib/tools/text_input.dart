import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final Icon icon;
  final String text;
  var onChanged;
  var onSaved;
  bool obscureText;
  bool divider;
  TextEditingController textEditingController;
  FormFieldValidator<String> validator;
  int minLength;
  TextInputType textInputType;
  String initialValue;
  bool isRequired;

  TextInput({
    Key key,
    this.icon,
    this.text,
    this.onChanged,
    this.onSaved,
    this.obscureText: false,
    this.divider: true,
    this.textEditingController: null,
    this.validator: null,
    this.minLength: 0,
    this.textInputType: TextInputType.text,
    this.initialValue: null,
    this.isRequired: true,
  }) : super(key: key);

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return new Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colors.black,
        ),
        child: Column(
          children: <Widget>[
            new TextFormField(
              controller: widget.textEditingController,
              onSaved: widget.onSaved,
              onChanged: widget.onChanged,
              obscureText: widget.obscureText,
              keyboardType: widget.textInputType,
              initialValue: widget.initialValue,
              validator: (widget.validator == null)
                  ? (value) {
                      if (!widget.isRequired) return null;
                      if (value.isEmpty) {
                        return '${widget.text} را وارد کنید';
                      } else if (widget.minLength != 0 && value.length < widget.minLength) {
                        return '${widget.text} کوتاه می باشد';
                      }
                      return null;
                    }
                  : widget.validator,
              decoration: new InputDecoration(
                icon: widget.icon,
                border: InputBorder.none,
                hintText: '${widget.text}',
              ),
            ),
            (widget.divider) ? new Divider(color: Colors.grey[900]) : new Container(width: 0, height: 0)
          ],
        ));
  }
}
