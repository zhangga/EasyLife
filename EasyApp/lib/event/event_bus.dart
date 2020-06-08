import 'package:event_bus/event_bus.dart';

/// Created by U-Demon
/// Date: 2020/3/4
class ApplicationEvent {
  static EventBus event;
}

// 任务选中事件
class QuestSelectedEvent {
  final int questSn;
  QuestSelectedEvent(this.questSn);
}

// 点击空白处
class TapBlankEvent {
  TapBlankEvent();
}
