// Copyright (c) 2013, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>
//
#ifndef __adc__h__
#define __adc__h__

#include <platform.h>
#include <xccompat.h>

#define XS1_NUM_ADC 8
#define ADC_CALIBRATION_TRIGGERS 6

#define PORT_ADC_TRIGGER XS1_PORT_1I

/**
 * Return codes from ADC functions
 *  \return ADC_OK                          Function completed successfully.
 *  \return ADC_INVALID_BITS_PER_SAMPLE     The number of bits per sample is unsupported
 *  \return ADC_INVALID_SAMPLES_PER_PACKET  The number of samples per packet is unsupported
 *  \return ADC_NO_ACTIVE_ADC               If trying to enable the ADC without configuring
 *                                          at least one input to be active
 *  \return ADC_WRITE_CONTROL_ERROR         If the write to the control register fails
 */
typedef enum {
    ADC_OK = 0,
    ADC_INVALID_BITS_PER_SAMPLE,
    ADC_INVALID_SAMPLES_PER_PACKET,
    ADC_NO_ACTIVE_ADC,
    ADC_WRITE_CONTROL_ERROR,
} adc_return_t;

typedef enum {
    ADC_8_BPS  = 0,
    ADC_16_BPS = 1,
    ADC_32_BPS = 3,
} adc_bits_per_sample_t;

/**
 * Configuration structure for ADCs:
 * \param input_enable          An array ints to determine which inputs are active.
 *                              Each non-zero input will be enabled.
 * \param bits_per_sample       Select how many bits to sample per ADC.
 * \param samples_per_packet    Number of samples per packet. Must be >0 and <=5.
 * \param calibration_mode      When set the ADCs will sample a 0.8V reference
 *                              rather than the external voltage.
 */
typedef struct {
    int                    input_enable[XS1_NUM_ADC];
    adc_bits_per_sample_t  bits_per_sample;          
    unsigned int           samples_per_packet;       
    int                    calibration_mode;         
} adc_config_t;

#ifndef __XC__
typedef const adc_config_t * const const_adc_config_ref_t;
#else
typedef const adc_config_t & const_adc_config_ref_t;
#endif

/**
 * Configure and enable the requested ADCs. Will also perform the calibration
 * pulses so that the ADCs are ready to provide data.
 *
 * \param c       The chanend to which all ADC samples will be sent.
 * \param config  The configuration to be used.
 *
 * \return ADC_OK on success and one of the return codes in adc_return_t on an error. 
 */
adc_return_t adc_enable(chanend adc_chan, port trigger_port, const_adc_config_ref_t config);

/**
 * Disable all of the ADCs.
 */
void adc_disable_all();

/**
 * Causes the ADC to take one sample. This function is intended to be used with
 * adc_read(). If used with adc_read_packet() then this function must be called
 * enough times to ensure that an entire data packet will be available before
 * the adc_read_packet() is called.
 *
 * \param trigger_port  The port used to trigger ADC samples.
 */
void adc_trigger(port trigger_port);

/**
 * Trigger the ADC enough times to complete a packet.
 *
 * \param config        The ADC ocnfiguration.
 * \param trigger_port  The port used to trigger ADC samples.
 */
void adc_trigger_packet(port trigger_port, const_adc_config_ref_t config);

/**
 * A selectable function to read an ADC sample from the chanend. Any
 * control tokens due to packetization will be discarded silently.
 *
 * Note that the adc_trigger function must have been called
 * before this function will return any data.
 *
 * Note that the configuration must be the same as that used when
 * enabling the ADCs.
 *
 * \param config  The ADC configuration.
 * \param data    The word to place the data in.
 *
 */
#ifdef __XC__
#pragma select handler
#endif
void adc_read(chanend adc_chan, 
              const_adc_config_ref_t config,
              REFERENCE_PARAM(unsigned int, data));

/**
 * A selectable function to read a packet of ADC samples from the chanend.
 *
 * Note that the adc_trigger_packet function must have been called
 * before this function will return any data.
 *
 * Note that the configuration must be the same as that used when
 * enabling the ADCs.
 *
 * \param config  The ADC configuration.
 * \param data    The buffer to place the returned data in. Each
 *                sample will be placed in a separate word. The
 *                buffer must be big enough to store all the data
 *                that will be read (samples_per_packet words).
 *
 */
#ifdef __XC__
#pragma select handler
#endif
void adc_read_packet(chanend adc_chan, 
              const_adc_config_ref_t config,
              unsigned int data[]);

#endif // __adc__h__

