import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';

class PostWidget extends StatelessWidget {
  final String postId;
  const PostWidget({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context);

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (provider.failure != null) {
      return Scaffold(body: Center(child: Text(provider.failure!.errorMessage)));
    }

    if (provider.postEntities == null ||
        provider.postEntities!.id.toString() != postId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.getSinglePost(postId);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final post = provider.postEntities!;
    return Scaffold(
      appBar: AppBar(title: Text(post.title!)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(post.body!),
          ],
        ),
      ),
    );
  }
}
