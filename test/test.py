# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    dut.ui_in.value = 0x8C
    dut.uio_in.value = 1

    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)

    dut.uio_in.value = 0

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    for i in range(50):
        await RisingEdge(dut.clk)
        if dut.uo_out.value != 0x40:
            break
    
    cocotb.log.info(f"Final 7-Segment Output: {hex(dut.uo_out.value)}")
    assert dut.uo_out.value == 0x66, f"TEST FAILED: Expected 0x66 (4), got {hex(dut.uo_out.value)}"
    
    cocotb.log.info("TEST PASSED! The Stein's Algorithm Chip Works!")
    
    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
