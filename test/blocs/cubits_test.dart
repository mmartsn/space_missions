import 'package:bloc_test/bloc_test.dart';
import 'package:space_missions/blocs/blocs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PageNumberCubit', () {
    test('initial state is 1', () {
      expect(PageNumberCubit().state, 1);
    });
  });
  group('pageByNumber', () {
    blocTest<PageNumberCubit, int>('emits [2] when state is 1',
        build: () => PageNumberCubit(),
        act: (cubit) => cubit.pageByNumber(2),
        expect: () => const <int>[2]);
  });
}
