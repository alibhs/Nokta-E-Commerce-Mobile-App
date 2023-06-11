import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/flavor_config.dart';
import '../../../../routes.dart';
import '../../../constants/validation_type.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/error_banner.dart';
import 'widgets/sign_up_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FlavorConfig flavor = FlavorConfig.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _txtEmailAddress = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();
  final FocusNode _fnEmailAddress = FocusNode();
  final FocusNode _fnPassword = FocusNode();

  bool _obsecureText = true;

  ValidationType validation = ValidationType.instance;

  @override
  void dispose() {
    _txtEmailAddress.dispose();
    _txtPassword.dispose();
    _fnEmailAddress.dispose();
    _fnPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset('assets/images/nokta_logo.png')),
                const SizedBox(height: 16),
                Text(
                  'Hesabınıza giriş yapın',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'Hoşgeldiniz lütfen bilgilerinizi girin.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _txtEmailAddress,
                          focusNode: _fnEmailAddress,
                          validator: validation.emailValidation,
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (value) =>
                              FocusScope.of(context).requestFocus(_fnPassword),
                          decoration: const InputDecoration(
                            hintText: 'E-posta adresinizi girin',
                            labelText: 'E-posta Adresi',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _txtPassword,
                          focusNode: _fnPassword,
                          obscureText: _obsecureText,
                          validator: validation.passwordValidation,
                          onFieldSubmitted: (value) =>
                              FocusScope.of(context).unfocus(),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_obsecureText
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded),
                              onPressed: () {
                                setState(() {
                                  _obsecureText = !_obsecureText;
                                });
                              },
                            ),
                            hintText: 'Şifrenizi giriniz',
                            labelText: 'Şifre',
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            NavigateRoute.toForgotPassword(context: context);
                          },
                          child: Text(
                            'Şifremi unuttum?',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Consumer<AuthProvider>(
                          builder: (context, value, child) {
                            if (value.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate() &&
                                    !value.isLoading) {
                                  try {
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentMaterialBanner();

                                    await value
                                        .login(
                                      emailAddress: _txtEmailAddress.text,
                                      password: _txtPassword.text,
                                    )
                                        .then((e) {
                                      if (!value.isRoleValid) {
                                        _formKey.currentState!.reset();

                                        ScaffoldMessenger.of(context)
                                            .showMaterialBanner(
                                          errorBanner(
                                              context: context,
                                              msg: 'Hesabınız engellendi'),
                                        );
                                      }
                                    });
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentMaterialBanner();
                                    ScaffoldMessenger.of(context)
                                        .showMaterialBanner(
                                      errorBanner(
                                          context: context, msg: e.toString()),
                                    );
                                  }
                                }
                              },
                              child: const Text('Giriş'),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const SignUpText(),
                      ],
                    ),
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
