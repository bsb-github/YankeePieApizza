class ChatBotMessage {
  final String role; // 'user' or 'assistant'
  final String content;
  final String? action;
  final Map<String, dynamic>? data;

  ChatBotMessage({
    required this.role,
    required this.content,
    this.action,
    this.data,
  });

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
      };
}
