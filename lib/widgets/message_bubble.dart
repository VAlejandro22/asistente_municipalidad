import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onEscalate;

  const MessageBubble({
    super.key,
    required this.message,
    this.onEscalate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.type == MessageType.user;
    final isSystem = message.type == MessageType.system;
    final isEscalation = message.type == MessageType.escalation;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(context, isSystem || isEscalation),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _getBubbleColor(theme, isUser, isSystem, isEscalation),
                borderRadius: BorderRadius.circular(18.0).copyWith(
                  bottomLeft: isUser ? const Radius.circular(18.0) : const Radius.circular(4.0),
                  bottomRight: isUser ? const Radius.circular(4.0) : const Radius.circular(18.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMessageContent(theme, isUser),
                  if (isEscalation) _buildEscalationButton(context),
                  const SizedBox(height: 4),
                  _buildTimestamp(theme, isUser),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildAvatar(context, false),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, bool isSystem) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: isSystem
          ? Colors.orange.shade100
          : Theme.of(context).primaryColor.withOpacity(0.1),
      child: Icon(
        isSystem
            ? Icons.info_outline
            : Icons.account_balance,
        size: 18,
        color: isSystem
            ? Colors.orange.shade700
            : Theme.of(context).primaryColor,
      ),
    );
  }

  Color _getBubbleColor(ThemeData theme, bool isUser, bool isSystem, bool isEscalation) {
    if (isUser) return theme.primaryColor;
    if (isSystem) return Colors.orange.shade50;
    if (isEscalation) return Colors.amber.shade50;
    return theme.colorScheme.surface;
  }

  Widget _buildMessageContent(ThemeData theme, bool isUser) {
    if (message.isLoading) {
      return AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            message.content,
            textStyle: TextStyle(
              color: isUser ? Colors.white : theme.textTheme.bodyLarge?.color,
              fontSize: 16,
            ),
            speed: const Duration(milliseconds: 50),
          ),
        ],
        totalRepeatCount: 1,
        displayFullTextOnTap: true,
      );
    }

    return MarkdownBody(
      data: message.content,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          color: isUser ? Colors.white : theme.textTheme.bodyLarge?.color,
          fontSize: 16,
          height: 1.4,
        ),
        strong: TextStyle(
          color: isUser ? Colors.white : theme.textTheme.bodyLarge?.color,
          fontWeight: FontWeight.bold,
        ),
        listBullet: TextStyle(
          color: isUser ? Colors.white70 : theme.textTheme.bodyMedium?.color,
        ),
      ),
    );
  }

  Widget _buildEscalationButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: ElevatedButton.icon(
        onPressed: onEscalate,
        icon: const Icon(Icons.person, size: 18),
        label: const Text('Conectar con funcionario'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildTimestamp(ThemeData theme, bool isUser) {
    return Text(
      _formatTimestamp(message.timestamp),
      style: TextStyle(
        color: isUser
            ? Colors.white70
            : theme.textTheme.bodySmall?.color?.withOpacity(0.6),
        fontSize: 12,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
