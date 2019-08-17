import 'package:abstract_dart/abstract_dart.dart';
import 'package:dart_animation_controller/dart_animation_controller.dart';
import 'package:test/test.dart';

void main() {
    group("$DartAnimationController", () {
        group("constructor", () {
            final controller = DartAnimationController(const Duration(seconds: 1));

            test("initValues", () {
                expect(controller.initValues, const DoubleLerp(0.0, 1.0));
            });

            test("startValue", () {
                expect(controller.currentValue, 0.0);
            });

            test("initialValue below start", () {
                expect(() => DartAnimationController(const Duration(seconds: 1), initialValue: -1.0),
                    throwsA(const TypeMatcher<AssertionError>()));
            });

            test("initialValue below end", () {
                expect(() => DartAnimationController(const Duration(seconds: 1), initialValue: 2.0),
                    throwsA(const TypeMatcher<AssertionError>()));
            });

            test("duration not null", () {
                expect(() => DartAnimationController(null),
                    throwsA(const TypeMatcher<AssertionError>()));
            });

            test("startValue not null", () {
                expect(() => DartAnimationController(const Duration(seconds: 1), startValue: null),
                    throwsA(const TypeMatcher<AssertionError>()));
            });

            test("targetValue not null", () {
                expect(() => DartAnimationController(const Duration(seconds: 1), targetValue: null),
                    throwsA(const TypeMatcher<AssertionError>()));
            });
        });

        group("init()", () {
            group("init while pingPong going backwards", () {
                final controller = DartAnimationController(
                    const Duration(seconds: 1),
                    startValue: 0.5,
                    targetValue: 1.0,
                    initialValue: 1.0,
                    loopMode: DeltaLoopMode.pingPong,
                )
                    ..init();

                test("a", () {
                    controller.update(0.5);
                    expect(controller.currentValue, 1.0);
                });
                test("b", () {
                    controller.update(0.5);
                    expect(controller.currentValue, 0.75);
                });
                test("init", () {
                    controller.init();
                });
                test("a", () {
                    controller.update(0.5);
                    expect(controller.currentValue, 1.0);
                });
                test("b", () {
                    controller.update(0.5);
                    expect(controller.currentValue, 0.75);
                });
            });

            group("before init()", () {
                test("currentValue", () {
                    final controller = DartAnimationController(const Duration(seconds: 1));
                    controller.currentValue = 0.4;
                    expect(controller.currentValue, 0.4);
                });
                test("isDone", () {
                    final controller = DartAnimationController(const Duration(seconds: 1));
                    expect(controller.isDone, true);
                });
            });

            group("after init()", () {
                test("currentValue", () {
                    final controller = DartAnimationController(const Duration(seconds: 1));
                    controller.currentValue = 0.4;
                    controller.init();
                    expect(controller.currentValue, 0.0);
                });
                test("isDone", () {
                    final controller = DartAnimationController(const Duration(seconds: 1));
                    controller.init();
                    expect(controller.isDone, false);
                });
            });
        });

        group("update()", () {
            group("${DeltaLoopMode.dontRepeat}", () {
                final controller = DartAnimationController(
                    const Duration(seconds: 1),
                    loopMode: DeltaLoopMode.dontRepeat,
                )
                    ..init();

                test("a", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.3);
                });
                test("b", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.6);
                });
                test("c", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.9);
                });
                test("d", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 1.0);
                });
                test("e", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 1.0);
                });
                test("f", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 1.0);
                });
            });
            group("${DeltaLoopMode.restart}", () {
                final controller = DartAnimationController(
                    const Duration(seconds: 1),
                    loopMode: DeltaLoopMode.restart,
                )
                    ..init();
                test("a", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.3);
                });
                test("b", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.6);
                });
                test("c", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.9);
                });
                test("d", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.0);
                });
                test("e", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.3);
                });
                test("f", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.6);
                });
                test("g", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.9);
                });
                test("h", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.0);
                });
                test("i", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.3);
                });
            });

            group("${DeltaLoopMode.pingPong}", () {
                final controller = DartAnimationController(
                    const Duration(seconds: 1),
                    startValue: 0.6,
                    targetValue: 1.6,
                    loopMode: DeltaLoopMode.pingPong,
                )
                    ..init();
                test("a", () {
                    controller.update(0.3);
                    expect(controller.currentValue, const MoreOrLessEquals(0.9, 0.0001));
                });
                test("b", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 1.2);
                });
                test("c", () {
                    controller.update(0.3);
                    expect(controller.currentValue, const MoreOrLessEquals(1.5, 0.0001));
                });
                test("d", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 1.6);
                });
                test("e", () {
                    controller.update(0.3);
                    expect(controller.currentValue, const MoreOrLessEquals(1.3, 0.0001));
                });
                test("f", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 1.0);
                });
                test("g", () {
                    controller.update(0.3);
                    expect(controller.currentValue, const MoreOrLessEquals(0.7, 0.0001));
                });
                test("h", () {
                    controller.update(0.3);
                    expect(controller.currentValue, const MoreOrLessEquals(0.6, 0.0001));
                });
                test("i", () {
                    controller.update(0.3);
                    expect(controller.currentValue, const MoreOrLessEquals(0.9, 0.0001));
                });
                test("i", () {
                    controller.update(0.3);
                    expect(controller.currentValue, const MoreOrLessEquals(1.2, 0.0001));
                });
            });

            group("${DeltaLoopMode.pingPong} with initialValue", () {
                final controller = DartAnimationController(
                    const Duration(seconds: 1),
                    initialValue: 1.0,
                    loopMode: DeltaLoopMode.pingPong,
                );

                test("setting initialValue", () {
                    expect(controller.currentValue, 1.0);
                    controller.init();
                    expect(controller.currentValue, 1.0);
                });
                test("a", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 1.0);
                });
                test("b", () {
                    controller.update(0.3);
                    expect(controller.currentValue, const MoreOrLessEquals(0.7, 0.0001));
                });
                test("c", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.4);
                });
                test("d", () {
                    controller.update(0.3);
                    expect(controller.currentValue, const MoreOrLessEquals(0.1, 0.0001));
                });
                test("e", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.0);
                });
                test("f", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.3);
                });
                test("g", () {
                    controller.update(0.3);
                    expect(controller.currentValue, const MoreOrLessEquals(0.6, 0.0001));
                });
                test("h", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 0.9);
                });
                test("i", () {
                    controller.update(0.3);
                    expect(controller.currentValue, 1.0);
                });
            });
        });
    });
}

// Inspired by flutters test package to not add a flutter dependency.
class MoreOrLessEquals extends Matcher {

    const MoreOrLessEquals(this.value, this.epsilon);

    final double value;

    final double epsilon;

    @override
    bool matches(Object object, Map<dynamic, dynamic> matchState) {
        if (object is! double)
            return false;
        if (object == value)
            return true;
        // ignore: avoid_as
        final double test = object as double;
        return (test - value).abs() <= epsilon;
    }

    @override
    Description describe(Description description) => description.add('$value (±$epsilon)');
}