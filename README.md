# ESPHome Configuration Repository

Personal ESPHome device configurations for home automation and IoT projects.

## Device Organization
- **device--bed.yaml** - HX711 weight sensor for bed occupancy detection
- **device--co2-*.yaml** - SCD30/SCD40 CO2 sensors for air quality monitoring
  - device--co2-bedrooms.yaml
  - device--co2-main.yaml
  - device--co2-office.yaml
- **device--fireplace.yaml** - Smart fireplace control
- **device--garage.yaml** - Garage door controller
- **device--outdoor-patio-outlets.yaml** - Outdoor outlet control with energy monitoring
- **device--outdoor-patio-shades.yaml** - Motorized shade control
- **device--bt-proxy-*.yaml** - Bluetooth proxy devices for Home Assistant
  - device--bt-proxy-bedrooms-poe.yaml
  - device--bt-proxy-office-poe.yaml
- **device--cat-wheel-trainer.yaml** - Interactive cat exercise wheel with sensors and treat rewards
- **device--cat-laser.yaml** - Automated laser toy controller
- **device--treat-dispenser.yaml** - Automated pet treat dispenser

## Package System

The `packages/` directory contains reusable configuration components:

- **global.yaml** - Common sensors, buttons, and base configuration
- **wifi.yaml** - WiFi and network settings
- **esp32-*.yaml** - Hardware-specific configurations
- **esp8266-*.yaml** - ESP8266 device configurations

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