import 'package:abstract_dart/abstract_dart.dart';

/// Custom animation controller with loop modes that doesn't need
/// to be disposed of and doesn't depend on flutter.
///
/// Intended for animation uses where a delta update is available.
class DartAnimationController {
  final Duration _duration;
  final DoubleLerp initValues;
  DoubleLerp currentBounds;
  final DeltaLoopMode _loopMode;
  Duration _currentTime;
  double currentValue;
  bool _stopped = true;
  double initialValue;

  DartAnimationController(Duration duration, {
    double startValue = 0.0,
    double targetValue = 1.0,
    double initialValue,
    DeltaLoopMode loopMode = DeltaLoopMode.dontRepeat,
  })  : assert(duration != null),
        assert(startValue != null),
        assert(targetValue != null),
        assert(startValue <= targetValue),
        assert(initialValue == null || (initialValue <= targetValue && initialValue >= startValue)),
        currentValue = initialValue ?? startValue,
        this.initialValue = initialValue ?? startValue,
        this._duration = duration,
        this._loopMode = loopMode,
        this._currentTime = Duration.zero,
        this.initValues = DoubleLerp(startValue, targetValue),
        this.currentBounds = DoubleLerp(startValue, targetValue);

  void init() {
    currentBounds = initValues;
    currentValue = initialValue;
    _currentTime = Duration(milliseconds: (currentBounds.reLerp(initialValue) * 1000.0 * 2).toInt());
    _stopped = false;
  }

  void update(double delta) {
    if (!_stopped) {
      _currentTime += Duration(milliseconds: (delta * 1000.0).toInt());
      final amtMS = _currentTime.inMilliseconds / _duration.inMilliseconds;
      currentValue = currentBounds.lerp(amtMS.clamp(0.0, 1.0).toDouble());

      if (currentValue == currentBounds.to) {
        switch (_loopMode) {
          case DeltaLoopMode.dontRepeat:
            _stopped = true;
            break;
          case DeltaLoopMode.pingPong:
            _currentTime = Duration.zero;
            currentBounds = DoubleLerp(currentBounds.to, currentBounds.from);
            break;
          case DeltaLoopMode.restart:
            init();
            break;
        }
      }
    }
  }

  bool get isDone => _stopped;
}

/// Various looping modes for [DartAnimationController].
enum DeltaLoopMode {
  /// When an animation starts and ends it will end and not repeat again.
  dontRepeat,

  /// When an animation ends it restarts again in reverse.
  ///
  /// The duration of an animation is only for one direction.
  pingPong,

  /// When an animation ends it restarts again from the beginning.
  restart,
}
