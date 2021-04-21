import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:module_home/model/lesson.dart';

class LessonItem extends StatelessWidget {

  final Lesson lesson;
  final bool isLast;

  const LessonItem({Key key,
    this.lesson,
    this.isLast
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          border: Border.all(color: Colours.app_main_500, width: 1.0),
          borderRadius: BorderRadius.circular(23.0),   //圆角
        ),
        child: TextButton(
            onPressed: () {
              if (isLast) {
                Routers.navigateTo(
                    context,
                    Routers.milestonePage);
              } else {
                Routers.navigateTo(
                    context,
                    Routers.lessonPage,
                    parameters: Parameters()..putObj('lesson', lesson));
              }
            } ,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colours.transparent),
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 2)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(23)))),
            ),
            child: Text(lesson.title,
              style: TextStyles.textMain500_14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
        ),
      ),
    );
  }
}
