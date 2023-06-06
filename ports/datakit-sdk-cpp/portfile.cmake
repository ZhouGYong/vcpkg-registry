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
  REF 1835e3869b72935057eff051277ad64f8e502b74
  SHA512 d86420e20bb52672c453f07940b29dd068be4908c2842f85e9b82bfe2cd7e0ed4353f430c8fa2360650abb751437a3a8d7eba11d63737d4e6c6a8fbcda8c6d9c
  HEAD_REF main
)

vcpkg_configure_cmake(
  SOURCE_PATH "${SOURCE_PATH}/src"
  PROJECT_NAME ft-sdk
  PREFER_NINJA
  CONFIGURE_ENVIRONMENT_VARIABLES
        BUILD_FROM_VCPKG=TRUE
)
vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")


# Handle copyright
#file(INSTALL "${SOURCE_PATH}/license.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)