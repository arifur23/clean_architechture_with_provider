import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:demo_clean_archtechture_with_provider/core/constants/constants.dart';
import 'package:demo_clean_archtechture_with_provider/core/errors/exceptions.dart';
import 'package:demo_clean_archtechture_with_provider/core/params/params.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/data/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class PostLocalDataSource {
  Future<void>? cachePost(PostModel? post);

  Future<PostModel> getAPost(PostParams params);
  Future<List<PostModel>> getAllPost();

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
  Future<PostModel> getAPost(PostParams params) {
    final jsonString = sharedPreferences.getString(kPost);

    if (jsonString != null) {
      final List<dynamic> decodedJson = jsonDecode(jsonString);
      final List<PostModel> posts = decodedJson
          .map<PostModel>((json) => PostModel.fromJson(json))
          .toList();

      try {
        final post = posts.firstWhere(
              (post) => post.id == int.tryParse(params.id),
        );
        return Future.value(post);
      } catch (e) {
        throw CacheException(); // post not found
      }
    } else {
      throw CacheException(); // cache empty
    }
  }


  @override
  Future<List<PostModel>> getAllPost() {
    final jsonString = sharedPreferences.getString(kPost);

    if (jsonString != null) {
      final List<dynamic> decodedJson = jsonDecode(jsonString);
      final List<PostModel> posts = decodedJson
          .map<PostModel>((json) => PostModel.fromJson(json))
          .toList();

      return Future.value(posts);
    } else {
      throw CacheException();
    }
  }

}
