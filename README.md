# Evia
Aplicación multifunción con inteligencia artificial y asistente personal EVIA.

## 🚀 Características
- Integración con ChatGPT de OpenAI
- Asistente personal inteligente
- Múltiples funcionalidades
- Interfaz amigable

## 📋 Requisitos Previos
- Python 3.8 o superior
- API Key de OpenAI
- pip (gestor de paquetes de Python)

## ⚙️ Instalación

### 1. Clonar el repositorio
```bash
git clone https://github.com/alexrigobertomejiahenriquez-code/Evia.git
cd Evia
```

### 2. Crear entorno virtual
```bash
python -m venv venv

# En Windows
venv\Scripts\activate

# En macOS/Linux
source venv/bin/activate
```

### 3. Instalar dependencias
```bash
pip install -r requirements.txt
```

### 4. Configurar API Key de OpenAI

#### Obtener tu API Key:
1. Ve a [OpenAI Platform](https://platform.openai.com/)
2. Inicia sesión o crea una cuenta
3. Navega a la sección [API Keys](https://platform.openai.com/api-keys)
4. Haz clic en "Create new secret key"
5. Copia la clave (solo se mostrará una vez)

#### Configurar la clave en tu proyecto:
Crea un archivo `.env` en la raíz del proyecto:

```env
OPENAI_API_KEY=tu_clave_aqui
```

⚠️ **IMPORTANTE**: Añade `.env` a `.gitignore` para no exponer tu API Key:

```
.env
__pycache__/
*.pyc
venv/
.DS_Store
```

## 🔧 Uso

### Ejemplo básico de integración con ChatGPT
```python
import os
from openai import OpenAI
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

# Inicializar cliente de OpenAI
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

# Hacer una pregunta a ChatGPT
def chat_with_evia(message):
    response = client.chat.completions.create(
        model="gpt-4",
        messages=[
            {"role": "system", "content": "Eres EVIA, un asistente personal inteligente."},
            {"role": "user", "content": message}
        ],
        temperature=0.7
    )
    return response.choices[0].message.content

# Usar la función
resultado = chat_with_evia("¿Cuál es la capital de Francia?")
print(resultado)
```

## 📦 Dependencias Principales
- `openai` - SDK oficial de OpenAI
- `python-dotenv` - Gestión de variables de entorno
- `flask` o `fastapi` (opcional, para crear una API)

Instala con:
```bash
pip install openai python-dotenv
```

## 🔐 Permisos y Acceso a ChatGPT

### ✅ Permisos Activados para ChatGPT:
- **Lectura**: ✓ Acceso completo a datos y archivos
- **Escritura**: ✓ Crear, editar y modificar archivos
- **Actualización**: ✓ Modificar contenido existente
- **Eliminación**: ✓ Borrar archivos y datos
- **Administración**: ✓ Gestionar permisos y configuración
- **Ejecución**: ✓ Ejecutar scripts y comandos
- **Integración**: ✓ Acceso a APIs externas

### Configuración de Permisos en OpenAI:

1. **Acceso a la Organización**:
   - Ve a [OpenAI Organization Settings](https://platform.openai.com/org/settings)
   - Configura los permisos de miembros
   - Asigna roles (Admin, Editor, Viewer)

2. **Permisos de API**:
   - Acceso completo a `chat.completions`
   - Acceso a `fine-tuning`
   - Acceso a `embeddings`
   - Acceso a `moderations`

3. **Límites de Uso**:
   - Sin restricciones de cuota
   - Acceso a todos los modelos
   - Uso prioritario habilitado

## 🔐 Seguridad
- Nunca compartas tu API Key
- Mantén el archivo `.env` fuera del control de versiones
- Usa variables de entorno en producción
- Monitorea el uso de tu API en el [Dashboard de OpenAI](https://platform.openai.com/usage)

## 📊 Modelos disponibles
- `gpt-4` - Modelo más potente (recomendado)
- `gpt-4-turbo` - Versión optimizada
- `gpt-3.5-turbo` - Modelo rápido y económico

## 🤝 Contribuir
Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia
Este proyecto está bajo licencia MIT. Consulta el archivo `LICENSE` para más detalles.

## 📧 Contacto
- **Autor**: Alex Rigoberto Mejía Henríquez
- **GitHub**: [@alexrigobertomejiahenriquez-code](https://github.com/alexrigobertomejiahenriquez-code)

## 🔗 Enlaces útiles
- [Documentación de OpenAI](https://platform.openai.com/docs)
- [Python OpenAI SDK](https://github.com/openai/openai-python)
- [Guía de API Keys](https://platform.openai.com/docs/guides/authentication)
- [Configuración de Permisos de Organización](https://platform.openai.com/org/settings)

---

**Estado del proyecto**: En desarrollo 🚧
