vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

#if(VCPKG_TARGET_IS_WINDOWS)
#    vcpkg_download_distfile(ARCHIVE
#        URLS "https://raw.githubusercontent.com/ZhouGYong/datakit-sdk-cpp/main/release/datakit_sdk_redist-v0.8.1.zip"
#        FILENAME "datakit_sdk_redist-v0.8.0.zip"
#        SHA512 627e6af5f57df0286bde87bbcd185cc48554864c040f2031967a165e3ea5a8685e232576c7fc7768d444723afdc317d3b38e95c078728607458c3c2e078c09bf
#    )
#elseif(VCPKG_TARGET_IS_LINUX)
#    vcpkg_download_distfile(ARCHIVE
#        URLS "https://raw.githubusercontent.com/ZhouGYong/datakit-sdk-cpp/main/release/datakit_sdk_redist-v0.8.1.tar.gz"
#        FILENAME "datakit_sdk_redist-v0.8.0.tar.gz"
#        SHA512 627e6af5f57df0286bde87bbcd185cc48554864c040f2031967a165e3ea5a8685e232576c7fc7768d444723afdc317d3b38e95c078728607458c3c2e078c09bf
#    )
#endif()

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO ZhouGYong/datakit-sdk-cpp
  REF 4976de38588746c7a8a2652f7abbfc0987362cac
  SHA512 86fd4070d4e277558a08e7fcc58b8ea53a1d02a2453e71a2f46dc1efd5e64e8430e8323b3a33d416f9449f4e86a2ad729aad15090f408d09f482530e11fc6b08
  HEAD_REF main
)

if(VCPKG_TARGET_IS_WINDOWS)
  set(VCPKG_TARGET_ARCHITECTURE x64)
  set(VCPKG_CRT_LINKAGE dynamic)
  set(VCPKG_LIBRARY_LINKAGE dynamic)
  set(VCPKG_CXX_FLAGS "/std:c++17 /EHa")
  set(VCPKG_C_FLAGS "/GL /Gw /GS-")
endif()

#set(VCPKG_BUILD_TYPE release)

vcpkg_configure_cmake(
  SOURCE_PATH "${SOURCE_PATH}/src"
  PROJECT_NAME ft-sdk
  WINDOWS_USE_MSBUILD
  OPTIONS
	  -DBUILD_FROM_VCPKG=TRUE
)
vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()

file(GLOB headers "${SOURCE_PATH}/src/datakit-sdk-cpp/ft-sdk/Include/*.h")
file(COPY ${headers} DESTINATION "${CURRENT_PACKAGES_DIR}/include/datakit-sdk-cpp")

#install(TARGETS ft-sdk
#  RUNTIME DESTINATION bin
#  LIBRARY DESTINATION lib
#  ARCHIVE DESTINATION lib 
#)

#if (__UNDEFINED)
if(VCPKG_TARGET_IS_WINDOWS)
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    #file(GLOB libs "${SOURCE_PATH}/lib/win64/*.lib")
    #file(COPY ${libs} DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
    #if(${VCPKG_BUILD_TYPE} STREQUAL "Debug")
      message(STATUS "copying debug")
      file(COPY "${SOURCE_PATH}/datakit_sdk_redist/debug/lib/ft-sdkd.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
      file(COPY "${SOURCE_PATH}/datakit_sdk_redist/debug/lib/ft-sdkd.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
    #else()
      message(STATUS "copying release")
      file(COPY "${SOURCE_PATH}/datakit_sdk_redist/release/lib/ft-sdk.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
      file(COPY "${SOURCE_PATH}/datakit_sdk_redist/release/lib/ft-sdk.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
    #endif()
  endif()
elseif(VCPKG_TARGET_IS_LINUX)
  message(STATUS "copying release:" VCPKG_TARGET_ARCHITECTURE)
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(_ARCH_ "x86_64")
  elseif (VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(_ARCH_ "aarch64")
  endif()
  
  file(COPY "${SOURCE_PATH}/datakit_sdk_redist/Debug/lib/${_ARCH_}/libft-sdk.so" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
  file(COPY "${SOURCE_PATH}/datakit_sdk_redist/Release/lib/${_ARCH_}/libft-sdk.so" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
  file(COPY "${SOURCE_PATH}/datakit_sdk_redist/Release/cmake/ft-sdk-config.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/datakit-sdk-cpp")
  file(COPY "${SOURCE_PATH}/datakit_sdk_redist/Release/cmake/ft-sdk-config-version.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/datakit-sdk-cpp")
  file(COPY "${SOURCE_PATH}/datakit_sdk_redist/Release/cmake/ft-sdk-targets.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/datakit-sdk-cpp")
  file(COPY "${SOURCE_PATH}/datakit_sdk_redist/Release/cmake/ft-sdk-targets-release.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/datakit-sdk-cpp")
  file(COPY "${SOURCE_PATH}/datakit_sdk_redist/Debug/cmake/ft-sdk-targets-debug.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/datakit-sdk-cpp")

  file(GLOB_RECURSE RELEASE_TARGETS
  "${CURRENT_PACKAGES_DIR}/share/datakit-sdk-cpp/*.cmake"
  )
  foreach(RELEASE_TARGET IN LISTS RELEASE_TARGETS)
    file(READ ${RELEASE_TARGET} _contents)
    string(REPLACE "${CURRENT_PACKAGES_DIR}" "\${CURRENT_PACKAGES_DIR}" _contents "${_contents}")
    file(WRITE ${RELEASE_TARGET} "${_contents}")
  endforeach()


endif()
#endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")


# Handle copyright
file(INSTALL "${SOURCE_PATH}/license.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)