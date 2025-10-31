import 'package:demo_clean_archtechture_with_provider/core/errors/failure.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/entities/post.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/presentation/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {

    PostEntities? post = Provider.of<PostProvider>(context).postEntities;
    Failure? failure = Provider.of<PostProvider>(context).failure;

    late Widget widget;

    if(post !=null){
      widget = Column(
        children: [
          Text('data'),
          Text(post.title.toString()),
          Text(post.body.toString()),

        ],
      );
    }
    else if(failure != null){
      widget = Expanded(child: Center(
        child: Text(failure.errorMessage),
      ));
    }
    else{
      return Expanded(child: Center(
        child: CircularProgressIndicator(

        ),
      ));
    }

    return widget;
  }
}
