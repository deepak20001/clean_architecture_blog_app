import 'package:blog_app/core/common/widgets/common_text.dart';
import 'package:blog_app/core/common/widgets/space.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({
    super.key,
    required this.blog,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(blog));
      },
      child: Container(
        height: size.width * numD50,
        margin: EdgeInsets.symmetric(
          horizontal: size.width * numD03,
          vertical: size.width * numD02,
        ),
        padding: EdgeInsets.all(size.width * numD03),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size.width * numD03),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: blog.topics
                          .map(
                            (e) => Padding(
                              padding:
                                  EdgeInsets.only(right: size.width * numD015),
                              child: Chip(
                                label: CommonText(
                                  title: e,
                                  fontSize: size.width * numD035,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  verticalSpace(size.width * numD015),
                  Flexible(
                    child: CommonText(
                      title: blog.title,
                      fontSize: size.width * numD055,
                      fontWeight: FontWeight.bold,
                      maxLine: 3,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(size.width * numD015),
            CommonText(
              title: '${calculateReadingTime(blog.content)} ${Constants.min}',
              fontSize: size.width * numD03,
            ),
          ],
        ),
      ),
    );
  }
}
