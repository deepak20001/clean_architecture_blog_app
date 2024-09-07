import 'dart:io';

import 'package:blog_app/core/common/widgets/common_text.dart';
import 'package:blog_app/core/common/widgets/space.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      /// app-bar
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),

      /// body
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.width * numD035),
          child: Column(
            children: [
              GestureDetector(
                onTap: selectImage,
                child: image != null
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.circular(size.width * numD03),
                        child: Image.file(
                          image!,
                          height: size.width * numD55,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : DottedBorder(
                        color: AppPallete.borderColor,
                        dashPattern: const [10, 4],
                        radius: Radius.circular(size.width * numD03),
                        borderType: BorderType.RRect,
                        strokeCap: StrokeCap.round,
                        child: SizedBox(
                          height: size.width * numD55,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open,
                                size: size.width * numD1,
                              ),
                              verticalSpace(size.width * numD035),
                              CommonText(
                                title: Constants.selectYourImage,
                                fontSize: size.width * numD035,
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              verticalSpace(size.width * numD05),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Constants.technology,
                    Constants.business,
                    Constants.programming,
                    Constants.entertainment,
                  ]
                      .map(
                        (e) => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * numD015),
                          child: GestureDetector(
                            onTap: () {
                              if (selectedTopics.contains(e)) {
                                selectedTopics.remove(e);
                              } else {
                                selectedTopics.add(e);
                              }
                              setState(() {});
                              debugPrint('selected-topics: $selectedTopics');
                            },
                            child: Chip(
                              label: CommonText(
                                title: e,
                                fontSize: size.width * numD035,
                              ),
                              color: (selectedTopics.contains(e))
                                  ? const WidgetStatePropertyAll(
                                      AppPallete.gradient1)
                                  : null,
                              side: (selectedTopics.contains(e))
                                  ? null
                                  : const BorderSide(
                                      color: AppPallete.borderColor,
                                    ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              verticalSpace(size.width * numD05),
              BlogEditor(
                controller: titleController,
                hintText: Constants.blogTitle,
              ),
              verticalSpace(size.width * numD05),
              BlogEditor(
                controller: contentController,
                hintText: Constants.blogContent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
