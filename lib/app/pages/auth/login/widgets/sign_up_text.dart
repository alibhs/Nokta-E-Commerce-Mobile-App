import 'package:e_commerce_app/app/constants/colors_value.dart';
import 'package:e_commerce_app/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpText extends StatelessWidget {
  const SignUpText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Hesabınınız yok mu? ',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextSpan(
            text: ' Kayıt ol',
            style: Theme.of(context).textTheme.bodySmall!.apply(
                  color: ColorsValue.primaryColor(context),
                ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                NavigateRoute.toRegister(context: context);
              },
          ),
        ],
      ),
    );
  }
}
