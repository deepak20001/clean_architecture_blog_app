import 'package:blog_app/core/common/widgets/common_text.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      /// app-bar
      appBar: AppBar(
        centerTitle: true,
        title: CommonText(
          title: Constants.blogApp,
          fontSize: size.width * numD055,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),

      /// body
      body: BlocConsumer<BlogBloc, BlogState>(listener: (context, state) {
        if (state is BlogFailure) {
          showSnackBar(context, state.error);
        }
      }, builder: (context, state) {
        if (state is BlogLoading) {
          return const Loader();
        }
        if (state is BlogDisplaySuccess) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state.blogs.length,
            itemBuilder: (context, index) {
              final blog = state.blogs[index];

              return BlogCard(
                blog: blog,
                color: index % 3 == 0
                    ? AppPallete.gradient1
                    : index % 2 == 0
                        ? AppPallete.gradient2
                        : AppPallete.gradient3,
              );
            },
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
