FROM opensuse/leap:15.6

LABEL maintainer="DiagnosticHub-SLES15-Builder"

# 1. 安装编译工具和 Qt6 开发库
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

# 2. 安装专门针对 Qt6 的打包利器：CQtDeployer
WORKDIR /tmp
RUN wget -O CQtDeployer.AppImage https://github.com/QuasarApp/CQtDeployer/releases/download/v1.6.0/CQtDeployer_1.6.0_Linux_x86_64.AppImage && \
    chmod +x CQtDeployer.AppImage && \
    ./CQtDeployer.AppImage --appimage-extract && \
    mv squashfs-root /opt/cqtdeployer && \
    ln -s /opt/cqtdeployer/AppRun /usr/local/bin/cqtdeployer && \
    rm CQtDeployer.AppImage

WORKDIR /workspace

CMD ["/bin/bash"]
