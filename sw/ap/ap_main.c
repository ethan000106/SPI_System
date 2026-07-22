#include "ap_main.h"
#include "xparameters.h"
#include "xgpio.h"
#include "xil_printf.h"
#include "sleep.h"

// 하위 모듈들 Include
#include "../HAL/SPI/SPI.h"
#include "../DRIVER/Button/Button.h"
#include "../DRIVER/LED/LED.h"

// 마스터 보드의 AXI GPIO 전역 객체 (Button, LED 공용)
XGpio Gpio_Inst;

void ap_init() {
    int Status;

    xil_printf("\r\n--- Microblaze SPI Master: Refactored AP Ready ---\r\n");

    // 1. GPIO 디바이스 전체 초기화
    Status = XGpio_Initialize(&Gpio_Inst, XPAR_GPIO_0_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("GPIO Init Failed!\r\n");
        return;
    }

    // 2. Driver 계층 초기화
    Button_Init(&Gpio_Inst);
    LED_Init(&Gpio_Inst);

    xil_printf("System Initialized. Press BTN0~BTN3.\r\n");
}

void ap_excute() {
    static uint32_t prev_btn_state = 0;
    uint32_t btn_state;
    uint8_t rx_data;

    // 1. 버튼 상태 읽기 (DRIVER 계층 호출)
    btn_state = Button_GetState();

    // 2. 버튼이 눌리는 순간 감지 (Edge Detect)
    if (btn_state != prev_btn_state) {
        if (btn_state != 0) {

            xil_printf("TX (Btn): 0x%02X  |  ", btn_state);

            // 3. SPI 통신 수행 (HAL 계층 호출)
            rx_data = SPI_Transfer((uint8_t)btn_state);

            xil_printf("RX (Sw): 0x%02X\r\n", rx_data);

            // 4. LED 출력 (DRIVER 계층 호출)
            LED_SetData(rx_data);
        }
        prev_btn_state = btn_state;
    }

    // 소프트웨어 디바운싱 지연
    usleep(10000);
}
