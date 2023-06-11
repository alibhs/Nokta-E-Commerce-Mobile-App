class ValidationType {
  // Singleton
  ValidationType._privateConstructor();
  static final ValidationType _instance = ValidationType._privateConstructor();
  static ValidationType get instance => _instance;

  final String _alertEmptyField = 'Bu alan boş bırakılamaz';
  final String _alertEmailIsNotValid = 'E-posta adresi geçerli değil';
  final String _alertPasswordLength = 'Şifreniz 6 karakterden uzun olmalı';
  final String _alertConfirmPassword = 'Parolayı doğrulayın';
  final String _alertCardNumberLength = 'Kart numarası 8 ila 19 haneden oluşur';
  final String _alertCvvLength = 'CVV numarası 3 ila 4 haneden oluşur';

  String? emailValidation(String? value) {
    RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (value == null || value.isEmpty) {
      return _alertEmptyField;
    }

    if (!emailRegex.hasMatch(value)) {
      return _alertEmailIsNotValid;
    }

    return null;
  }

  String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return _alertEmptyField;
    }

    if (value.length < 6) {
      return _alertPasswordLength;
    }

    return null;
  }

  String? emptyValidation(String? value) {
    if (value == null || value.isEmpty) {
      return _alertEmptyField;
    }

    return null;
  }

  String? confirmPasswordValidation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return _alertEmptyField;
    }

    if (value != password) {
      return _alertConfirmPassword;
    }

    return null;
  }

  String? cardNumberValidation(String? value) {
    if (value == null || value.isEmpty) {
      return _alertEmptyField;
    }

    if (value.length < 8) {
      return _alertCardNumberLength;
    }

    return null;
  }

  String? cvvValidation(String? value) {
    if (value == null || value.isEmpty) {
      return _alertEmptyField;
    }

    if (value.length < 3) {
      return _alertCvvLength;
    }

    return null;
  }
}
