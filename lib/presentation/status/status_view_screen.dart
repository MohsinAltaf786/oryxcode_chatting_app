import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StatusViewScreen extends StatefulWidget {
  const StatusViewScreen({super.key, this.data});

  final dynamic data;

  @override
  State<StatusViewScreen> createState() => _StatusViewScreenState();
}

class _StatusViewScreenState extends State<StatusViewScreen> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<StoryItem> storyItems = widget.data['status'].map<StoryItem>((item) {
      if (item['type'] == 'image') {
        return StoryItem.pageImage(
          url: item['url'],
          caption: item.containsKey('caption')
              ? Text(
                  item['caption'],
                  textAlign: TextAlign.center,
                  style: StyleHelper.titleMedium(context)
                      ?.copyWith(color: AppColors.white),
                )
              : null,
          controller: storyController,
        );
      } else if (item['type'] == 'text') {
        return StoryItem.text(
          title: item['title'],
          backgroundColor: item.containsKey('backgroundColor')
              ? item['backgroundColor']
              : Colors.blue,
          textStyle: StyleHelper.headlineMedium(context),
        );
      }
      else if (item['type'] == 'video') {
        return StoryItem.pageVideo(
          item['url'],
          caption: item.containsKey('caption')
              ? Text(
                  item['caption'],
                  textAlign: TextAlign.center,
                  style: StyleHelper.titleMedium(context)
                      ?.copyWith(color: AppColors.white),
                )
              : null,
          controller: storyController,
        );
      }
      else {
        throw Exception('Unsupported status type');
      }
    }).toList();

    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        children: [
          StoryView(
            storyItems: storyItems,
            onComplete: () {
              navigateBack(context);
            },
            progressPosition: ProgressPosition.top,
            repeat: false,
            onVerticalSwipeComplete: (p0) {
              navigateBack(context);
            },
            controller: storyController,
          ),
          _buildAppBar()
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SafeArea(
      child: Padding(
        padding: const .only(top: 20),
        child: Row(
          children: [
            spacing(width: 5),
            IconButton(
                onPressed: () {
                  navigateBack(context);
                },
                icon:
                const Icon(Icons.arrow_back, color: AppColors.white)),
            spacing(width: 15),
            Expanded(
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    '${widget.data['name']}',
                    style: StyleHelper.titleMedium(context)
                        ?.copyWith(color: AppColors.white),
                  ),
                  Text('${widget.data['created_at']}',
                      style: StyleHelper.titleSmall(context)?.copyWith(
                          color: Colors.white60,
                          fontSize: 13
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
