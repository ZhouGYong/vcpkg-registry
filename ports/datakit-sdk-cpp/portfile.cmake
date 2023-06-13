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
  REF d68eb46b43d6b73a1c1b3bba9dafa50ff2c48a16
  SHA512 b804caa53a80fc216b72eb62f8e8e9da4a798436ac1518f8caa9d54f652de7b93f95f83503f38eb8246f3ada9d9b6126c34c723dab6d0431ccdc562113ef6e6e
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

  CONFIGURE_ENVIRONMENT_VARIABLES
        BUILD_FROM_VCPKG=TRUE
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
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86_64")
    #file(GLOB libs "${SOURCE_PATH}/lib/x86_64/*")
    #file(COPY ${libs} DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
    #message(STATUS "copying debug")
    #file(COPY "${SOURCE_PATH}/datakit_sdk_redist/Debug/lib/${ARCHITECTURE}/libft-sdk.a" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
    #file(COPY "${SOURCE_PATH}/datakit_sdk_redist/Debug/lib/${ARCHITECTURE}/libft-sdk.so" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
  #else()
    message(STATUS "copying release:" VCPKG_TARGET_ARCHITECTURE)
    set(_ARCH_ "x86_64")
    file(COPY "${SOURCE_PATH}/datakit_sdk_redist/Release/lib/${_ARCH_}/libft-sdk.a" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
    file(COPY "${SOURCE_PATH}/datakit_sdk_redist/Release/lib/${_ARCH_}/libft-sdk.so" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
  endif()
endif()
#endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")


# Handle copyright
file(INSTALL "${SOURCE_PATH}/license.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)