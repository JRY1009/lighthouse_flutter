import 'package:flutter/material.dart';

///A controller for updating the single digit displayed by [DigitTicker]
class _DigitSlideController extends ValueNotifier {
  String _number;

  _DigitSlideController({String num = '0'}) : super(num) {
    this._number = num;
  }

  String get number => _number;

  set number(String num) {
    this._number = num;
    super.value = num;
  }
}

///A widget for displaying a single digit.
class _DigitSlide extends StatelessWidget {
  ///The color of background.
  final Color backgroundColor;

  ///The curve of scrolling animation.
  final Curve curve;

  ///The duration of animation.
  final Duration duration;

  ///The initial number to be displayed.
  final String initialNumber;

  ///The scrollController.
  ScrollController scrollController;

  ///The textStyle of number displayed.
  final TextStyle textStyle;

  ///The controller of this widget.
  final _DigitSlideController controller;

  _DigitSlide(
      {this.backgroundColor = Colors.transparent,
        this.curve = Curves.ease,
        this.controller,
        this.textStyle,
        this.initialNumber,
        this.duration})
      : assert(controller != null, 'Controller cannot be null.'),
        assert(initialNumber != null, 'Initial number cannot be null.'),
        super(key: Key(controller.toString())) {

    scrollController = ScrollController(initialScrollOffset: textStyle.fontSize * (9 / 10) * _initOffset());
    controller.addListener(onValueChanged);
  }

  int _initOffset() {
    if (_isNumber(initialNumber)) {
      return int.parse(initialNumber);
    }
    return 0;
  }

  bool _isNumber(String num) {
    if (num != null && num.length == 1) {
      int digit = num.codeUnitAt(0) - 48;
      if (digit >= 0 && digit <= 9) {
        return true;
      }
    }

    return false;
  }
  ///Scrolls to the positions of the new number.
  void onValueChanged() {
    if (this.scrollController.hasClients) {

      if(_isNumber(controller.number)) {
        int digit = controller.number.codeUnitAt(0) - 48;
        scrollController.animateTo(
            digit * textStyle.fontSize * (9 / 10),
            duration: duration,
            curve: curve);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        return true;
      },
      child: Container(
          color: backgroundColor,
          height: textStyle.fontSize * (9 / 10),
          width: _isNumber(controller.number) ? textStyle.fontSize * (6 / 10) : textStyle.fontSize * (3 / 10),
          child: Stack(
            children: [
              _isNumber(controller.number) ?
              ListView(
                controller: scrollController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (var i in List.generate(10, (index) => index))
                    Container(
                      height: textStyle.fontSize * (9 / 10),
                      child: Center(
                        child: Text("$i", style: textStyle),
                      ),
                    )
                ],
              ) :
              Container(
                height: textStyle.fontSize * (9 / 10),
                child: Center(
                  child: Text(controller.number, style: textStyle),
                ),
              )
            ],
          )),
    );
  }
}

class NumberSlideController extends ValueNotifier {
  String _number;

  NumberSlideController() : super(0) {
    this._number = '0';
  }

  String get number => _number;

  set number(String num) {
    this._number = num;
    super.value = num;
  }
}

///A widget for displaying the realtime change of a number.
class NumberSlide extends StatefulWidget {
  ///The color of background.
  final Color backgroundColor;

  ///The curve of scrolling animation.
  final Curve curve;

  ///The initial number to be displayed, default is 0.
  final String initialNumber;

  ///The duration of animation.
  final Duration duration;

  ///The controller of this widget.
  final NumberSlideController controller;

  ///The text style of the number.
  final TextStyle textStyle;

  NumberSlide(
      {this.backgroundColor = Colors.transparent,
        this.curve = Curves.ease,
        this.controller,
        this.textStyle = const TextStyle(color: Colors.black, fontSize: 12),
        this.initialNumber,
        this.duration = const Duration(milliseconds: 300)
      })
      : assert(controller != null, 'Controller cannot be null.'),
        assert(initialNumber != null, 'Initial number cannot be null.'),
        assert(duration != null, 'Duration cannot be null.') {
    this.controller.number = initialNumber;
  }

  @override
  _NumberSlideState createState() => _NumberSlideState();
}

///The state of [NumberSlide].
class _NumberSlideState extends State<NumberSlide>
    with SingleTickerProviderStateMixin {
  ///The animation controller for animating the removed or added [DigitTicker].
  AnimationController animationController;

  ///The string representation of the [currentNum].
  String currentNumString;

  ///The indicator of whether the new number is longer or shorter than the current one.
  bool shorter = false, longer = false;

  ///The list of [_DigitSlideController].
  List<_DigitSlideController> digitControllers = [];

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    var numString = widget.initialNumber;

    currentNumString = numString;

    for (int i = 0; i < numString.length; i++) {
      var digit = numString[i];
      digitControllers.insert(i, _DigitSlideController(num: digit));
    }

    widget.controller.addListener(onNumberChanged);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (shorter) {
            while(currentNumString.length < digitControllers.length) {
              digitControllers.removeLast();
            }
          }

          this.longer = false;
          this.shorter = false;
        });
        animationController.value = 0;
      }
    });

    super.initState();
  }

  ///Updates the number when notified.
  onNumberChanged() {
    if (animationController.isAnimating) {
      animationController.notifyStatusListeners(AnimationStatus.completed);
    }

    var numString = widget.controller.number;

    bool shorter = false;
    bool longer = false;

    if (numString.length < currentNumString.length) {

      int shortLength = currentNumString.length - numString.length;
      for (int i=digitControllers.length-1; i >= shortLength; i--) {
        digitControllers[i].number = '';
      }

      shorter = true;

    } else if (numString.length > currentNumString.length) {

      for (int i=0; i < numString.length - currentNumString.length; i++) {
        digitControllers.insert(i, _DigitSlideController(num: numString[i]));
      }

      longer = true;
    }

    int startIndex = 0;

    if (longer) {
      startIndex = numString.length - currentNumString.length;
    }

    for (int i = startIndex; i < numString.length; i++) {
      var digit = numString[i];
      var oldDigit = longer
          ? currentNumString[i-startIndex]
          : currentNumString[i];

      if (digit != oldDigit) {
        digitControllers[i].number = digit;
      }
    }

    currentNumString = numString;

    if (shorter || longer) {
      animationController.forward();
    }
    this.shorter = shorter;
    this.longer = longer;
  }

  @override
  Widget build(BuildContext context) {
    var width = widget.textStyle.fontSize * (6 / 10);
    return AnimatedBuilder(
        animation: animationController,
        builder: (_, __) {

          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: widget.backgroundColor,
                  width: longer ? (animationController.value) * width : width,
                  child: digitControllers.first == null
                      ? Text(' ')
                      : _DigitSlide(
                      backgroundColor: widget.backgroundColor,
                      controller: digitControllers.first,
                      curve: widget.curve,
                      duration: widget.duration,
                      textStyle: widget.textStyle,
                      initialNumber: currentNumString[0],
                )),

                for (int i = 1; i < digitControllers.length - 1; i++)
                  digitControllers[i] == null
                      ? Text(' ')
                      : _DigitSlide(
                      backgroundColor: widget.backgroundColor,
                      controller: digitControllers[i],
                      curve: widget.curve,
                      duration: widget.duration,
                      textStyle: widget.textStyle,
                      initialNumber: i == currentNumString.length ? '0' : currentNumString[i]),

                if (digitControllers.length > 1)
                  Container(
                    width: shorter
                        ? (1 - animationController.value) * width
                        : width,
                    child: digitControllers.last == null
                        ? Text(' ')
                        : _DigitSlide(
                        backgroundColor: widget.backgroundColor,
                        controller: digitControllers.last,
                        curve: widget.curve,
                        duration: widget.duration,
                        textStyle: widget.textStyle,
                        initialNumber: currentNumString[currentNumString.length - 1]),
                  ),
              ],
            ),
          );
        });
  }
}
