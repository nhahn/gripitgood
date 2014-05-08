Grip It Good
=================

This repository holds the code for the 2014 BME Design Project, Grip it Good. As an intro into the project:

> We are creating a set of devices that will allow occupational therapists to assess the grip force of patients with a weakened grip. This can include older individuals, stroke patients, and arthritis patients. Unlike traditional techniques, these objects are meant to simulate the look and feel of an object you would interact with on a daily basis, such as a soda can. The devices utilize resistive force sensors to determine the force being applied to the object by the patient, and transmit it wirelessly to a therapist while they are performing rehabilitation tests. 

To accomplish this, we have two primary sets of code: MATLAB code that parses the data from the arduino and displays it visually and the arduino code, that reads the values from the sensor and sends them serially over Bluetooth. This code is divided up into a few subfolders for organizational purposes.

###Arduino Bluetooth Control
This folder holds a simple program for changing the settings on the Arduino Bluetooth controller. We use a RN42-XV module from [Sparkfun](https://www.sparkfun.com/products/11601). This module defines a set of properties that you can set using the serial connection to the Arduino in [this document](http://ww1.microchip.com/downloads/en/DeviceDoc/bluetooth_cr_UG-v1.0r.pdf).

###Arduino Force Sensor
This is the main Arduino sketch used to collect the data from the force sensor and transmit it over Bluetooth. This software is what is currently loaded on the Arduino device.

###Arduino Serial Controller
A program used early on to connect the Arduino to MATLAB quickly and easily. It allows for individual pin control and reads using the arduino serial connection

###MATLAB Control
This is the force sensor parsing code we use in MATLAB as well as the gui display. Run the gui.m file in this directory to connect to the force sensor can.

###MATLAB Test Code
Some early code from testing the arduino connection to MATLAB. This is provided as a reference to help individuals understand the process we used to create the final version(s) of the code featured in the MATLAB Control folder.
