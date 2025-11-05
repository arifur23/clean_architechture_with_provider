import 'package:dartz/dartz.dart';
import 'package:demo_clean_archtechture_with_provider/core/errors/failure.dart';
import 'package:demo_clean_archtechture_with_provider/core/params/params.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/entities/post.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/repositories/post_repositories.dart';

class GetAPostUseCase {
  final PostRepository postRepository;

  GetAPostUseCase(this.postRepository);

  Future<Either<Failure, PostEntities>> call({required PostParams params}) async {

    return await postRepository.getAPost(params: params);

  }
}