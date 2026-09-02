# 📱 EVIA - Asistente Personal Multifunción

**Aplicación Flutter multifunción con inteligencia artificial, herramientas de productividad, gestión de proyectos y asistencia personal.**

---

## 🎯 Visión de EVIA

EVIA es una aplicación integral diseñada para reunir en un solo lugar todas las herramientas que una persona necesita para:

- **Organizar** - Gestión de proyectos, tareas, calendario y documentos
- **Crear** - Desarrollo de contenido, documentos, planos y cotizaciones
- **Gestionar** - Presupuestos, compras, proyectos y documentos personalizables
- **Aprender** - Idiomas sin limitaciones, con conversación, voz y correcciones contextuales
- **Trabajar** - Con asistencia de IA integrada en todos los módulos
- **Planificar** - Calendarios, recordatorios, avisos y fechas importantes

Toda la experiencia está diseñada para ser accesible mediante **texto y voz**, adaptable a diferentes profesiones y sectores.

---

## 🧭 Navegación Principal (V1)

La aplicación presenta una navegación clara con **5 secciones principales** accesibles desde una barra de navegación inferior:

| Sección | Descripción | Icono |
|---------|-------------|-------|
| **Inicio** | Panel de acceso a todos los módulos | 🏠 |
| **Buscar** | Búsqueda global en documentos, proyectos y contenido | 🔍 |
| **Crear** | Crear nuevo contenido rápidamente | ➕ |
| **Avisos** | Recordatorios, notificaciones y alertas | 🔔 |
| **Más** | Configuración, tema, idioma y opciones | ⋯ |

---

## 📦 Módulos Principales

### 1. 🤖 IA - Asistente Central
**Estado:** ⏳ Estructura preparada (placeholder)

Asistente de inteligencia artificial integrado para:
- Conversación natural y procesamiento de texto
- Reconocimiento y procesamiento de voz
- Ayuda contextual con proyectos, documentos y tareas
- Cálculos, análisis y sugerencias
- Organización y planificación
- Integración futura con todos los módulos

*Próxima integración:* OpenAI API, Google Gemini o similar

### 2. 📚 eBook - Sistema de Documentación
**Estado:** ⏳ Estructura preparada (placeholder)

Sistema personalizable para crear, organizar y gestionar contenido:
- Crear secciones y capítulos jerárquicos
- Editar contenido colaborativamente
- Búsqueda de contenido integrada
- Dicción de contenido mediante voz
- Organización inteligente
- Exportación de documentos

### 3. 📋 Proyectos - Gestión de Proyectos
**Estado:** ⏳ Estructura preparada (placeholder)

Crear y administrar proyectos completos:
- Nombre, descripción y estado del proyecto
- Tareas y subtareas organizadas
- Presupuesto y materiales
- Fechas, hitos y plazos
- Documentos asociados
- Notas y comentarios

### 4. 📐 Planos - Diseño de Planos y Esquemas
**Estado:** ⏳ Estructura preparada (placeholder)

Base modular preparada para crear planos, esquemas y dibujos:
- Creación de planos con elementos
- Capas y organización
- Medidas y dimensiones
- Guardar y editar proyectos
- Exportación a diversos formatos

*Nota:* No incluye editor CAD completo en V1, pero la arquitectura está preparada para crecimiento futuro

### 5. 💰 Cotizar - Generador de Cotizaciones
**Estado:** ⏳ Estructura preparada (placeholder)

Crear cotizaciones profesionales:
- Agregar productos, materiales y servicios
- Cantidades y precios unitarios
- Subtotales y totales automáticos
- Presupuesto y descuentos
- Exportación profesional de cotizaciones

### 6. 📅 Agenda - Calendario y Tareas
**Estado:** ⏳ Estructura preparada (placeholder)

Gestión completa de tiempo y tareas:
- Eventos y tareas programadas
- Fechas, horarios y plazos
- Recordatorios y notificaciones
- Repetición de eventos
- Integración automática con avisos

### 7. 🔔 Avisos - Centro de Notificaciones
**Estado:** ⏳ Estructura preparada (placeholder)

Centralización de todas las notificaciones:
- Recordatorios personales
- Avisos de pagos
- Fechas importantes
- Tareas pendientes
- Avisos de proyectos
- Base preparada para notificaciones push

### 8. 📄 Documentos - Documentos Personalizables
**Estado:** ⏳ Estructura preparada (placeholder)

Generación de documentos y formularios adaptados por profesión:
- Plantillas para médicos y personal médico
- Plantillas para enfermeras
- Plantillas para técnicos de laboratorio
- Plantillas para electricistas
- Plantillas para profesionales diversos
- Formularios completamente personalizables

### 9. 🛠️ Herramientas - Utilidades Variadas
**Estado:** ⏳ Estructura preparada (placeholder)

Espacio para herramientas, cálculos y utilidades especializadas:
- Calculadoras profesionales
- Conversores de unidades
- Herramientas de productividad
- Utilidades específicas por profesión

### 10. 🌐 Aprendizaje de Idiomas - Práctica Multilingüe
**Estado:** ⏳ Estructura preparada (placeholder)

Aprendizaje de idiomas sin limitaciones técnicas:
- **Seleccionar cualquier idioma** (sin restricción a inglés)
- **Cambiar de idioma** posteriormente sin perder progreso
- Práctica de conversación en contextos reales
- **Interacción mediante voz** (reconocimiento y síntesis)
- Correcciones contextuales y retroalimentación
- Ejercicios interactivos y prácticos
- Práctica de situaciones reales y cotidianas
- **Arquitectura abierta** - permite agregar nuevos idiomas sin modificar el sistema

### 11. 🛒 Compras y Presupuesto - Gestión de Gastos
**Estado:** ⏳ Estructura preparada (placeholder)

Registro y gestión completa de compras:
- Registrar productos y precios
- **Entrada de datos mediante voz**
- Cantidades y categorización
- Cálculo automático e instantáneo de:
  - **Gasto total**
  - **Presupuesto disponible**
  - **Porcentaje del presupuesto utilizado**
- Historial detallado de compras
- Análisis de gastos

---

## 🏗️ Arquitectura Técnica

### Stack Tecnológico

- **Frontend:** Flutter 3.0+ / Dart 3.0+
- **State Management:** Provider
- **Diseño UI:** Material 3 (Modo claro y oscuro)
- **Almacenamiento Local:** Hive (preparado)
- **Base de datos:** Supabase (preparado)
- **Autenticación:** Supabase Auth (preparado)

### Estructura del Proyecto

```
lib/
├── main.dart                          # Punto de entrada
├── app/
│   └── routes/
│       └── app_routes.dart            # Navegación principal - BottomNavigationBar
├── core/
│   ├── theme/
│   │   ├── app_theme.dart             # Temas Material 3 (claro/oscuro)
│   │   ├── app_colors.dart            # Paleta de colores centralizada
│   │   └── app_typography.dart        # Tipografía centralizada
│   └── services/
│       ├── evia_core.dart             # EVIA Core (coordinador central)
│       ├── ai_service.dart            # Interfaz y mock para IA
│       ├── voice_service.dart         # Interfaz y mock para voz
│       ├── notification_service.dart  # Interfaz y mock para notificaciones
│       └── supabase_service.dart      # Interfaz y mock para Supabase
├── features/
│   ├── home/                          # Pantalla Inicio (módulos)
│   ├── search/                        # Pantalla Buscar
│   ├── create/                        # Pantalla Crear
│   ├── alerts/                        # Pantalla Avisos
│   ├── more/                          # Pantalla Configuración
│   ├── ai/                            # Módulo IA
│   ├── ebook/                         # Módulo eBook
│   ├── projects/                      # Módulo Proyectos
│   ├── plans/                         # Módulo Planos
│   ├── quotes/                        # Módulo Cotizaciones
│   ├── agenda/                        # Módulo Agenda
│   ├── documents/                     # Módulo Documentos
│   ├── tools/                         # Módulo Herramientas
│   ├── language_learning/             # Módulo Idiomas
│   └── shopping/                      # Módulo Compras
├── shared/
│   ├── models/
│   │   └── evia_models.dart           # Modelos compartidos (User, Project, Task, Document)
│   ├── widgets/                       # Widgets reutilizables
│   └── utils/
│       └── extensions.dart            # Extensiones útiles (String, DateTime, num)
└── constants/
    └── app_constants.dart             # Constantes globales
```

### Capa Central: EVIA Core

EVIA Core es el **coordinador central** que inicializa y gestiona todos los servicios:

```
Flutter EVIA
    |
EVIA CORE (inicializador y coordinador)
    |
+---+---+-------+-------+
|   |   |       |       |
AI Voice Notif. Datos Supabase
```

**Ventajas:**
- Inicialización centralizada y ordenada
- Control de ciclo de vida de servicios
- Punto único para cambios y configuración
- Facilita logging, debugging y monitoreo
- Desacoplamiento total entre módulos y servicios

---

## 🔌 Servicios y Preparación para Integraciones

### Arquitectura de Servicios

Todos los servicios están diseñados con **interfaces desacopladas** (`IAIService`, `IVoiceService`, etc.), permitiendo:
- ✅ Reemplazar implementaciones mock por reales sin cambiar código
- ✅ Testing fácil con mocks
- ✅ Múltiples proveedores de un mismo servicio
- ✅ Cambios sin efectos secundarios

### Servicios Base (V1.0 - Implementación Mock)

#### AIService
- **Estado Actual:** ✅ Mock que simula respuestas de IA
- **Interfaz:** `IAIService`
- **Métodos:** `sendMessage()`, `processVoiceMessage()`, `generateText()`, `getSuggestions()`
- **Próxima Integración:** OpenAI API, Google Gemini, Hugging Face, etc.
- **Sin claves API en código** ✅

#### VoiceService
- **Estado Actual:** ✅ Mock que simula grabación y transcripción
- **Interfaz:** `IVoiceService`
- **Métodos:** `startRecording()`, `stopRecording()`, `transcribeAudio()`, `speakText()`
- **Próxima Integración:** flutter_tts, record, Whisper API, Google Speech-to-Text
- **Sin claves API en código** ✅

#### NotificationService
- **Estado Actual:** ✅ Mock con almacenamiento en memoria
- **Interfaz:** `INotificationService`
- **Métodos:** `scheduleNotification()`, `sendNotification()`, `cancelNotification()`
- **Próxima Integración:** firebase_messaging, flutter_local_notifications
- **Sin credenciales en código** ✅

#### SupabaseService
- **Estado Actual:** ✅ Mock con base de datos simulada
- **Interfaz:** `ISupabaseService`
- **Métodos:** `signIn()`, `signUp()`, `fetch()`, `insert()`, `update()`, `delete()`
- **Próxima Integración:** Supabase real (PostgreSQL + Auth)
- **Sin credenciales en código** ✅

### Integraciones Externas Planificadas

| Servicio | Propósito | Estado | Versión Prevista |
|----------|-----------|--------|-------------------|
| **Supabase** | Backend, autenticación, base de datos | ⏳ Preparado (mock) | V1.1+ |
| **IA (OpenAI/Gemini)** | Asistente, procesamiento | ⏳ Preparado (mock) | V1.2+ |
| **STT/TTS** | Reconocimiento y síntesis de voz | ⏳ Preparado (mock) | V1.2+ |
| **Firebase/FCM** | Notificaciones push | ⏳ Preparado (mock) | V1.1+ |
| **Google Drive** | Almacenamiento, backup, planos | 🔲 Futuro | V2.0+ |
| **Almacenamiento en Nube** | Sincronización de datos | 🔲 Futuro | V2.0+ |

---

## 📊 Estado Actual de EVIA V1.0

### ✅ Implementado y Funcional

- [x] Estructura modular de Flutter con arquitectura clara
- [x] EVIA Core como coordinador central de servicios
- [x] Servicios base con interfaces desacopladas (AI, Voice, Notifications, Supabase)
- [x] Tema Material 3 completo con modo claro y oscuro
- [x] Navegación principal (BottomNavigationBar) con 5 secciones
- [x] Pantalla Inicio con acceso visual a todos los módulos
- [x] Pantalla Buscar funcional
- [x] Pantalla Crear con opciones rápidas
- [x] Centro de Avisos con gestión de notificaciones
- [x] Pantalla Configuración con selector dinámico de tema
- [x] Modelos compartidos (EUser, EProject, ETask, EDocument)
- [x] Extensiones útiles para desarrollo (String, DateTime, num)
- [x] Constantes globales (AppConstants, AppStyles, AppMessages)
- [x] Colores centralizados por módulo
- [x] Tipografía Material 3 completa

### ⏳ Estructura Preparada (Placeholder Pages)

Todas las pantallas placeholder están creadas y funcionales, listas para desarrollo:

- [ ] Módulo IA - Asistente inteligente
- [ ] Módulo eBook - Documentación personalizable
- [ ] Módulo Proyectos - Gestión de proyectos
- [ ] Módulo Planos - Diseño de planos y esquemas
- [ ] Módulo Cotizar - Generador de cotizaciones
- [ ] Módulo Agenda - Calendario y tareas
- [ ] Módulo Documentos - Documentos por profesión
- [ ] Módulo Herramientas - Utilidades especializadas
- [ ] Módulo Aprendizaje de Idiomas - Práctica multilingüe sin limitaciones
- [ ] Módulo Compras - Gestión de presupuesto y gastos

### 🔲 Pendiente de Integración Real

- [ ] Supabase (autenticación, base de datos, almacenamiento)
- [ ] OpenAI API o Google Gemini (módulo IA)
- [ ] Reconocimiento de voz (STT) - Speech-to-Text
- [ ] Síntesis de voz (TTS) - Text-to-Speech
- [ ] Firebase Cloud Messaging (notificaciones push)
- [ ] Google Drive (documentos, planos, backup)

### 🚫 No Planificado para V1

- [ ] Editor CAD completo (V1 tiene arquitectura preparada)
- [ ] Sincronización en tiempo real
- [ ] Offline-first completo
- [ ] Colaboración multiusuario
- [ ] Integraciones especializadas avanzadas
- [ ] Aplicación web

---

## 🚀 Instalación y Configuración

### Requisitos Previos

- **Flutter:** 3.0 o superior
- **Dart:** 3.0 o superior
- **Git:** para control de versiones
- **IDE:** Android Studio, VS Code o similar

### Pasos de Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/alexrigobertomejiahenriquez-code/Evia.git
cd Evia

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar análisis estático
flutter analyze

# 4. Ejecutar tests (cuando estén disponibles)
flutter test

# 5. Ejecutar la aplicación en modo debug
flutter run

# 6. Ejecutar en modo release (optimizado)
flutter run --release
```

### Configuración de Desarrollo

#### Variables de Entorno
Crear un archivo `.env` en la raíz del proyecto (NO incluido en git):

Las credenciales de Supabase, servicios de IA, voz y notificaciones se configurarán cuando se realicen las integraciones reales. Estas credenciales **NUNCA deben almacenarse en GitHub** ni en control de versiones.

**IMPORTANTE:** Añadir `.env` al `.gitignore` para evitar exponer credenciales.

#### Tema
Accesible desde la pantalla "Más" → "Tema" (claro/oscuro/sistema)

#### Idioma
Preparado para futuras configuraciones multiidioma

---

## 🔐 Política de Seguridad

### Principios Fundamentales

✅ **NUNCA** incluir en código:
- API Keys o tokens
- Contraseñas
- URLs privadas
- Información personal
- Credenciales de servicios

✅ **SIEMPRE**:
- Usar variables de entorno
- Usar secrets de CI/CD en producción
- Revisar `.gitignore` antes de commits
- Usar credenciales temporales en desarrollo

✅ **Buena Práctica:**

```dart
// ❌ INCORRECTO
const String apiKey = "sk-1234567890";

// ✅ CORRECTO
final apiKey = String.fromEnvironment('OPENAI_API_KEY');
```

---

## 📋 Principios de Desarrollo

### 1. Modularidad
- Cada feature es independiente en su carpeta
- Cada feature puede tener: `presentation/domain/data`
- Reutilización a través de `shared/`

### 2. Escalabilidad
- Diseñado para agregar nuevos módulos sin reconstruir
- Estructura uniforme facilita crecimiento
- Base preparada para futuras integraciones

### 3. Desacoplamiento
- Servicios usan interfaces
- Implementaciones pueden reemplazarse
- Módulos no tienen dependencias circulares

### 4. Mantenibilidad
- Código limpio y autodocumentado
- Nombres descriptivos y consistentes
- Componentes reutilizables

### 5. Testing
- Interfaces permiten mocks fáciles
- Cada módulo puede testearse independientemente
- Cobertura de tests en crecimiento

---

## 🗺️ Hoja de Ruta

### V1.0 (Actual - Septiembre 2026 - En Desarrollo 🚧)

**Objetivos:**
- ✅ Estructura base Flutter modular
- ✅ EVIA Core y servicios mock
- ✅ Navegación principal (5 secciones)
- ✅ Tema Material 3 completo
- ✅ Pantalla Inicio con módulos
- ✅ Placeholder pages para todos los módulos
- 🔄 Análisis estático y validación

**Estado:** Parcialmente completado

### V1.1 (Próxima Fase)

**Objetivos:**
- [ ] Integración Supabase Auth (login/signup)
- [ ] Persistencia local con Hive
- [ ] Módulo Inicio completamente funcional
- [ ] Primeras funciones de módulos principales
- [ ] Base de datos en Supabase

**Prioridad:** Alta

### V1.2 (Fase Posterior)

**Objetivos:**
- [ ] Integración OpenAI API (módulo IA)
- [ ] Módulo IA completamente funcional
- [ ] Integración STT/TTS
- [ ] Módulos con funcionalidades de voz
- [ ] Notificaciones en tiempo real

**Prioridad:** Alta

### V2.0 (Futuro)

**Objetivos:**
- [ ] Módulos especializados completos
- [ ] Sincronización Supabase bidireccional
- [ ] Notificaciones push (Firebase)
- [ ] Integraciones Google Drive
- [ ] Colaboración multiusuario
- [ ] Aplicación web (Flutter web)
- [ ] Aplicación de escritorio (Windows, macOS, Linux)

**Prioridad:** Media

---

## 📚 Documentación Adicional

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Decisiones de diseño, patrones y arquitectura detallada
- **[pubspec.yaml](pubspec.yaml)** - Dependencias y configuración del proyecto
- **[.gitignore](.gitignore)** - Archivos y directorios ignorados por Git

---

## 🤝 Contribución y Desarrollo

### Antes de hacer cambios:

1. Consulta [ARCHITECTURE.md](ARCHITECTURE.md) para entender el diseño
2. **Mantén la modularidad** del proyecto
3. **No elimines funcionalidades** sin autorización
4. **Documenta decisiones importantes**
5. Usa **nombres claros y descriptivos**
6. **No agregues secretos** al código
7. Ejecuta `flutter analyze` y `flutter test` antes de commit

### Pasos para contribuir:

```bash
# 1. Crear una rama
git checkout -b feature/tu-feature

# 2. Hacer cambios
# ... tu código ...

# 3. Verificar calidad
flutter analyze
flutter test

# 4. Commit
git commit -m "feat: descripción clara del cambio"

# 5. Push
git push origin feature/tu-feature

# 6. Abrir Pull Request
```

---

## 📞 Información del Proyecto

| Información | Valor |
|-------------|-------|
| **Proyecto** | EVIA - Asistente Personal Multifunción |
| **Versión Actual** | 1.0.0 |
| **Estado** | En Desarrollo 🚧 |
| **Framework** | Flutter 3.0+ / Dart 3.0+ |
| **Licencia** | MIT |
| **Autor** | Alex Rigoberto Mejía Henríquez |
| **Repositorio** | https://github.com/alexrigobertomejiahenriquez-code/Evia |

---

## 📄 Licencia

Este proyecto está bajo licencia **MIT**. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

## 🔗 Enlaces Útiles

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material 3 Design](https://m3.material.io/)
- [Provider Package](https://pub.dev/packages/provider)
- [Supabase Documentation](https://supabase.com/docs) (futuro)
- [OpenAI API Reference](https://platform.openai.com/docs/api-reference) (futuro)

---

**EVIA está en construcción activa. Nuestro objetivo es crear una aplicación modular, escalable y potente que crezca de manera sostenible para satisfacer las necesidades del usuario.**

**Versión V1.0.0 - Septiembre 2026**
