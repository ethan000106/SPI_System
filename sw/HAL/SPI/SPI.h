/*
 * SPI.h
 *
 *  Created on: 2026. 5. 3.
 *      Author: kccistc
 */

#ifndef SRC_HAL_SPI_SPI_H_
#define SRC_HAL_SPI_SPI_H_

#include "xil_io.h"
#include <stdint.h>

// 커스텀 SPI IP의 베이스 주소
#define SPI_BASEADDR 0x44A00000

uint8_t SPI_Transfer(uint8_t tx_data);

#endif /* SRC_HAL_SPI_SPI_H_ */
