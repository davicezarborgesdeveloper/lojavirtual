import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final User user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
              key: formKey,
              child: Consumer<UserManager>(
                builder: (_, userManager, ___) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: [
                      TextFormField(
                        enabled: !userManager.isLoggedIn,
                        decoration:
                            const InputDecoration(hintText: 'Nome Completo'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (name) {
                          if (name.isEmpty)
                            return 'Campo obrigatório';
                          else if (name.trim().split(' ').length <= 1)
                            return 'Preencha seu nome completo';
                          return null;
                        },
                        onSaved: (name) => user.name = name,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        enabled: !userManager.isLoggedIn,
                        decoration: const InputDecoration(hintText: 'E-mail'),
                        validator: (email) {
                          if (email.isEmpty)
                            return 'Campo obrigatório';
                          else if (!emailValid(email)) return 'E-mail inválido';
                          return null;
                        },
                        onSaved: (email) => user.email = email,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        enabled: !userManager.isLoggedIn,
                        decoration: const InputDecoration(hintText: 'Senha'),
                        obscureText: true,
                        validator: (pass) {
                          if (pass.isEmpty)
                            return 'Campo obrigatório';
                          else if (pass.length < 6) return 'Senha muito curta';
                          return null;
                        },
                        onSaved: (pass) => user.password = pass,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        enabled: !userManager.isLoggedIn,
                        decoration:
                            const InputDecoration(hintText: 'Repita a Senha'),
                        obscureText: true,
                        validator: (pass) {
                          if (pass.isEmpty)
                            return 'Campo obrigatório';
                          else if (pass.length < 6) return 'Senha muito curta';
                          return null;
                        },
                        onSaved: (pass) => user.confirmPassword = pass,
                      ),
                      const SizedBox(height: 16),
                      RaisedButton(
                        color: Theme.of(context).primaryColor,
                        disabledTextColor:
                            Theme.of(context).primaryColor.withAlpha(100),
                        textColor: Colors.white,
                        onPressed: userManager.loading
                            ? null
                            : () {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                  if (user.password != user.confirmPassword) {
                                    scaffoldKey.currentState
                                        .showSnackBar(const SnackBar(
                                      content: Text('Senhas não coincidem'),
                                      backgroundColor: Colors.red,
                                    ));
                                    return;
                                  }
                                  userManager.signUp(context,
                                      user: user,
                                      onSucess: () => Navigator.pop(context),
                                      onFail: (e) {
                                        scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text('Falha ao entrar $e'),
                                          backgroundColor: Colors.red,
                                        ));
                                      });
                                }
                              },
                        child: userManager.loading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : const Text(
                                'Criar Conta',
                                style: TextStyle(fontSize: 15),
                              ),
                      ),
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }
}
