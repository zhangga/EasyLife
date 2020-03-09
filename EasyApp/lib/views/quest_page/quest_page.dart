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
  QuestData _currQuest = QuestData({"sn": "0"});

  @override
  void initState() {
    super.initState();
    _initWidget();
    // 事件监听
    ApplicationEvent.event.on<QuestSelectedEvent>().listen(onQuestSelected);
    // 获取任务数据
    DataUtils.getTableDatasAtColumn(QUEST, ['sn', 'questName']).then((result) {
      List<QuestData> list = [];
      for (int i = 0; i < result.length; i++) {
        list.add(QuestData(result[i]));
      }
      // 排序
      list.sort((o1, o2) => o1.getSN().compareTo(o2.getSN()));
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
      itemBuilder: (context, index) => QuestCardWidget(_quests[index].getSN(), _quests[index].getName()),
    );
  }

  // 任务编辑
  Widget buildQuestEdit() {
    if (_currQuest.getSN() == 0) {
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
          runSpacing: 8.0, // 纵轴（垂直）方向间距
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
            // 任务目标
            buildBlockTitle('接取关系'),
            buildQuestAccept(),
            buildDivider(),
          ],
        ),
      ),
    );
  }

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
            onEditingComplete: () => _updateQuestData1(_snEditContr, _snEditContr.text),
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
            onEditingComplete: () => _updateQuestData1(_nameEditContr, _nameEditContr.text),
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
            value: _currQuest.getIntValue('questType'),
            items: buildDropdownMenu(QUEST_TYPE),
            onChanged: (value) => _updateQuestData0('questType', value),
          ),
        ),
        Row(),
        // 任务描述
        Text('任务描述：', style: AppTextStyle.label),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 30, maxWidth: 800),
          child: TextField(
            controller: _descEditContr,
            onEditingComplete: () => _updateQuestData1(_descEditContr, _descEditContr.text),
            style: AppTextStyle.label,
            decoration: InputDecoration(hintText: "任务描述",),
          ),
        ),
      ],
    );
  }

  // 任务目标
  Widget buildQuestGoal() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 10.0,
      alignment: WrapAlignment.start,
      children: <Widget>[
        Text('或关系【||】', style: AppTextStyle.label_blue),
        // 目标关系
        Switch(
          activeColor: Colors.red,
          inactiveThumbColor: Colors.blue,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: _currQuest.getBoolValue('relationType'),
          onChanged: (value) => _updateQuestData0('relationType', value ? 1:0),
        ),
        Text('与关系【&&】', style: AppTextStyle.label_red),
      ],
    );
  }

  // 任务接取
  Widget buildQuestAccept() {
    return Wrap(

    );
  }

  Widget buildBlockTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[Text(title, style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),)],
    );
  }

  Widget buildDivider() {
    return Divider(height: 10.0, thickness: 5, indent: 0.0, color: Colors.brown,);
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
        _currQuest = QuestData(response['data']);
      });
      _updateWidgetValue();
    });
  }

  // 构建下拉菜单
  List<DropdownMenuItem> buildDropdownMenu(List list) {
    List<DropdownMenuItem> menu = [];
    for (int i = 0; i < list.length; i+=2) {
      menu.add(DropdownMenuItem(value: list[i], child: Text(list[i+1])));
    }
    return menu;
  }

  // 刷新控件的值
  void _updateWidgetValue() {
    setState(() {
      QuestData.widget_field.forEach((widget, field) {
        // 获取值
        if (!_currQuest.containsKey(field))
          return;
        String value = _currQuest.getValue(field);
        if (widget.runtimeType == TextEditingController) {
          (widget as TextEditingController).text = value;
        }
      });
    });
  }

  // 更新任务的值
  void _updateQuestData1(dynamic widget, String value) {
    if (!QuestData.widget_field.containsKey(widget)) {
      print('该组件没有对应的映射关系，不会修改数据内容：' + widget.toString());
      return;
    }
    String field = QuestData.widget_field[widget];
    _updateQuestData0(field, value);
  }

  void _updateQuestData0(String field, dynamic value) {
    setState(() {
      _currQuest.setValue(field, value);
    });
//    DataUtils.updateTableData(QUEST, _currQuest.getVerNum(), _currQuest.getSN(), {field: value.toString()}).then((response) {
//      if (response['result'] != '1') {
//        NoticeUtils.showToast(context, '保存失败！' + response['hint']);
//        return;
//      }
//      if (response['sn'] == _currQuest.getSN().toString()) {
//        _currQuest.setVerNum(response['verNum']);
//      }
//    }).catchError((e) {
//      NoticeUtils.showToast(context, '保存失败！' + e.toString());
//      return;
//    });
  }

  // 组件
  final TextEditingController _snEditContr = new TextEditingController();
  final TextEditingController _nameEditContr = new TextEditingController();
  final TextEditingController _descEditContr = new TextEditingController();
  // 初始化组件映射
  void _initWidget() {
    QuestData.widget_field[_snEditContr] = 'sn';
    QuestData.widget_field[_nameEditContr] = 'questName';
    QuestData.widget_field[_descEditContr] = 'questDescription';
  }

}
