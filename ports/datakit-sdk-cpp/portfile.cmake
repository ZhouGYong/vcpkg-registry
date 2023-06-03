vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_download_distfile(ARCHIVE
        URLS "https://raw.githubusercontent.com/ZhouGYong/datakit-sdk-cpp/main/release/datakit_sdk_redist-v0.8.0.zip"
        FILENAME "datakit_sdk_redist-v0.8.0.zip"
        SHA512 6e76d5ed802de4819c209f00bb1fc684b9f4cf8358cd84173810647e39d0bb101b9abecba686900e3471855869a56d2fcb63a139380b6ed2ac0f23539c13ba12
    )
elseif(VCPKG_TARGET_IS_LINUX)
    vcpkg_download_distfile(ARCHIVE
        URLS "https://raw.githubusercontent.com/ZhouGYong/datakit-sdk-cpp/main/release/datakit_sdk_redist-v0.8.0.tar.gz"
        FILENAME "datakit_sdk_redist-v0.8.0.tar.gz"
        SHA512 6e76d5ed802de4819c209f00bb1fc684b9f4cf8358cd84173810647e39d0bb101b9abecba686900e3471855869a56d2fcb63a139380b6ed2ac0f23539c13ba12
    )
endif()

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

file(GLOB headers "${SOURCE_PATH}/include/*")
file(COPY ${headers} DESTINATION "${CURRENT_PACKAGES_DIR}/include")

if(VCPKG_TARGET_IS_WINDOWS)
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    file(GLOB libs "${SOURCE_PATH}/lib/win64/*.lib")
    file(COPY ${libs} DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
    file(COPY "${SOURCE_PATH}/lib/win64/fmt.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
file(COPY "${SOURCE_PATH}/lib/win64/fmt.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
file(COPY "${SOURCE_PATH}/lib/win64/ft-sdk.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
file(COPY "${SOURCE_PATH}/lib/win64/libcurl.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
file(COPY "${SOURCE_PATH}/lib/win64/sqlite3.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
file(COPY "${SOURCE_PATH}/lib/win64/zlib1.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
  elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    file(GLOB libs "${SOURCE_PATH}/lib/win64/*")
    file(COPY ${libs} DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
  endif()
elseif(VCPKG_TARGET_IS_LINUX)
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    file(GLOB libs "${SOURCE_PATH}/lib/x86_64/*")
    file(COPY ${libs} DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
  elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    file(GLOB libs "${SOURCE_PATH}/lib/x86_64/*")
    file(COPY ${libs} DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
  endif()
endif()

# Handle copyright
#file(INSTALL "${SOURCE_PATH}/license.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)