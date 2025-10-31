import 'package:demo_clean_archtechture_with_provider/core/constants/constants.dart';
import 'package:demo_clean_archtechture_with_provider/core/errors/exceptions.dart';
import 'package:demo_clean_archtechture_with_provider/core/params/params.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/data/models/post_model.dart';
import 'package:dio/dio.dart';

abstract class PostRemoteDataSource {
  Future<PostModel> getPost({required PostParams params});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource{
  final Dio dio;

  PostRemoteDataSourceImpl({required this.dio});

  @override
  Future<PostModel> getPost({required PostParams params}) async {
    final response = await dio.get(
        kPostUrl,
      queryParameters: {
          'api_key' : "",
      }
    );

    if(response.statusCode == 200){
      return PostModel.fromJson(response.data);
    }
    else {
      throw ServerException();
    }
  }


}
