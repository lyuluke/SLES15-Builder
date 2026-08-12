FROM opensuse/leap:15.6

LABEL maintainer="DiagnosticHub-SLES15-Builder"

# 1. 安装编译工具、unzip（解压 zip 包必备）和 Qt6 依赖包
RUN zypper refresh && \
    zypper install -y \
    gcc \
    gcc-c++ \
    make \
    cmake \
    wget \
    file \
    unzip \
    qt6-base-devel \
    qt6-tools-devel \
    qt6-svg-devel \
    libxcb-devel && \
    zypper clean -a

# 2. 下载并安装你截图中的 CQtDeployer 最新版本 (v1.6.2441.67ee1ef)
WORKDIR /tmp
RUN wget https://github.com/QuasarApp/CQtDeployer/releases/download/v1.6.2441.67ee1ef/CQtDeployer_1.6.2441.67ee1ef_Linux_x86_64.zip && \
    unzip CQtDeployer_1.6.2441.67ee1ef_Linux_x86_64.zip -d /opt/cqtdeployer && \
    chmod +x /opt/cqtdeployer/bin/CQtDeployer /opt/cqtdeployer/CQtDeployer.sh && \
    ln -s /opt/cqtdeployer/CQtDeployer.sh /usr/local/bin/cqtdeployer && \
    rm CQtDeployer_1.6.2441.67ee1ef_Linux_x86_64.zip

WORKDIR /workspace

CMD ["/bin/bash"]
