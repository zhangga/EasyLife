/// Created by U-Demon
/// Date: 2020/3/7
class QuestData {

  int sn;
  String name;
  String desc;
  int type;

  QuestData({
    this.sn,
    this.name,
    this.desc,
    this.type,
  });

  factory QuestData.fromJson(Map<String, dynamic> json) {
    return QuestData(
      sn: parseInt(json['sn']),
      name: json['questName'],
      desc: json['questDescription'],
      type: parseInt(json['questType']),
    );
  }

  static int parseInt(var value) {
    if (value.runtimeType == String)
      return int.parse(value);
    return value;
  }

}
