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
  REF 489b63323469a2a9ab786af27c6f4beebb776228
  SHA512 26794cba70afbb80e70e51d759b9178857157219c0a4472c775d12a1f6e9521cfdbaa566d0f4ae20e4dcbe3dadbab6e9316868a30b6461ef1c4367347f6e71c7
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
#vcpkg_fixup_cmake_targets()

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

endif()
#endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")


# Handle copyright
file(INSTALL "${SOURCE_PATH}/license.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)