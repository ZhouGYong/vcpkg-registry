vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_download_distfile(ARCHIVE
        URLS "https://raw.githubusercontent.com/ZhouGYong/datakit-sdk-cpp/main/release/datakit_sdk_redist-v0.7.5.zip"
        FILENAME "datakit_sdk_redist-v0.7.5.zip"
        SHA512  23776dcd29f0dc1a7afb5699d5b2262328917fa8c71c4300fc8fa312db346737a9d29a2c1134889f8b8cd0f58fa894df44ea7891e3163d849e4ad6b102cb81da
    )
elseif(VCPKG_TARGET_IS_LINUX)
    vcpkg_download_distfile(ARCHIVE
        URLS "https://raw.githubusercontent.com/ZhouGYong/datakit-sdk-cpp/main/release/datakit_sdk_redist-v0.7.5.zip"
        FILENAME "datakit_sdk_redist-v0.7.5.tar.gz"
        SHA512 538a2c79a2609f600ef37fd2f5e9664af059a935705f7f3ef1d690a9da79135ca1aee5395f4156ac766cae819487ae99013fb0dacebfa8a109a0c3a85c9334de
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
    file(COPY "${SOURCE_PATH}/lib/win64/*" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
  elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    file(COPY "${SOURCE_PATH}/lib/win64/*" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
  endif()
elseif(VCPKG_TARGET_IS_LINUX)
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    file(COPY "${SOURCE_PATH}/lib64/libxl.so" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
    file(COPY "${SOURCE_PATH}/lib64/libxl.so" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
  elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    file(COPY "${SOURCE_PATH}/lib/libxl.so" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
    file(COPY "${SOURCE_PATH}/lib/libxl.so" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
  endif()
endif()

# Handle copyright
#file(INSTALL "${SOURCE_PATH}/license.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)