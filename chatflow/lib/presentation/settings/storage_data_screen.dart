import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';

class StorageDataScreen extends StatefulWidget {
  const StorageDataScreen({super.key});

  @override
  State<StorageDataScreen> createState() => _StorageDataScreenState();
}

class _StorageDataScreenState extends State<StorageDataScreen> {
  bool useLessDataCalls = true;

  bool autoDownload = true;
  bool autoDownloadPhotos = true;
  bool autoDownloadVideos = false;
  bool autoDownloadAudio = true;
  bool autoDownloadDocuments = true;

  int mediaUploadQuality = 1;

  bool saveGalleryPhotos = true;
  bool saveGalleryVideos = true;
  bool saveGalleryAudio = true;
  bool saveGalleryDocuments = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, key: 'storage_and_data')),
      ),
      body: ListView(
        padding: .symmetric(horizontal: 20, vertical: 10),
        children: [
          SwitchListTile(
            value: useLessDataCalls,
            title: Text(trans(context, key: 'reduce_data_usage_for_calls')),
            contentPadding: .zero,
            onChanged: (e) {
              setState(() {
                useLessDataCalls = e;
              });
            },
          ),
          spacing(height: 15),
          Text(trans(context, key: 'media_auto_download'),
              style: StyleHelper.titleSmall(context)),
          SwitchListTile(
            value: autoDownload,
            title: Text(trans(context, key: 'auto_download')),
            contentPadding: .zero,
            onChanged: (e) {
              setState(() {
                autoDownload = e;
              });
            },
          ),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  value: autoDownloadPhotos,
                  title: Text(trans(context, key: 'photos')),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: .zero,
                  onChanged: (e) {
                    setState(() {
                      autoDownloadPhotos = e!;
                    });
                  },
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  value: autoDownloadAudio,
                  title: Text(trans(context, key: 'audio')),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: .zero,
                  onChanged: (e) {
                    setState(() {
                      autoDownloadAudio = e!;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  value: autoDownloadVideos,
                  title: Text(trans(context, key: 'videos')),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: .zero,
                  onChanged: (e) {
                    setState(() {
                      autoDownloadVideos = e!;
                    });
                  },
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  value: autoDownloadDocuments,
                  title: Text(trans(context, key: 'documents')),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: .zero,
                  onChanged: (e) {
                    setState(() {
                      autoDownloadDocuments = e!;
                    });
                  },
                ),
              ),
            ],
          ),
          const Divider(),
          spacing(height: 15),
          Text(trans(context, key: 'save_to_gallery'),
              style: StyleHelper.titleSmall(context)),
          spacing(height: 5),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  value: saveGalleryPhotos,
                  title: Text(trans(context, key: 'photos')),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: .zero,
                  onChanged: (e) {
                    setState(() {
                      saveGalleryPhotos = e!;
                    });
                  },
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  value: saveGalleryAudio,
                  title: Text(trans(context, key: 'audio')),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: .zero,
                  onChanged: (e) {
                    setState(() {
                      saveGalleryAudio = e!;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  value: saveGalleryVideos,
                  title: Text(trans(context, key: 'videos')),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: .zero,
                  onChanged: (e) {
                    setState(() {
                      saveGalleryVideos = e!;
                    });
                  },
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  value: saveGalleryDocuments,
                  title: Text(trans(context, key: 'documents')),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: .zero,
                  onChanged: (e) {
                    setState(() {
                      saveGalleryDocuments = e!;
                    });
                  },
                ),
              ),
            ],
          ),
          spacing(height: 15),
          Text(trans(context, key: 'media_upload_quality'),
              style: StyleHelper.titleSmall(context)),
          spacing(height: 5),
          RadioGroup<int>(
            groupValue: mediaUploadQuality,
            onChanged: (int? value) {
              setState(() {
                mediaUploadQuality = value ?? 1;
              });
            },
            child: Column(
              children: [
                RadioListTile(
                  value: 1,
                  title: Text(trans(context, key: 'hd_quality')),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: .zero,
                ),
                RadioListTile(
                  value: 2,
                  title: Text(trans(context, key: 'standard_quality')),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: .zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
