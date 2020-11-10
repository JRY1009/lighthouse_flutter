
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/dimens.dart';
import 'package:lighthouse/ui/page2nd/home_page.dart';
import 'package:lighthouse/ui/page2nd/news_page.dart';
import 'package:lighthouse/ui/provider/main_provider.dart';
import 'package:lighthouse/ui/widget/auto_image.dart';
import 'package:lighthouse/utils/double_tap_back_exit_app.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  static const double _imageSize = 25.0;

  List<Widget> _pageList;
  List<String> _appBarTitles ;
  final PageController _pageController = PageController();

  MainProvider provider = MainProvider();

  List<BottomNavigationBarItem> _list;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  void initData() {
    _appBarTitles = [S.current.home, S.current.news, S.current.money, S.current.mine];
    _pageList = [
      HomePage(),
      Container(color: Colours.red),
      NewsPage(supportPullRefresh: true),
      Container(color: Colours.default_line),
    ];
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItem() {
    if (_list == null) {
      const _tabImages = [
        [
          LocalImage('tab_home', width: _imageSize, color: Colours.unselected_item_color,),
          LocalImage('tab_home', width: _imageSize, color: Colours.app_main_500,),
        ],
        [
          LocalImage('tab_news', width: _imageSize, color: Colours.unselected_item_color,),
          LocalImage('tab_news', width: _imageSize, color: Colours.app_main_500,),
        ],
        [
          LocalImage('tab_money', width: _imageSize, color: Colours.unselected_item_color,),
          LocalImage('tab_money', width: _imageSize, color: Colours.app_main_500,),
        ],
        [
          LocalImage('tab_mine', width: _imageSize, color: Colours.unselected_item_color,),
          LocalImage('tab_mine', width: _imageSize, color: Colours.app_main_500,),
        ]
      ];
      _list = List.generate(_tabImages.length, (i) {
        return BottomNavigationBarItem(
          icon: Container(margin: EdgeInsets.only(bottom: 3), child: _tabImages[i][0]),
          activeIcon: Container(margin: EdgeInsets.only(bottom: 3), child: _tabImages[i][1]),
          label: _appBarTitles[i],
        );
      });
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainProvider>(
      create: (_) => provider,
      child: DoubleTapBackExitApp(
        child: Scaffold(
          bottomNavigationBar: Consumer<MainProvider>(
            builder: (_, provider, __) {
              return BottomNavigationBar(
                backgroundColor: Colours.white,
                items: _buildBottomNavigationBarItem(),
                type: BottomNavigationBarType.fixed,
                currentIndex: provider.value,
                elevation: 5.0,
                iconSize: 21.0,
                selectedFontSize: Dimens.font_sp10,
                unselectedFontSize: Dimens.font_sp10,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Colours.unselected_item_color,
                onTap: (index) => _pageController.jumpToPage(index),
              );
            },
          ),
          // 使用PageView的原因参看 https://zhuanlan.zhihu.com/p/58582876
          body: PageView(
            physics: const NeverScrollableScrollPhysics(), // 禁止滑动
            controller: _pageController,
            onPageChanged: (int index) => provider.value = index,
            children: _pageList,
          )
        ),
      ),
    );
  }

}
