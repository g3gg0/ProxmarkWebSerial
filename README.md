# Proxmark WebSerial Interface

## Overview
This repository provides a web-based interface for interacting with Proxmark3 devices using the latest Iceman firmware, leveraging the Web Serial API available in Chrome-based browsers.
It enables users to connect to their Proxmark3, execute commands such as reading ISO15693 tags, sniffing that traffic, and flashing firmware directly from the browser without the need for additional software.

## Features
- **Device Connection**: Connect to Proxmark3 via the Web Serial API.
- **Read ISO15693 Tags**: Quickly read UID of ISO15693 NFC tags.
- **Sniff ISO15693 Traffic**: Capture NFC traffic for analysis.
- **Flash Firmware**: Update your Proxmark3 with new firmware from a .bin file or directly from a provided URL.

## Prerequisites
- Proxmark3 with Iceman firmware.
- Chrome-based browser with Web Serial API support.

## Usage

### Connecting to Proxmark3
1. Open the Proxmark WebSerial page in a compatible browser.
2. Click on the `Connect` button and select your Proxmark3 device.
3. Do things.

### Reading ISO15693 Tags
- After connecting, use the `ISO15693 Read UID` button to read the UID of nearby tags.

### Sniffing NFC Traffic
- Click on the `ISO15693 Sniff Traffic` button to start capturing NFC traffic.

### Flashing Firmware
To flash the firmware, plug the Proxmark3 with the button pressed. Then two LEDs should be lit and you can connect to it for flashing new firmware.
- To flash firmware from a file: choose a `.bin` file using the file input under `From File`.
- To flash firmware from a URL: click the `Download` button under `From g3gg0.de`.
The firmware must be in .bin format - run arm-elf-objcopy -O fullflash.bin fullflash.elf before.

## Installation
Simply host the provided HTML file on any web server, or open it directly in a browser from your local filesystem.

## Development
- **Kaitai Struct**: For parsing binary data formats.
- **JavaScript**: Primary programming language.

## Contributing
Contributions are welcome! Please submit pull requests or create issues for bugs and feature requests.

## License
MIT

## Acknowledgements
- Thanks to the Proxmark3 community and the developers of the Iceman firmware.
- Utilizes Kaitai Struct and other open-source libraries for various functionalities.

