# ESPHome Configuration Repository

Personal ESPHome device configurations for home automation and IoT projects.

## Device Organization
- **the_brewery--co2-office.yaml** - SenseAir CO2 sensor for air quality monitoring
- **the_brewery--fireplace.yaml** - Smart fireplace control
- **the_brewery--garage.yaml** - Garage door controller
- **the_brewery--outdoor-patio-outlets.yaml** - Outdoor outlet control with energy monitoring
- **the_brewery--outdoor-patio-shades.yaml** - Motorized shade control
- **the_brewery--bt-proxy-*.yaml** - Bluetooth proxy devices for Home Assistant
  - the_brewery--bt-proxy-bedrooms-poe.yaml
  - the_brewery--bt-proxy-office-poe.yaml
- **the_brewery--cat-laser.yaml** - Automated laser toy controller
- **the_brewery--cat-litter-box.yaml** - Cat litter box automation
- **the_brewery--cat-wheel-trainer.yaml** - Interactive cat exercise wheel with sensors and treat rewards (backed by the `packages/cat-wheel/` subsystem: globals/sensors/metrics/status/controls/logic)
- **the_brewery--air-quality-main.yaml** - Sensirion SEN66 air quality node (PM/CO2/RH-T/VOC/NOx)
- **the_brewery--rf-proxy.yaml** - RF proxy device
- **the_coastal_brewhouse--*.yaml** - Devices at the coastal brewhouse property (separate WiFi)
  - the_coastal_brewhouse--airconditioner.yaml - Midea AC control over UART
  - the_coastal_brewhouse--waterheater.yaml - GE GEA heat-pump water heater (external `gea` component)
  - the_coastal_brewhouse--bt-proxy.yaml - Bluetooth proxy (PoE)
  - the_coastal_brewhouse--rf-proxy.yaml - RF proxy device
  - the_coastal_brewhouse--washerdryer.yaml - Washer/dryer monitoring
  - the_coastal_brewhouse--air-quality-main.yaml - Sensirion SEN66 air quality node
- **the_ranch--*.yaml** - Devices at the ranch property (separate WiFi)
  - the_ranch--bt-proxy.yaml - Bluetooth proxy (PoE)

## Package System

The `packages/` directory contains reusable configuration components:

- **global.yaml** - Common sensors, buttons, and base configuration
- **wifi.yaml** / **coast-wifi.yaml** - WiFi settings (per-property credentials)
- **ethernet.yaml** - W5500 PoE/Ethernet networking
- **esp32-*.yaml** / **esp8266-*.yaml** - Per-board hardware configs
  (`esp32-d1_mini32`, `esp32-s3-devkitc`, `esp32-xiao-s3`, `esp32-c3-devkitc`, `esp32-wrover`,
  `esp8266-d1_mini`, `esp8266-esp12e`)
- **bt-proxy.yaml**, **co2.yaml**, **sen66.yaml** - Reusable feature blocks
  (`sen66.yaml` accepts `sen66_sda`/`sen66_scl` pins and
  `sen66_temperature_offset`/`sen66_humidity_offset` overrides)

## Getting Started

1. Update device-specific settings in each YAML file
2. Use ESPHome dashboard or CLI to compile and upload

## Common Patterns

### Device Structure
```yaml
packages:
  global: !include packages/global.yaml
  wifi: !include packages/wifi.yaml
  esp32: !include packages/esp32-d1_mini32.yaml

substitutions:
  slug: device-name
  name: Friendly Device Name
```