include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)

set(LIBUNWIND_SOURCE_DIR "${proton_SOURCE_DIR}/contrib/libunwind")

set(LIBUNWIND_CXX_SOURCES
    "${LIBUNWIND_SOURCE_DIR}/src/libunwind.cpp"
    "${LIBUNWIND_SOURCE_DIR}/src/Unwind-EHABI.cpp"
    "${LIBUNWIND_SOURCE_DIR}/src/Unwind-seh.cpp")
if (APPLE)
    set(LIBUNWIND_CXX_SOURCES ${LIBUNWIND_CXX_SOURCES} "${LIBUNWIND_SOURCE_DIR}/src/Unwind_AppleExtras.cpp")
endif ()

set(LIBUNWIND_C_SOURCES
    "${LIBUNWIND_SOURCE_DIR}/src/UnwindLevel1.c"
    "${LIBUNWIND_SOURCE_DIR}/src/UnwindLevel1-gcc-ext.c"
    "${LIBUNWIND_SOURCE_DIR}/src/Unwind-sjlj.c"
    # Use unw_backtrace to override libgcc's backtrace symbol for better ABI compatibility
    unwind-override.c)
set_source_files_properties(${LIBUNWIND_C_SOURCES} PROPERTIES COMPILE_FLAGS "-std=c99")

set(LIBUNWIND_ASM_SOURCES
    "${LIBUNWIND_SOURCE_DIR}/src/UnwindRegistersRestore.S"
    "${LIBUNWIND_SOURCE_DIR}/src/UnwindRegistersSave.S")

enable_language(ASM)

set(LIBUNWIND_SOURCES
    ${LIBUNWIND_CXX_SOURCES}
    ${LIBUNWIND_C_SOURCES}
    ${LIBUNWIND_ASM_SOURCES})

add_library(unwind ${LIBUNWIND_SOURCES})
set_target_properties(unwind PROPERTIES FOLDER "contrib/libunwind-cmake")

target_include_directories(unwind SYSTEM BEFORE PUBLIC $<BUILD_INTERFACE:${LIBUNWIND_SOURCE_DIR}/include>)
target_compile_definitions(unwind PRIVATE -D_LIBUNWIND_NO_HEAP=1 -D_DEBUG -D_LIBUNWIND_IS_NATIVE_ONLY)

# We should enable optimizations (otherwise it will be too slow in debug)
# and disable sanitizers (otherwise infinite loop may happen)
target_compile_options(unwind PRIVATE -O3 -fno-exceptions -funwind-tables -fno-sanitize=all $<$<COMPILE_LANGUAGE:CXX>:-nostdinc++ -fno-rtti>)

check_c_compiler_flag(-Wunused-but-set-variable HAVE_WARNING_UNUSED_BUT_SET_VARIABLE)
if (HAVE_WARNING_UNUSED_BUT_SET_VARIABLE)
    target_compile_options(unwind PRIVATE -Wno-unused-but-set-variable)
endif ()

check_cxx_compiler_flag(-Wmissing-attributes HAVE_WARNING_MISSING_ATTRIBUTES)
if (HAVE_WARNING_MISSING_ATTRIBUTES)
    target_compile_options(unwind PRIVATE -Wno-missing-attributes)
endif ()

check_cxx_compiler_flag(-Wmaybe-uninitialized HAVE_WARNING_MAYBE_UNINITIALIZED)
if (HAVE_WARNING_MAYBE_UNINITIALIZED)
    target_compile_options(unwind PRIVATE -Wno-maybe-uninitialized)
endif ()

# The library is using register variables that are bound to specific registers
# Example: DwarfInstructions.hpp: register unsigned long long x16 __asm("x16") = cfa;
check_cxx_compiler_flag(-Wregister HAVE_WARNING_REGISTER)
if (HAVE_WARNING_REGISTER)
    target_compile_options(unwind PRIVATE "$<$<COMPILE_LANGUAGE:CXX>:-Wno-register>")
endif ()

install(
    TARGETS unwind
    EXPORT global
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)
