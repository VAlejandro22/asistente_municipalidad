// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bot_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BotResponse _$BotResponseFromJson(Map<String, dynamic> json) => BotResponse(
  response: json['output'] as String,
  requiresEscalation: json['requiresEscalation'] as bool? ?? false,
  escalationReason: json['escalationReason'] as String?,
  suggestedActions:
      (json['suggestedActions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  documentReference: json['documentReference'] as String?,
  confidence: (json['confidence'] as num?)?.toDouble(),
);

Map<String, dynamic> _$BotResponseToJson(BotResponse instance) =>
    <String, dynamic>{
      'response': instance.response,
      'requiresEscalation': instance.requiresEscalation,
      'escalationReason': instance.escalationReason,
      'suggestedActions': instance.suggestedActions,
      'documentReference': instance.documentReference,
      'confidence': instance.confidence,
    };
