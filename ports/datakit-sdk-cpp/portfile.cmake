vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_download_distfile(ARCHIVE
        URLS "https://raw.githubusercontent.com/ZhouGYong/datakit-sdk-cpp/main/release/datakit_sdk_redist-v0.8.1.zip"
        FILENAME "datakit_sdk_redist-v0.8.0.zip"
        SHA512 627e6af5f57df0286bde87bbcd185cc48554864c040f2031967a165e3ea5a8685e232576c7fc7768d444723afdc317d3b38e95c078728607458c3c2e078c09bf
    )
elseif(VCPKG_TARGET_IS_LINUX)
    vcpkg_download_distfile(ARCHIVE
        URLS "https://raw.githubusercontent.com/ZhouGYong/datakit-sdk-cpp/main/release/datakit_sdk_redist-v0.8.1.tar.gz"
        FILENAME "datakit_sdk_redist-v0.8.0.tar.gz"
        SHA512 627e6af5f57df0286bde87bbcd185cc48554864c040f2031967a165e3ea5a8685e232576c7fc7768d444723afdc317d3b38e95c078728607458c3c2e078c09bf
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