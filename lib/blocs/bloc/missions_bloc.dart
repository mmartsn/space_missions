import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:space_missions/api_client.dart';
import 'package:space_missions/model/mission_model.dart';
import 'package:meta/meta.dart';

part 'missions_event.dart';
part 'missions_state.dart';

class MissionsBloc extends Bloc<MissionsEvent, MissionsState> {
  MissionsBloc({required MissionsApiClient missionsApiClient})
      : _missionsApiClient = missionsApiClient,
        super(MissionsLoadInProgress()) {
    on<MissionsFetchStarted>(_onMissionsFetchStarted);
  }

  final MissionsApiClient _missionsApiClient;

  void _onMissionsFetchStarted(
    MissionsFetchStarted event,
    Emitter<MissionsState> emit,
  ) async {
    emit(MissionsLoadInProgress());
    try {
      final missions = await _missionsApiClient.getMissions(
          event.offset, event.limit, event.searchterm);
      emit(MissionsLoadSuccess(missions));
    } catch (_) {
      emit(MissionsLoadFailure());
    }
  }
}
