# FPGA-Based Interactive System

[![VHDL](https://img.shields.io/badge/VHDL-Project-blue.svg)](https://en.wikipedia.org/wiki/VHDL)
[![GitHub Issues](https://img.shields.io/github/issues/your-username/your-repo-name.svg)](https://github.com/Revenant01/FPGA_mesh_system.git)

## Overview

This project implements an interactive digital system on an FPGA, integrating keyboard input, VGA display output, and serial UART communication. The design is modular, with each core functionality encapsulated in a dedicated VHDL entity. This repository contains the VHDL source code for these modules and their interconnections. Detailed documentation for each module can be found in the [docs/](docs/) directory.

## Top-Level Module (`top.vhd`)

The `top.vhd` file serves as the entry point and orchestrates the entire system by instantiating and connecting the following key modules:

* **`Keyboard` ([docs/Keyboard.md](docs/Keyboard.md))**: This module handles the interface with a PS/2 keyboard. It receives the clock and data signals from the keyboard, debounces the input, and outputs a 128-bit data vector representing the pressed keys along with a flag indicating new data.

* **`control_unit` ([docs/control_unit.md](docs/control_unit.md))**: This is the central logic module responsible for coordinating the data flow between the other modules. It receives processed keyboard data from the `Keyboard` module and determines how this input should affect the VGA display (managed by the `Display` module) and any data to be transmitted via the UART (handled by the `uart_j` module). The `control_unit` likely contains the core state machine and decision-making logic of the interactive system. It processes the keyboard input to generate the appropriate data for the VGA display and the UART transmitter.

* **`uart_j` ([docs/uart_j.md](docs/uart_j.md))**: This module implements a full-duplex Universal Asynchronous Receiver/Transmitter (UART). It handles both the transmission (`uart_txj`) and reception (`uart_rxj`) of serial data. It also interfaces with a `seven_seg_display` to potentially show the status or received data.

* **`Display` ([docs/Display.md](docs/Display.md))**: This module is responsible for generating the video signals for a VGA monitor. It takes in display data and control signals to output the red, green, and blue color components, as well as the horizontal and vertical synchronization signals (`Hsync`, `Vsync`). Internally, it utilizes other modules like `Clock_Divider`, `Pixel_On_Text`, and `ASCII_to_Alpha` to render text on the screen.

## Module Documentation

For detailed information on each individual module, please refer to the markdown files within the [docs/](docs/) directory. Each file provides a description of the module's functionality, ports, generics (if any), and internal workings.

## Getting Started

*(This section can be expanded with instructions on how to simulate, synthesize, or implement the design for a specific FPGA board if applicable.)*

## Dependencies

* IEEE Standard Logic Library (`IEEE.STD_LOGIC_1164`)
* IEEE Numeric Standard (`IEEE.NUMERIC_STD`)
* *(List any other specific libraries used in the top-level or its direct instantiations)*

## License

This project is licensed under the [MIT License](LICENSE).
