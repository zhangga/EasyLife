import 'package:flutter/material.dart';
import 'package:EasyApp/utils/data_utils.dart';

/// 任务界面
/// Created by U-Demon
/// Date: 2020/3/6
class QuestPage extends StatefulWidget {
  @override
  _QuestPageState createState() => new _QuestPageState();
}

class _QuestPageState extends State<QuestPage> with AutomaticKeepAliveClientMixin {
  _QuestPageState() : super();

  @override
  bool get wantKeepAlive => true;

  List<_QuestData> _quests = [];

  @override
  void initState() {
    super.initState();
    // 获取任务数据
    DataUtils.getTableDatasAtColumn('QUEST', ['sn', 'questName']).then((result) {
      List<_QuestData> list = [];
      for (int i = 0; i < result.length; i++) {
        var json = result[i];
        list.add(_QuestData(int.parse(json['sn']), json['questName']));
      }
      setState(() {
        _quests = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Row(children: <Widget>[
        // 任务列表
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          color: Colors.grey,
          child: ListView.separated(
            itemCount: _quests.length,
            separatorBuilder: (context, index) => Divider(height: 12.0),
            itemBuilder: (context, index) {
              String text = "【" + _quests[index].sn.toString() + "】" + _quests[index].name;
              return ListTile(title: Text(text));
            },
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          color: Theme.of(context).backgroundColor,
          child: Text('2222'),
        ),
      ],),
    );
  }
}

class _QuestData {
  int sn;
  String name;

  _QuestData(this.sn, this.name);
}
