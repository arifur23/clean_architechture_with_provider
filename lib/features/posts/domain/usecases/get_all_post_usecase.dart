import 'package:dartz/dartz.dart';
import 'package:demo_clean_archtechture_with_provider/core/errors/failure.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/entities/post.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/repositories/post_repositories.dart';

import '../../../../core/params/params.dart';

class GetAllPostUseCase {
  final PostRepository postRepository;

  GetAllPostUseCase(this.postRepository);

  Future<Either<Failure, List<PostEntities>>> call({required PostParams params}) async{
    return await postRepository.getAllPost(params: params);
  }
}