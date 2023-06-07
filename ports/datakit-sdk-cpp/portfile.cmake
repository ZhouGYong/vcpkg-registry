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
  REF c1e7559288cd92fabdaebc22d44b719a03d90788
  SHA512 c361c69d471e906803ceaec3a743a75e1187d9aeddf485e22e60b5931284e3175c5cd3332234455630b649bbc1dfa3c4c0d7a4a992c348e67f34ccd7312c5b93
  HEAD_REF main
)

if(VCPKG_TARGET_IS_WINDOWS)
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)
set(VCPKG_CXX_FLAGS "/std:c++17 /EHa")
set(VCPKG_C_FLAGS "/GL /Gw /GS-")
endif()

vcpkg_configure_cmake(
  SOURCE_PATH "${SOURCE_PATH}/src"
  PROJECT_NAME ft-sdk
  WINDOWS_USE_MSBUILD
  OPTIONS
	-DCMAKE_BUILD_TYPE=release
	-DBUILD_FROM_VCPKG=TRUE

  CONFIGURE_ENVIRONMENT_VARIABLES
        BUILD_FROM_VCPKG=TRUE
)
vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")


# Handle copyright
#file(INSTALL "${SOURCE_PATH}/license.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)