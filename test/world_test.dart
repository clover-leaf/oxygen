import 'package:oxygen/oxygen.dart';
import 'package:test/test.dart';

class SystemA extends System {
  @override
  void execute(double delta) {}

  @override
  void init() {}
}

class ComponentA extends ValueComponent<int> {}

void main() {
  group('World', () {
    group('Bug', () {
      test('Add and remove component from entity', () {
        final world = World()
          ..registerSystem(SystemA())
          ..registerComponent<ComponentA, int>(() => ComponentA())
          ..init();

        final entity = world.createEntity()..add<ComponentA, int>(1);
        expect(entity.has<ComponentA>(), true);
        entity.remove<ComponentA>();
        expect(entity.has<ComponentA>(), true);
        world.execute(1);
        expect(entity.has<ComponentA>(), false);
      });
      test('Remove component from entity then remove entity', () {
        final world = World()
          ..registerSystem(SystemA())
          ..registerComponent<ComponentA, int>(() => ComponentA())
          ..init();
        final entity = world.createEntity()..add<ComponentA, int>(1);
        expect(entity.has<ComponentA>(), true);
        world.entityManager.removeEntity(entity);
        entity.remove<ComponentA>();
        expect(entity.has<ComponentA>(), true);
        world.execute(1);
        expect(entity.has<ComponentA>(), false);
        expect(entity.alive, false);
      });
      test('Remove entity then remove component from entity', () {
        final world = World()
          ..registerSystem(SystemA())
          ..registerComponent<ComponentA, int>(() => ComponentA())
          ..init();
        final entity = world.createEntity()..add<ComponentA, int>(1);
        expect(entity.has<ComponentA>(), true);
        entity.remove<ComponentA>();
        world.entityManager.removeEntity(entity);
        expect(entity.has<ComponentA>(), true);
        world.execute(1);
        expect(entity.has<ComponentA>(), false);
        expect(entity.alive, false);
      });
    });
  });
}
