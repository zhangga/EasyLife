import 'package:flutter/material.dart';
import 'package:EasyApp/utils/style.dart';
import 'package:EasyApp/utils/data_utils.dart';
import 'package:EasyApp/event/event_bus.dart';

class SearchInput extends StatefulWidget {
  final String hintText;

  final double width;

  final String tableName;

  final List<String> cols;

  SearchInput({Key key, this.hintText, this.width, this.tableName, this.cols}) : super(key: key);

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  FocusNode focusNode = new FocusNode();
  OverlayEntry overlayEntry;
  OverlayEntry textFormOverlayEntry;
  LayerLink layerLink = new LayerLink();

  List<SearchData> _datas;
  String _searchKey = '';

  @override
  void initState() {
    super.initState();
    // 监听事件
    ApplicationEvent.event.on<TapBlankEvent>().listen(onClickedBlank);
    ApplicationEvent.event.on<QuestSelectedEvent>().listen(onClickedBlank);
    print('Search_Input: table=' + widget.tableName + ', cols=' + widget.cols.toString());
    // 获取表数据
    DataUtils.getTableDatasAtColumn(widget.tableName, widget.cols).then((result) {
      List<SearchData> list = [];
      for (int i = 0; i < result.length; i++) {
        SearchData data = SearchData();
        result[i].forEach((k,v) {
          if (k.toString().toLowerCase() == 'sn') {
            data.sn = int.parse(v);
          } else {
            data.name = v.toString();
          }
        });
        list.add(data);
      }
      setState(() {
        _datas = list;
      });
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        overlayEntry = createSelectPopupWindow();
        Overlay.of(context).insert(overlayEntry);
      } else {
        overlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (textFormOverlayEntry != null) {
          textFormOverlayEntry.remove();
          textFormOverlayEntry = null;
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: GestureDetector(
        onTap: () {
          if (textFormOverlayEntry != null) {
            textFormOverlayEntry.remove();
            textFormOverlayEntry = null;
          }
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 50, maxWidth: MediaQuery.of(context).size.width * widget.width),
          child: CompositedTransformTarget(
            link: layerLink,
            child: TextFormField(
              decoration: InputDecoration(hintText: widget.hintText, hintStyle: AppTextStyle.label),
              style: AppTextStyle.label,
              focusNode: focusNode,
              // 搜索输入
              onChanged: (value) => onChangeSearchKey(value),
            ),
          ),
        ),
      ),
    );
  }

  void onChangeSearchKey(value) {
    _searchKey = value;
    print('搜索：' + _searchKey);
    overlayEntry.remove();
    overlayEntry = createSelectPopupWindow();
    Overlay.of(context).insert(overlayEntry);
  }

  /// 利用Overlay实现PopupWindow效果，悬浮的widget
  /// 利用CompositedTransformFollower和CompositedTransformTarget
  OverlayEntry createSelectPopupWindow() {
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return new Positioned(
        width: MediaQuery.of(context).size.width * widget.width,
        child: new CompositedTransformFollower(
          offset: Offset(0.0, 50),
          link: layerLink,
          child: new Material(
            child: new Container(
                color: Colors.blueGrey,
                child: new Column(children: buildSearchResult(),)),
          ),
        ),
      );
    });
    return overlayEntry;
  }

  /// 构建搜索结果列表
  List<Widget> buildSearchResult() {
    List<Widget> list = [];
    // 搜索匹配
    for (SearchData data in _datas) {
      String dataValue = data.getShowValue();
      if (!dataValue.contains(_searchKey))
        continue;
      list.add(ListTile(
        title: Text(dataValue),
        onTap: () {
          Toast.show(context: context, message: '选择了$dataValue');
          focusNode.unfocus();
          ApplicationEvent.event.fire(QuestSelectedEvent(data.sn));
        },
      ));
      if (list.length >= 10)
        break;
    }
    return list;
  }

  void onClickedBlank(event) {
    focusNode.unfocus();
  }
}

/// 利用overlay实现Toast
class Toast {
  static void show({@required BuildContext context, @required String message}) {
    //创建一个OverlayEntry对象
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return new Positioned(
          top: MediaQuery.of(context).size.height * 0.9,
          child: new Material(
            child: new Container(
              width: MediaQuery.of(context).size.width * 0.2,
              alignment: Alignment.center,
              child: new Center(
                child: new Card(
                  child: new Padding(
                    padding: EdgeInsets.all(8),
                    child: new Text(message, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,),),
                  ),
                  color: Colors.pinkAccent,
                ),
              ),
            ),
          ));
    });
    //往Overlay中插入插入OverlayEntry
    Overlay.of(context).insert(overlayEntry);
    new Future.delayed(Duration(seconds: 2)).then((value) {
      overlayEntry.remove();
    });
  }
}

/// 搜索结果
class SearchData {
  int sn;
  String name;

  String getShowValue() {
    return '【'+sn.toString()+'】' + name;
  }
}



class SearchBarDelegate extends SearchDelegate<String> {
  static const searchList = [
    "wangcai",
    "xiaoxianrou",
    "dachangtui",
    "nvfengsi"
  ];
  static const recentSuggest = [
    "wangcai推荐-1",
    "nvfengsi推荐-2"
  ];
  //重写右侧的图标
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: ()=>query = "",)];
  }

  //重写返回图标
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      //关闭上下文，当前页面
      onPressed: ()=>close(context,null),
    );
  }

  //重写搜索结果
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      child: Card(color: Colors.redAccent, child: Center(child: Text(query),),),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty ? recentSuggest : searchList.where((input)=> input.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: RichText(text: TextSpan(
            text: suggestionList[index].substring(0, query.length),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),),
        );
      },
    );
  }
}
