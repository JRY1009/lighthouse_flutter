// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// The over-scroll distance that moves the indicator to its maximum
// displacement, as a percentage of the scrollable's container extent.
const double _kDragContainerExtentPercentage = 0.25;

// How much the scroll's drag gesture can overshoot the NestedRefreshIndicator's
// displacement; max displacement = _kDragSizeFactorLimit * displacement.
const double _kDragSizeFactorLimit = 1.5;

// When the scroll ends, the duration of the refresh indicator's animation
// to the NestedRefreshIndicator's displacement.
const Duration _kIndicatorSnapDuration = Duration(milliseconds: 150);

// The duration of the ScaleTransition that starts when the refresh action
// has completed.
const Duration _kIndicatorScaleDuration = Duration(milliseconds: 200);

/// The signature for a function that's called when the user has dragged a
/// [NestedRefreshIndicator] far enough to demonstrate that they want the app to
/// refresh. The returned [Future] must complete when the refresh operation is
/// finished.
///
/// Used by [NestedRefreshIndicator.onRefresh].
typedef NestedRefreshCallback = Future<void> Function();

// The state machine moves through these modes only when the scrollable
// identified by scrollableKey has been scrolled to its min or max limit.
enum _NestedRefreshIndicatorMode {
  drag,     // Pointer is down.
  armed,    // Dragged far enough that an up event will run the onRefresh callback.
  snap,     // Animating to the indicator's final "displacement".
  refresh,  // Running the refresh callback.
  done,     // Animating the indicator's fade-out after refreshing.
  canceled, // Animating the indicator's fade-out after not arming.
}

/// Used to configure how [NestedRefreshIndicator] can be triggered.
enum NestedRefreshIndicatorTriggerMode {
  /// The indicator can be triggered regardless of the scroll position
  /// of the [Scrollable] when the drag starts.
  anywhere,

  /// The indicator can only be triggered if the [Scrollable] is at the edge
  /// when the drag starts.
  onEdge,
}

/// A widget that supports the Material "swipe to refresh" idiom.
///
/// When the child's [Scrollable] descendant overscrolls, an animated circular
/// progress indicator is faded into view. When the scroll ends, if the
/// indicator has been dragged far enough for it to become completely opaque,
/// the [onRefresh] callback is called. The callback is expected to update the
/// scrollable's contents and then complete the [Future] it returns. The refresh
/// indicator disappears after the callback's [Future] has completed.
///
/// The trigger mode is configured by [NestedRefreshIndicator.triggerMode].
///
/// ## Troubleshooting
///
/// ### Refresh indicator does not show up
///
/// The [NestedRefreshIndicator] will appear if its scrollable descendant can be
/// overscrolled, i.e. if the scrollable's content is bigger than its viewport.
/// To ensure that the [NestedRefreshIndicator] will always appear, even if the
/// scrollable's content fits within its viewport, set the scrollable's
/// [Scrollable.physics] property to [AlwaysScrollableScrollPhysics]:
///
/// ```dart
/// ListView(
///   physics: const AlwaysScrollableScrollPhysics(),
///   children: ...
/// )
/// ```
///
/// A [NestedRefreshIndicator] can only be used with a vertical scroll view.
///
/// See also:
///
///  * <https://material.io/design/platform-guidance/android-swipe-to-refresh.html>
///  * [NestedRefreshIndicatorState], can be used to programmatically show the refresh indicator.
///  * [RefreshProgressIndicator], widget used by [NestedRefreshIndicator] to show
///    the inner circular progress spinner during refreshes.
///  * [CupertinoSliverRefreshControl], an iOS equivalent of the pull-to-refresh pattern.
///    Must be used as a sliver inside a [CustomScrollView] instead of wrapping
///    around a [ScrollView] because it's a part of the scrollable instead of
///    being overlaid on top of it.
class NestedRefreshIndicator extends StatefulWidget {
  /// Creates a refresh indicator.
  ///
  /// The [onRefresh], [child], and [notificationPredicate] arguments must be
  /// non-null. The default
  /// [displacement] is 40.0 logical pixels.
  ///
  /// The [semanticsLabel] is used to specify an accessibility label for this widget.
  /// If it is null, it will be defaulted to [MaterialLocalizations.refreshIndicatorSemanticLabel].
  /// An empty string may be passed to avoid having anything read by screen reading software.
  /// The [semanticsValue] may be used to specify progress on the widget.
  const NestedRefreshIndicator({
    Key? key,
    required this.child,
    this.displacement = 40.0,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = nestedScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = 2.0,
    this.triggerMode = NestedRefreshIndicatorTriggerMode.onEdge,
  }) : assert(child != null),
        assert(onRefresh != null),
        assert(notificationPredicate != null),
        assert(strokeWidth != null),
        assert(triggerMode != null),
        super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// The refresh indicator will be stacked on top of this child. The indicator
  /// will appear when child's Scrollable descendant is over-scrolled.
  ///
  /// Typically a [ListView] or [CustomScrollView].
  final Widget child;

  /// The distance from the child's top or bottom edge to where the refresh
  /// indicator will settle. During the drag that exposes the refresh indicator,
  /// its actual displacement may significantly exceed this value.
  final double displacement;

  /// A function that's called when the user has dragged the refresh indicator
  /// far enough to demonstrate that they want the app to refresh. The returned
  /// [Future] must complete when the refresh operation is finished.
  final NestedRefreshCallback onRefresh;

  /// The progress indicator's foreground color. The current theme's
  /// [ThemeData.accentColor] by default.
  final Color? color;

  /// The progress indicator's background color. The current theme's
  /// [ThemeData.canvasColor] by default.
  final Color? backgroundColor;

  /// A check that specifies whether a [ScrollNotification] should be
  /// handled by this widget.
  ///
  /// By default, checks whether `notification.depth == 0`. Set it to something
  /// else for more complicated layouts.
  final ScrollNotificationPredicate notificationPredicate;

  /// {@macro flutter.progress_indicator.ProgressIndicator.semanticsLabel}
  ///
  /// This will be defaulted to [MaterialLocalizations.refreshIndicatorSemanticLabel]
  /// if it is null.
  final String? semanticsLabel;

  /// {@macro flutter.progress_indicator.ProgressIndicator.semanticsValue}
  final String? semanticsValue;

  /// Defines `strokeWidth` for `NestedRefreshIndicator`.
  ///
  /// By default, the value of `strokeWidth` is 2.0 pixels.
  final double strokeWidth;

  /// Defines how this [NestedRefreshIndicator] can be triggered when users overscroll.
  ///
  /// The [NestedRefreshIndicator] can be pulled out in two cases,
  /// 1, Keep dragging if the scrollable widget at the edge with zero scroll position
  ///    when the drag starts.
  /// 2, Keep dragging after overscroll occurs if the scrollable widget has
  ///    a non-zero scroll position when the drag starts.
  ///
  /// If this is [NestedRefreshIndicatorTriggerMode.anywhere], both of the cases above can be triggered.
  ///
  /// If this is [NestedRefreshIndicatorTriggerMode.onEdge], only case 1 can be triggered.
  ///
  /// Defaults to [NestedRefreshIndicatorTriggerMode.onEdge].
  final NestedRefreshIndicatorTriggerMode triggerMode;

  @override
  NestedRefreshIndicatorState createState() => NestedRefreshIndicatorState();
}

/// Contains the state for a [NestedRefreshIndicator]. This class can be used to
/// programmatically show the refresh indicator, see the [show] method.
class NestedRefreshIndicatorState extends State<NestedRefreshIndicator> with TickerProviderStateMixin<NestedRefreshIndicator> {
  late AnimationController _positionController;
  late AnimationController _scaleController;
  late Animation<double> _positionFactor;
  late Animation<double> _scaleFactor;
  late Animation<double> _value;
  Animation<Color?>? _valueColor;

  _NestedRefreshIndicatorMode? _mode;
  Future<void>? _pendingRefreshFuture;
  bool? _isIndicatorAtTop;
  double? _dragOffset;

  static final Animatable<double> _threeQuarterTween = Tween<double>(begin: 0.0, end: 0.75);
  static final Animatable<double> _kDragSizeFactorLimitTween = Tween<double>(begin: 0.0, end: _kDragSizeFactorLimit);
  static final Animatable<double> _oneToZeroTween = Tween<double>(begin: 1.0, end: 0.0);

  @override
  void initState() {
    super.initState();
    _positionController = AnimationController(vsync: this);
    _positionFactor = _positionController.drive(_kDragSizeFactorLimitTween);
    _value = _positionController.drive(_threeQuarterTween); // The "value" of the circular progress indicator during a drag.

    _scaleController = AnimationController(vsync: this);
    _scaleFactor = _scaleController.drive(_oneToZeroTween);
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _valueColor = _positionController.drive(
      ColorTween(
        begin: (widget.color ?? theme.accentColor).withOpacity(0.0),
        end: (widget.color ?? theme.accentColor).withOpacity(1.0),
      ).chain(CurveTween(
          curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit)
      )),
    );
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant NestedRefreshIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      final ThemeData theme = Theme.of(context);
      _valueColor = _positionController.drive(
        ColorTween(
          begin: (widget.color ?? theme.accentColor).withOpacity(0.0),
          end: (widget.color ?? theme.accentColor).withOpacity(1.0),
        ).chain(CurveTween(
            curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit)
        )),
      );
    }
  }

  @override
  void dispose() {
    _positionController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  bool _shouldStart(ScrollNotification notification) {
    return (notification is ScrollStartNotification || (notification is ScrollUpdateNotification && notification.dragDetails != null && widget.triggerMode == NestedRefreshIndicatorTriggerMode.anywhere))
        && notification.metrics.extentBefore == 0.0
        && _mode == null
        && _start(notification.metrics.axisDirection);
  }

  double maxContainerExtent = 0.0;
  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification))
      return false;

    maxContainerExtent = math.max(notification.metrics.viewportDimension, maxContainerExtent);
    if (_shouldStart(notification)) {
      setState(() {
        _mode = _NestedRefreshIndicatorMode.drag;
      });
      return false;
    }
    bool? indicatorAtTopNow;
    switch (notification.metrics.axisDirection) {
      case AxisDirection.down:
        indicatorAtTopNow = true;
        break;
      case AxisDirection.up:
        indicatorAtTopNow = false;
        break;
      case AxisDirection.left:
      case AxisDirection.right:
        indicatorAtTopNow = null;
        break;
    }
    if (indicatorAtTopNow != _isIndicatorAtTop) {
      if (_mode == _NestedRefreshIndicatorMode.drag || _mode == _NestedRefreshIndicatorMode.armed) {
        _dismiss(_NestedRefreshIndicatorMode.canceled);
      }
    } else if (notification is ScrollUpdateNotification) {
      if (_mode == _NestedRefreshIndicatorMode.drag || _mode == _NestedRefreshIndicatorMode.armed) {
        if (notification.metrics.extentBefore > 0.0) {
          _dismiss(_NestedRefreshIndicatorMode.canceled);
        } else {
          _dragOffset = _dragOffset! - notification.scrollDelta!;
          _checkDragOffset(maxContainerExtent);
        }
      }
      if (_mode == _NestedRefreshIndicatorMode.armed && notification.dragDetails == null) {
        // On iOS start the refresh when the Scrollable bounces back from the
        // overscroll (ScrollNotification indicating this don't have dragDetails
        // because the scroll activity is not directly triggered by a drag).
        _show();
      }
    } else if (notification is OverscrollNotification) {
      if (_mode == _NestedRefreshIndicatorMode.drag || _mode == _NestedRefreshIndicatorMode.armed) {
        _dragOffset = _dragOffset! - notification.overscroll / 2.0;
        _checkDragOffset(maxContainerExtent);
      }
    } else if (notification is ScrollEndNotification) {
      switch (_mode) {
        case _NestedRefreshIndicatorMode.armed:
          _show();
          break;
        case _NestedRefreshIndicatorMode.drag:
          _dismiss(_NestedRefreshIndicatorMode.canceled);
          break;
        default:
        // do nothing
          break;
      }
    }
    return false;
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    if (notification.depth != 0 || !notification.leading)
      return false;
    if (_mode == _NestedRefreshIndicatorMode.drag) {
      notification.disallowGlow();
      return true;
    }
    return false;
  }

  bool _start(AxisDirection direction) {
    assert(_mode == null);
    assert(_isIndicatorAtTop == null);
    assert(_dragOffset == null);
    switch (direction) {
      case AxisDirection.down:
        _isIndicatorAtTop = true;
        break;
      case AxisDirection.up:
        _isIndicatorAtTop = false;
        break;
      case AxisDirection.left:
      case AxisDirection.right:
        _isIndicatorAtTop = null;
        // we do not support horizontal scroll views.
        return false;
    }
    _dragOffset = 0.0;
    _scaleController.value = 0.0;
    _positionController.value = 0.0;
    return true;
  }

  void _checkDragOffset(double containerExtent) {
    assert(_mode == _NestedRefreshIndicatorMode.drag || _mode == _NestedRefreshIndicatorMode.armed);
    double newValue = _dragOffset! / (containerExtent * _kDragContainerExtentPercentage);
    if (_mode == _NestedRefreshIndicatorMode.armed)
      newValue = math.max(newValue, 1.0 / _kDragSizeFactorLimit);
    _positionController.value = newValue.clamp(0.0, 1.0); // this triggers various rebuilds
    if (_mode == _NestedRefreshIndicatorMode.drag && _valueColor!.value!.alpha == 0xFF)
      _mode = _NestedRefreshIndicatorMode.armed;
  }

  // Stop showing the refresh indicator.
  Future<void> _dismiss(_NestedRefreshIndicatorMode newMode) async {
    await Future<void>.value();
    // This can only be called from _show() when refreshing and
    // _handleScrollNotification in response to a ScrollEndNotification or
    // direction change.
    assert(newMode == _NestedRefreshIndicatorMode.canceled || newMode == _NestedRefreshIndicatorMode.done);
    setState(() {
      _mode = newMode;
    });
    switch (_mode) {
      case _NestedRefreshIndicatorMode.done:
        await _scaleController.animateTo(1.0, duration: _kIndicatorScaleDuration);
        break;
      case _NestedRefreshIndicatorMode.canceled:
        await _positionController.animateTo(0.0, duration: _kIndicatorScaleDuration);
        break;
      default:
        assert(false);
    }
    if (mounted && _mode == newMode) {
      _dragOffset = null;
      _isIndicatorAtTop = null;
      setState(() {
        _mode = null;
      });
    }
  }

  void _show() {
    assert(_mode != _NestedRefreshIndicatorMode.refresh);
    assert(_mode != _NestedRefreshIndicatorMode.snap);
    final Completer<void> completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
    _mode = _NestedRefreshIndicatorMode.snap;
    _positionController
        .animateTo(1.0 / _kDragSizeFactorLimit, duration: _kIndicatorSnapDuration)
        .then<void>((void value) {
      if (mounted && _mode == _NestedRefreshIndicatorMode.snap) {
        assert(widget.onRefresh != null);
        setState(() {
          // Show the indeterminate progress indicator.
          _mode = _NestedRefreshIndicatorMode.refresh;
        });

        final Future<void> refreshResult = widget.onRefresh();
        assert(() {
          if (refreshResult == null)
            FlutterError.reportError(FlutterErrorDetails(
              exception: FlutterError(
                  'The onRefresh callback returned null.\n'
                      'The NestedRefreshIndicator onRefresh callback must return a Future.'
              ),
              context: ErrorDescription('when calling onRefresh'),
              library: 'material library',
            ));
          return true;
        }());
        // `refreshResult` has a non-nullable type, but might be null when
        // running with weak checking, so we need to null check it anyway (and
        // ignore the warning that the null-handling logic is dead code).
        if (refreshResult == null) // ignore: dead_code
          return;
        refreshResult.whenComplete(() {
          if (mounted && _mode == _NestedRefreshIndicatorMode.refresh) {
            completer.complete();
            _dismiss(_NestedRefreshIndicatorMode.done);
          }
        });
      }
    });
  }

  /// Show the refresh indicator and run the refresh callback as if it had
  /// been started interactively. If this method is called while the refresh
  /// callback is running, it quietly does nothing.
  ///
  /// Creating the [NestedRefreshIndicator] with a [GlobalKey<NestedRefreshIndicatorState>]
  /// makes it possible to refer to the [NestedRefreshIndicatorState].
  ///
  /// The future returned from this method completes when the
  /// [NestedRefreshIndicator.onRefresh] callback's future completes.
  ///
  /// If you await the future returned by this function from a [State], you
  /// should check that the state is still [mounted] before calling [setState].
  ///
  /// When initiated in this manner, the refresh indicator is independent of any
  /// actual scroll view. It defaults to showing the indicator at the top. To
  /// show it at the bottom, set `atTop` to false.
  Future<void>? show({ bool atTop = true }) {
    if (_mode != _NestedRefreshIndicatorMode.refresh &&
        _mode != _NestedRefreshIndicatorMode.snap) {
      if (_mode == null)
        _start(atTop ? AxisDirection.down : AxisDirection.up);
      _show();
    }
    return _pendingRefreshFuture;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final Widget child = NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleGlowNotification,
        child: widget.child,
      ),
    );
    assert(() {
      if (_mode == null) {
        assert(_dragOffset == null);
        assert(_isIndicatorAtTop == null);
      } else {
        assert(_dragOffset != null);
        assert(_isIndicatorAtTop != null);
      }
      return true;
    }());

    final bool showIndeterminateIndicator =
        _mode == _NestedRefreshIndicatorMode.refresh || _mode == _NestedRefreshIndicatorMode.done;

    return Stack(
      children: <Widget>[
        child,
        if (_mode != null) Positioned(
          top: _isIndicatorAtTop! ? 0.0 : null,
          bottom: !_isIndicatorAtTop! ? 0.0 : null,
          left: 0.0,
          right: 0.0,
          child: SizeTransition(
            axisAlignment: _isIndicatorAtTop! ? 1.0 : -1.0,
            sizeFactor: _positionFactor, // this is what brings it down
            child: Container(
              padding: _isIndicatorAtTop!
                  ? EdgeInsets.only(top: widget.displacement)
                  : EdgeInsets.only(bottom: widget.displacement),
              alignment: _isIndicatorAtTop!
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
              child: ScaleTransition(
                scale: _scaleFactor,
                child: AnimatedBuilder(
                  animation: _positionController,
                  builder: (BuildContext context, Widget? child) {
                    return RefreshProgressIndicator(
                      semanticsLabel: widget.semanticsLabel ?? MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
                      semanticsValue: widget.semanticsValue,
                      value: showIndeterminateIndicator ? null : _value.value,
                      valueColor: _valueColor,
                      backgroundColor: widget.backgroundColor,
                      strokeWidth: widget.strokeWidth,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//return true so that we can handle inner scroll notification
bool nestedScrollNotificationPredicate(
    ScrollNotification notification) {
  return true;
}
