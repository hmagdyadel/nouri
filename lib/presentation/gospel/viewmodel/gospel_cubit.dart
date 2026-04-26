import 'package:agpeya/core/di/injection.dart';
import 'package:agpeya/domain/usecases/get_daily_gospel_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'gospel_state.dart';

class GospelCubit extends Cubit<GospelState> {
  GospelCubit({GetDailyGospelUseCase? useCase})
      : _useCase = useCase ?? getIt<GetDailyGospelUseCase>(),
        super(GospelInitial());

  final GetDailyGospelUseCase _useCase;

  Future<void> load() async {
    emit(GospelLoading());
    final result = await _useCase();
    emit(
      result.fold(
        (_) => const GospelLoaded(
          ar: 'إنجيل اليوم',
          en: 'Today gospel',
          cop: 'Ⲡⲓⲉⲩⲁⲅⲅⲉⲗⲓⲟⲛ',
          readToday: false,
        ),
        (gospel) => GospelLoaded(
          ar: gospel.arabic,
          en: gospel.english,
          cop: gospel.coptic,
          readToday: false,
        ),
      ),
    );
  }

  void markReadToday() {
    if (state is! GospelLoaded) return;
    emit((state as GospelLoaded).copyWith(readToday: true));
  }

  void toggleHighlightedVerse(int index) {
    if (state is! GospelLoaded) return;
    final GospelLoaded loaded = state as GospelLoaded;
    if (loaded.highlightedVerse == index) {
      emit(loaded.copyWith(clearHighlight: true));
      return;
    }
    emit(loaded.copyWith(highlightedVerse: index));
  }
}
