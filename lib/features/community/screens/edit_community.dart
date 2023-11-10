import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/core/common/error_text.dart';
import 'package:social_media_app/core/constants/constants.dart';
import 'package:social_media_app/core/utils.dart';
import 'package:social_media_app/features/community/controller/community_controller.dart';
import 'package:social_media_app/models/community_model.dart';
import 'package:social_media_app/theme/pallete.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';
import '../../../core/common/loader.dart';


class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key,required this.name});

  @override
  ConsumerState<EditCommunityScreen> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;
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

  void save(Community community){
    ref.read(communityControllerProvider.notifier).editCommunity(
        profileFile: profileFile,
        bannerFile: bannerFile, 
        community: community,
        context: context);
  }
  
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (community) =>  Scaffold(
          backgroundColor: currentTheme.backgroundColor,
          appBar: AppBar(
            title: const Text('Edit Community'),
            actions: [
              TextButton(
                  onPressed: ()=>save(community),
                  child: const Text('save')),
            ],
          ),
          body: isLoading ? const Loader(): Padding(
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
                          color: currentTheme.textTheme.bodyText2!.color!,
                          child: Container(
                            width: double.infinity,
                            height:150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:bannerFile!=null? Image.file(bannerFile!): community.banner.isEmpty || community.banner == Constants.bannerDefault?
                            const Center(
                              child: Icon(Icons.camera_alt,size: 45,),
                            ):Image.network(community.banner)

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
                             backgroundImage: NetworkImage(community.avatar),
                             radius: 32,
                           ),

                         ),
                      ),
            ],
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

