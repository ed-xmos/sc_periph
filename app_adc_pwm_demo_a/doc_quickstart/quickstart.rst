xCORE-Analog ADC and PWM Demo Quick Start Guide
===============================================

.. _app_adc_pwm_demo_a_quick_start:

_app_adc_pwm_demo_a Quick Start Guide
-------------------------------------

This application demonstrates how to use the ADC on xCORE-Analog (A-Series)
devices. The demo is designed to run out of the box on the ``XK-SK-A16`` slice kit.

The application reads the voltage from the joystick input using the ADC. It then sends the read voltage value to a PWM generator, which is then filtered by external passive components. This effective provides an ADC->DAC path with the output voltage tracking the input voltage. The application reads the output voltage from the filtered PWM using a second ADC input.  The two values are then printed to the screen whenever the second ADC input changes, allowing the user to compare values.

Hardware Setup
++++++++++++++

To setup the hardware (:ref:`adc_a_example_hardware_setup`):

    #. Connect the XA-SK-MIXED-SIGNAL slice to the XP-SKC-A16 board on the slice connector marked ``A``
    #. Connect the XTAG-2 USB debug adaptor to the XP-SKC-A16 board to the box header connector marked ``XSYS``
    #. Connect the XTAG-2 to host PC (via a USB extension cable if desired)
    #. For power, connect the 12V supply to the barrel connector
    #. Switch the ``XLINK`` switch by the XSYS connector to ON
    #. Connect a flying lead between P1 pin 1 and J2 pin 1 on the XA-SK-MIXED-SIGNAL slice card

.. _adc_a_example_hardware_setup:

.. figure:: images/hw_setup.*
   :width: 120mm
   :align: center

   Hardware Setup for A-Series ADC PWM loopback example

Import and Build the Application
++++++++++++++++++++++++++++++++

   #. Open xTIMEcomposer and open the edit perspective (Window->Open Perspective->XMOS Edit).
   #. Locate the ``xCORE-Analog loopback ADC Example`` item in the xSOFTip pane on the bottom left
      of the window and drag it into the Project Explorer in the xTIMEcomposer.
      This will also cause the modules on which this application depends (in this case,
      module_xassert, module_logging, module_pwm_tutorial_support, module_analog_tile_support) to be imported as well. 
   #. Click on the ``app_adc_pwm_demo_a`` item in the Project Explorer then click on the
      build icon (hammer) in xTIMEcomposer. Check the Console window to verify that the
      application has built successfully.


Note that the Developer Column in the xTIMEcomposer on the right hand side of your screen
provides information on the xSOFTip components you are using. Select the ``module_analog_tile_support``
component in the Project Explorer, and you will see its description together with API
documentation. Having done this, click the `back` icon until you return to this
quick start guide within the Developer Column.

For help in using xTIMEcomposer, try the xTIMEcomposer tutorial (See Help->Tutorials in xTIMEcomposer).

Run the Application
+++++++++++++++++++

Now that the application has been compiled, the next step is to run it on the
board using the tools to load the application over JTAG (via the XTAG-2 Adaptor card)
into the xCORE multicore microcontroller.

   #. Create a run configuration. Click on the ``Run`` pull-down menu item and select `Run Configurations``. The Run Configurations dialogue will appear. In the left hand pane, select the ``xCORE Application`` item and click the ``New`` icon above it, or right click and select New. If the application built successfully and the hardware is connected as described, the binary and debug adapter will be selected automatically.
   #. Enable XScope real-time debug printing. Select ``Run XScope output server`` near the bottom of the window. This will enable collection of fast debug print from the application, with minimal intrusiveness.
   #. Click on the ``Run`` button at the bottom of the screen to launch.
   #. The application will start running and initially print a message declaring ``Analog loopback demo started.``. It will then print the value of two ADC channels which which are connected to the joystick y axis and the filtered PWM output. Note it will only print when the value of the measured PWM DAC voltage changes.
   #. Move the joystick to see the sampled voltage value change, causing the PWM DAC to follow suite.

*Note:* if the run dialog does not provide the options expected, go back and ensure that the application build successfully and that the debug adapter is connected to the host and the XLINK switch is set to ``ON``.

*Note:* every time there is output to the Console window from the application the Console
window is brought to the foreground. To stop the Console window coming to the foreground
simply stop the application using the ``Stop`` button in the Console window (red square).

Next Steps
++++++++++

Look at the source and change the application to track the ambient light intensity rather than the joystick value.

   #. In the ``Project Explorer`` double click on the ``app_adc_pwm_demo_a/src/main.xc``
      to open the main source file.
   #. Change the ``adc_config.input_enable[2] = 1;`` from ``[2]`` to ``[0]``.
   #. Save ``main.xc`` and click on the ``Run`` icon. This will cause the application
      to be re-compiled and start running. Notice the printed ADC values as you shade or shine light on the XA-SK-MIXED-SIGNAL with the LDR on it.


