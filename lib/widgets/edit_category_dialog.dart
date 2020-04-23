import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gerente_loja/blocs/category_bloc.dart';
import 'package:flutter_gerente_loja/widgets/image_source_sheet.dart';

class EditCategoryDialog extends StatefulWidget {

  final DocumentSnapshot category;

  EditCategoryDialog({this.category});

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState(
    category: category
  );
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {

  final CategoryBloc _categoryBloc;
  final TextEditingController _controller;

  _EditCategoryDialogState({DocumentSnapshot category}) :
        _categoryBloc = CategoryBloc(category),
        _controller = TextEditingController(
            text: category != null
                ? category.data['title']
                : ""
        );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => ImageSourceSheet(
                      onImageSelected: (image) {
                        Navigator.of(context).pop();
                        _categoryBloc.setImage(image);
                      },
                    )
                  );
                },
                child: StreamBuilder(
                    stream: _categoryBloc.outImage,
                    builder: (context, snapshot) {
                      if(snapshot.data != null) {
                        return CircleAvatar(
                          child: snapshot.data is File ?
                          Image.file(snapshot.data, fit: BoxFit.cover,) :
                          Image.network(snapshot.data, fit: BoxFit.cover,),
                          backgroundColor: Colors.transparent,
                        );
                      }

                      return Icon(Icons.image);
                    }
                ),
              ),
              title: StreamBuilder<String>(
                stream: _categoryBloc.outTitle,
                builder: (context, snapshot) {
                  return TextField(
                    controller: _controller,
                    onChanged: _categoryBloc.setTitle,
                    decoration: InputDecoration(
                      labelText: "Titulo",
                      errorText: snapshot.hasError ? snapshot.error : null
                    ),
                  );
                }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                StreamBuilder<bool>(
                    stream: _categoryBloc.outDelete,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return FlatButton(
                          child: Text("Excluir"),
                          textColor: Colors.red,
                          onPressed: !(snapshot.data) ? null
                              : () {
                                _categoryBloc.delete();
                                Navigator.of(context).pop();
                              },
                        );
                      }else{
                        return Container();
                      }
                    }
                ),
                StreamBuilder<bool>(
                  stream: _categoryBloc.submitValid,
                  builder: (context, snapshot) {
                    return FlatButton(
                      child: Text("Salvar"),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: snapshot.hasData ? null
                          : () async {
                            await _categoryBloc.saveData();
                            Navigator.of(context).pop();
                          },
                    );
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

