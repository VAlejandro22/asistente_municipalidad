// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
  id: json['id'] as String,
  content: json['content'] as String,
  type: $enumDecode(_$MessageTypeEnumMap, json['type']),
  timestamp: DateTime.parse(json['timestamp'] as String),
  isLoading: json['isLoading'] as bool? ?? false,
  metadata: json['metadata'] as String?,
);

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'isLoading': instance.isLoading,
      'metadata': instance.metadata,
    };

const _$MessageTypeEnumMap = {
  MessageType.user: 'user',
  MessageType.bot: 'bot',
  MessageType.system: 'system',
  MessageType.escalation: 'escalation',
};
