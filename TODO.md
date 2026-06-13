# TODO — Entrega "Modelos en Producción" (UNI 2026)

Fecha límite: **13-06-26**  
Rúbrica: 20 pts (6 docker + 6 modelo + 3 README + 5 extras)

---

## 🔴 Crítico (asegura que la imagen arranca)

- [x] **Incluir modelo ONNX dentro de la imagen Docker**
  - ✅ Quitado `models/` del `.dockerignore`
  - ✅ Añadido `COPY models/ ./models/` en el Dockerfile (stage runtime)
  - ✅ `CHEST_XPERT_MODEL_PATH` seteado como ENV default en el Dockerfile
  - ✅ Verificado: `docker run --rm -p 8000:8000 ghcr.io/ahincho/chest-xpert-backend:1.0.2` arranca sin volúmenes

---

## 🟡 Alto impacto (puntos extra directos)

- [x] **Crear workflow de GitHub Actions**
  - ✅ `ci.yml`: lint (ruff) → test (pytest) → build (docker) → semantic-release
  - ✅ `cd.yml`: trigger por tag `v*.*.*` → build + push a GHCR
  - ✅ Actions actualizadas a últimas versiones (checkout v6, buildx v4, login v4, metadata v6, build-push v7, attest v4, setup-uv v8.2.0)
  - ✅ CI pasa verde en GitHub

- [x] **Publicar imagen en GHCR** (configurado en cd.yml)
  - ✅ `ghcr.io/ahincho/chest-xpert-backend:1.0.2` publicada
  - ✅ Tags: semver (1.0.2, 1.0, 1) + latest + sha-XXXXXXX
  - ✅ Attestation de provenance incluida
  - [ ] Verificar que el paquete sea público (Settings → Change visibility → Public)

- [x] **Añadir configuración de ruff** al `pyproject.toml`
  - ✅ `[tool.ruff]` con reglas: E, W, F, I, N, UP, B, S, A, C4, DTZ, T20, RET, SIM, PTH
  - ✅ Per-file ignores para tests y scripts
  - ✅ `ruff check .` → All checks passed!
  - ✅ `ruff format --check .` → 18 files already formatted

- [x] **python-semantic-release configurado**
  - ✅ Conventional Commits → versionado automático
  - ✅ v1.0.0 → v1.0.1 → v1.0.2 creados automáticamente
  - ✅ Actualiza version en `pyproject.toml`

---

## 🟢 Medio impacto (mejoran la nota)

- [ ] **Añadir más tests**
  - Test de integración: `test_predict.py` (request completo al endpoint con imagen real)
  - Test del health endpoint
  - Test del filtro RGB-Diff (imagen color → rechazo)

- [ ] **Añadir pre-commit hooks** (opcional)
  - `.pre-commit-config.yaml` con ruff + format check
  - Documentar en el README del backend

- [ ] **Endpoint `/metrics`** (opcional, observabilidad)
  - Conteo de requests totales
  - Latencia promedio de inferencia
  - Formato Prometheus o JSON simple

---

## 📝 Artículo LaTeX (informe)

- [ ] **Sección 1: Introducción** — Redactar contexto del modelo original + motivación MLOps
- [ ] **Sección 2: Arquitectura** — Diagrama de flujo, componentes, decisiones técnicas
- [ ] **Sección 3: Implementación** — Fragmentos de código (Dockerfile, endpoint, servicio)
- [ ] **Sección 4: Despliegue y entrega continua** — Workflow CI/CD, GHCR, buenas prácticas
- [ ] **Sección 5: Demostración** — Comando docker run + ejemplo real request/response
- [ ] **Sección 6: Conclusiones** — Aprendizajes y trabajo futuro
- [ ] **Reemplazar figuras** en `figures/` con diagramas relevantes a este proyecto
- [ ] **Compilar y verificar** que el PDF se genera correctamente

---

## 📋 README del proyecto raíz

- [x] Cómo construir/cargar la imagen
- [x] Cómo correrla
- [x] Ejemplo de entrada → respuesta
- [ ] **Actualizar** con la URL real de GHCR (ghcr.io/ahincho/chest-xpert-backend:latest)
- [ ] **Agregar ejemplo real** (con output capturado del servicio corriendo)

---

## Orden sugerido de ejecución (restante)

1. ~~Incluir modelo en la imagen Docker~~ ✅
2. ~~Añadir ruff al pyproject.toml~~ ✅
3. ~~Crear GitHub Actions workflow~~ ✅
4. ~~Push + verificar que GHCR funciona~~ ✅
5. Hacer público el paquete en GHCR ← **pendiente (manual en GitHub)**
6. Actualizar README con ejemplo real ← siguiente
7. Redactar artículo LaTeX (�) ← principal pendiente
8. Tests adicionales si hay tiempo (🟢)
