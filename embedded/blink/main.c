#include <stdint.h>

struct port_registers {
  volatile uint32_t dir;
  volatile uint32_t dir_clear;
  volatile uint32_t dir_set;
  volatile uint32_t dir_toggle;
  volatile uint32_t out;
  volatile uint32_t out_clear;
  volatile uint32_t out_set;
} typedef port_registers;

volatile port_registers* port_register = (volatile port_registers*)(0x41004400UL);

void Reset_Handler(void){
  main();
  for(;;){}
}

int main() {
  setup();

  for(;;){
    loop();
  }
}

void setup(){
  port_register->dir_set = 1ul << 20;
}

void loop(){
  for(int i = 0; i < 10000000; i++) {
    port_register->out_set = 1ul << 20;
  }
  
  for(int i = 0; i < 10000000; i++) {
    port_register->out_clear = 1ul << 20;
  }
}

typedef struct _DeviceVectors
{
  /* Stack pointer */
  void* pvStack;

  /* Cortex-M handlers */
  void* pfnReset_Handler;
  void* pfnNMI_Handler;
  void* pfnHardFault_Handler;
  void* pfnReservedM12;
  void* pfnReservedM11;
  void* pfnReservedM10;
  void* pfnReservedM9;
  void* pfnReservedM8;
  void* pfnReservedM7;
  void* pfnReservedM6;
  void* pfnSVC_Handler;
  void* pfnReservedM4;
  void* pfnReservedM3;
  void* pfnPendSV_Handler;
  void* pfnSysTick_Handler;

  /* Peripheral handlers */
  void* pfnPM_Handler;                    /*  0 Power Manager */
  void* pfnSYSCTRL_Handler;               /*  1 System Control */
  void* pfnWDT_Handler;                   /*  2 Watchdog Timer */
  void* pfnRTC_Handler;                   /*  3 Real-Time Counter */
  void* pfnEIC_Handler;                   /*  4 External Interrupt Controller */
  void* pfnNVMCTRL_Handler;               /*  5 Non-Volatile Memory Controller */
  void* pfnDMAC_Handler;                  /*  6 Direct Memory Access Controller */
  void* pfnUSB_Handler;                   /*  7 Universal Serial Bus */
  void* pfnEVSYS_Handler;                 /*  8 Event System Interface */
  void* pfnSERCOM0_Handler;               /*  9 Serial Communication Interface 0 */
  void* pfnSERCOM1_Handler;               /* 10 Serial Communication Interface 1 */
  void* pfnSERCOM2_Handler;               /* 11 Serial Communication Interface 2 */
  void* pfnSERCOM3_Handler;               /* 12 Serial Communication Interface 3 */
  void* pfnReserved13;
  void* pfnReserved14;
  void* pfnTCC0_Handler;                  /* 15 Timer Counter Control 0 */
  void* pfnTCC1_Handler;                  /* 16 Timer Counter Control 1 */
  void* pfnTCC2_Handler;                  /* 17 Timer Counter Control 2 */
  void* pfnTC3_Handler;                   /* 18 Basic Timer Counter 3 */
  void* pfnTC4_Handler;                   /* 19 Basic Timer Counter 4 */
  void* pfnTC5_Handler;                   /* 20 Basic Timer Counter 5 */
  void* pfnReserved21;
  void* pfnReserved22;
  void* pfnADC_Handler;                   /* 23 Analog Digital Converter */
  void* pfnAC_Handler;                    /* 24 Analog Comparators */
  void* pfnDAC_Handler;                   /* 25 Digital Analog Converter */
  void* pfnPTC_Handler;                   /* 26 Peripheral Touch Controller */
  void* pfnI2S_Handler;                   /* 27 Inter-IC Sound Interface */
} DeviceVectors;

/* Exception Table */
__attribute__ ((section(".isr_vector"))) const DeviceVectors exception_table =
{
  /* Configure Initial Stack Pointer, using linker-generated symbols */
  (void*) (0x10000),

  (void*) main,
  (void*) main,
  (void*) main,
  (void*) (0UL), /* Reserved */
  (void*) (0UL), /* Reserved */
  (void*) (0UL), /* Reserved */
  (void*) (0UL), /* Reserved */
  (void*) (0UL), /* Reserved */
  (void*) (0UL), /* Reserved */
  (void*) (0UL), /* Reserved */
  (void*) main,
  (void*) (0UL), /* Reserved */
  (void*) (0UL), /* Reserved */
  (void*) main,
  (void*) main,

  /* Configurable interrupts */
  (void*) main,             /*  0 Power Manager */
  (void*) main,        /*  1 System Control */
  (void*) main,            /*  2 Watchdog Timer */
  (void*) main,            /*  3 Real-Time Counter */
  (void*) main,            /*  4 External Interrupt Controller */
  (void*) main,        /*  5 Non-Volatile Memory Controller */
  (void*) main,           /*  6 Direct Memory Access Controller */
  (void*) main,            /*  7 Universal Serial Bus */
  (void*) main,          /*  8 Event System Interface */
  (void*) main,        /*  9 Serial Communication Interface 0 */
  (void*) main,        /* 10 Serial Communication Interface 1 */
  (void*) main,        /* 11 Serial Communication Interface 2 */
  (void*) main,        /* 12 Serial Communication Interface 3 */
  (void*) main,        /* 13 Serial Communication Interface 4 */
  (void*) main,        /* 14 Serial Communication Interface 5 */
  (void*) main,           /* 15 Timer Counter Control 0 */
  (void*) main,           /* 16 Timer Counter Control 1 */
  (void*) main,           /* 17 Timer Counter Control 2 */
  (void*) main,            /* 18 Basic Timer Counter 0 */
  (void*) main,            /* 19 Basic Timer Counter 1 */
  (void*) main,            /* 20 Basic Timer Counter 2 */
  (void*) main,            /* 21 Basic Timer Counter 3 */
  (void*) main,            /* 22 Basic Timer Counter 4 */
  (void*) main,            /* 23 Analog Digital Converter */
  (void*) main,             /* 24 Analog Comparators */
  (void*) main,            /* 25 Digital Analog Converter */
  (void*) main,            /* 26 Peripheral Touch Controller */
  (void*) main,            /* 27 Inter-IC Sound Interface */
  (void*) (0UL),                  /* Reserved */
};
