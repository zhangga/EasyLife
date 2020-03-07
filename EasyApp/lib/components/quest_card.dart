import 'package:flutter/material.dart';
import 'package:EasyApp/event/event_bus.dart';

/// Created by U-Demon
/// Date: 2020/3/7
class QuestCardWidget extends StatefulWidget {
  int sn;
  String name;

  QuestCardWidget(this.sn, this.name);

  @override
  _QuestCardWidgetState createState() => _QuestCardWidgetState();
}

class _QuestCardWidgetState extends State<QuestCardWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String name = "【"+widget.sn.toString()+"】"+widget.name;
    return FlatButton(
      child: ListTile(title: Text(name)),
      onPressed: () {
        ApplicationEvent.event.fire(QuestSelectedEvent(widget.sn));
      },
    );
  }

}
