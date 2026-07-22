/*
 * LED.c
 *
 *  Created on: 2026. 5. 3.
 *      Author: kccistc
 */


#include "LED.h"

extern XGpio Gpio_Inst; // AP에서 관리하는 GPIO 객체 사용

void LED_Init(XGpio *InstancePtr) {
    // 16비트 전체를 출력(0)으로 설정 : 0x0000
    XGpio_SetDataDirection(InstancePtr, LED_CHANNEL, 0x0000);
    // 초기화 시 LED 모두 끄기
    XGpio_DiscreteWrite(InstancePtr, LED_CHANNEL, 0x00);
}

void LED_SetData(uint8_t data) {
    // 수신한 8비트 데이터를 출력
    XGpio_DiscreteWrite(&Gpio_Inst, LED_CHANNEL, data);
}
