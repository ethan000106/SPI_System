/*
 * SPI.c
 *
 *  Created on: 2026. 5. 3.
 *      Author: kccistc
 */


#include "SPI.h"

uint8_t SPI_Transfer(uint8_t tx_data) {
    // 1. 보낼 데이터 쓰기
    Xil_Out32(SPI_BASEADDR + 0, (uint32_t)tx_data);

    // 2. Control 레지스터 설정 (clk_div=49, Mode=0)
    uint32_t control_val = (49 << 8);

    // 3. Start 펄스 쏘기
    Xil_Out32(SPI_BASEADDR + 4, control_val | 0x01);
    Xil_Out32(SPI_BASEADDR + 4, control_val & ~0x01);

    // 4. 통신 완료(busy 비트 0) 대기
    while ((Xil_In32(SPI_BASEADDR + 8) & 0x01) == 1) {
        // Wait
    }

    // 5. 수신 데이터 하위 8비트 읽어서 반환
    return (uint8_t)(Xil_In32(SPI_BASEADDR + 12) & 0xFF);
}
