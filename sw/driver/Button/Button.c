/*
 * Button.c
 *
 *  Created on: 2026. 4. 28.
 *      Author: kccistc
 */

#include "Button.h"

extern XGpio Gpio_Inst; // AP에서 관리하는 GPIO 객체 사용

void Button_Init(XGpio *InstancePtr) {
    // 하위 4비트를 입력(1)으로 설정 : 0x0F
    XGpio_SetDataDirection(InstancePtr, BTN_CHANNEL, 0x0F);
}

uint32_t Button_GetState() {
    return XGpio_DiscreteRead(&Gpio_Inst, BTN_CHANNEL);
}



