import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social_media_app/features/auth/controller/auth_controller.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/storage_repository_providers.dart';
import '../../../core/utils.dart';
import '../../../models/community_model.dart';
import '../repository/post_repository.dart';
import 'dart:io';


final userPostsProvider = StreamProvider.family((ref,List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

final postControllerProvider = StateNotifierProvider<PostController,bool>((ref){
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return  PostController(
      postRepository: postRepository,
      storageRepository: storageRepository,
      ref: ref);
});

final getPostByIdProvider = StreamProvider.family((ref,String postId){
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId);
});


class PostController extends StateNotifier<bool>{
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController({
    required PostRepository postRepository,required StorageRepository storageRepository,
    required Ref ref,
  }) :
        _postRepository=postRepository ,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);


  void shareTextPost({
  required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,

}) async{
    state = true;
    String  postId = Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(id: postId, title: title, communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar, upvotes: [], downvotes: [],
        commentCount: 0, username: user.name, uid: user.uid, type: 'text', createdAt: DateTime.now(), awards: [],
    description: description,
    );
    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackBar(context,l.message), (r) {
      showSnackBar(context,'Posted Successfully');
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,

  }) async{
    state = true;
    String  postId = Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(id: postId, title: title, communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar, upvotes: [], downvotes: [],
      commentCount: 0, username: user.name, uid: user.uid, type: 'link', createdAt: DateTime.now(), awards: [],
      link: link,
    );
    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackBar(context,l.message), (r) {
      showSnackBar(context,'Posted Successfully');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,

  }) async{
    state = true;
    String  postId = Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
        path: 'posts/${selectedCommunity.name}', id: postId, file: file);

    imageRes.fold((l) => showSnackBar(context,l.message), (r) async{
      final Post post = Post(id: postId, title: title, communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar, upvotes: [], downvotes: [],
        commentCount: 0, username: user.name, uid: user.uid, type: 'image', createdAt: DateTime.now(), awards: [],
        link: r,
      );
      final res = await _postRepository.addPost(post);
      state = false;
      res.fold((l) => showSnackBar(context,l.message), (r) {
        showSnackBar(context,'Posted Successfully');
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities){
    if(communities.isNotEmpty){
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  void deletePost(Post post,BuildContext context)async{
    final res = await _postRepository.deletePost(post);
    res.fold((l) => null, (r) => showSnackBar(context,'Post deleted Successfully'));
  }

  void upvote(Post post)async{
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.upvote(post, uid);
  }

  void downvote(Post post)async{
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.downvote(post, uid);
  }

  Stream<Post> getPostById(String postId){
    return _postRepository.getPostById(postId);
  }

  }