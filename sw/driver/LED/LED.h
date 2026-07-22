/*
 * LED.h
 *
 *  Created on: 2026. 5. 3.
 *      Author: kccistc
 */

#ifndef SRC_DRIVER_LED_LED_H_
#define SRC_DRIVER_LED_LED_H_

#include <stdint.h>
#include "xgpio.h"

#define LED_CHANNEL 2

void LED_Init(XGpio *InstancePtr);
void LED_SetData(uint8_t data);

#endif /* SRC_DRIVER_LED_LED_H_ */
