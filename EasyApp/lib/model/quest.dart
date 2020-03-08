/// 任务数据
/// Created by U-Demon
/// Date: 2020/3/7
class QuestData {

  // 映射关系：组件-字段
  static Map<dynamic, String> widget_field = {};

  // 任务数据
  Map<String, dynamic> _data = {};

  QuestData(this._data);

  int getSN() {
    return parseInt(_data['sn']);
  }

  String getName() {
    return parseString(_data['questName']);
  }

  int getVerNum() {
    return parseInt(_data['verNum']);
  }

  void setVerNum(int verNum) {
    _data['verNum'] = verNum;
  }

  bool containsKey(String field) {
    return _data.containsKey(field);
  }

  String getValue(String field) {
    return parseString(_data[field]);
  }

  // 更新对象的值
  void update(Map<String, dynamic> json) {
    json.forEach((key, value) {
      _data[key] = value;
    });
  }

  static int parseInt(var value) {
    if (value.runtimeType == String)
      return int.parse(value);
    else if (value.runtimeType == int || value.runtimeType == double)
      return value;
    else {
      print('转换类型parseInt出错：$value');
      return 0;
    }
  }

  static String parseString(var value) {
    if (value.runtimeType == String)
      return value;
    else
      return value.toString();
  }

}
