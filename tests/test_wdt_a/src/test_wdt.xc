#include "debug_conf.h"
#include "debug_print.h"
#include "at_wdt.h"


int main (void)
{
  timer tmr;
  int sys_start_time;

  at_watchdog_set_timeout(0xf055);
  at_watchdog_enable();
  debug_printf("Sleep demo started, and I'm currently awake\n");

at_watchdog_kick


  tmr :> sys_start_time;

  tmr when timerafter(sys_start_time + (AWAKE_TIME * 100000)) :> void;


  at_watchdog_set_timeout(0xf055);
  at_watchdog_disable();

  debug_printf("RTC elapsed time measured in %ums = %ums\n", AWAKE_TIME, rtc_end_time-rtc_start_time);
  return 0;
}


