import 'package:dartz/dartz.dart';
import 'package:demo_clean_archtechture_with_provider/core/connection/network_connection.dart';
import 'package:demo_clean_archtechture_with_provider/core/errors/exceptions.dart';
import 'package:demo_clean_archtechture_with_provider/core/errors/failure.dart';
import 'package:demo_clean_archtechture_with_provider/core/params/params.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/data/data_sources/local_data_source.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/data/data_sources/post_remote_data_source.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/entities/post.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/repositories/post_repositories.dart';

import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final NetworkConnection networkConnection;
  final PostRemoteDataSource postRemoteDataSource;
  final PostLocalDataSource postLocalDataSource;

  PostRepositoryImpl({
    required this.networkConnection,
    required this.postRemoteDataSource,
    required this.postLocalDataSource,
  });

  // -------------------------------
  // GET SINGLE POST
  // -------------------------------
  @override
  Future<Either<Failure, PostEntities>> getAPost({required PostParams params}) async {
    if (await networkConnection.isNetworkConnected!) {
      try {
        final remotePost = await postRemoteDataSource.getAPost(params: params);

        // Cache the post locally
        await postLocalDataSource.cachePost(remotePost as dynamic);

        return Right(remotePost);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'Server failed to fetch post'));
      }
    } else {
      try {
        final localPost = await postLocalDataSource.getAPost(params);
        return Right(localPost);
      } on CacheException {
        return Left(CacheFailure(errorMessage: 'No cached post found'));
      }
    }
  }

  // -------------------------------
  // GET ALL POSTS
  // -------------------------------
  @override
  Future<Either<Failure, List<PostEntities>>> getAllPost({required PostParams params}) async {
    if (await networkConnection.isNetworkConnected!) {
      try {
        final networkAllPosts = await postRemoteDataSource.getAllPost(params: params); // List<PostEntities>

        // Cache all posts locally
        await postLocalDataSource.cacheAllPosts(networkAllPosts);

        return Right(networkAllPosts);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'Server failed to fetch posts'));
      }
    }

    else {
      try {
        final localAllPosts = await postLocalDataSource.getAllPost();
        return Right(localAllPosts);
      } on CacheException {
        return Left(CacheFailure(errorMessage: 'No cached posts found'));
      }
    }
  }

}
