import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';

class SharedMedia extends StatelessWidget {
  const SharedMedia({super.key, required this.list});

  final List<dynamic> list;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: cardShape,
      elevation: 2,
      child: Padding(
        padding: const .all(15),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(trans(context, key: 'shared_media'),
                style: StyleHelper.titleMedium(context)),
            spacing(height: 10),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  mainAxisExtent: 70),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ImageWidget(
                  image: list[index]['link'],
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  type: ImageType.network,
                  placeholder: AssetsConst.imagePlaceholder,
                  borderRadius: .circular(10),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
