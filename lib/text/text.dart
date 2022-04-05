import 'package:credit_cards/text/model.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';

class TextPage extends StatefulWidget {
  const TextPage({Key? key}) : super(key: key);

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  List<DraggableList> allLists = [
    DraggableList(
      header: 'Best Fruits',
      items: [
        DraggableListItem(
          text: 'Lemon',
        ),
      ],
    ),
    DraggableList(
      header: 'Good Fruits',
      items: [
        DraggableListItem(
          text: 'Orange',
        ),
        DraggableListItem(
          text: 'Papaya',
        ),
      ],
    ),
    DraggableList(
      header: 'Disliked Fruits',
      items: [
        DraggableListItem(
          text: 'Grapefruit',
        ),
        DraggableListItem(
          text: 'Strawberries',
        ),
        DraggableListItem(
          text: 'Banana',
        ),
      ],
    ),
  ];

  late List<DragAndDropList> lists;

  var selectedList = 0;

  @override
  void initState() {
    super.initState();
    _initWidgets();
  }

  DragAndDropItem _text() {
    return DragAndDropItem(
      child: DraggableTextWidget(
        key: UniqueKey(),
        onChanged: (text, key) => _onChanged(text, key),
      ),
    );
  }

  void _onChanged(String text, Key key) {
    var index = 0;
    int i = 0;
    int j = 0;
    for (var list in lists) {
      for (var element in list.children) {
        if (element.child.key == key) {
          setState(() {
            allLists[i].items[j].text = text;
          });
          _initWidgets();
        }
        j++;
      }
      i++;
      j = 0;
    }
  }

  void _initWidgets() {
    // lists = allLists.map(buildList).toList();
    lists = List.from(allLists.map(buildList).toList());
  }

  void _addText() {
    setState(() {
      if (lists.isEmpty) {
        lists.add(DragAndDropList(children: []));
      }
      lists.last.children.add(_text());
    });
  }

  void onReorderListItem(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      final oldListItems = lists[oldListIndex].children;
      final newListItems = lists[newListIndex].children;

      final movedItem = oldListItems.removeAt(oldItemIndex);
      newListItems.insert(newItemIndex, movedItem);
    });
  }

  void onReorderList(
    int oldListIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedList = lists.removeAt(oldListIndex);
      lists.insert(newListIndex, movedList);
    });
  }

  Widget _buildFloatingButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: _addText,
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.text_fields_outlined,
            size: 26,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 5),
        FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.image,
            size: 26,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  DragHandle buildDragHandle({bool isList = false}) {
    final verticalAlignment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;
    final color = isList ? Colors.blueGrey : Colors.black26;

    return DragHandle(
      verticalAlignment: verticalAlignment,
      child: Container(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(Icons.menu, color: color),
      ),
    );
  }

  DragAndDropList buildList(DraggableList list) => DragAndDropList(
        header: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            list.header,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        children: list.items
            .map((item) => DragAndDropItem(
                    child: DraggableTextWidget(
                  key: UniqueKey(),
                  text: item.text,
                  onChanged: (text, key) => _onChanged(text, key),
                )))
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: _buildFloatingButton(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: DragAndDropLists(
            children: lists,
            listDragHandle: buildDragHandle(isList: true),
            itemDragHandle: buildDragHandle(),
            onItemReorder: onReorderListItem,
            onListReorder: onReorderList,
          ),
        ),
      ),
    );
  }
}

class DraggableWidget {
  final TextFormField? textWidget;
  final Image? imageWidget;
  const DraggableWidget(this.textWidget, this.imageWidget);
}

class DraggableTextWidget extends StatefulWidget {
  final String? text;
  final Function(String text, Key key) onChanged;
  const DraggableTextWidget({
    this.text,
    required this.onChanged,
    required Key key,
  }) : super(key: key);

  @override
  State<DraggableTextWidget> createState() => _DraggableTextWidgetState();
}

class _DraggableTextWidgetState extends State<DraggableTextWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.text != null) {
      _controller.text = widget.text!;
    }
  }

  @override
  void dispose() {
    _controller.clear();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 8,
          child: TextFormField(
            onChanged: (text) => widget.onChanged(text, widget.key!),
            controller: _controller,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '...',
              hintStyle: TextStyle(
                fontSize: 24,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
        ),
        const Flexible(
          flex: 1,
          child: SizedBox(width: 20),
        ),
      ],
    );
  }
}
