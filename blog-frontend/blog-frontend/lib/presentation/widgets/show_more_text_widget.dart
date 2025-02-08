import 'package:flutter/cupertino.dart';
import 'package:readmore/readmore.dart';

import '../../core/ui.dart';

class ShowMoreTextWidget extends StatelessWidget {
  final String? text;
  final int? lines;
  final double? leftPad;
  const ShowMoreTextWidget({
    super.key,
    this.text,
    this.lines,
    this.leftPad,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPad ?? 8.0),
      child: ReadMoreText(
        text ??
            'but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
        trimMode: TrimMode.Line,
        trimLines: lines ?? 3,
        lessStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          color: AppColors.primaryColor,
        ),
        trimCollapsedText: 'Show more',
        trimExpandedText: 'Show less',
        moreStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
