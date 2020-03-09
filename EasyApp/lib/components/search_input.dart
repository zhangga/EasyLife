import 'package:flutter/material.dart';
import 'package:EasyApp/utils/style.dart';

class SearchInput extends StatefulWidget {
  final String hintText;

  SearchInput({Key key, this.hintText}) : super(key: key);

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  FocusNode focusNode = new FocusNode();
  OverlayEntry overlayEntry;
  OverlayEntry textFormOverlayEntry;
  LayerLink layerLink = new LayerLink();

  @override
  void initState() {
    super.initState();
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
          constraints: BoxConstraints(maxHeight: 50, maxWidth: 300),
          child: CompositedTransformTarget(
            link: layerLink,
            child: TextFormField(
              decoration: InputDecoration(hintText: widget.hintText, hintStyle: AppTextStyle.label),
              style: AppTextStyle.label,
              focusNode: focusNode,),
          ),
        ),
      ),
    );
  }

  /// 利用Overlay实现PopupWindow效果，悬浮的widget
  /// 利用CompositedTransformFollower和CompositedTransformTarget
  OverlayEntry createSelectPopupWindow() {
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return new Positioned(
        width: 200,
        child: new CompositedTransformFollower(
          offset: Offset(0.0, 50),
          link: layerLink,
          child: new Material(
            child: new Container(
                color: Colors.indigo,
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      title: new Text("选项1"),
                      onTap: () {
                        Toast.show(context: context, message: "选择了选项1");
                        focusNode.unfocus();
                      },
                    ),
                    new ListTile(
                        title: new Text("选项2"),
                        onTap: () {
                          Toast.show(context: context, message: "选择了选项1");
                          focusNode.unfocus();
                        }),
                  ],
                )),
          ),
        ),
      );
    });
    return overlayEntry;
  }
}

/// 利用overlay实现Toast
class Toast {
  static void show({@required BuildContext context, @required String message}) {
    //创建一个OverlayEntry对象
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return new Positioned(
          top: MediaQuery.of(context).size.height * 0.7,
          child: new Material(
            child: new Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: new Center(
                child: new Card(
                  child: new Padding(
                    padding: EdgeInsets.all(8),
                    child: new Text(message),
                  ),
                  color: Colors.grey,
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
