# 使用 opensuse/leap:15.6 作为基础镜像（100% 兼容 SLES 15）
FROM opensuse/leap:15.6

LABEL maintainer="DiagnosticHub-SLES15-Builder"

# 1. 安装 C++ 工具链、CMake 以及你代码所需的所有 Qt6 组件 (Base + SVG)
RUN zypper refresh && \
    zypper install -y \
    gcc \
    gcc-c++ \
    make \
    cmake \
    wget \
    file \
    qt6-base-devel \
    qt6-tools-devel \
    qt6-svg-devel \
    libxcb-devel && \
    zypper clean -a

# 2. 修复 Qt6 qmake 兼容性（linuxdeployqt 依赖此机制寻找 Qt 库路径）
RUN ln -s /usr/bin/qmake6 /usr/bin/qmake

# 3. 部署 linuxdeployqt（提前解压并全局安装）
WORKDIR /tmp
RUN wget -O linuxdeployqt.AppImage https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage && \
    chmod +x linuxdeployqt.AppImage && \
    ./linuxdeployqt.AppImage --appimage-extract && \
    mv squashfs-root /opt/linuxdeployqt && \
    ln -s /opt/linuxdeployqt/AppRun /usr/local/bin/linuxdeployqt && \
    rm linuxdeployqt.AppImage

# 4. 设定工作区
WORKDIR /workspace

CMD ["/bin/bash"]
