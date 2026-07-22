/*
 * Button.h
 *
 *  Created on: 2026. 4. 28.
 *      Author: kccistc
 */

#ifndef SRC_DRIVER_BUTTON_BUTTON_H_
#define SRC_DRIVER_BUTTON_BUTTON_H_

#include <stdint.h>
#include "xgpio.h"

#define BTN_CHANNEL 1

void Button_Init(XGpio *InstancePtr);
uint32_t Button_GetState();

#endif /* SRC_DRIVER_BUTTON_BUTTON_H_ */
