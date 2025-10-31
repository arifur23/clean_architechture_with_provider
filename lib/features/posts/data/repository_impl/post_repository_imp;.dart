

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
  Future<Either<Failure, PostEntities>> getPost({required PostParams params}) async{

    if(await networkConnection.isNetworkConnected!){
      try{
        final remotePost = await postRemoteDataSource.getPost(params:
        PostParams(id: '1')
        );

        return Right(remotePost);
      } on ServerException{
        return Left(ServerFailure(errorMessage: 'Data pulling failed'));
      }

    }
    else{
      try {
        final localPost = await postLocalDataSource.getLastPost();
        return Right(localPost);
      } on CacheException{
        return Left(CacheFailure(errorMessage: 'local is empty'));
      }
    }

  }

}