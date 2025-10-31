

import 'package:dartz/dartz.dart';
import 'package:demo_clean_archtechture_with_provider/core/errors/failure.dart';
import 'package:demo_clean_archtechture_with_provider/core/params/params.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/entities/post.dart';

abstract class PostRepository{

  Future<Either<Failure, PostEntities>>  getPost({required PostParams params});
}