import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social_media_app/core/common/error_text.dart';
import 'package:social_media_app/core/common/post_card.dart';
import 'package:social_media_app/features/auth/controller/auth_controller.dart';
import 'package:social_media_app/features/community/controller/community_controller.dart';
import 'package:social_media_app/models/community_model.dart';

import '../../../core/common/loader.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key,required this.name});

  void navigateToModTools(BuildContext context){
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref,Community community,BuildContext context){
    ref.read(communityControllerProvider.notifier).joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
    body: ref.watch(getCommunityByNameProvider(name)).when(
        data: (community) => NestedScrollView(
            headerSliverBuilder: (context,innerBoxIsScrolled){
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(child: Image.network(community.banner,fit: BoxFit.cover,)),
                    ],
                  ),
                ),
                SliverPadding(
                    padding:const EdgeInsets.all(16),
                  sliver: SliverList(delegate: SliverChildListDelegate(
                    [
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            community.avatar
                          ),
                          radius: 35,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('r/${community.name}',style: const TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),

                          community.mods.contains(user!.uid)?
                          OutlinedButton(
                              onPressed: (){
                                navigateToModTools(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: const Text('mod tools'),
                          )
                              :  OutlinedButton(
                            onPressed: ()=>joinCommunity(ref, community, context),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding:const EdgeInsets.symmetric(horizontal: 25),
                            ),
                            child:  Text(community.members.contains(user.uid) ? 'joined' : 'join'),
                          )

                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text('${community.members.length} members'),
                    ],
                  ),),
                ),
              ];
            },
            body:  ref.watch(getCommunityPostsProvider(name)).when(
                data: (data){
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index){
                        final post = data[index];
                        return PostCard(post: post);
                      }
                  );
                },
                error: (error,stackTrace){

                  return ErrorText(error: error.toString());
                },
                loading: ()=>const  Loader(),
    ),
        ),
        error: (error,stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
    ),
    );
  }
}
