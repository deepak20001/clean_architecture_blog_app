import 'dart:io';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/common_text.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/common/widgets/space.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<String> _selectedTopics = [];
  File? _image;

  void _selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  void _uploadBlog() {
    if (_formKey.currentState!.validate() &&
        _selectedTopics.isNotEmpty &&
        _image != null) {
      /// we can get posterId i.e user-id via AppUserCubit as on logging in we are saving user-details
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
            BlogUpload(
              posterId: posterId,
              title: _titleController.text.trim(),
              content: _contentController.text.trim(),
              image: _image!,
              topics: _selectedTopics,
            ),
          );
    } else if (_image == null) {
      showSnackBar(context, Constants.selectImage);
    } else if (_selectedTopics.isEmpty) {
      showSnackBar(context, Constants.selectTopic);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
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
            onPressed: _uploadBlog,
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),

      /// body
      body: BlocConsumer<BlogBloc, BlogState>(listener: (context, state) {
        if (state is BlogFailure) {
          showSnackBar(context, state.error);
        } else if (state is BlogUploadSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            BlogPage.route(),
            (route) => false,
          );
        }
      }, builder: (context, state) {
        if (state is BlogLoading) {
          return const Loader();
        }
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(size.width * numD035),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _selectImage,
                    child: _image != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(size.width * numD03),
                            child: Image.file(
                              _image!,
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
                      children: Constants.topics
                          .map(
                            (e) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * numD015),
                              child: GestureDetector(
                                onTap: () {
                                  if (_selectedTopics.contains(e)) {
                                    _selectedTopics.remove(e);
                                  } else {
                                    _selectedTopics.add(e);
                                  }
                                  setState(() {});
                                  debugPrint(
                                      'selected-topics: $_selectedTopics');
                                },
                                child: Chip(
                                  label: CommonText(
                                    title: e,
                                    fontSize: size.width * numD035,
                                  ),
                                  color: (_selectedTopics.contains(e))
                                      ? const WidgetStatePropertyAll(
                                          AppPallete.gradient1)
                                      : null,
                                  side: (_selectedTopics.contains(e))
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
                    controller: _titleController,
                    hintText: Constants.blogTitle,
                  ),
                  verticalSpace(size.width * numD03),
                  BlogEditor(
                    controller: _contentController,
                    hintText: Constants.blogContent,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
