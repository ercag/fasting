// ignore_for_file: must_be_immutable

import 'package:fasting/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class DummyProps {
  String? key;
  String title;
  Widget child;
  bool? selected;
  DummyProps(
      {this.key, required this.title, required this.child, this.selected});
}

class DummyPage extends StatefulWidget {
  Color? iconColor;

  DummyPage({Key? key, this.iconColor}) : super(key: key);

  @override
  State<DummyPage> createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  )..repeat(reverse: true);

  late Animation<Offset> offset = Tween<Offset>(
    begin: const Offset(-1.0, 0),
    end: const Offset(0.0, 0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));
  List<DummyProps> containers = [];
  DummyProps? activeContainer;

  @override
  void initState() {
    super.initState();
    containers.clear();

    containers.add(DummyProps(
      title: "Container 1",
      child: Container(
        height: 500,
        color: Colors.cyan,
      ),
    ));

    containers.add(DummyProps(
        title: "Container 2",
        child: Container(
          height: 500,
          color: Colors.red,
        )));

    containers.add(DummyProps(
        title: "Container 3",
        child: Container(
          height: 500,
          color: Colors.blueGrey,
        ),
        selected: true));

    for (var element in containers) {
      if (element.selected != null) {
        activeContainer = element;
      }
    }

    activeContainer ??= containers.first;

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CText("Dummy Page"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child: IconButton(
                    iconSize: 32,
                    onPressed: activeContainer != containers.first
                        ? () {
                            setState(() {
                              activeContainer = containers
                                  .takeWhile(
                                      (value) => value != activeContainer)
                                  .last;
                            });

                            offset = Tween<Offset>(
                              begin: const Offset(1.0, 0),
                              end: const Offset(0.0, 0),
                            ).animate(CurvedAnimation(
                              parent: _controller,
                              curve: Curves.easeInOutQuad,
                            ));
                            _controller.reset();
                            _controller.forward();
                          }
                        : null,
                    icon: Icon(
                      Icons.arrow_left,
                      color: widget.iconColor,
                    ),
                  )),
              CText(
                activeContainer == null ? "Welcome" : activeContainer!.title,
                fontSize: 16,
              ),
              Expanded(
                  flex: 2,
                  child: IconButton(
                    iconSize: 32,
                    onPressed: containers.last != activeContainer
                        ? () {
                            setState(() {
                              activeContainer = containers
                                  .skipWhile((x) => x != activeContainer)
                                  .skip(1)
                                  .first;
                            });

                            offset = Tween<Offset>(
                              begin: const Offset(-1.0, 0),
                              end: const Offset(0.0, 0),
                            ).animate(CurvedAnimation(
                              parent: _controller,
                              curve: Curves.easeInOutQuad,
                            ));
                            _controller.reset();
                            _controller.forward();
                          }
                        : null,
                    icon: Icon(Icons.arrow_right, color: widget.iconColor),
                  ))
            ],
          ),
          activeContainer == null
              ? Container()
              : SlideTransition(
                  position: offset,
                  child: activeContainer!.child,
                )
        ],
      ),
    );
  }
}
