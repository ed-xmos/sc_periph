#include <print.h>
#include "debug_print.h"
#include "xassert.h"
#include "adc.h"

#define TEST_LENGTH   1000000000
#define PRINT_PERIOD   100000000
#define TRIGGER_PERIOD    100000

#define NUM_ACTIVE_ADCS    4
#define SAMPLES_PER_PACKET 4

port trigger_port = PORT_ADC_TRIGGER;
clock cl = XS1_CLKBLK_2;

void adc_example(chanend c)
{
    timer        print_timer, test_timer;
    unsigned int print_time, test_time;

    unsigned int current_value[NUM_ACTIVE_ADCS] = { 0 };
    unsigned int new_value[NUM_ACTIVE_ADCS] = { 0 };
    unsigned int adc_ptr = 0;

    adc_config_t adc_config = { { 0, 0, 0, 0, 0, 0, 0, 0 }, ADC_8_BPS, 1, 0 };

    if (adc_enable(c, trigger_port, adc_config) != ADC_NO_ACTIVE_ADC)
    {
        printstrln("Failed to detect no active ADCs");
        return;
    }

    for (int i = 0; i < NUM_ACTIVE_ADCS; i++)
    {
        adc_config.input_enable[i] = 1;

        // A value that is not possible to get from the 12-bit ADC
        current_value[i] = 0xffffffff;
    }

    adc_config.bits_per_sample = 2;
    if (adc_enable(c, trigger_port, adc_config) != ADC_INVALID_BITS_PER_SAMPLE)
    {
        printstrln("Error: failed to detect invalide bits_per_sample");
        return;
    }

    adc_config.bits_per_sample = ADC_16_BPS;

    adc_config.samples_per_packet = 0;
    if (adc_enable(c, trigger_port, adc_config) != ADC_INVALID_SAMPLES_PER_PACKET)
    {
        printstrln("Error: failed to detect invalide samples_per_packet");
        return;
    }

    adc_config.samples_per_packet = 6;
    if (adc_enable(c, trigger_port, adc_config) != ADC_INVALID_SAMPLES_PER_PACKET)
    {
        printstrln("Error: failed to detect invalide samples_per_packet");
        return;
    }

    adc_config.samples_per_packet = SAMPLES_PER_PACKET;
    adc_config.calibration_mode = 0;

    if (adc_enable(c, trigger_port, adc_config) != ADC_OK)
    {
        printstrln("Error: failed to initialize ADC");
        return;
    }
    printstrln("ADC initialized and ready to use");

    print_timer :> print_time;
    print_time += PRINT_PERIOD;

    test_timer :> test_time;
    test_time += TEST_LENGTH;

    adc_trigger_packet(trigger_port, adc_config);

    while (1)
    {
        unsigned data[SAMPLES_PER_PACKET];

        select
        {
            case test_timer when timerafter(test_time) :> void:
                printstrln("PASS");
                return;

            case adc_read_packet(c, adc_config, data):
                for (int i = 0; i < adc_config.samples_per_packet; i++)
                {
                    new_value[adc_ptr] = data[i];
                    adc_ptr++;
                    if (adc_ptr >= NUM_ACTIVE_ADCS)
                        adc_ptr = 0;
                }
                adc_trigger_packet(trigger_port, adc_config);
                break;

            case print_timer when timerafter(print_time) :> void:
                for (int i = 0; i < NUM_ACTIVE_ADCS; i++)
                {
                    if (new_value[i] != current_value[i])
                    {
                        debug_printf("ADC value: %d = 0x%x\n", i, new_value[i]);
                        current_value[i] = new_value[i];
                    }
                }
                print_time += PRINT_PERIOD;
                break;
        }
    }

    xassert(0 && _msg("Unreachable"));
}

int main()
{
    chan c;

    par {
        on stdcore[0]: adc_example(c);
        xs1_su_adc_service(c);
    }

    return 0;
}

