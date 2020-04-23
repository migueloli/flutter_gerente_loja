import 'package:flutter/material.dart';
import 'package:flutter_gerente_loja/blocs/login_bloc.dart';
import 'package:flutter_gerente_loja/screens/home_screen.dart';
import 'package:flutter_gerente_loja/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      switch(state){
        case LoginState.SUCCESS:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HomeScreen())
          );
          break;
        case LoginState.FAIL:
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Erro"),
              content: Text("Você não possui os privilégios necessários."),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  textColor: Theme.of(context).primaryColor,
                )
              ],
            )
          );
          break;
        default:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        initialData: LoginState.LOAD,
        builder: (context, snapshot) {
          switch(snapshot.data) {
            case LoginState.LOAD:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Theme
                      .of(context)
                      .primaryColor),),
              );
            default:
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(),
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.store_mall_directory,
                            color: Theme
                                .of(context)
                                .primaryColor,
                            size: 160,
                          ),
                          InputField(
                            icon: Icons.person_outline,
                            hint: "Usuário",
                            obscure: false,
                            stream: _loginBloc.outEmail,
                            onChanged: _loginBloc.changeEmail,
                          ),
                          InputField(
                            icon: Icons.lock_outline,
                            hint: "Senha",
                            obscure: true,
                            stream: _loginBloc.outPass,
                            onChanged: _loginBloc.changePass,
                          ),
                          SizedBox(height: 32,),
                          StreamBuilder<bool>(
                              stream: _loginBloc.outSubmitValid,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  height: 50,
                                  child: RaisedButton(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    disabledColor: Theme
                                        .of(context)
                                        .primaryColor
                                        .withAlpha(140),
                                    child: Text(
                                      "Entrar",
                                    ),
                                    onPressed: snapshot.hasData ? _loginBloc
                                        .submit : null,
                                    textColor: Colors.white,
                                  ),
                                );
                              }
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
          }
        }
      ),
    );
  }
}
