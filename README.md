# Chest Xpert AI — Modelos en Producción

Servicio containerizado de clasificación multi-etiqueta de patologías torácicas mediante Deep Learning. Recibe una radiografía de tórax y devuelve las probabilidades de 5 patologías urgentes.

**Modelo:** DenseNet121 + TorchXRayVision (AUC = 0.869)  
**Patologías detectadas:** Cardiomegaly, Edema, Consolidation, Atelectasis, Pleural Effusion

---

## Opción 1: Ejecutar solo la API (un solo comando)

```bash
docker run --rm -p 8000:8000 ghcr.io/ahincho/chest-xpert-backend:latest
```

La API estará lista en http://localhost:8000. Verificar con:

```bash
curl http://localhost:8000/health
# {"status":"ok"}
```

---

## Opción 2: Ejecutar con observabilidad (API + Grafana LGTM)

Clonar el repositorio del backend y levantar con Docker Compose:

```bash
git clone https://github.com/ahincho/chest-xpert-backend.git
cd chest-xpert-backend
docker compose up -d
```

Esto levanta:

| Servicio | URL | Descripción |
|---|---|---|
| API Backend | http://localhost:8000 | FastAPI + modelo ONNX |
| Swagger UI | http://localhost:8000/docs | Documentación interactiva |
| Grafana | http://localhost:3000 | Dashboards (user: admin, pass: admin) |

Para ver la telemetría en Grafana:
- **Traces** → Explore → Tempo → Search → Run query
- **Logs** → Explore → Loki → `{service_name="chest-xpert-backend"}`
- **Métricas** → Explore → Prometheus → `chest_xpert_predictions_total`
- **Profiling** → Explore → Pyroscope

Para detener todo:

```bash
docker compose down
```

---

## Opción 3: Construir la imagen desde cero

```bash
git clone https://github.com/ahincho/chest-xpert-backend.git
cd chest-xpert-backend
docker build -t chest-xpert-backend .
docker run --rm -p 8000:8000 chest-xpert-backend
```

---

## Ejemplo de uso

### Request (predicción de radiografía)

```bash
curl -X POST http://localhost:8000/predict \
  -F "file=@radiografia.png"
```

### Response

```json
{
  "success": true,
  "predictions": [
    {"pathology": "Cardiomegaly", "probability": 0.2543},
    {"pathology": "Edema", "probability": 0.1606},
    {"pathology": "Consolidation", "probability": 0.0134},
    {"pathology": "Atelectasis", "probability": 0.0740},
    {"pathology": "Pleural Effusion", "probability": 0.0610}
  ]
}
```

### Imágenes de prueba

El repositorio del backend incluye radiografías reales del dataset NIH ChestX-ray14 en `tests/images/`, organizadas por patología:

```
tests/images/
├── Cardiomegaly/       (10 imágenes)
├── Edema/              (10 imágenes)
├── Consolidation/      (10 imágenes)
├── Atelectasis/        (10 imágenes)
├── Pleural_Effusion/   (10 imágenes)
└── No_Finding/         (10 imágenes)
```

Ejemplo con una imagen de prueba:

```bash
curl -X POST http://localhost:8000/predict \
  -F "file=@tests/images/Cardiomegaly/00000001_000.png"
```

---

## Documentación de la API

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/health` | Health check del servicio |
| POST | `/predict` | Clasificar radiografía (multipart/form-data, campo `file`) |
| GET | `/docs` | Swagger UI (documentación interactiva) |
| GET | `/redoc` | ReDoc |

---

## Repositorios del proyecto

| Repositorio | Descripción |
|---|---|
| [`chest-xpert-backend`](https://github.com/ahincho/chest-xpert-backend) | API REST (FastAPI + ONNX) + Docker + CI/CD + Observabilidad |
| [`chest-xpert-ai`](https://github.com/ahincho/chest-xpert-ai) | Entrenamiento del modelo (PyTorch + TorchXRayVision) |
| [`chest-xpert-frontend`](https://github.com/ahincho/chest-xpert-frontend) | Aplicación web (Angular) |

---

## Stack tecnológico

| Componente | Tecnología |
|---|---|
| Framework web | FastAPI |
| Inferencia | ONNX Runtime (~20ms/predicción) |
| Containerización | Docker (multi-stage, slim + uv) |
| CI/CD | GitHub Actions (lint → test → build → release → push GHCR) |
| Registry | GitHub Container Registry (GHCR) |
| Versionado | python-semantic-release (Conventional Commits) |
| Linter | Ruff (95.9% coverage) |
| Tests | pytest + Hypothesis (40 tests) |
| Observabilidad | OpenTelemetry + Grafana LGTM (Tempo, Loki, Mimir, Pyroscope) |

---

## Puntos extra implementados

- [x] Repo Git limpio: `.gitignore` + `.dockerignore`, sin secretos
- [x] Dockerfile de producción: multi-stage, base slim, uv con lockfile, non-root user
- [x] Imagen publicada en GHCR
- [x] CI con GitHub Actions (lint → test → build → semantic-release)
- [x] Tests (pytest, 40 tests, 95.9% branch coverage)
- [x] Lint (ruff, 15 reglas activas)
- [x] Observabilidad (OpenTelemetry + Grafana LGTM stack)
- [x] Versionado semántico automático

---

## Autor

**Angel Eduardo Hincho Jove**  
Universidad Nacional de Ingeniería  
Programa de Especialización en IA Generativa y MLOps — UNI 2026  
ahincho@unsa.edu.pe
