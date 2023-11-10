import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/features/auth/controller/auth_controller.dart';
import 'package:social_media_app/user_profile/controller/user_profile_controller.dart';
import 'package:social_media_app/user_profile/repository/user_profile_repository.dart';
import 'dart:io';
import '../../core/common/error_text.dart';
import '../../core/common/loader.dart';
import '../../core/constants/constants.dart';
import '../../core/utils.dart';
import '../../theme/pallete.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key,required this.uid});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {

  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController ;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectBannerImage()async{
    final res  = await pickImage();
    if(res != null){
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage()async{
    final res  = await pickImage();
    if(res != null){
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(){
    ref.read(userProfileControllerProvider.notifier).editCommunity(
        profileFile: profileFile,
        bannerFile: bannerFile,
        context: context,
        name: nameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
      data: (user) =>  Scaffold(
        backgroundColor: currentTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Edit Profile'),
          actions: [
            TextButton(
                onPressed: save,
                child: const Text('save')),
          ],
        ),
        body: isLoading ? const Loader() : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Stack(
                  children:[
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(10),
                        dashPattern: [10,4],
                        strokeCap: StrokeCap.round,
                        color: currentTheme.textTheme.bodyText1!.color!,
                        child: Container(
                            width: double.infinity,
                            height:150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:bannerFile!=null? Image.file(bannerFile!): user.banner.isEmpty || user.banner == Constants.bannerDefault?
                            const Center(
                              child: Icon(Icons.camera_alt,size: 45,),
                            ):Image.network(user.banner)

                        ),
                      ),
                    ),
                    Positioned(
                      width: 50,height: 50,
                      left: 10,top: 120,
                      child: GestureDetector(
                        onTap: selectProfileImage,
                        child: profileFile != null
                            ? CircleAvatar(
                          backgroundImage: FileImage(profileFile! ),
                          radius: 32,
                        )
                            :CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 32,
                        ),

                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(18),
                ),

              ),
            ],
          ),
        ),
      ),
      error: (error,stackTrace) => ErrorText(error: error.toString()),
      loading:()=> const Loader(),
    );

  }
}
