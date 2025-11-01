

import 'package:dartz/dartz.dart';
import 'package:demo_clean_archtechture_with_provider/core/connection/network_connection.dart';
import 'package:demo_clean_archtechture_with_provider/core/errors/exceptions.dart';
import 'package:demo_clean_archtechture_with_provider/core/errors/failure.dart';
import 'package:demo_clean_archtechture_with_provider/core/params/params.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/data/data_sources/local_data_source.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/data/data_sources/post_remote_data_source.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/entities/post.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/repositories/post_repositories.dart';

class PostRepositoryImpl implements PostRepository{
  final NetworkConnection networkConnection;
  final PostRemoteDataSource postRemoteDataSource;
  final PostLocalDataSource postLocalDataSource;

  PostRepositoryImpl({required this.networkConnection, required this.postRemoteDataSource, required this.postLocalDataSource});

  @override
  Future<Either<Failure, PostEntities>> getAPost({required PostParams params}) async{

    if(await networkConnection.isNetworkConnected!){
      try{
        final remotePost = await postRemoteDataSource.getAPost(params:
        params
        );

        return Right(remotePost);
      } on ServerException{
        return Left(ServerFailure(errorMessage: 'Data pulling failed'));
      }

    }
    else{
      try {
        final localPost = await postLocalDataSource.getAPost(params);
        return Right(localPost);
      } on CacheException{
        return Left(CacheFailure(errorMessage: 'local is empty'));
      }
    }
  }

  @override
  Future<Either<Failure, List<PostEntities>>> getAllPost({required PostParams params}) async{
    if(await networkConnection.isNetworkConnected!){

      try{
        final networkAllPost = await postRemoteDataSource.getAllPost(params: params);

        return Right(networkAllPost);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'Server failed'));
      }

    }
    else{
      try{
        final localAllPost = await postLocalDataSource.getAllPost();

        return Right(localAllPost);
      } on CacheException{
        return Left(CacheFailure(errorMessage: 'Server failed'));
      }
    }
  }

}