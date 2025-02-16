import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meu_onibus_app/Models/Usuario.dart';
import 'package:email_validator/email_validator.dart';
import 'package:meu_onibus_app/API/Request_Auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Minimizar o teclado quando tocar em qualquer área da tela
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(27),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF9800), Colors.yellow],
                ),
              ),
              child: Form(
                key: _formkey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        child: Hero(
                          tag: 'logo',
                          child: Image.asset('assets/images/bus.png'),
                        ),
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Digite o seu E-mail",
                          hintStyle:
                              TextStyle(color: Colors.black38, fontSize: 14),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return "O e-mail é obrigatório";
                          } else if (!EmailValidator.validate(email)) {
                            return "Por favor, insira um e-mail válido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _senhaController,
                        obscureText: _isObscured,
                        decoration: InputDecoration(
                          hintText: "Digite sua senha",
                          hintStyle: const TextStyle(
                              color: Colors.black38, fontSize: 14),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                            child: Icon(
                              _isObscured
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        validator: (senha) {
                          if (senha == null || senha.isEmpty) {
                            return "A senha é obrigatória";
                          } else if (senha.length < 4) {
                            return "A senha deve ter pelo menos 4 caracteres";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          color: Colors.greenAccent,
                          child: const Text(
                            "Login ",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              Usuario date = (
                                _emailController.text,
                                _senhaController.text
                              );
                              bool login =
                                  await Request_Auth().login(date, context);

                              FocusScope.of(context).unfocus();

                              if (!login) {
                                _senhaController.clear();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    'E-mail ou Senha Incorreto!!!',
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ));
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: const Text(
                          "Caso não tenha acesso,solicite seu cadastro em sua Instituição de ensino.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
              )),
        ));
  }

  void logIn() async {
    Usuario date = (_emailController.text, _senhaController.text);
    await Request_Auth().login(date, context);
  }
}
