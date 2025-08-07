# 🏥 Sofia Healthcare Data Project

Este proyecto implementa dos casos de uso complementarios para el manejo de datos de salud:

1. **Data Modelling with dbt** - Modelado de datos con arquitectura dimensional
2. **Mini "Ask Claims" Assistant** - Sistema inteligente de consultas

## 📁 Estructura del Proyecto

```
sofia/
├── README.md                      # Este archivo
├── challenge presentation.pdf     # Presentación del challenge
├── sofia_dbt/                    # Proyecto dbt (Modelado de datos)
├── resources/                    # Notebooks y ddls de raw (las fuentes crudas)
├── env/                         # Entorno virtual Python (ignorado)
└── logs/                        # Logs del sistema (ignorado)
```

---

## 🏗️ Caso 1: Data Modelling with dbt 

Implementación de un modelo de datos usando dbt con arquitectura dimensional para procesar datos de claims médicos. Se cargaron las files en un esquema dbt_raw, el cuál es referenciado dentro de los modelos. 

### Fuentes de Datos:
El proyecto procesa los siguientes tipos de datos médicos:

- **Claims**: Información de reclamos médicos (diagnósticos, procedimientos, montos)
- **Patients**: Datos demográficos y de planes de salud de pacientes  
- **Providers**: Información de proveedores médicos (especialidades, ubicaciones, contratos)
- **Claim_Providers**: Relaciones entre claims y proveedores médicos

### 🔧 Estructura del Proyecto dbt

```
sofia_dbt/
├── dbt_project.yml              # Configuración principal de dbt
├── packages.yml                 # Dependencias dbt (dbt_utils)
├── models/
│   ├── staging/                 # Capa de staging (limpieza inicial)
│   │   ├── schema.yml          # Tests y documentación staging
│   │   ├── stg_patients.sql    # Pacientes staging
│   │   ├── stg_providers.sql   # Proveedores staging
│   │   ├── stg_claims.sql      # Claims staging
│   │   └── stg_claim_providers.sql # Relación claims-proveedores
│   └── warehouse/               # Capa de warehouse (modelado dimensional)
│       ├── schema.yml          # Tests y documentación warehouse
│       ├── dim_patients.sql    # Dimensión de pacientes
│       ├── dim_providers.sql   # Dimensión de proveedores
│       └── fact_claims.sql     # Tabla de hechos de claims
├── target/ (ignorado)           # Archivos compilados por dbt
├── dbt_packages/ (ignorado)     # Paquetes instalados
└── logs/ (ignorado)             # Logs de dbt
```

### 🏗️ Arquitectura de Datos

#### Capas de Datos:

1. **Staging Layer** (`models/staging/`):
   - Limpieza inicial de datos
   - Deduplicación usando `row_number()`
   - Validaciones básicas de calidad

2. **Warehouse Layer** (`models/warehouse/`):
   - **Dimensiones**: `dim_patients`, `dim_providers`
   - **Tabla de Hechos**: `fact_claims`
   - Implementa surrogate keys (SK) y business keys (BK)
   - Foreign keys para integridad referencial

### 🧪 Tests Implementados

#### Tests de Calidad de Datos:
- **not_null**: Campos requeridos
- **unique**: Claves primarias
- **accepted_values**: Valores permitidos (ej: gender = 'M', 'F')

---

## 🤖 Caso 2: Mini "Ask Claims" Assistant

Ejercicio utilizando LLMs para consultar y analizar información de reclamaciones médicas mediante lenguaje natural. Se creo el ejercicio para permitir a usuarios hacer preguntas sobre los datos de claims sin necesidad de conocimientos técnicos, facilitando la exploración de la información de manera sencilla e intuitiva.

### 📊 La carpeta: `resources/`

Contiene los notebooks con el código del ejercicio del asistente. 
- **Notebooks**: `ask-claims-assistant.ipynb`

---

## 📄 Documentación Adicional

### `challenge presentation.pdf`
Presentación completa que explica (la presentación se encuentra en ingles) :
- Contexto y problema
- Solución y resultados
- Detalle técnico y siguientes pasos 



