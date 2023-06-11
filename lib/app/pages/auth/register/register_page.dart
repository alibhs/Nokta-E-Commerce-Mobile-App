import 'package:e_commerce_app/app/constants/colors_value.dart';
import 'package:e_commerce_app/app/constants/validation_type.dart';
import 'package:e_commerce_app/app/providers/auth_provider.dart';
import 'package:e_commerce_app/app/widgets/error_banner.dart';
import 'package:e_commerce_app/config/flavor_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/login_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FlavorConfig flavor = FlavorConfig.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _txtFullName = TextEditingController();
  final TextEditingController _txtEmailAddress = TextEditingController();
  final TextEditingController _txtPhoneNumber = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();
  final TextEditingController _txtConfirmPassword = TextEditingController();

  final FocusNode _fnFullName = FocusNode();
  final FocusNode _fnEmailAddress = FocusNode();
  final FocusNode _fnPhoneNumber = FocusNode();
  final FocusNode _fnPassword = FocusNode();
  final FocusNode _fnConfirmPassword = FocusNode();

  bool _obsecureText = true;
  bool _obsecureConfirm = true;

  bool _agreeToTermOfService = false;

  ValidationType validation = ValidationType.instance;

  @override
  void dispose() {
    _txtFullName.dispose();
    _txtEmailAddress.dispose();
    _txtPhoneNumber.dispose();
    _txtPassword.dispose();
    _txtConfirmPassword.dispose();

    _fnFullName.dispose();
    _fnEmailAddress.dispose();
    _fnPhoneNumber.dispose();
    _fnPassword.dispose();
    _fnConfirmPassword.dispose();
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
                  'Hesap Oluştur',
                  style: Theme.of(context).textTheme.titleLarge,
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
                          controller: _txtFullName,
                          focusNode: _fnFullName,
                          validator: validation.emptyValidation,
                          onFieldSubmitted: (value) => FocusScope.of(context)
                              .requestFocus(_fnEmailAddress),
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: 'İsim giriniz',
                            labelText: 'İsim ',
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _txtEmailAddress,
                          focusNode: _fnEmailAddress,
                          validator: validation.emailValidation,
                          onFieldSubmitted: (value) => FocusScope.of(context)
                              .requestFocus(_fnPhoneNumber),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'E-posta adresinizi giriniz',
                            labelText: 'E-posta adresi',
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _txtPhoneNumber,
                          focusNode: _fnPhoneNumber,
                          validator: validation.emptyValidation,
                          onFieldSubmitted: (value) =>
                              FocusScope.of(context).requestFocus(_fnPassword),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          maxLength: 14,
                          decoration: const InputDecoration(
                            hintText:
                                'Ülke Kodu + Telefon Numarası (ör: 5xx xxx xxxx)',
                            labelText: 'Telefon Numarası',
                            counterText: '',
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _txtPassword,
                          focusNode: _fnPassword,
                          obscureText: _obsecureText,
                          validator: validation.passwordValidation,
                          onFieldSubmitted: (value) => FocusScope.of(context)
                              .requestFocus(_fnConfirmPassword),
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
                            hintText: 'Şifrenizi girin',
                            labelText: 'Şifre',
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _txtConfirmPassword,
                          focusNode: _fnConfirmPassword,
                          obscureText: _obsecureConfirm,
                          validator: (value) {
                            return validation.confirmPasswordValidation(
                                value, _txtPassword.text);
                          },
                          onFieldSubmitted: (value) =>
                              FocusScope.of(context).unfocus(),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_obsecureConfirm
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded),
                              onPressed: () {
                                setState(() {
                                  _obsecureConfirm = !_obsecureConfirm;
                                });
                              },
                            ),
                            hintText: 'Şifrenizi tekrar girin',
                            labelText: 'Şifreyi onayla',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              activeColor: ColorsValue.primaryColor(context),
                              value: _agreeToTermOfService,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToTermOfService = value!;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: 'Sözleşmeyi okudum',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                    TextSpan(
                                      text: ' Terms of Service',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: ColorsValue.primaryColor(
                                                context),
                                          ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          Uri url = Uri.parse(
                                              'https://generator.lorem-ipsum.info/terms-and-conditions');
                                          if (!await launchUrl(url)) {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Sign Up Button
                        Consumer<AuthProvider>(
                          builder: (context, value, child) {
                            if (value.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return ElevatedButton(
                              onPressed: _agreeToTermOfService
                                  ? () async {
                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState!.validate() &&
                                          !value.isLoading) {
                                        try {
                                          ScaffoldMessenger.of(context)
                                              .removeCurrentMaterialBanner();

                                          await value
                                              .register(
                                            emailAddress: _txtEmailAddress.text,
                                            password: _txtPassword.text,
                                            fullName: _txtFullName.text,
                                            phoneNumber: _txtPhoneNumber.text,
                                          )
                                              .then((value) {
                                            Navigator.of(context).pop();
                                          });
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showMaterialBanner(
                                            errorBanner(
                                                context: context,
                                                msg: e.toString()),
                                          );
                                        }
                                      }
                                    }
                                  : null,
                              child: const Text('Kayıt ol'),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        const LoginText(),
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
