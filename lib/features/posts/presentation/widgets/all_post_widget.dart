import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import 'post_widget.dart';

class AllPostsWidget extends StatelessWidget {
  const AllPostsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.failure != null) {
      return Center(child: Text(provider.failure!.errorMessage));
    }

    if (provider.allPosts == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.getAllPosts();
      });
      return const Center(child: CircularProgressIndicator());
    }

    // ✅ FIX: Wrap ListView in Expanded (since you're inside another Scaffold)
    return Expanded(
      child: ListView.builder(
        itemCount: provider.allPosts!.length,
        itemBuilder: (context, index) {
          final post = provider.allPosts![index];
          return ListTile(
            title: Text(post.title ?? ''),
            subtitle: Text(
              post.body ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostWidget(postId: post.id.toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
