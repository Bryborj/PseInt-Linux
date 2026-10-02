#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR"

VERSION=$(cat bin/version)

echo "=== 1. Preparando tarball de fuentes ==="
./pack.sh src

echo "=== 2. Configurando entorno rpmbuild ==="
mkdir -p ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
cp "dist/pseint-src-${VERSION}.tgz" ~/rpmbuild/SOURCES/
cp dist/pseint.desktop ~/rpmbuild/SOURCES/
cp dist/pseint.spec ~/rpmbuild/SPECS/

echo "=== 3. Verificando dependencias de construcción ==="
if ! rpm -q wxGTK-devel >/dev/null 2>&1; then
    echo "Falta el paquete wxGTK-devel. Instálelo ejecutando:"
    echo "  sudo dnf install -y wxGTK-devel"
    echo ""
    echo "Generando paquete de fuentes (SRPM)..."
    rpmbuild -bs ~/rpmbuild/SPECS/pseint.spec
    echo "SRPM listo en ~/rpmbuild/SRPMS/"
    exit 1
fi

echo "=== 4. Compilando paquete RPM binario ==="
rpmbuild -ba ~/rpmbuild/SPECS/pseint.spec

mkdir -p dist
cp ~/rpmbuild/RPMS/*/*.rpm dist/ || true
cp ~/rpmbuild/SRPMS/*.src.rpm dist/ || true

echo ""
echo "=== ¡Compilación exitosa! ==="
ls -lh dist/*.rpm
