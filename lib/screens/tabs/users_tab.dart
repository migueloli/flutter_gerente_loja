import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gerente_loja/blocs/user_bloc.dart';
import 'package:flutter_gerente_loja/widgets/user_tile.dart';

class UsersTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _usersBloc = BlocProvider.getBloc<UserBloc>();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            onChanged: _usersBloc.onChangedSearch,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: "Pesquisar",
              hintStyle: TextStyle(
                color: Colors.white,
              ),
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List>(
            stream: _usersBloc.outUsers,
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).primaryColor
                  ),
                ),);
              }else if(snapshot.data.length == 0){
                return Center(
                  child: Text(
                    "Nenhum usuário encontrado.",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                );
              }else {
                return ListView.separated(
                  itemBuilder: (context, i) {
                    return UserTile(snapshot.data[i]);
                  },
                  separatorBuilder: (context, i) {
                    return Divider();
                  },
                  itemCount: snapshot.data.length,
                );
              }
            }
          ),
        )
      ],
    );
  }
}
