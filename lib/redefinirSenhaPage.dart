import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meu_onibus_app/API/Request_RedefinirSenha.dart';

class RedefinirSenhaPage extends StatefulWidget {
  const RedefinirSenhaPage({super.key});

  @override
  State<RedefinirSenhaPage> createState() => _RedefinirSenhaPageState();
}

class _RedefinirSenhaPageState extends State<RedefinirSenhaPage> {
  bool _isObscured = true;
  bool _isObscured2 = true;

  final _formkey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'A senha não pode estar vazia';
    if (value.length < 8) return 'A senha deve ter pelo menos 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(value))
      return 'A senha deve ter pelo menos uma letra maiúscula';
    if (!RegExp(r'[0-9]').hasMatch(value))
      return 'A senha deve ter pelo menos um número';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value))
      return 'A senha deve ter pelo menos um caractere especial';
    return null;
  }

  void _resetPassword() async {
    if (_formkey.currentState!.validate()) {
      if (_passwordController.text == _confirmPasswordController.text) {
        await Request_DefinirSenha()
            .redefinirSenha(_passwordController.text, context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('As senhas não coincidem!')),
        );
      }
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Minimizar o teclado quando tocar em qualquer área da tela
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Redefinição de Senha",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                          controller: _passwordController,
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                            hintText: "Nova senha",
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
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          validator: _validatePassword),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _isObscured2,
                        decoration: InputDecoration(
                          hintText: "Confirmar senha",
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
                                _isObscured2 = !_isObscured2;
                              });
                            },
                            child: Icon(
                              _isObscured2
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        validator: (senha) {
                          if (senha == null || senha.isEmpty)
                            return 'Confirme a senha';
                          if (senha != _passwordController.text)
                            return 'As senhas não coincidem';
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
                                "Redefinir ",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () => {_resetPassword()})),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: const Text(
                          "Caso não consiga redefinir a senha,fale com sua Instituição de ensino.",
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
}
