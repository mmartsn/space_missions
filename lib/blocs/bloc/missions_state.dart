part of 'missions_bloc.dart';

abstract class MissionsState extends Equatable {
  const MissionsState();
  @override
  List<Object> get props => [];
}

class MissionsLoadInProgress extends MissionsState {}

class MissionsLoadSuccess extends MissionsState {
  final List<Mission> missions;
  const MissionsLoadSuccess(this.missions);

  @override
  List<Object> get props => [missions];
  @override
  String toString() => 'MissionsLoadSuccess { missions: $missions }';
}

class MissionsLoadFailure extends MissionsState {}
