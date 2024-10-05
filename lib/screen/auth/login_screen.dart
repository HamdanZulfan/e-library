import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_library/providers/auth_provider.dart';
import 'package:e_library/screen/auth/register_screen.dart';
import 'package:e_library/screen/navbar/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> passKey = GlobalKey<FormState>();
  final GlobalKey<FormState> emailKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late ValueNotifier<bool> isObscure;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showFailedDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      showCloseIcon: true,
      dismissOnTouchOutside: false,
      title: "Failed",
      desc: "Email atau password anda salah",
      btnOkOnPress: () {},
    ).show();
  }

  void showSuccessDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      dismissOnTouchOutside: false,
      title: "Success",
      desc: "Login Anda Berhasil",
      btnOkOnPress: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const NavBarScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      },
    ).show();
  }

  @override
  void initState() {
    isObscure = ValueNotifier(true);
    super.initState();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Image(
                        height: 150,
                        image: AssetImage('assets/logo.png'),
                      ),
                      Text(
                        'Masuk',
                        style: yellowTextStyle.copyWith(
                          fontWeight: semiBold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Email',
                  style: navyTextStyle.copyWith(fontWeight: semiBold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Form(
                  key: emailKey,
                  child: TextFormField(
                    controller: emailController,
                    validator: (String? value) {
                      const String expression = "[a-zA-Z0-9+._%-+]{1,256}"
                          "\\@"
                          "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"
                          "("
                          "\\."
                          "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}"
                          ")+";
                      final RegExp regExp = RegExp(expression);
                      return !regExp.hasMatch(value!)
                          ? "Masukkan email yang valid!"
                          : null;
                    },
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
                  ),
                ),
                const SizedBox(
                  height: 30,
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
                    return Form(
                      key: passKey,
                      child: TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Kata sandi tidak boleh kosong';
                          } else if (value.length < 8) {
                            return 'Kata sandi harus minimal 8 karakter';
                          }
                          return null;
                        },
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
                            onPressed: () => isObscure.value = !isObscure.value,
                            icon: Icon(
                              value ? Icons.visibility_off : Icons.visibility,
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        obscureText: value,
                      ),
                    );
                  }),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellowColor,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    if (emailKey.currentState!.validate() &&
                        passKey.currentState!.validate()) {
                      emailKey.currentState!.save();
                      passKey.currentState!.save();
                      String email = emailController.text;
                      String password = passwordController.text;

                      bool success = await Provider.of<AuthProvider>(context,
                              listen: false)
                          .login(email, password);
                      if (success) {
                        showSuccessDialog(context);
                      } else {
                        showFailedDialog(context);
                      }
                    }
                  },
                  child: Text(
                    'Masuk',
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
                      'Anda Belum Memiliki Akun ? ',
                      style: navyTextStyle,
                    ),
                    InkWell(
                      child: Text(
                        'Daftar disini',
                        style: yellowTextStyle.copyWith(
                          fontWeight: semiBold,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return const RegisterScreen();
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
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
