


target_compile_definitions(${EXECUTABLE} PRIVATE
        -DUSE_FULL_ASSERT
        -DUSE_HAL_DRIVER
        -DUSE_FULL_LL_DRIVER
        -DSTM32F103xB
        -DHSE_VALUE=8000000
        -D${MCU_FAMILY}
        )



target_compile_options(${EXECUTABLE} PRIVATE
        -mcpu=cortex-m3
        -mthumb
        -fdata-sections
        -ffunction-sections
        -Wall
        $<$<CONFIG:Debug>:-Og>
        )

target_link_options(${EXECUTABLE} PRIVATE
        -T${LINKER_SCRIPT_FLASH}
        -mcpu=cortex-m3
        -mthumb
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

