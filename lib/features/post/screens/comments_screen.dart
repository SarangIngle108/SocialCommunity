import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/features/post/controller/post_controller.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({super.key,required this.postId});

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (data){
            
          },
          error:(error,stackTrace){
        return ErrorText(error: error.toString(),);
    },
          loading: ()=>const Loader(),
      ),
    );
  }
}
