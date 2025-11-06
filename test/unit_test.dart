import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:demo_clean_archtechture_with_provider/core/errors/failure.dart';
import 'package:demo_clean_archtechture_with_provider/core/params/params.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/entities/post.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/repositories/post_repositories.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/usecases/get_post_usecase.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/domain/usecases/get_all_post_usecase.dart';

import 'unit_test.mocks.dart';

// Add this annotation to generate mocks
@GenerateMocks([PostRepository])

void main() {
  late MockPostRepository mockRepository;
  late GetAPostUseCase getAPostUseCase;
  late GetAllPostUseCase getAllPostUseCase;

  setUp(() {
    mockRepository = MockPostRepository();
    getAPostUseCase = GetAPostUseCase(mockRepository);
    getAllPostUseCase = GetAllPostUseCase(mockRepository);
  });

  final testPost = PostEntities(id: 1, title: "Test Title", body: "Test Body");
  final testPosts = [
    PostEntities(id: 1, title: "Test 1", body: "Body 1"),
    PostEntities(id: 2, title: "Test 2", body: "Body 2"),
  ];
  final testFailure = ServerFailure(errorMessage: "Server error");
  final testParams = PostParams(id: '1');
  final allPostsParams = PostParams(id: '');

  group('GetAPostUseCase', () {
    test('should return a post when repository returns data successfully', () async {
      // Arrange
      when(mockRepository.getAPost(params: anyNamed('params')))
          .thenAnswer((_) async => Right(testPost));

      // Act
      final result = await getAPostUseCase(params: testParams);

      // Assert
      expect(result, Right(testPost));
      verify(mockRepository.getAPost(params: testParams)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a failure when repository fails', () async {
      // Arrange
      when(mockRepository.getAPost(params: anyNamed('params')))
          .thenAnswer((_) async => Left(testFailure));

      // Act
      final result = await getAPostUseCase(params: testParams);

      // Assert
      expect(result, Left(testFailure));
      verify(mockRepository.getAPost(params: testParams)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('GetAllPostUseCase', () {
    test('should return a list of posts when repository returns data successfully', () async {
      // Arrange
      when(mockRepository.getAllPost(params: anyNamed('params')))
          .thenAnswer((_) async => Right(testPosts));

      // Act
      final result = await getAllPostUseCase(params: allPostsParams);

      // Assert
      expect(result, Right(testPosts));
      verify(mockRepository.getAllPost(params: allPostsParams)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a failure when repository fails', () async {
      // Arrange
      when(mockRepository.getAllPost(params: anyNamed('params')))
          .thenAnswer((_) async => Left(testFailure));

      // Act
      final result = await getAllPostUseCase(params: allPostsParams);

      // Assert
      expect(result, Left(testFailure));
      verify(mockRepository.getAllPost(params: allPostsParams)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}