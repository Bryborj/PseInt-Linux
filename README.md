# PSeInt para Linux

[![Build & Release Linux Packages](https://github.com/Bryborj/PseInt-Linux/actions/workflows/release.yml/badge.svg)](https://github.com/Bryborj/PseInt-Linux/actions/workflows/release.yml)

Repositorio adaptado y optimizado para la compilación, empaquetado y distribución automática de **PSeInt** en GNU/Linux mediante paquetes nativos y universales:

- **`.rpm`**: Para distribuciones basadas en RPM como Fedora, RHEL, openSUSE, etc.
- **`.deb`**: Para distribuciones basadas en Debian como Ubuntu, Linux Mint, Debian, etc.
- **`AppImage`**: Paquete ejecutable universal para cualquier distribución Linux.

---

## 📥 Instalación

Puedes descargar la última versión desde la sección de **[Releases](https://github.com/Bryborj/PseInt-Linux/releases)**.

### Fedora / Red Hat / openSUSE (.rpm)
```bash
sudo dnf install ./pseint-*.rpm
# O en openSUSE:
sudo zypper install ./pseint-*.rpm
```

### Ubuntu / Debian / Mint (.deb)
```bash
sudo apt install ./pseint_*_amd64.deb
```

### AppImage (Universal)
```bash
chmod +x PSeInt-*-x86_64.AppImage
./PSeInt-*-x86_64.AppImage
```

---

## 🛠️ Compilación Local

### Requisitos previos
- **Compilador C++**: `g++` (C++17)
- **Biblioteca GUI**: `wxWidgets 3.2` (`wxGTK-devel` en Fedora, `libwxgtk3.2-dev` en Ubuntu)
- **Gráficos**: `OpenGL`, `GLU`, `X11`

### Scripts de empaquetado directo
En la carpeta `dist/` se incluyen scripts automatizados para cada formato:

- **RPM**:
  ```bash
  ./dist/build-rpm.sh
  ```
- **DEB**:
  ```bash
  ./dist/build-deb.sh
  ```
- **AppImage**:
  ```bash
  ./dist/build-appimage.sh
  ```

---

## 🚀 Integración Continua (CI/CD)

El workflow de **GitHub Actions** (`.github/workflows/release.yml`):
1. Compila automáticamente en cada push a `main`.
2. Genera los paquetes `.rpm`, `.deb` y `.AppImage`.
3. Al crear un tag de versión (ejemplo: `v20250314`) o ejecutarlo manualmente, publica automáticamente un **GitHub Release** público con todos los instaladores adjuntos.

---

## 📄 Licencia

PSeInt es software libre distribuido bajo la licencia **GPL-2.0-or-later**.
Autor original: **Pablo Novara** (http://pseint.sourceforge.net/)
