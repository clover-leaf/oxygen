import 'package:test/fake.dart';
import 'package:test/test.dart';

import 'package:oxygen/oxygen.dart';

class FakeWorld extends Fake implements World {}

class VelocityComponent extends Component<int> {
  int? x;

  @override
  void init([int? data]) {
    x = data ?? 0;
  }

  @override
  void reset() {
    x = null;
  }
}

void main() {
  late World world;

  setUp(() {
    world = FakeWorld();
  });

  group('ComponentManager', () {
    test('Should be able to register a component and check if it is registered',
        () {
      final manager = ComponentManager(world);

      expect(manager.hasComponent<VelocityComponent>(), false);

      manager.registerComponent(() => VelocityComponent());

      expect(manager.hasComponent<VelocityComponent>(), true);
    });
    test(
        'Should not be able to register a component if it is already registered',
        () {
      final manager = ComponentManager(world);

      manager.registerComponent(() => VelocityComponent());
      manager.registerComponent(() => VelocityComponent());
      manager.registerComponent(() => VelocityComponent());
      manager.registerComponent(() => VelocityComponent());

      expect(manager.components.length, 1);
    });
    test('Should be able to acquire a component pool', () {
      final manager = ComponentManager(world)
        ..registerComponent(() => VelocityComponent());

      expect(manager.getComponentPool<VelocityComponent, int>(),
          isA<ComponentPool<VelocityComponent>>());
    });
  });
}
