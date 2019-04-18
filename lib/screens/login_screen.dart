import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "CRIAR CONTA",
                style: TextStyle(
                    fontSize: 15.0
                ),
              ),
              textColor: Colors.white,
              onPressed: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context)=>SignUpScreen())
                );
              },
            )
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
            builder: (context, child, model){
              if(model.isLoading)
                return Center(child: CircularProgressIndicator(),);
              return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "E-mail"
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text){
                        if(text.isEmpty || !text.contains("@")) return "E-mail inválido!";
                      },
                    ),
                    Divider(height: 16.0, color: Colors.transparent,),
                    TextFormField(
                      controller: _passController,
                      decoration: InputDecoration(
                          hintText: "Senha"
                      ),
                      obscureText: true,
                      validator: (text){
                        if(text.isEmpty || text.length < 6) return "Senha inválida";
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: (){
                          if(_emailController.text.isEmpty)
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text("Digite o e-mail cadastrado para recuperação"),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                )
                            );
                          else
                            model.recoverPass(_emailController.text, onFail: _onFailRecovery, onSuccess: _onSuccessRecovery);
                        },
                        child: Text("Esqueci minha senha", textAlign: TextAlign.right,),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    Divider(height: 16.0, color: Colors.transparent,),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text("Entrar",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          if(_formKey.currentState.validate()){
                            model.signIn(
                                email: _emailController.text,
                                pass: _passController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              );
            }
        )
    );
  }
  Future _onSuccess() async {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Usuário logado com sucesso!"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
    );
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pop();
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("O usuário ou a senha estão incorretas"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }

  void _onSuccessRecovery(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("E-mail com a recuperação da senha enviado com sucesso!"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
    );
  }

  void _onFailRecovery(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("E-mail não cadastrado"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}


