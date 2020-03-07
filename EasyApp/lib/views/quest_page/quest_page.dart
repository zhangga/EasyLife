import 'package:flutter/material.dart';
import 'package:EasyApp/utils/data_utils.dart';
import 'package:EasyApp/utils/constant.dart';
import 'package:EasyApp/utils/style.dart';
import 'package:EasyApp/utils/notice_utils.dart';
import 'package:EasyApp/model/quest.dart';
import 'package:EasyApp/components/quest_card.dart';
import 'package:EasyApp/event/event_bus.dart';

const String QUEST = "QUEST";

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

  List<QuestData> _quests = [];
  QuestData _currQuest = QuestData.fromJson({"sn": "0", "questName": ""});

  @override
  void initState() {
    super.initState();
    // 事件监听
    ApplicationEvent.event.on<QuestSelectedEvent>().listen(onQuestSelected);
    // 获取任务数据
    DataUtils.getTableDatasAtColumn(QUEST, ['sn', 'questName']).then((result) {
      List<QuestData> list = [];
      for (int i = 0; i < result.length; i++) {
        list.add(QuestData.fromJson(result[i]));
      }
      // 排序
      list.sort((o1, o2) => o1.sn.compareTo(o2.sn));
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
        Scrollbar(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            color: Colors.grey,
            child: buildQuestList(),
          ),
        ),
        // 任务编辑
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          color: Theme.of(context).backgroundColor,
          child: buildQuestEdit(),
        ),
      ],),
    );
  }

  // 任务列表
  ListView buildQuestList() {
    return ListView.separated(
      itemCount: _quests.length,
      separatorBuilder: (context, index) => Divider(height: 10.0),
      itemBuilder: (context, index) => QuestCardWidget(_quests[index].sn, _quests[index].name),
    );
  }

  // 任务编辑
  Widget buildQuestEdit() {
    if (_currQuest.sn == 0) {
      return Image(image: AssetImage('assets/images/p2.png'));
    }
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Color.fromARGB(200, 199, 237, 204),
          image: DecorationImage(image: AssetImage('assets/images/paimaiLogo.png'), fit: BoxFit.scaleDown, alignment: Alignment.bottomRight,)
        ),
        // 右侧任务编辑界面
        child: Wrap(
          spacing: 8.0, // 主轴(水平)方向间距
          runSpacing: 4.0, // 纵轴（垂直）方向间距
          alignment: WrapAlignment.start, //沿主轴方向
          children: <Widget>[
            // 基础属性
            buildBlockTitle('基础属性'),
            buildQuestBase(),
            buildDivider(),
            // 任务目标
            buildBlockTitle('任务目标'),
            buildQuestGoal(),
            buildDivider(),
          ],
        ),
      ),
    );
  }

  final TextEditingController _snEditContr = new TextEditingController();
  final TextEditingController _nameEditContr = new TextEditingController();
  final TextEditingController _typeEditContr = new TextEditingController();
  final TextEditingController _descEditContr = new TextEditingController();
  // 基础属性
  Widget buildQuestBase() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 10.0,
      alignment: WrapAlignment.start,
      children: <Widget>[
        // sn
        Text('SN：', style: AppTextStyle.label),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 30, maxWidth: 100),
          child: TextField(
            controller: _snEditContr,
            onEditingComplete: () {
              print(_snEditContr.text);
            },
            style: AppTextStyle.label,
            decoration: InputDecoration(hintText: "任务SN",),
          ),
        ),
        SizedBox(width: 50.0),
        // 任务名称
        Text('任务名称：', style: AppTextStyle.label),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 30, maxWidth: 200),
          child: TextField(
            controller: _nameEditContr,
            onEditingComplete: () {
              print(_nameEditContr.text);
            },
            style: AppTextStyle.label,
            decoration: InputDecoration(hintText: "任务名称",),
          ),
        ),
        SizedBox(width: 50.0),
        // 任务类型
        Text('任务类型：', style: AppTextStyle.label),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 30, maxWidth: 200),
          child: DropdownButton(
            hint: Text('请选择任务类型'),
            value: _currQuest.type,
            items: buildQuestType(),
            onChanged: (value) {print(value);},
          ),
        ),
        SizedBox(width: 50.0),
        // 任务描述
        Text('任务描述：', style: AppTextStyle.label),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 30, maxWidth: 800),
          child: TextField(
            controller: _descEditContr,
            onEditingComplete: () {
              print(_descEditContr.text);
            },
            style: AppTextStyle.label,
            decoration: InputDecoration(hintText: "任务描述",),
          ),
        ),
      ],
    );
  }

  Widget buildQuestGoal() {
    return Row(

    );
  }

  Widget buildBlockTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[Text(title, style: TextStyle(color: Colors.indigo, fontSize: 30),)],
    );
  }

  Widget buildDivider() {
    return Divider(height: 10.0, thickness: 3, indent: 0.0, color: Colors.deepPurple,);
  }

  // 刷新控件的值
  void updateWidgetValue() {
    setState(() {
      _snEditContr.text = _currQuest.sn.toString();
      _nameEditContr.text = _currQuest.name;
      _descEditContr.text = _currQuest.desc;
    });
  }

  // 任务选择事件
  void onQuestSelected(QuestSelectedEvent event) {
    int questSn = event.questSn;
    print("选择任务：" + questSn.toString());
    DataUtils.getTableDataBySn(QUEST, questSn).then((response) {
      print("获取数据：" + response.toString());
      if (response['result'] != "1") {
        NoticeUtils.showToast(context, response['hint']);
        return;
      }
      setState(() {
        _currQuest = QuestData.fromJson(response['data']);
      });
      updateWidgetValue();
    });
  }

  // 任务类型下拉菜单
  List<DropdownMenuItem> buildQuestType() {
    List<DropdownMenuItem> list = [];
    for (int i = 0; i < QUEST_TYPE.length; i+=2) {
      list.add(DropdownMenuItem(value: QUEST_TYPE[i], child: Text(QUEST_TYPE[i+1])));
    }
    return list;
  }

}
