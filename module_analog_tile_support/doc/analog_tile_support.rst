xCORE-USB Support Library
=========================

This module provides support functions for xCORE-Analog devices.

The library supports use of:
  * Analog to digital converter
  * Watchdog timer
  * Real time clock
  * Sleep controller including deep sleep memory

ADC API
-------

.. doxygenenum:: adc_bits_per_sample_t

.. doxygenfunction:: adc_enable
.. doxygenfunction:: adc_disable_all
.. doxygenfunction:: adc_trigger
.. doxygenfunction:: adc_trigger_packet
.. doxygenfunction:: adc_read
.. doxygenfunction:: adc_read_packet

