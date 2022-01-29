// ignore_for_file: must_be_immutable

import 'package:fasting/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class SlidableWidgetProps {
  String? key;
  String title;
  Widget child;
  bool? selected;
  SlidableWidgetProps(
      {this.key, required this.title, required this.child, this.selected});
}

class SlidableWidget extends StatefulWidget {
  Color? iconColor;
  List<SlidableWidgetProps> list = [];
  bool lock;
  Function(SlidableWidgetProps oldContainer, SlidableWidgetProps nextContainer)?
      afterNext;
  Function(SlidableWidgetProps oldContainer,
      SlidableWidgetProps previousContainer)? afterPrevious;
  Function(SlidableWidgetProps activeContainer, bool lockStatus)? onLock;

  SlidableWidget(
      {Key? key,
      required this.list,
      this.iconColor,
      required this.lock,
      this.afterNext,
      this.afterPrevious,
      this.onLock})
      : super(key: key);

  @override
  State<SlidableWidget> createState() => _SlidableWidgetState();
}

class _SlidableWidgetState extends State<SlidableWidget>
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
  // List<SlidableWidgetProps> containers = [];
  SlidableWidgetProps? activeContainer;

  @override
  void initState() {
    super.initState();
    setSelected();
  }

  @override
  void didChangeDependencies() {
    setSelected();
    super.didChangeDependencies();
  }

  void setSelected() {
    for (var element in widget.list) {
      if (element.selected != null) {
        activeContainer = element;
      }
    }

    activeContainer ??= widget.list.first;
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Row(
        children: [
          Expanded(
              flex: 2,
              child: IconButton(
                iconSize: 32,
                onPressed: activeContainer != widget.list.first
                    ? widget.lock
                        ? null
                        : () {
                            SlidableWidgetProps? oldContainer = activeContainer;
                            setState(() {
                              activeContainer = widget.list
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
                            if (widget.afterPrevious != null) {
                              widget.afterPrevious!(
                                  oldContainer!, activeContainer!);
                            }
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
                onPressed: widget.list.last != activeContainer
                    ? widget.lock
                        ? null
                        : () {
                            SlidableWidgetProps? oldContainer = activeContainer;

                            setState(() {
                              activeContainer = widget.list
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

                            if (widget.afterNext != null) {
                              widget.afterNext!(
                                  oldContainer!, activeContainer!);
                            }
                          }
                    : null,
                icon: Icon(Icons.arrow_right, color: widget.iconColor),
              )),
          Expanded(
              flex: 2,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      widget.lock = !widget.lock;
                    });
                    if (widget.onLock != null) {
                      widget.onLock!(activeContainer!, widget.lock);
                    }
                  },
                  icon: widget.lock
                      ? const Icon(
                          Icons.lock,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.lock_open,
                          color: Colors.green,
                        )))
        ],
      ),
      activeContainer == null
          ? Container()
          : SlideTransition(
              position: offset,
              child: activeContainer!.child,
            )
    ]);
  }
}
