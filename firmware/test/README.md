# CortiPod Firmware — Test Instructions

This directory is reserved for PlatformIO unit tests using the
[Unity](https://github.com/ThrowTheSwitch/Unity) test framework.

## Running Tests

```bash
# Run all tests on the native host (no hardware required for unit tests)
pio test -e native

# Run tests on the target device over serial
pio test -e dev
```

## Test Structure (planned)

| File | What it tests |
|---|---|
| `test_sensors.cpp` | GSR voltage-divider math, SHT40 CRC-8 implementation |
| `test_potentiostat.cpp` | SPI frame encoding (register read/write byte sequences) |
| `test_measurement_cycle.cpp` | Offline ring-buffer wrap-around, flush logic |
| `test_power_mgmt.cpp` | Battery percentage interpolation, low-battery threshold |
| `test_ble_service.cpp` | ChronoPacket chunking, temperature encoding (float→int16) |

## Hardware-in-the-Loop Tests

For integration tests that require the physical board:

1. Flash a debug build: `pio run -e dev -t upload`
2. Open the serial monitor: `pio device monitor`
3. Send BLE command `0x01` (CMD_TRIGGER_MEASUREMENT) from the iPhone app
   and verify a complete cycle log appears on serial.

## Notes

- All hardware-dependent code paths are guarded by `CORTIPOD_DEBUG` and
  stub implementations, so unit tests can run without a connected nRF52832.
- Add a `[env:native]` section to `platformio.ini` when ready to enable
  host-based unit testing.
