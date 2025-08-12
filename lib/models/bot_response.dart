import 'package:json_annotation/json_annotation.dart';

part 'bot_response.g.dart';

@JsonSerializable()
class BotResponse {
  final String response;
  final bool requiresEscalation;
  final String? escalationReason;
  final List<String>? suggestedActions;
  final String? documentReference;
  final double? confidence;

  BotResponse({
    required this.response,
    this.requiresEscalation = false,
    this.escalationReason,
    this.suggestedActions,
    this.documentReference,
    this.confidence,
  });

  factory BotResponse.fromJson(Map<String, dynamic> json) =>
      _$BotResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BotResponseToJson(this);
}
