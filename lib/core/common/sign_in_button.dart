import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/core/constants/constants.dart';
import 'package:social_media_app/features/auth/controller/auth_controller.dart';

import '../../theme/pallete.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({Key? key}) : super(key: key);

  void signInWithGoogle(BuildContext context,WidgetRef ref){
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
}

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
          onPressed: (){
            return signInWithGoogle(context,ref);
          },
          label: const Text('Continue with Google',style: TextStyle(fontSize: 18),),
          icon: Image.asset(Constants.googlePath,width: 35,),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
