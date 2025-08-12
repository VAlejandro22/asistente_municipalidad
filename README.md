# Asistente Virtual Municipal - ChatBot Inteligente

Un chatbot elegante estilo ChatGPT para municipalidades, desarrollado con Flutter y arquitectura MVVM, que se conecta a workflows de n8n para proporcionar respuestas inteligentes sobre trámites municipales.

## 🏛️ Características

- **Interfaz Elegante**: Diseño moderno similar a ChatGPT
- **Arquitectura MVVM**: Separación clara entre lógica de negocio y presentación
- **Integración n8n**: Conecta con workflows de n8n para procesamiento inteligente
- **Escalación Humana**: Derivación automática a funcionarios cuando es necesario
- **Respuestas Contextuales**: Búsqueda semántica en base documental municipal

## 🚀 Funcionalidades

### Para Ciudadanos
- Consultas sobre trámites y documentos requeridos
- Información de horarios de recolección de residuos
- Acceso a ordenanzas y normativas municipales
- Procedimientos administrativos
- Escalación a funcionarios en línea

### Para la Municipalidad
- Base documental integrada (embeddings + vector DB)
- Análisis semántico de consultas
- Historial de conversaciones
- Métricas de satisfacción
- Dashboard de consultas frecuentes

## 🛠️ Tecnologías Utilizadas

- **Frontend**: Flutter (Dart)
- **Arquitectura**: MVVM con Provider
- **HTTP Client**: package:http
- **UI Components**: Material Design 3
- **Backend**: n8n Workflows
- **IA**: LLM (GPT-4 o LLaMA3) integrado en n8n

## 📋 Prerrequisitos

- Flutter SDK >= 3.7.2
- Dart SDK >= 3.0.0
- n8n instance configurada
- Acceso a modelo LLM (OpenAI, Anthropic, o local)

## ⚡ Instalación

1. **Clonar el repositorio**:
```bash
git clone <repository-url>
cd proy_final
```

2. **Instalar dependencias**:
```bash
flutter pub get
```

3. **Generar código de serialización**:
```bash
dart run build_runner build
```

4. **Configurar n8n webhooks** en `lib/config/chatbot_config.dart`:
```dart
static const String n8nBaseUrl = 'https://tu-instancia-n8n.com';
```

## 🔧 Configuración de n8n

### Webhook Principal (`/webhook/municipality-chatbot`)

**Request Body esperado**:
```json
{
  "query": "¿Qué documentos necesito para el permiso de construcción?",
  "session_id": "1234567890",
  "timestamp": "2024-01-01T12:00:00.000Z",
  "source": "flutter_app"
}
```

**Response esperado**:
```json
{
  "response": "Para el permiso de construcción necesitas presentar...",
  "requiresEscalation": false,
  "confidence": 0.85,
  "documentReference": "Ordenanza 123/2024",
  "suggestedActions": ["Descargar formulario", "Consultar requisitos"]
}
```

### Webhook de Escalación (`/webhook/escalate-to-human`)

**Request Body**:
```json
{
  "action": "escalate",
  "reason": "Consulta compleja requiere atención humana",
  "context": "Historial de conversación...",
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

## 🏗️ Arquitectura del Proyecto

```
lib/
├── config/
│   └── chatbot_config.dart      # Configuración de webhooks y constantes
├── models/
│   ├── chat_message.dart        # Modelo de mensaje de chat
│   ├── bot_response.dart        # Modelo de respuesta del bot
│   └── *.g.dart                 # Archivos generados para serialización
├── services/
│   └── chatbot_service.dart     # Servicio HTTP para comunicación con n8n
├── viewmodels/
│   └── chat_viewmodel.dart      # Lógica de negocio del chat (MVVM)
├── widgets/
│   ├── message_bubble.dart      # Componente de burbuja de mensaje
│   └── chat_input_field.dart    # Campo de entrada de texto
├── screens/
│   └── chat_screen.dart         # Pantalla principal del chat
└── main.dart                    # Punto de entrada de la aplicación
```

## 💬 Casos de Uso

### Ejemplo 1: Consulta sobre Permisos
**Usuario**: "¿Qué documentos necesito para sacar el permiso de construcción?"

**Bot**: "Para obtener el permiso de construcción necesitas presentar:
• Planos arquitectónicos firmados por profesional habilitado
• Certificado de factibilidad de servicios
• Constancia de libre deuda municipal
• Formulario de solicitud completado

¿Te ayudo con algún paso específico?"

### Ejemplo 2: Horarios de Recolección
**Usuario**: "¿Cuándo pasa el recolector por mi barrio?"

**Bot**: "Para conocer el horario de recolección necesito que me indiques tu barrio o dirección. Los horarios varían según la zona:
• Zona Norte: Lunes, Miércoles, Viernes - 6:00 AM
• Zona Sur: Martes, Jueves, Sábados - 7:00 AM"

## 🎨 Personalización de UI

El chatbot utiliza Material Design 3 con colores municipales:
- **Color primario**: `#1565C0` (azul municipal)
- **Tipografía**: Roboto
- **Tema**: Claro con soporte para modo oscuro

## 📱 Ejecución

```bash
# Desarrollo
flutter run

# Producción (Android)
flutter build apk --release

# Web
flutter build web
```

## 🔒 Seguridad

- Validación de entrada de usuario
- Timeout en requests HTTP (30 segundos)
- Manejo seguro de errores
- No almacenamiento de datos sensibles localmente

## 📊 Monitoreo y Métricas

El sistema registra:
- Número de consultas por día
- Tiempo de respuesta promedio
- Tasa de escalación a humanos
- Consultas más frecuentes
- Satisfacción del usuario

## 🤝 Contribución

1. Fork el proyecto
2. Crear rama para feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

## 📞 Soporte

- **Email**: soporte@municipio.gov
- **Teléfono**: +1234567890
- **Documentación n8n**: [n8n.io/docs](https://n8n.io/docs)

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

---

**Desarrollado con ❤️ para la transformación digital municipal**
