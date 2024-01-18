cmake_minimum_required(VERSION 3.20)

project(BlinkLED VERSION 1.0.0)


set(MCU_FAMILY_LIST  STM32F7xx STM32F4xx STM32F1xx STM32F0xx)
set(MCU_FAMILY STM32F0xx CACHE STRING "Default MCU Family is Core")
set_property(CACHE MCU_FAMILY PROPERTY STRINGS ${MCU_FAMILY_LIST})


include(arm-none-eabi-binutils)


set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

enable_language(ASM)

set(WORKSPACE ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME})

##########################################################

set(EXECUTABLE ${PROJECT_NAME}.elf)


include(Source_Core)
include(Source_User)

add_executable(${EXECUTABLE} ${SOURCES_FILES} ${USER_SOURCES_FILES}) 
target_include_directories(${EXECUTABLE} PRIVATE ${INCLUDE_DIR} ${USER_INCLUDE_DIR})
##########################################################

##########################################################
 include(${MCU_FAMILY})
##########################################################


# Create hex file
add_custom_command(TARGET ${EXECUTABLE}
        POST_BUILD
        COMMAND arm-none-eabi-objcopy -O ihex ${EXECUTABLE} ${PROJECT_NAME}.hex
        COMMAND arm-none-eabi-objcopy -O binary ${EXECUTABLE} ${PROJECT_NAME}.bin)


# Print executable size
add_custom_command(TARGET ${EXECUTABLE}
        POST_BUILD
        COMMAND arm-none-eabi-size ${EXECUTABLE})
