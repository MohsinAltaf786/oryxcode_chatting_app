import 'package:chat_flow/core/bloc/config_bloc/config_bloc.dart';
import 'package:chat_flow/core/bloc/config_bloc/config_event.dart';
import 'package:chat_flow/core/bloc/config_bloc/config_state.dart';
import 'package:chat_flow/core/bloc/models/public_registration_model.dart';
import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/services/app_snackbar_service.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/auth/login_screen.dart';
import 'package:chat_flow/presentation/auth/otp_screen.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showPassword = false;
  bool showRetypePassword = false;
   final TextEditingController nameController=TextEditingController();
   final mobileController =TextEditingController();
  final ValueNotifier<String> countryCode = ValueNotifier("+93");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ImageWidget(
            image: getLogoPath(context), type: ImageType.asset, height: 35),
      ),
      body: ListView(
        padding: const .symmetric(horizontal: 20),
        children: [
          spacing(height: 70),
          _buildBanner(),
          spacing(height: 30),
          _buildTitle(),
          spacing(height: 40),
          _buildForm(nameController: nameController,mobileController: mobileController),
          spacing(height: 15),
          _buildButtons(mobileController: mobileController,nameController: nameController,countryCode:countryCode),
          spacing(height: 20),
         // _buildSignUp(),
          //spacing(height: 20),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return const ImageWidget(
            image: AssetsConst.signUp, height: 180, type: ImageType.asset)
        .animate(
          delay: const Duration(milliseconds: 200),
        )
        .fade(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
        .slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
  }

  Widget _buildTitle() {
    return Text(
      trans(context, key: 'create_an_account'),
      textAlign: TextAlign.center,
      style: StyleHelper.headlineSmall(context)
          ?.copyWith(fontWeight: FontWeight.w600),
    )
        .animate(
          delay: const Duration(milliseconds: 400),
        )
        .fade(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
        .slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
  }

  Widget _buildForm({required TextEditingController nameController,required TextEditingController mobileController}) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        TextFormField(
          controller:nameController,
          decoration: fieldDeco(
            label: trans(context, key: 'full_name'),
            hintText: trans(context, key: 'enter_your_name'),
          ),
        ),
        spacing(height: 20),
        TextFormField(
          controller: mobileController,
          keyboardType: TextInputType.number,
          decoration: fieldDeco(
            label: trans(context, key: 'phone_number'),
            hintText: trans(context, key: 'enter_your_phone'),
            prefixWidget:  CountryCodePicker(
              onChanged:(code){
                print('code ${code.dialCode}');
                countryCode.value = code.dialCode ?? "+93";
              },// print,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
            ),
          ),
        ),
        // spacing(height: 20),
        // TextFormField(
        //   keyboardType: TextInputType.emailAddress,
        //   decoration: fieldDeco(
        //     label: trans(context, key: 'email_address'),
        //     hintText: trans(context, key: 'enter_your_email'),
        //   ),
        // ),
        // spacing(height: 20),
        // TextFormField(
        //   obscureText: !showPassword,
        //   decoration: fieldDeco(
        //       label: trans(context, key: 'password'),
        //       hintText: trans(context, key: 'enter_password'),
        //       suffix: IconButton(
        //           onPressed: () {
        //             setState(() {
        //               showPassword = !showPassword;
        //             });
        //           },
        //           icon: Icon(
        //             showPassword ? TablerIcons.eye : TablerIcons.eye_off,
        //             color: AppColors.grey60,
        //           ))),
        // ),
        // spacing(height: 20),
        // TextFormField(
        //   obscureText: !showRetypePassword,
        //   decoration: fieldDeco(
        //       label: trans(context, key: 'retype_password'),
        //       hintText: trans(context, key: 'enter_password'),
        //       suffix: IconButton(
        //           onPressed: () {
        //             setState(() {
        //               showRetypePassword = !showRetypePassword;
        //             });
        //           },
        //           icon: Icon(
        //               showRetypePassword
        //                   ? TablerIcons.eye
        //                   : TablerIcons.eye_off,
        //               color: AppColors.grey60))),
        // ),
        spacing(height: 15),
      ],
    )
        .animate(
          delay: const Duration(milliseconds: 500),
        )
        .fade(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
        .slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
  }

  // Widget _buildButtons() {
  //   return Center(
  //     child: CustomButton(
  //         title: trans(context, key: 'create'),
  //         rightIcon: TablerIcons.arrow_right,
  //         fontSize: 16,
  //         yPadding: 12,
  //         width: 320,
  //         onTap: () {}),
  //   )
  //       .animate(
  //         delay: const Duration(milliseconds: 700),
  //       )
  //       .fade(
  //           duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
  //       .slideY(
  //           begin: 0.3,
  //           duration: const Duration(milliseconds: 300),
  //           curve: Curves.easeOut);
  // }

  Widget _buildButtons({
    required TextEditingController nameController,
    required TextEditingController mobileController,
    required ValueNotifier<String> countryCode,
  }) {
    return BlocConsumer<ConfigBloc, ConfigState>(
      listener: (context, state) {
        if (state is OtpRequested && state.success) {
          final phoneNumber = '${countryCode.value}${mobileController.text}';
          final publicRegistration=PublicRegistrationModel(name: nameController.text,mobile:phoneNumber);


          print('otp received');

          navigateToScreen(
            context,
            OtpScreen(publicRegistrationModel:publicRegistration),
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is ConfigLoading;

        return Center(
          child: CustomButton(
            title: trans(context, key: 'create'),
            rightIcon: TablerIcons.arrow_right,
            loading: isLoading,
            fontSize: 16,
            yPadding: 12,
            width: 320,
            onTap: () {
              if(nameController.text.isEmpty){
                AppSnackBarService.showTopSnackbar(message:'Name can\'t be empty!', context: context);
                return;
              }
              if(mobileController.text.isEmpty){
                AppSnackBarService.showTopSnackbar(message:'Phone number can\'t be empty!', context: context);
                return;
              }
              final phoneNumber =
                  '${countryCode.value}${mobileController.text}';

              print('phone: $phoneNumber');

              context.read<ConfigBloc>().add(
                RequestOtpEvent(
                  mobileNumber: phoneNumber,
                ),
              );
            },
          ),
        );
      },
    );
  }
  // Widget _buildSignUp() {
  //   return Row(
  //     mainAxisAlignment: .center,
  //     children: [
  //       Text(
  //         trans(context, key: 'already_have_an_account'),
  //         style: StyleHelper.titleSmall(context),
  //       ),
  //       spacing(width: 8),
  //       GestureDetector(
  //         onTap: () {
  //           navigateToScreen(context, const LoginScreen(), replace: true);
  //         },
  //         behavior: HitTestBehavior.opaque,
  //         child: Text(trans(context, key: 'login'),
  //             style: StyleHelper.titleSmall(context)
  //                 ?.copyWith(color: AppColors.primary)),
  //       ),
  //     ],
  //   )
  //       .animate(
  //         delay: const Duration(milliseconds: 800),
  //       )
  //       .fade(
  //           duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
  //       .slideY(
  //           begin: 0.3,
  //           duration: const Duration(milliseconds: 300),
  //           curve: Curves.easeOut);
  //}
}
