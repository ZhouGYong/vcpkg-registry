vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_download_distfile(ARCHIVE
        URLS "https://raw.githubusercontent.com/ZhouGYong/datakit-sdk-cpp/main/release/datakit_sdk_redist-v0.7.5.zip"
        FILENAME "datakit_sdk_redist-v0.7.5.zip"
        SHA512 c6235249e00c5bb52fb8451f9ad35e0d784817833fc79c574f941207f6c98cb858a56627e50f4046b8a4e86457cbbd20574d9a20addb7dad56f3838279c7c7ee
    )
elseif(VCPKG_TARGET_IS_LINUX)
    vcpkg_download_distfile(ARCHIVE
        URLS "https://raw.githubusercontent.com/ZhouGYong/datakit-sdk-cpp/main/release/datakit_sdk_redist-v0.7.5.tar.gz"
        FILENAME "datakit_sdk_redist-v0.7.5.tar.gz"
        SHA512 c6235249e00c5bb52fb8451f9ad35e0d784817833fc79c574f941207f6c98cb858a56627e50f4046b8a4e86457cbbd20574d9a20addb7dad56f3838279c7c7ee
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
    file(GLOB libs "${SOURCE_PATH}/lib/win64/*")
    file(COPY ${libs} DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
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