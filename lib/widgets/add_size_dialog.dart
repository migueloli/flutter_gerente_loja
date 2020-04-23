import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 2, left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Tamanho"
                  ),
                  controller: _controller,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 4, bottom: 8, left: 16, right: 0),
                alignment: Alignment.centerRight,
                child: FlatButton(
                  child: Text("ADD"),
                  textColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pop(_controller.text);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
