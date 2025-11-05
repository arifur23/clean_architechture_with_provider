import 'dart:convert';
import 'package:demo_clean_archtechture_with_provider/core/constants/constants.dart';
import 'package:demo_clean_archtechture_with_provider/core/errors/exceptions.dart';
import 'package:demo_clean_archtechture_with_provider/core/params/params.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/data/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostLocalDataSource {
  /// Cache a single post (append or update)
  Future<void> cachePost(PostModel post);

  /// Cache all posts
  Future<void> cacheAllPosts(List<PostModel> posts);

  /// Get one post by ID
  Future<PostModel> getAPost(PostParams params);

  /// Get all cached posts
  Future<List<PostModel>> getAllPost();
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl({required this.sharedPreferences});

  static String cacheKey = kPost;

  // --------------------------------------------------------
  // 🧩 Cache all posts
  // --------------------------------------------------------
  @override
  Future<void> cacheAllPosts(List<PostModel> posts) async {
    if (posts.isEmpty) throw CacheException();

    final jsonString = jsonEncode(posts.map((p) => p.toJson()).toList());
    await sharedPreferences.setString(cacheKey, jsonString);
  }

  // --------------------------------------------------------
  // 🧩 Cache a single post (append or update)
  // --------------------------------------------------------
  @override
  Future<void> cachePost(PostModel post) async {
    final jsonString = sharedPreferences.getString(cacheKey);
    List<PostModel> existingPosts = [];

    if (jsonString != null) {
      final List decodedJson = jsonDecode(jsonString);
      existingPosts =
          decodedJson.map((e) => PostModel.fromJson(e)).toList().cast<PostModel>();
    }

    // check if post already exists — update or add
    final existingIndex = existingPosts.indexWhere((p) => p.id == post.id);
    if (existingIndex >= 0) {
      existingPosts[existingIndex] = post;
    } else {
      existingPosts.add(post);
    }

    // save back to cache
    await sharedPreferences.setString(
      cacheKey,
      jsonEncode(existingPosts.map((p) => p.toJson()).toList()),
    );
  }

  // --------------------------------------------------------
  // 🧩 Get a single cached post
  // --------------------------------------------------------
  @override
  Future<PostModel> getAPost(PostParams params) async {
    final jsonString = sharedPreferences.getString(cacheKey);
    if (jsonString == null) throw CacheException();

    final List decodedJson = jsonDecode(jsonString);
    final posts = decodedJson.map((e) => PostModel.fromJson(e)).toList();

    try {
      final post = posts.firstWhere(
            (p) => p.id == int.tryParse(params.id),
      );
      return Future.value(post);
    } catch (_) {
      throw CacheException(); // Not found
    }
  }

  // --------------------------------------------------------
  // 🧩 Get all cached posts
  // --------------------------------------------------------
  @override
  Future<List<PostModel>> getAllPost() async {
    final jsonString = sharedPreferences.getString(cacheKey);
    if (jsonString == null) throw CacheException();

    final List decodedJson = jsonDecode(jsonString);
    final posts = decodedJson.map((e) => PostModel.fromJson(e)).toList();
    return Future.value(posts);
  }
}
