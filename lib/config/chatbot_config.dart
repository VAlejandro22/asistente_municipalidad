class ChatbotConfig {
  // n8n Webhook Configuration
  // Replace these URLs with your actual n8n instance URLs
  static const String n8nBaseUrl = 'http://192.168.1.20:5678'; // Change to your n8n instance URL
 // static const String municipalityChatbotWebhook = '/webhook-test/municipalidad';
  static const String municipalityChatbotWebhook = '/webhook/municipalidad';
  static const String escalationWebhook = '/webhook/escalate-to-human';

  // Complete webhook URLs
  static String get chatbotWebhookUrl => '$n8nBaseUrl$municipalityChatbotWebhook';
  static String get escalationWebhookUrl => '$n8nBaseUrl$escalationWebhook';

  // API Configuration
  static const Duration requestTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Municipality Information
  static const String municipalityName = 'Municipalidad';
  static const String supportEmail = 'soporte@municipio.gov';
  static const String supportPhone = '+1234567890';

  // Example n8n Workflow Response Format:
  // {
  //   "response": "Para el permiso de construcción necesitas...",
  //   "requiresEscalation": false,
  //   "confidence": 0.85,
  //   "documentReference": "Ordenanza 123/2024",
  //   "suggestedActions": ["Descargar formulario", "Consultar requisitos"]
  // }
}

