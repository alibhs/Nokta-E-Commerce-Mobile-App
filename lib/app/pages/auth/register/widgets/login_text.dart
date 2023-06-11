import 'package:e_commerce_app/app/constants/colors_value.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginText extends StatelessWidget {
  const LoginText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Hesabın var mı? ',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextSpan(
            text: 'Giriş yap',
            style: Theme.of(context).textTheme.bodySmall!.apply(
                  color: ColorsValue.primaryColor(context),
                ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).pop();
              },
          ),
        ],
      ),
    );
  }
}
