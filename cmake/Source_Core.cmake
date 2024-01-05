
##############################################################

set(CORE_INC_DIR ${WORKSPACE}/Core/Inc)
set(CORE_SRC_DIR ${WORKSPACE}/Core/Src)
set(DRIVER_INC_DIR ${WORKSPACE}/Drivers/${MCU}_HAL_Driver/Inc)
set(DRIVER_SRC_DIR ${WORKSPACE}/Drivers/${MCU}_HAL_Driver/Src)
set(CMSIS_INC_DIR ${WORKSPACE}/Drivers/CMSIS/Include)
set(CMSIS_DEVICE_INC_DIR ${WORKSPACE}/Drivers/CMSIS/Device/ST/${MCU}/Include)
##############################################################



##############################################################
file(GLOB CORE_INC_FILES ${CORE_INC_DIR}/*.h)
file (GLOB DRIVER_INC_FILES ${DRIVER_INC_DIR}/stm32*.h ${DRIVER_INC_DIR}/legancy/stm32*.h)
file(GLOB CMSIS_INC_FILES 
        ${CMSIS_INC_DIR}/cmsis_*.h 
        ${CMSIS_INC_DIR}/core_*.h 
        ${CMSIS_INC_DIR}/mpu_*.h 
        ${CMSIS_INC_DIR}/tz_context_*.h)


file(GLOB CORE_SRC_FILES ${CORE_SRC_DIR}/*.c)        
file(GLOB DRIVER_SRC_FILES ${DRIVER_SRC_DIR}/stm32*.c)
############################################################     

#Add linker and startup file
############################################################
file(GLOB LINKER_SCRIPT_FLASH ${WORKSPACE}/STM32*_FLASH.ld)
file(GLOB LINKER_SCRIPT_RAM ${WORKSPACE}/STM32*_RAM.ld)
file(GLOB START_UP ${WORKSPACE}/Core/Startup/startup_stm32*.s)
############################################################

set(SOURCES_FILES 
    ${START_UP}
    ${CORE_SRC_FILES}
    ${CORE_INC_FILES} 
    ${DRIVER_SRC_FILES}
    ${DRIVER_INC_FILES}
    ${CMSIS_INC_FILES}
    ${CMSIS_DEVICE_INC_FILES} )

set(INCLUDE_DIR
        ${CORE_INC_DIR} 
        ${DRIVER_INC_DIR} 
        ${CMSIS_INC_DIR} 
        ${CMSIS_DEVICE_INC_DIR})