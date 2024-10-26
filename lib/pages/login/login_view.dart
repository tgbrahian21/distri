import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vista_practica/pages/pagina_main.dart';
import 'package:vista_practica/provider/login_provider.dart';
import 'package:vista_practica/services/local_storage.dart';
import 'package:vista_practica/services/push_notification.dart';
import 'package:vista_practica/utils/app_colors.dart';
import 'package:vista_practica/utils/showsnacbar.dart';
import 'package:vista_practica/validators/validator.dart';
import 'package:vista_practica/widgets/button_decoration_widget.dart';
import 'package:vista_practica/widgets/circularprogress_widget.dart';
import 'package:vista_practica/widgets/imput_decoration_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;
  static String? token;

  @override
  void initState() {
    super.initState();
    token = PushNotificationService.token;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailOrEmailController.dispose();
    _passwordController.dispose();
  }


  //loguear el usuario
  void onFormLogin(
    String usernameOrEmail,
    String password,
    context,
  ) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final String usernameOrEmailLower = usernameOrEmail.toLowerCase();

      loginProvider.LoginUser(
          usernameOrEmail: usernameOrEmailLower,
          password: password,
          onSuccess: () async {

          //verificar si el usuario a verificado su cuenta
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null && user.emailVerified) {
            //si el usuario ha verificado su cuenta
            setState(() {
              _isLoading = false;
            });

          dynamic userData = await loginProvider.getUserData(user.email!);

          //guardar los datos del usuario en el local storage
          await LocalStorage().saveUserData(_emailOrEmailController.text, _passwordController.text);
          //guardar el estado de inicio de sesion
          await LocalStorage().setIsSignedIn(true);

          //cambiar estado de autenticacion
          loginProvider.checkAuthState();

          //navegar a la pagina principal
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return Pagemain(
              userData: userData,
            );
          }));

          } else {
            setState(() {
              //si el usuario no ha verificado su cuenta
              _isLoading = false;
            });

            await showDialog(context: context, builder: (context){
              return AlertDialog(
                title: const Text('Verifica tu cuenta'),
                content: const Text('Por favor verifica tu cuenta, te hemos enviado un correo de verificacion'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Aceptar'),
                  ),
                ],
              );
            },
            );
          }
            

          },
          onError: (String error) {
            setState(() {
              _isLoading = false;
            });
            showSnackbar(context, error.toString());
          }
          );

    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
                color: AppColors.greenOscure,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
            child: const Center(
              child: Text(
                'Login',
                style: TextStyle(
                    fontSize: 30,
                    color: AppColors.text,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ImputDecorationWidget(
                      hintText: 'user@example',
                      labelText: 'Ingrese email o usuario',
                      controller: _emailOrEmailController,
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: Icon(Icons.email_outlined),
                      validator: Validators.emailOrUser,
                    ),
                    const SizedBox(height: 20),
                    ImputDecorationWidget(
                      hintText: '**********',
                      labelText: 'Ingrese su contraseña',
                      controller: _passwordController,
                      maxLines: 1,
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                            _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      obscureText: _isObscure,
                      validator: Validators.passwordValidator,
                    ),
                    const SizedBox(height: 30),
                    _isLoading ? CircularProgressWidget(text: 'Validando.....',)
                    : ButtonDecorationWidget(text: "Inicia Sesion",
                    onPressed: () {
                      onFormLogin(_emailOrEmailController.text, _passwordController.text, context);
                    },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿No tienes cuenta?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/Register');
                          },
                          child: const Text('Registrate',
                          style: TextStyle(
                            color: AppColors.greenOscure,
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
