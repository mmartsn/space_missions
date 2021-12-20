part of 'missions_bloc.dart';

@immutable
abstract class MissionsEvent extends Equatable {}

class MissionsFetchStarted extends MissionsEvent {
  final int offset;
  final int limit;
  final String searchterm;

  MissionsFetchStarted(this.offset, this.limit, this.searchterm);

  @override
  List<Object> get props => [offset, limit, searchterm];

  @override
  String toString() =>
      'MissionsFetchStarted { offset: $offset  limit: $limit searchterm: $searchterm }';
}
