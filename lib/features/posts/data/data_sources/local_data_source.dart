import 'dart:convert';

import 'package:demo_clean_archtechture_with_provider/core/constants/constants.dart';
import 'package:demo_clean_archtechture_with_provider/core/errors/exceptions.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/data/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostLocalDataSource {
  Future<void>? cachePost(PostModel? post);

  Future<PostModel> getLastPost();

}

class PostLocalDataSourceImpl implements PostLocalDataSource{
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void>? cachePost(PostModel? post) {
    if(post !=null){
      sharedPreferences.setString(
       kPost,
        json.encode(
            post.toJson()
        )
      );
    }
    else{
      throw CacheException();
    }
  }

  @override
  Future<PostModel> getLastPost() {
    final jsonString = sharedPreferences.getString(kPost);
    if(jsonString != null){
      return Future.value(PostModel.fromJson(jsonDecode(jsonString)));
    }
    else {
      throw CacheException();
    }
  }
}
