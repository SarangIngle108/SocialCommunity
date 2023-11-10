import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social_media_app/core/common/error_text.dart';
import 'package:social_media_app/core/common/loader.dart';
import 'package:social_media_app/features/community/controller/community_controller.dart';

import '../../../models/community_model.dart';

class SearchCommunityDelegate extends SearchDelegate{
  final WidgetRef ref;
  SearchCommunityDelegate(this.ref);
  @override
  List<Widget>? buildActions(BuildContext context) {
   return [
     IconButton(
         onPressed: (){
           query = '';
         },
         icon: const Icon(Icons.close),),
   ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
   return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
     return  ref.watch(searchCommunityProvider(query)).when(
          data: (communities) => ListView.builder(
              itemCount: communities.length,
              itemBuilder: (BuildContext context,int index){
                final community = communities[index];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(community.avatar),),
                  title: Text('r/${community.name}'),
                //  subtitle: Text('${community.members.length} members'),
                  onTap: () =>navigateToCommunity(context, community.name),

                );
              },
          ),
          error: (error,stackTrace) =>ErrorText(error: error.toString(),),
          loading: ()=>const Loader(),
      );
  }
  void navigateToCommunity(BuildContext context,String communityName){
    Routemaster.of(context).push('/r/$communityName');
  }

}