import 'package:e_commerce_app/app/constants/colors_value.dart';
import 'package:e_commerce_app/app/constants/validation_type.dart';
import 'package:e_commerce_app/app/pages/profile/widgets/action_row.dart';
import 'package:e_commerce_app/app/pages/profile/widgets/edit_profile_dialog.dart';
import 'package:e_commerce_app/app/pages/profile/widgets/personal_info_tile.dart';
import 'package:e_commerce_app/app/pages/profile/widgets/profile_picture_avatar.dart';
import 'package:e_commerce_app/app/providers/account_provider.dart';
import 'package:e_commerce_app/app/providers/auth_provider.dart';
import 'package:e_commerce_app/app/widgets/pick_image_source.dart';
import 'package:e_commerce_app/config/flavor_config.dart';
import 'package:e_commerce_app/routes.dart';
import 'package:e_commerce_app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../widgets/error_banner.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AccountProvider>(
        builder: (context, value, child) {
          if (value.isLoadProfile) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Center(
                    child: ProfilePictureAvatar(
                      photoProfileUrl: value.account.photoProfileUrl,
                      isLoading: value.isLoading,
                      onTapCamera: () {
                        pickImage();
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Kişisel Bilgiler",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PersonalInfoTile(
                    personalInfo: 'İsim',
                    value: value.account.fullName,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditProfileDialog(
                          title: 'İsminizi değiştirin',
                          hintText: 'İsminizi giriniz.',
                          labelText: 'İsim',
                          initialValue: value.account.fullName,
                          fieldName: 'İsim Soyisim',
                          validation: ValidationType.instance.emptyValidation,
                        ),
                      );
                    },
                  ),
                  PersonalInfoTile(
                    personalInfo: 'E-posta',
                    value: value.account.emailAddress,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditProfileDialog(
                          title: 'Eposta Adresinizi değiştirin',
                          hintText: 'Eposta Adresinizi giriniz',
                          labelText: 'E-posta',
                          initialValue: value.account.emailAddress,
                          fieldName: 'eposta',
                          validation: ValidationType.instance.emailValidation,
                        ),
                      );
                    },
                  ),
                  PersonalInfoTile(
                    personalInfo: 'Telefon',
                    value: value.account.phoneNumber.separateCountryCode(),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditProfileDialog(
                          title: 'Telefon Numaranızı değiştirin',
                          hintText: 'Telefon numaranı giriniz',
                          labelText: 'Telefon Numarası',
                          initialValue: value.account.phoneNumber,
                          fieldName: 'telefon_numarası',
                          validation: ValidationType.instance.emptyValidation,
                          isPhone: true,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "İşlemler",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ActionRow(
                    label: 'Şifreyi sıfırla',
                    onTap: () {
                      resetPassword(emailAddress: value.account.emailAddress);
                    },
                  ),
                  const Divider(height: 1),
                  if (flavor.flavor == Flavor.user)
                    ActionRow(
                      label: 'Adresleri yönet',
                      onTap: () {
                        NavigateRoute.toManageAddress(context: context);
                      },
                    ),
                  if (flavor.flavor == Flavor.user) const Divider(height: 1),
                  if (flavor.flavor == Flavor.user)
                    ActionRow(
                      label: 'Ödemeleri yönet',
                      onTap: () {
                        NavigateRoute.toManagePaymentMethod(context: context);
                      },
                    ),
                  if (flavor.flavor == Flavor.user) const Divider(height: 1),
                  const Divider(height: 1),
                  ActionRow(
                    label: 'Çıkış Yap',
                    onTap: () {
                      context.read<AuthProvider>().logout();
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  pickImage() async {
    try {
      ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

      ImageSource? pickImageSource = await showDialog(
        context: context,
        builder: (context) {
          return const PickImageSource();
        },
      );

      if (pickImageSource != null) {
        await _picker.pickImage(source: pickImageSource).then((image) {
          if (image != null) {
            context.read<AccountProvider>().updatePhotoProfile(image);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
      ScaffoldMessenger.of(context).showMaterialBanner(
        errorBanner(context: context, msg: e.toString()),
      );
    }
  }

  resetPassword({required String emailAddress}) async {
    try {
      ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

      await context
          .read<AuthProvider>()
          .resetPassword(
            email: emailAddress,
          )
          .whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Şifremi Sıfırla'),
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
}
