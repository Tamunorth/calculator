import 'package:calaculator/widgets/button_array.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

TextEditingController _controller;

String question = '';
bool _textFieldFocus = true;

class _HomePageState extends State<HomePage> {
  final List<String> items = [
    'C',
    '()',
    '%',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '+/-',
    '0',
    '.',
    '=',
  ];

  void _insertText(String myText) {
    final text = _controller.text;
    final textSelection = _controller.selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    final myTextLength = myText.length;
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
  }

  void _backspace() {
    final text = _controller.text;
    final textSelection = _controller.selection;
    final selectionLength = textSelection.end - textSelection.start;
    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      _controller.text = newText;
      _controller.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return;
    }
    // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return;
    }
    // Delete the previous character
    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 0)),
                        BoxShadow(
                            color: Colors.black,
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: Offset(5, 5)),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            textAlign: TextAlign.end,
                            showCursor: true,
                            cursorColor: Theme.of(context).accentColor,
                            maxLines: null,
                            controller: _controller,
                            autofocus: _textFieldFocus,
                            readOnly: true,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 50.0,
                            ),
                          ),
                        ),
                        question == ''
                            ? SizedBox.shrink()
                            : Expanded(
                                flex: 1,
                                child: Text(
                                  question,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50.0,
                                  ),
                                )),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  children: List.generate(20, (index) {
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ButtonArray(
                        items: items,
                        index: index,
                        onTextInput: (myText) {
                          _insertText(myText);
                        },
                        onBackspace: _backspace,
                        onTextComplete: () {
                          String ans = _controller.text.interpret().toString();
                          setState(() {
                            question = '= $ans';
                          });
                          print(ans);
                        },
                        clearFunction: () {
                          setState(() {
                            question = '';
                          });
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
