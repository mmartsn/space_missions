import 'package:json_annotation/json_annotation.dart';

part 'mission_model.g.dart';

@JsonSerializable(createToJson: false)
class Mission {
  final String missionName;
  final String details;

  const Mission({required this.missionName, required this.details});

  factory Mission.fromJson(Map<String, dynamic> json) =>
      _$MissionFromJson(json);
}
