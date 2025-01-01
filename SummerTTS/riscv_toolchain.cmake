# toolchain.cmake
# 配置 RISC-V 工具链，使用 musl C 标准库

# 设置工具链根目录
set(TOOLCHAIN_ROOT "/home/openharmony/toolchain/riscv")

# 设置交叉编译工具链的基本配置
set(CMAKE_SYSTEM_NAME Linux) # 目标系统为 Linux
set(CMAKE_SYSTEM_PROCESSOR riscv64) # 目标架构为 RISC-V 64 位

# 设置交叉编译器路径
set(CMAKE_C_COMPILER "${TOOLCHAIN_ROOT}/bin/riscv64-unknown-linux-musl-gcc")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_ROOT}/bin/riscv64-unknown-linux-musl-g++")
set(CMAKE_ASM_COMPILER "${TOOLCHAIN_ROOT}/bin/riscv64-unknown-linux-musl-as")

# 设置工具链相关工具
set(CMAKE_AR "${TOOLCHAIN_ROOT}/bin/riscv64-unknown-linux-musl-ar")
set(CMAKE_RANLIB "${TOOLCHAIN_ROOT}/bin/riscv64-unknown-linux-musl-ranlib")
set(CMAKE_STRIP "${TOOLCHAIN_ROOT}/bin/riscv64-unknown-linux-musl-strip")

# 设置目标系统的 sysroot
set(CMAKE_SYSROOT "${TOOLCHAIN_ROOT}/sysroot")

# 添加目标平台的头文件路径
include_directories("${CMAKE_SYSROOT}/usr/include")
include_directories("${CMAKE_SYSROOT}/include")

# 链接库的搜索路径
link_directories("${CMAKE_SYSROOT}/usr/lib")
link_directories("${CMAKE_SYSROOT}/lib")

# 设置 musl 为默认 C 标准库
set(CMAKE_C_FLAGS "--sysroot=${CMAKE_SYSROOT} -nostdinc -isystem ${CMAKE_SYSROOT}/include")
set(CMAKE_CXX_FLAGS "--sysroot=${CMAKE_SYSROOT} -nostdinc -isystem ${CMAKE_SYSROOT}/include")
set(CMAKE_EXE_LINKER_FLAGS "--sysroot=${CMAKE_SYSROOT}")