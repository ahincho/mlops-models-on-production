# Chest Xpert AI — Modelos en Producción

Servicio containerizado de clasificación multi-etiqueta de patologías torácicas mediante Deep Learning. Recibe una radiografía de tórax y devuelve las probabilidades de 5 patologías urgentes.

**Modelo:** DenseNet121 + TorchXRayVision (AUC = 0.869)  
**Patologías detectadas:** Cardiomegaly, Edema, Consolidation, Atelectasis, Pleural Effusion

---

## Cómo obtener la imagen

```bash
docker pull ghcr.io/ahincho/chest-xpert-backend:latest
```

O construir localmente desde el repositorio:

```bash
git clone https://github.com/ahincho/chest-xpert-backend.git
cd chest-xpert-backend
docker build -t chest-xpert-backend .
```

---

## Cómo correr el servicio

```bash
docker run --rm -p 8000:8000 ghcr.io/ahincho/chest-xpert-backend:latest
```

El servicio estará disponible en `http://localhost:8000`.

**Verificar que arrancó:**

```bash
curl http://localhost:8000/health
# {"status":"ok"}
```

---

## Ejemplo de uso

### Request

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

**Interpretación:** Cada valor es la probabilidad (0 a 1) de que la patología esté presente en la radiografía. Valores cercanos a 1 indican alta probabilidad de la condición.

---

## Documentación de la API

Con el servicio corriendo:

| Recurso | URL |
|---|---|
| Swagger UI | http://localhost:8000/docs |
| ReDoc | http://localhost:8000/redoc |
| Health check | http://localhost:8000/health |

---

## Repositorios del proyecto

| Repositorio | Descripción |
|---|---|
| [`chest-xpert-backend`](https://github.com/ahincho/chest-xpert-backend) | API REST (FastAPI + ONNX Runtime) + Dockerfile + CI/CD |
| [`chest-xpert-ai`](https://github.com/ahincho/chest-xpert-ai) | Entrenamiento del modelo (PyTorch + TorchXRayVision) |
| [`chest-xpert-frontend`](https://github.com/ahincho/chest-xpert-frontend) | Aplicación web (Angular) |

---

## Stack tecnológico

| Componente | Tecnología |
|---|---|
| Framework web | FastAPI |
| Inferencia | ONNX Runtime (~20ms/predicción) |
| Containerización | Docker (multi-stage, slim + uv) |
| CI/CD | GitHub Actions |
| Registry | GitHub Container Registry (GHCR) |
| Versionado | python-semantic-release (Conventional Commits) |
| Linter | Ruff |
| Tests | pytest + Hypothesis |

---

## Puntos extra implementados

- [x] Repo Git limpio: `.gitignore` + `.dockerignore`, sin secretos
- [x] Dockerfile de producción: multi-stage, base slim, uv con lockfile, orden de capas, non-root user
- [x] Imagen publicada en GHCR (`ghcr.io/ahincho/chest-xpert-backend:latest`)
- [x] CI con GitHub Actions (lint → test → build → semantic-release, tag por semver)
- [x] Tests (`pytest`), lint (`ruff`)
- [x] Versionado semántico automático (Conventional Commits)

---

## Autor

**Angel Eduardo Hincho Jove**  
Universidad Nacional de San Agustín  
Modelos en Producción — UNI 2026
