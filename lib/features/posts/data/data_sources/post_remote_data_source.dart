import 'package:demo_clean_archtechture_with_provider/core/constants/constants.dart';
import 'package:demo_clean_archtechture_with_provider/core/errors/exceptions.dart';
import 'package:demo_clean_archtechture_with_provider/core/params/params.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/data/models/post_model.dart';
import 'package:dio/dio.dart';

abstract class PostRemoteDataSource {
  Future<PostModel> getAPost({required PostParams params});
  Future<List<PostModel>> getAllPost({required PostParams params});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource{

  final Dio dio;

  PostRemoteDataSourceImpl({required this.dio});

  @override
  Future<PostModel> getAPost({required PostParams params}) async {
    print(params.id);
    final response = await dio.get(
        kPostUrl+params.id,
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

  @override
  Future<List<PostModel>> getAllPost({required PostParams params}) async {
    final response = await dio.get(
      kPostUrl, // we don't need `+params.id` for all posts
      queryParameters: {
        'api_key': '',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      print(data.toString());
      return data.map((json) => PostModel.fromJson(json)).toList();

    } else {
      throw ServerException();
    }
  }
}
