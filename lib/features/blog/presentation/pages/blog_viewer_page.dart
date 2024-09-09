import 'package:blog_app/core/common/widgets/common_text.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/common/widgets/space.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  static route(Blog blog) => MaterialPageRoute(
        builder: (context) => BlogViewerPage(blog: blog),
      );
  final Blog blog;
  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      /// app-bar
      appBar: AppBar(),

      /// body
      body: Scrollbar(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * numD03,
            ).copyWith(
              bottom: size.width * numD03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  title: blog.title,
                  fontSize: size.width * numD055,
                  fontWeight: FontWeight.bold,
                ),
                verticalSpace(size.width * numD03),
                CommonText(
                  title: 'By ${blog.posterName}',
                  fontSize: size.width * numD035,
                  fontWeight: FontWeight.w500,
                ),
                verticalSpace(size.width * numD015),
                CommonText(
                  title:
                      '${formatDateBydMMMYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min',
                  fontSize: size.width * numD035,
                  color: AppPallete.greyColor,
                  fontWeight: FontWeight.w500,
                ),
                verticalSpace(size.width * numD03),
                SizedBox(
                  height: size.width * numInt1,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(size.width * numD03),
                    child: CachedNetworkImage(
                      imageUrl: blog.imageUrl,
                      placeholder: (context, url) => const Loader(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                verticalSpace(size.width * numD03),
                CommonText(
                  title: blog.content,
                  fontSize: size.width * numD04,
                  color: AppPallete.greyColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
