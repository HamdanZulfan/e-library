import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_library/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/theme.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late ValueNotifier<bool> isObscure;
  @override
  void initState() {
    isObscure = ValueNotifier(true);
    super.initState();
  }

  void showFailedDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      showCloseIcon: true,
      title: "Failed",
      desc: "Email Anda Sudah Terdaftar",
      btnOkOnPress: () {
        // Navigator.pop(context);
      },
    ).show();
  }

  void showSuccessDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      showCloseIcon: true,
      title: "Success",
      desc: "Register Anda Berhasil",
      btnOkOnPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
    ).show();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Center(
                  child: Column(
                    children: [
                      Image(
                        height: 150,
                        image: AssetImage('assets/logo.png'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama Lengkap',
                        style: navyTextStyle.copyWith(fontWeight: semiBold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffBDBDBD),
                            ),
                          ),
                          border: const OutlineInputBorder(),
                          hintText: 'Ex. Ahmad Sarifudin',
                          fillColor: whiteColor,
                          filled: true,
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Email',
                        style: navyTextStyle.copyWith(fontWeight: semiBold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffBDBDBD),
                            ),
                          ),
                          border: const OutlineInputBorder(),
                          hintText: 'Ex. example@gmail.com',
                          fillColor: whiteColor,
                          filled: true,
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'email tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Kata Sandi',
                        style: navyTextStyle.copyWith(fontWeight: semiBold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: isObscure,
                        builder: ((context, value, _) {
                          return TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                              border: const OutlineInputBorder(),
                              hintText: 'Ex. Password',
                              fillColor: whiteColor,
                              filled: true,
                              suffixIcon: IconButton(
                                splashRadius: 20,
                                onPressed: () =>
                                    isObscure.value = !isObscure.value,
                                icon: Icon(
                                  value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            obscureText: value,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Kata sandi tidak boleh kosong';
                              } else if (value.length < 8) {
                                return 'Kata sandi harus minimal 8 karakter';
                              }
                              return null;
                            },
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellowColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          final isValidForm = _formKey.currentState!.validate();
                          if (isValidForm) {
                            String username = nameController.text;
                            String email = emailController.text;
                            String password = passwordController.text;

                            bool success = await Provider.of<AuthProvider>(
                                    context,
                                    listen: false)
                                .register(username, email, password);
                            if (success) {
                              showSuccessDialog(context);
                            } else {
                              showFailedDialog(context);
                            }
                          }
                        },
                        child: Text(
                          'Daftar',
                          style: blackRegulerTextStyle.copyWith(
                            fontWeight: semiBold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Anda Sudah Memiliki Akun ? ',
                            style: navyTextStyle,
                          ),
                          InkWell(
                            child: Text(
                              'Masuk',
                              style: yellowTextStyle.copyWith(
                                fontWeight: semiBold,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return const LoginScreen();
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    final tween = Tween(
                                      begin: 0.0,
                                      end: 1.0,
                                    );
                                    return FadeTransition(
                                      opacity: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
