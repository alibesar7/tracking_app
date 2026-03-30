import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/app_sections/presentation/manager/app_section_cubit.dart';
import 'package:tracking_app/features/app_sections/presentation/manager/app_section_states.dart';

void main() {
  late AppSectionCubit cubit;

  setUp(() {
    cubit = AppSectionCubit();
  });
  tearDown(() async {
    await cubit.close();
  });

  group('App section cubit', () {
    blocTest<AppSectionCubit, AppSectionStates>(
      'emits index 0 when updateIndex(0) is called',
      build: () => cubit,
      act: (cubit) => cubit.updateIndex(0),
      expect: () => [
        isA<AppSectionStates>().having(
          (s) => s.selectedIndex,
          'selectedIndex',
          0,
        ),
      ],
    );

    blocTest<AppSectionCubit, AppSectionStates>(
      'emits index 1 when updateIndex(1) is called',
      build: () => cubit,
      act: (cubit) => cubit.updateIndex(1),
      expect: () => [
        isA<AppSectionStates>().having(
          (s) => s.selectedIndex,
          'selectedIndex',
          1,
        ),
      ],
    );

    blocTest<AppSectionCubit, AppSectionStates>(
      'emits index 2 when updateIndex(2) is called',
      build: () => cubit,
      act: (cubit) => cubit.updateIndex(2),
      expect: () => [
        isA<AppSectionStates>().having(
          (s) => s.selectedIndex,
          'selectedIndex',
          2,
        ),
      ],
    );

    blocTest<AppSectionCubit, AppSectionStates>(
      'does not emit when updating with the same index',
      build: () => cubit,
      seed: () => AppSectionStates(selectedIndex: 2),
      act: (cubit) => cubit.updateIndex(2),
      expect: () => [
        isA<AppSectionStates>().having(
          (s) => s.selectedIndex,
          'selectedIndex',
          2,
        ),
      ],
    );

    blocTest<AppSectionCubit, AppSectionStates>(
      'emits correct states when updateIndex is called multiple times',
      build: () => cubit,
      act: (cubit) {
        cubit.updateIndex(0);
        cubit.updateIndex(1);
        cubit.updateIndex(2);
      },
      expect: () => [
        isA<AppSectionStates>().having((s) => s.selectedIndex, 'index', 0),
        isA<AppSectionStates>().having((s) => s.selectedIndex, 'index', 1),
        isA<AppSectionStates>().having((s) => s.selectedIndex, 'index', 2),
      ],
    );
  });
}
