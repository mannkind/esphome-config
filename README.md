# esphome-config

ESPHome configs for the devices at three properties: the brewery, the coastal
brewhouse, and the ranch.

Device files are thin — a few packages, a board, two substitutions. The real
content lives in `packages/`.

## Devices

Named `<property>--<device>.yaml`. Each property has its own WiFi package
because each has its own credentials.

### the_brewery

| File                                           | What it is                                                                                                                                           |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| `air-quality-main`                             | Sensirion SEN66 — PM, CO2, RH/T, VOC, NOx                                                                                                            |
| `bt-proxy-bedrooms-poe`, `bt-proxy-office-poe` | Bluetooth proxies, wired                                                                                                                             |
| `cat-laser`                                    | Pan/tilt servos and a laser                                                                                                                          |
| `cat-litter-box`                               | Litter-Robot 4 over UART; external component. Roams: it knows both the brewery and coastal brewhouse WiFi, and lives at the brewery most of the time |
| `cat-wheel-trainer`                            | Exercise wheel w/ treat dispenser; logic in `packages/cat-wheel/`                                                                                    |
| `co2-office`                                   | SenseAir CO2                                                                                                                                         |
| `fireplace`                                    | One relay                                                                                                                                            |
| `garage`                                       | Door controller                                                                                                                                      |
| `outdoor-patio-outlets`                        | Outlets w/ energy monitoring                                                                                                                         |
| `outdoor-patio-shades`                         | Motorized shades                                                                                                                                     |
| `rf-proxy`                                     | CC1101 at 433.92MHz, rtl_433 decode                                                                                                                  |

### the_coastal_brewhouse

| File               | What it is                               |
| ------------------ | ---------------------------------------- |
| `air-quality-main` | SEN66                                    |
| `airconditioner`   | Midea AC over UART                       |
| `bt-proxy`         | Bluetooth proxy, wired                   |
| `rf-proxy`         | CC1101 at 433.92MHz, rtl_433 decode      |
| `washerdryer`      | GE washer/dryer on the GEA bus           |
| `waterheater`      | GE heat-pump water heater on the GEA bus |

### the_ranch

| File       | What it is      |
| ---------- | --------------- |
| `bt-proxy` | Bluetooth proxy |

## packages/

**Base** — `global.yaml` sets name, api, ota, logger, and the diagnostic
entities (uptime, status, restart, safe mode). Every device includes it.

**Network** — `wifi.yaml`, `coast-wifi.yaml`, `ranch-wifi.yaml`, one per
property, credentials from `secrets.yaml`. `brewery-coast-wifi.yaml` carries
both of the first two as a `networks:` list, for a device that moves between
those properties. `ethernet.yaml` is the W5500 for the PoE nodes.

**Boards** — `esp32-d1_mini32`, `esp32-s3-devkitc`, `esp32-xiao-s3`,
`esp32-c3-devkitc`, `esp32-wrover`, `esp8266-d1_mini`, `esp8266-esp12e`. The
litter box skips these and sets its own `esp32:` block; it needs esp-idf w/
`sram1_as_iram`.

**Features**

- `bt-proxy.yaml`, `co2.yaml`, `rf-proxy.yaml`
- `sen66.yaml` — pins via `sen66_sda`/`sen66_scl`, plus
  `sen66_temperature_offset` and `sen66_humidity_trim`
- `cat-wheel/` — globals, sensors, metrics, status, controls, logic, diagnostics
- `litter-robot-4/` — vendored from esphome-litter-robot `LR4/2026.9.1`:
  `base`, `sleep-schedule` (which pulls in `sleep-override`), `wifi`, `hopper`,
  `smart-detection`, `cat-tracking`, `custom-status`. Include `custom-status`
  last; it `!extend`s entities the others define. Each file heads with the local
  changes and why; recheck them on a version bump.

## Secrets

`secrets.yaml` is gitignored. CI writes it from the `SECRET_YAML` repo secret.

## Building

CI builds every device on push and daily at 13:30 UTC, one artifact per device.
New devices need a line in the matrix in `.github/workflows/build.yaml` or they
never get built.

Locally, mise tasks:

```
$(mise run esphome:venv)     # source .venv/bin/activate
mise run esphome:dashboard   # esphome-device-builder
mise run esphome:update      # bump esphome
mise run hooks:install       # install the git hooks (once per clone)
```

## Tests

`tests/unit.sh` compiles firmware for every device. A config that renders is not
proof of much; a config that compiles is, and it catches the things `esphome
config` waves through - a bad pin, a lambda that doesn't build, a component
whose options changed under you.

```
mise run test:unit                        # compile all 19
./tests/unit.sh the_brewery--garage.yaml  # or just the one you're working on
```

It keeps going after a failure and lists every broken device at the end, so one
run tells you the whole story.

The first compile of a device is slow - minutes. After that esphome caches builds
in `.esphome/` and reruns are quick, so the painful run is the one right after a
clone or an esphome upgrade.

## Hooks

`lefthook.yml`, installed by `mise run hooks:install`:

| Hook       | What it does                                      |
| ---------- | ------------------------------------------------- |
| pre-commit | Formats staged YAML with prettier and restages it |
| pre-push   | Compiles every device                             |

`SKIP_TESTS=1 git push` skips the compile and leaves the rest. `LEFTHOOK=0`
skips everything.

## Device structure

```yaml
packages:
  global: !include packages/global.yaml
  wifi: !include packages/wifi.yaml
  esp32: !include packages/esp32-d1_mini32.yaml

substitutions:
  slug: device-name
  name: Friendly Device Name
```
