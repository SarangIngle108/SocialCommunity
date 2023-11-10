import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/features/community/controller/community_controller.dart';

import '../../../core/common/loader.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {

  final communityNameController = TextEditingController();

  @override
  void dispose() {
    communityNameController.dispose();
    super.dispose();
  }

  void createCommunity(){
    ref.read(communityControllerProvider.notifier).createCommunity(communityNameController.text.trim(),context);
  }
  
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Community'),
      ),
      body: isLoading? Loader():Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const Text('Community name',style: TextStyle(fontSize: 15),),

           const SizedBox(height: 20,),

           TextField(
           controller: communityNameController,
           decoration:  InputDecoration(
             labelText: 'r/Community_name',
             filled: true,
             border: InputBorder.none,
             fillColor: Colors.grey.shade700,
             contentPadding:const EdgeInsets.all(15.0),
           ),
             maxLength: 21,
           ),

           const SizedBox(height: 30,),

           ElevatedButton(
               onPressed: createCommunity,
               child: const Text('Create Community',style: TextStyle(fontSize: 17),),
             style: ElevatedButton.styleFrom(
               minimumSize: const Size(double.infinity,50),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
             ),
           ),

          ],
        ),
      ),
    );
  }
}


