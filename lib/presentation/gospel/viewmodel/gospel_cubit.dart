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
        (_) => const GospelLoaded('إنجيل اليوم', 'Today gospel', 'Ⲡⲓⲉⲩⲁⲅⲅⲉⲗⲓⲟⲛ'),
        (gospel) => GospelLoaded(gospel.arabic, gospel.english, gospel.coptic),
      ),
    );
  }
}
