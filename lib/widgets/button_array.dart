import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class ButtonArray extends StatelessWidget {
  ButtonArray({
    @required this.items,
    this.index,
    this.onTextInput,
    this.onBackspace,
    this.onTextComplete,
    this.clearFunction,
  });

  final List<String> items;
  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;
  final Function onTextComplete;
  final index;
  final clearFunction;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      containedInkWell: true,
      onTap: () {
        switch (index) {
          case 0:
            onBackspace?.call();
            break;
          case 1:
            return;
            break;
          case 2:
            return;
            break;
          case 16:
            return;
            break;
          case 19:
            onTextComplete.call();
            break;
          default:
            onTextInput?.call(items[index]);
        }
      },
      onLongPress: clearFunction,
      child: Container(
        decoration: BoxDecoration(
            color: index == 19
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor,
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
        child: Center(
          child: Text(
            items[index],
            style: TextStyle(
              color: index == 19 ? Colors.black : Theme.of(context).accentColor,
              fontSize: 25.0,
            ),
          ),
        ),
      ),
    );
  }
}
