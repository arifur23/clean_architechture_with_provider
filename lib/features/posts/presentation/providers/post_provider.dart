import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:demo_clean_archtechture_with_provider/core/connection/network_connection.dart';
import 'package:demo_clean_archtechture_with_provider/core/errors/failure.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/data/data_sources/local_data_source.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/data/data_sources/post_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/params/params.dart';
import '../../data/repository_impl/post_repository_imp;.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_all_post_usecase.dart';
import '../../domain/usecases/get_post_usecase.dart';

class PostProvider extends ChangeNotifier {
  // SINGLE POST
  PostEntities? postEntities;

  // MULTIPLE POSTS
  List<PostEntities>? allPosts;

  // COMMON STATES
  Failure? failure;
  bool isLoading = false;

  // REPOSITORY INITIALIZER
  Future<PostRepositoryImpl> _getRepository() async {
    return PostRepositoryImpl(
      networkConnection: NetworkConnectionImpl(DataConnectionChecker()),
      postRemoteDataSource: PostRemoteDataSourceImpl(dio: Dio()),
      postLocalDataSource: PostLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
    );
  }

  /// 🧩 Fetch all posts
  Future<void> getAllPosts() async {


    final repository = await _getRepository();
    final result = await GetAllPostUseCase(repository).call(params: PostParams(id: ''));

    result.fold(
          (newFailure) {
        failure = newFailure;
        allPosts = null;
      },
          (postsList) {
        allPosts = postsList;
        failure = null;
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// 🧩 Fetch a single post by ID
  Future<void> getSinglePost(String id) async {
    isLoading = true;
    notifyListeners();

    final repository = await _getRepository();
    final result = await GetAPostUseCase(repository).call(
      params: PostParams(id: id),
    );

    result.fold(
          (newFailure) {
        failure = newFailure;
        postEntities = null;
      },
          (singlePost) {
        postEntities = singlePost;
        failure = null;
      },
    );

    isLoading = false;
    notifyListeners();
  }
}
