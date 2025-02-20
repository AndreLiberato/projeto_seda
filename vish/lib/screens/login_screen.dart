import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../screens/register_acc_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool? isChecked = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _disableOnBoarding();
  }

  void _disableOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool("firstTimeAppUsage", false);
  }

  login() async {
    setState(() => loading = true);
    try {
      await context
          .read<AuthProvider>()
          .login(emailController.text, passwordController.text)
          .then((_) {
        if (Provider.of<AuthProvider>(context, listen: false).user != null) {
          _saveLoginInfo();
          Navigator.of(context).pushReplacementNamed("/home-screen");
        }
      });
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  void _saveLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool("loggedIn", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.cover,
                height: 350.0,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 40.0, left: 15.0),
                child: Text(
                  "Seja Bem Vindo!",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 35.0, left: 15.0, right: 15.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    iconColor: const Color.fromARGB(255, 232, 236, 242),
                    hintText: "Informe o seu e-mail",
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 232, 236, 242),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 3, color: Color.fromARGB(255, 250, 102, 46)),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 3, color: Color.fromARGB(255, 232, 236, 242)),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.redAccent),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    contentPadding:
                        const EdgeInsets.only(bottom: 20, top: 20, right: 15),
                  ),
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.black, fontSize: 18.0),
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Insira seu e-mail!";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 35.0, left: 15.0, right: 15.0),
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }),
                    iconColor: const Color.fromARGB(255, 232, 236, 242),
                    hintText: "Informe sua senha",
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 232, 236, 242),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 3, color: Color.fromARGB(255, 250, 102, 46)),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 3, color: Color.fromARGB(255, 232, 236, 242)),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.redAccent),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    contentPadding:
                        const EdgeInsets.only(bottom: 20, top: 20, right: 15),
                  ),
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.black, fontSize: 18.0),
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Insira sua senha!";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 10.0, left: 15.0, right: 15.0),
                child: SizedBox(
                  height: 60.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 250, 102, 46),
                        textStyle: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "ENTRAR",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: CheckboxListTile(
                    title: const Text(
                      "Continuar conectado",
                      style: TextStyle(color: Colors.black54),
                    ),
                    value: isChecked,
                    activeColor: const Color.fromARGB(255, 250, 102, 46),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (newBool) {
                      setState(() {
                        isChecked = newBool;
                      });
                    }),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Esqueceu a senha?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 250, 102, 46),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Não tem uma conta?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _redirect();
                    },
                    child: const Text(
                      "Cadastre-se",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 250, 102, 46),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _redirect() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterAccountScreen(),
      ),
    );
  }
}
