cmake_minimum_required(VERSION 3.20)
set(MCU STM32F7xx)
project(BlinkLED)


set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

enable_language(ASM)



##############################################################
set(WORKSPACE ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME})

set(CORE_INC_DIR ${WORKSPACE}/Core/Inc)
set(CORE_SRC_DIR ${WORKSPACE}/Core/Src)
set(DRIVER_INC_DIR ${WORKSPACE}/Drivers/${MCU}_HAL_Driver/Inc)
set(DRIVER_SRC_DIR ${WORKSPACE}/Drivers/${MCU}_HAL_Driver/Src)
set(CMSIS_INC_DIR ${WORKSPACE}/Drivers/CMSIS/Include)
set(CMSIS_DEVICE_INC_DIR ${WORKSPACE}/Drivers/CMSIS/Device/ST/${MCU}/Include)
##############################################################



##############################################################
file(GLOB CORE_INC_FILES ${CORE_INC_DIR}/*.h)
file(GLOB DRIVER_INC_FILES ${DRIVER_INC_DIR}/stm32*.h)
file (GLOB DRIVER_INC_FILES ${DRIVER_INC_DIR}/stm32*.h ${DRIVER_INC_DIR}/legancy/stm32*.h)
file(GLOB CMSIS_INC_FILES 
        ${CMSIS_INC_DIR}/cmsis_*.h 
        ${CMSIS_INC_DIR}/core_*.h 
        ${CMSIS_INC_DIR}/mpu_*.h 
        ${CMSIS_INC_DIR}/tz_context_*.h)


file(GLOB CORE_SRC_FILES ${CORE_SRC_DIR}/*.c)        
file(GLOB DRIVER_SRC_FILES ${DRIVER_SRC_DIR}/stm32*.c)
############################################################        

############################################################
file(GLOB LINKER_SCRIPT_FLASH ${WORKSPACE}/STM32*_FLASH.ld)
file(GLOB LINKER_SCRIPT_RAM ${WORKSPACE}/STM32*_RAM.ld)
file(GLOB START_UP ${WORKSPACE}/Core/Startup/startup_stm32*.s)
message(${START_UP})
############################################################

############################################################
set(EXECUTABLE ${PROJECT_NAME}.elf)

add_executable(${EXECUTABLE}  ${START_UP}
        ${CORE_SRC_FILES}
        ${CORE_INC_FILES} 
        ${DRIVER_SRC_FILES}
        ${DRIVER_INC_FILES}
        ${CMSIS_INC_FILES}
        ${CMSIS_DEVICE_INC_FILES}
                     )
target_include_directories(${EXECUTABLE} PRIVATE
        ${CORE_INC_DIR} 
        ${DRIVER_INC_DIR} 
        ${CMSIS_INC_DIR} 
        ${CMSIS_DEVICE_INC_DIR}
)
##########################################################


target_compile_definitions(${EXECUTABLE} PRIVATE
        -DUSE_FULL_ASSERT
        -DUSE_HAL_DRIVER
        -DUSE_FULL_LL_DRIVER
        -DSTM32F746xx
        -DHSE_VALUE=8000000
        -D${MCU}
        )



target_compile_options(${EXECUTABLE} PRIVATE
        -mcpu=cortex-m4
        -mthumb
        -mfpu=fpv4-sp-d16
        -mfloat-abi=hard
        -fdata-sections
        -ffunction-sections
        -Wall
        $<$<CONFIG:Debug>:-Og>
        )

target_link_options(${EXECUTABLE} PRIVATE
        -T${LINKER_SCRIPT_FLASH}
        -mcpu=cortex-m7
        -mthumb
        -mfpu=fpv4-sp-d16
        -mfloat-abi=hard
        -specs=nano.specs
        -Wl,-Map=${PROJECT_NAME}.map,--cref
        -lnosys
        -Wl,--gc-sections
        -u _printf_float 
        -Wl,--start-group
        -lc
        -lm
        -lstdc++
        -lsupc++
        -Wl,--end-group
        -Wl,--print-memory-usage
        )


# Create hex file
add_custom_command(TARGET ${EXECUTABLE}
        POST_BUILD
        COMMAND arm-none-eabi-objcopy -O ihex ${EXECUTABLE} ${PROJECT_NAME}.hex
        COMMAND arm-none-eabi-objcopy -O binary ${EXECUTABLE} ${PROJECT_NAME}.bin)


# Print executable size
add_custom_command(TARGET ${EXECUTABLE}
        POST_BUILD
        COMMAND arm-none-eabi-size ${EXECUTABLE})
