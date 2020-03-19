import 'package:flutter/material.dart';
import 'package:EasyApp/model/user_info.dart';
import 'package:EasyApp/views/quest_page/quest_page.dart';
import 'package:EasyApp/views/quest_page/tables_page.dart';
import 'package:EasyApp/components/search_input.dart';

/// Created by U-Demon
/// Date: 2020/3/4
class AppPage extends StatefulWidget {
  final UserInfo userInfo;

  AppPage(this.userInfo);

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<AppPage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  List<Widget> _list = List();
  List tabData = [
    {'text': '任务', 'icon': Icon(Icons.import_contacts)},
    {'text': '管理', 'icon': Icon(Icons.home)}
  ];
  List<BottomNavigationBarItem> _myTabs = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < tabData.length; i++) {
      _myTabs.add(BottomNavigationBarItem(
        icon: tabData[i]['icon'],
        title: Text(tabData[i]['text'])
      ));
    }
    _list
      ..add(QuestPage())
      ..add(TablesPage());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(context, widget, _currentIndex),
      body: IndexedStack(
        index: _currentIndex,
        children: _list,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _myTabs,
        // 高亮  被点击高亮
        currentIndex: _currentIndex,
        // 修改 页面
        onTap: onBottomItemTapped,
        // fixed：固定
        type: BottomNavigationBarType.fixed,
        fixedColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: null,
      ),
    );
  }

  renderAppBar(BuildContext context, Widget widget, int index) {
    if (index == 0) {
      return AppBar(title: SearchInput(hintText: '搜索任务名称/ID', width: 0.2, tableName: QUEST, cols: ['sn', 'questName'],));
    }
    else if (index == 1) {
      return AppBar(title: Text(tabData[index]['text']),);
    }
    else {
      return AppBar(
        title: Text('按照名称/ID搜索'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () => showSearch(context: context, delegate: SearchBarDelegate()),),
        ],);
    }
  }

  void onBottomItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
