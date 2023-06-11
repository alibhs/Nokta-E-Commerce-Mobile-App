import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/validation_type.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/error_banner.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Form Key (For validation)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController & FocusNode
  final TextEditingController _txtEmailAddress = TextEditingController();
  final FocusNode _fnEmailAddress = FocusNode();

  // Validation
  ValidationType validation = ValidationType.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo must svg, so we can changed the color based on primaryColor
              SizedBox(height: 100, width: 100, child: Image.asset('assets/images/nokta_logo.png')),
              const SizedBox(height: 16),

              // Title
              Text(
                'Şifremi Unuttum',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                'E-posta adresinizi girin ve şifre newestleme mailinizi gönderelim',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 32),

              // Input Email Address
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _txtEmailAddress,
                  focusNode: _fnEmailAddress,
                  validator: validation.emailValidation,
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
                  decoration: const InputDecoration(
                    hintText: 'E-posta adresinizi girin',
                    labelText: 'E-posta Adresi',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Log In Button
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
                      // Check if the form valid
                      if (_formKey.currentState!.validate() && !value.isLoading) {
                        try {
                          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                          await value
                              .resetPassword(
                            email: _txtEmailAddress.text,
                          )
                              .whenComplete(() {
                            _formKey.currentState!.reset();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email gönderildi'),
                              ),
                            );
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                          ScaffoldMessenger.of(context).showMaterialBanner(
                            errorBanner(context: context, msg: e.toString()),
                          );
                        }
                      }
                    },
                    child: const Text('Şifreni sıfırla'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
