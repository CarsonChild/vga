## Simple FPGA VGA Implementation
This is a simple VGA module I wrote in SystemVerilog to control a VGA PMOD for the Arty A7 board. The design should work on other boards, but the clock_divider parameters will have to be adjusted if your board clock is not 100MHz and the constraints file will of course have to be updated.

Thanks to Will at [Project F](https://projectf.io/) for his great tutorials that helped me get started on this project.
