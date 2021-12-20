import 'package:bloc/bloc.dart';

class PageNumberCubit extends Cubit<int> {
  PageNumberCubit() : super(1);

  void nextPage() {
    emit(state + 1);
  }

  void previousPage() {
    emit(state - 1);
  }

  void pageByNumber(int numb) {
    emit(numb);
  }
}
