import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gerente_loja/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState {IDLE, LOAD, SUCCESS, FAIL}

class LoginBloc extends BlocBase with LoginValidators {

  final _emailController = BehaviorSubject<String>();
  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Function(String) get changeEmail => _emailController.sink.add;

  final _passController = BehaviorSubject<String>();
  Stream<String> get outPass => _passController.stream.transform(validatePass);
  Function(String) get changePass => _passController.sink.add;

  final _stateController = BehaviorSubject<LoginState>();
  Stream<LoginState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValid => Observable.combineLatest2(
    outEmail,
    outPass,
    (a, b) => true
  );

  StreamSubscription _streamSubscription;

  LoginBloc() {
    _streamSubscription = FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if(user != null){
        if(await verifyPrivileges(user)){
          _stateController.add(LoginState.SUCCESS);
        }else{
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.FAIL);
        }
      }else{
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  @override
  void dispose() {
    _emailController.close();
    _passController.close();
    _stateController.close();

    _streamSubscription.cancel();

    super.dispose();
  }

  void submit(){
    final email = _emailController.value;
    final password = _passController.value;

    _stateController.add(LoginState.LOAD);

    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
    ).catchError((e) {
      _stateController.add(LoginState.FAIL);
    });
  }

  Future<bool> verifyPrivileges(FirebaseUser user) async {
    return await Firestore.instance.collection("admin").document(user.uid).get().then((doc){
      if(doc.data != null){
        return true;
      }else{
        return false;
      }
    }).catchError((e) {
      return false;
    });
  }

}