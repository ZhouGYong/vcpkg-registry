vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO ZhouGYong/datakit-sdk-cpp
  REF ec953d80875850503e220ff7c37f4584f21824ee
  SHA512 baa3feb5ce15edd09d81dc66e102fd5d3b603cc2a4d01470fec6043c9d5b8e20e5cd054b6d15c36e851f4726fc79420d5e2c36fa7394dd3ccc68f2e7cd7a1283
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

file(GLOB headers "${SOURCE_PATH}/src/datakit-sdk-cpp/ft-sdk/Include/*.h")
file(COPY ${headers} DESTINATION "${CURRENT_PACKAGES_DIR}/include/datakit-sdk-cpp")


#if (__UNDEFINED)
if(VCPKG_TARGET_IS_WINDOWS)
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
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