import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vista_practica/provider/register_provider.dart';
import 'package:vista_practica/services/push_notification.dart';
import 'package:vista_practica/utils/app_colors.dart';
import 'package:vista_practica/utils/showsnacbar.dart';
import 'package:vista_practica/validators/validator.dart';
import 'package:vista_practica/widgets/button_decoration_widget.dart';
import 'package:vista_practica/widgets/circularprogress_widget.dart';
import 'package:vista_practica/widgets/imput_decoration_widget.dart';
import 'package:vista_practica/widgets/upload_image.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;
  File? image;
  static String? token;

  @override
  void initState() {
    super.initState();
    token = PushNotificationService.token;
  }

  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthController.dispose();
  }

  //registro de usuario
  void submitRegister() async {
    final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
    if (_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      
    //verificar si el nombre de usuario ya existe
    final bool existUsername = await registerProvider.chekUserExist(_usernameController.text);
    if (existUsername) {
      setState(() {
        _isLoading = false;
      });
      showSnackbar(context, "El nombre de usuario ya existe");
      return;
    }
    
    final bool existEmail = await registerProvider.checkEmailExist(_emailController.text);
    if (existEmail) {
      setState(() {
        _isLoading = false;
      });
      showSnackbar(context, "El email ya existe");
      return;
    }

  //validar que ingresen una imagen de perfil 
  if (image == null) { 
    setState(() {
      _isLoading = false;
    });
    showSnackbar(context, "Por favor seleccione una imagen de perfil");
    return;
  }

  //obtener la fecha y hora actual
  final now = DateTime.now();
  String formatedDate = DateFormat('dd/MM/yyyy').format(now);
  //obtener la fecha de nacimiento
  final birth = _birthController.text;
  //calcular la edad
  DateTime dateBirth = DateFormat('dd/MM/yyyy').parse(birth);
  int age = now.year - dateBirth.year;
  if (now.month < dateBirth.month || (now.month == dateBirth.month && now.day < dateBirth.day)) {
    age--;
  }

  //registrar usuario
  try {
    await registerProvider.registerUser(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      rol: 'user',
      birth: _birthController.text,
      age: age.toString(),
      token: token!,
      createdAt: formatedDate,
      image: image!,
      onError: (error) {
        setState(() {
          _isLoading = false;
        });
        showSnackbar(context, error);
      },
    );
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    showSnackbar(context, "Usuario registrado correctamente, por favor verifique su correo");
    Navigator.pushNamedAndRemoveUntil(context, "/Login", (route) => false);
    setState(() {
      
    });
  } on FirebaseAuthException catch (e) {
    showSnackbar(context, e.toString());
  } catch (e) {
    showSnackbar(context, e.toString());
  }
    /*setState(() {
      _isLoading = false;
    });
    showSnackbar(context, "Usuario registrado correctamente");
    Navigator.pushNamed(context, '/Login');
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    showSnackbar(context, "Error al registrar el usuario");
  }*/
    } else {
      setState(() {
        _isLoading = false;
      });
  }
  }


  //seleccionar una imagen
  void selectedImage() async {
    image = await uploadImage(context);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.fondoColors,
        iconTheme: const IconThemeData(color: AppColors.text),
        centerTitle: true,
        title: const Text(
          'Register',
          style: TextStyle(color: AppColors.text),
        ),
      ),
      body: Form(
        key: _formKey,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                      children: [
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: (){
                            selectedImage();
                          },
                          child: image == null
                          ? const CircleAvatar(
                            radius: 60,
                            backgroundColor: AppColors.oscureColor,
                            child: Icon(Icons.camera_alt_outlined, size: 40, color: AppColors.text),
                          )
                          : CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(image!),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ImputDecorationWidget(
                          hintText: 'Nombre de usuario',
                          labelText: 'Ingrese su nombre de usuario',
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          suffixIcon: Icon(Icons.person_outline),
                          validator: Validators.validateUsername,
                        ),
                        const SizedBox(height: 20),
                        ImputDecorationWidget(
                          hintText: 'user@example.com',
                          labelText: 'ingrese su email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          suffixIcon: Icon(Icons.email_outlined),
                          validator: Validators.emailValidator,
                        ),
                        const SizedBox(height: 20),
                        ImputDecorationWidget(
                          hintText: '**********',
                          labelText: 'Ingrese su contraseña',
                          controller: _passwordController,
                          maxLines: 1,
                          keyboardType: TextInputType.visiblePassword,
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
                            onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
                            },
                          ),
                          obscureText: _isObscure,
                          validator: Validators.passwordValidator,
                        ),
                        const SizedBox(height: 20),
                        getBirth(context),
                        const SizedBox(height: 30),
                        _isLoading
                            ? CircularProgressWidget(
                  text: 'Registrando.....',
                )
                            : ButtonDecorationWidget(
                  text: "Registrarse",
                  onPressed: submitRegister,
                ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('¿Ya tienes cuenta?'),
                            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Login');
                },
                child: const Text(
                  'Registrate',
                  style: TextStyle(
                      color: AppColors.greenOscure,
                      fontWeight: FontWeight.bold),
                ),
                            ),
                          ],
                        ),
                      ],
                ),
              ),
            )),
    );
  }

  Widget getBirth(BuildContext context) {
    return ImputDecorationWidget(
      hintText: 'DD/MM/AAAA',
      labelText: 'Fecha de nacimiento',
      controller: _birthController,
      keyboardType: TextInputType.datetime,
      suffixIcon: Icon(Icons.calendar_today_outlined),
      validator: Validators.birthValidator,
      readOnly: true,
      onTap: () async {
        DateTime? pickedData = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.fondoColors,
                  onPrimary: Colors.white,
                  surface: AppColors.text,
                  onSurface: Colors.black,
                ),
                dialogBackgroundColor: AppColors.fondoColors,
                textButtonTheme: TextButtonThemeData(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(AppColors.text),
                  )
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedData != null) {
          final DateFormat formatter = DateFormat('dd/MM/yyyy');
          String formatedData = formatter.format(pickedData);
          setState(() {
            _birthController.text = formatedData;
          });
        }
      },
    );
  }
}
