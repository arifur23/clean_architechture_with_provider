import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:demo_clean_archtechture_with_provider/core/connection/network_connection.dart';
import 'package:demo_clean_archtechture_with_provider/core/errors/failure.dart';
import 'package:demo_clean_archtechture_with_provider/core/params/params.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/data/data_sources/local_data_source.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/data/data_sources/post_remote_data_source.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/data/repository_impl/post_repository_imp;.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/entities/post.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/usecases/get_post_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostProvider extends ChangeNotifier{

  PostEntities? postEntities;
  Failure? failure;

  PostProvider({
    this.postEntities,
    this.failure
});

  void eitherFailureOrPost({required String value,}) async{
    PostRepositoryImpl postRepositoryImpl = PostRepositoryImpl(
        networkConnection: NetworkConnectionImpl(DataConnectionChecker()),
        postRemoteDataSource: PostRemoteDataSourceImpl(dio: Dio()),
        postLocalDataSource: PostLocalDataSourceImpl(sharedPreferences: await SharedPreferences.getInstance())
     );

    final failureOrPost = await GetAPostUseCase(postRepositoryImpl).call(params: PostParams(id: '1'));

    failureOrPost.fold(
        (newFailure){
          postEntities = null;
          failure = newFailure;
          notifyListeners();
        },
        (newPost){
          postEntities = newPost;
          failure = null;
          notifyListeners();

        }
    );
  }

}