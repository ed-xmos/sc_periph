#include "at_periph.h"
#include "debug_print.h"


void sleep_demo(void){

  timer tmr;
  int sys_start_time;


  at_pm_memory_write(my_sleep_mem);
  at_pm_memory_read(my_sleep_mem2);

  at_watchdog_set_timeout(0xf055);
  at_watchdog_enable();
  debug_printf("Sleep demo started, and I'm currently awake\n");

  at_rtc_clear();

  tmr :> sys_start_time;

  tmr when timerafter(sys_start_time + (AWAKE_TIME * 100000)) :> void;


  at_watchdog_set_timeout(0xf055);
  at_watchdog_disable();

  debug_printf("RTC elapsed time measured in %ums = %ums\n", AWAKE_TIME, rtc_end_time-rtc_start_time);
}


int main (void)
{
  par{
    sleep_demo();
  }
  return 0;
}


