Name:           pseint
Version:        20250314
Release:        1%{?dist}
Summary:        Tool for learning programming logic with Spanish pseudocode
Summary(es):    Herramienta para aprender lógica de programación con pseudocódigo

License:        GPL-2.0-or-later
URL:            http://pseint.sourceforge.net/
Source0:        pseint-src-%{version}.tgz
Source1:        pseint.desktop

BuildRequires:  gcc-c++
BuildRequires:  make
BuildRequires:  wxGTK-devel >= 3.2
BuildRequires:  mesa-libGL-devel
BuildRequires:  mesa-libGLU-devel
BuildRequires:  libX11-devel
BuildRequires:  desktop-file-utils

Requires:       wxGTK >= 3.2
Requires:       mesa-libGL
Requires:       mesa-libGLU
Requires:       libX11
Requires:       hicolor-icon-theme

%global debug_package %{nil}

%description
PSeInt is an educational tool designed for students starting out in
programming. Through a simple and intuitive Spanish pseudocode, it allows
them to focus on the fundamental concepts of computational algorithms.

%description -l es
PSeInt es una herramienta para asistir a un estudiante en sus primeros pasos
en programación. Mediante un simple e intuitivo pseudocódigo en español, le
permite centrar su atención en los conceptos fundamentales de la algoritmia
computacional.

%prep
%autosetup -n pseint

%build
%{make_build} ARCH=lnx

%install
mkdir -p %{buildroot}%{_libdir}/pseint/bin
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/applications
mkdir -p %{buildroot}%{_datadir}/pixmaps

# Binaries
cp -a bin/bin/* %{buildroot}%{_libdir}/pseint/bin/

# Resources and data
cp -a bin/creator.psz %{buildroot}%{_libdir}/pseint/
cp -a bin/ejemplos %{buildroot}%{_libdir}/pseint/
cp -a bin/help %{buildroot}%{_libdir}/pseint/
cp -a bin/imgs %{buildroot}%{_libdir}/pseint/
cp -a bin/Inconsolata-Regular.ttf %{buildroot}%{_libdir}/pseint/
cp -a bin/perfiles %{buildroot}%{_libdir}/pseint/
cp -a bin/pseint.dir %{buildroot}%{_libdir}/pseint/
cp -a bin/version %{buildroot}%{_libdir}/pseint/

# Executable wrappers in /usr/bin
cat << 'EOF' > %{buildroot}%{_bindir}/pseint
#!/bin/bash
exec %{_libdir}/pseint/bin/pseint "$@"
EOF
chmod 0755 %{buildroot}%{_bindir}/pseint

cat << 'EOF' > %{buildroot}%{_bindir}/wxpseint
#!/bin/bash
exec %{_libdir}/pseint/bin/wxPSeInt "$@"
EOF
chmod 0755 %{buildroot}%{_bindir}/wxpseint

# Desktop launcher
desktop-file-install \
    --dir=%{buildroot}%{_datadir}/applications \
    %{SOURCE1}

# Icons
for size in 16 32 48 64 128; do
    mkdir -p %{buildroot}%{_datadir}/icons/hicolor/${size}x${size}/apps
    cp -a bin/imgs/icon${size}.png %{buildroot}%{_datadir}/icons/hicolor/${size}x${size}/apps/pseint.png
done
cp -a bin/imgs/icon128.png %{buildroot}%{_datadir}/pixmaps/pseint.png

%files
%license license.txt
%{_bindir}/pseint
%{_bindir}/wxpseint
%{_libdir}/pseint/
%{_datadir}/applications/pseint.desktop
%{_datadir}/icons/hicolor/*/apps/pseint.png
%{_datadir}/pixmaps/pseint.png

%changelog
* Fri Mar 14 2025 Pablo Novara <zaskar_84@yahoo.com.ar> - 20250314-1
- Release 20250314 packaged as RPM for Fedora
