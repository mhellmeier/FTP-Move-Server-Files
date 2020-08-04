FTP Move Server Files
=====================
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

A simple bash script to move files over FTP / SSH from a source to a (different) destination server.

## Table of Contents

- [About the Project](#about-the-project)
- [Getting Started](#getting-started)
    - [Pre-Requirements](#pre-requirements)
    - [Installation](#installation)
    - [Important Information](#important-information)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)



## About The Project

**Current version**: 0.0.1 (Alpha Phase)

There are many cases where people want to transfer files and folders from a source server `A` to a destination server `B` (for example websites or backups). In most of the cases, the only possible solution to migrate a website to a new host is to download all files manually with a FTP client (like FileZilla) on your local computer and upload it to the new server afterwards. Direct transfers over FXP aren't possible in most of the cases due to restrictions in many (shared) webhosting packages. This small bash script will do the job for you!

If there is access to a VPS or Root Server `C`, I suggest executing the script on that machine to use the benefits of the data centre and to protect your own hardware and internet bandwidth.


## Getting Started

### Pre-Requirements

To use the script, these are the only things you need:
- Linux machine (or Mac or Winodws 10 with Linux Subsystem installed)
- `ftp` installed (`sudo apt install ftp`)
- `lftp` installed (`sudo apt install lftp`)

### Installation

1. Clone the repository and go into it
```sh
git clone https://github.com/mhellmeier/FTP-Move-Server-Files.git
cd FTP-Move-Server-Files
```
2. Install requirements and set permissions if not already done or simple use the small install script
```sh
chmod +x install.sh
sh install.sh
```
3. Start the transfer script and follow the instructions shown in your terminal
```sh
./moveServerFiles.sh
```
4. Enjoy!

### Important Information

- The script asks for passwords to connect to the source and destination hosts. Keep in mind that these will be used in the commands (plaintext!) to connect and download / upload content. It can be a security concern if the commands will be stored in the log history
- To get rid of some certificate verifiaction errors, the scripts doesn't make certificate checks
- Remember to open FTP / SSH relevant ports in your firewall
- Use it at your own risk!


## Roadmap

Alle planned features, bugs and discussions can be found in the [open issues](https://github.com/mhellmeier/FTP-Move-Server-Files/issues).


## Contributing

Feel free to fork the project, work in your personal branch and create a pull request your simple interact in the [issue section](https://github.com/mhellmeier/FTP-Move-Server-Files/issues).

**This is an open source project! Every contribution is greatly appreciated!**


## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Malte Hellmeier - [![LinkedIn][linkedin-shield]][linkedin-url]

Project Link: [https://github.com/mhellmeier/FTP-Move-Server-Files](https://github.com/mhellmeier/FTP-Move-Server-Files)


[issues-shield]: https://img.shields.io/github/issues/mhellmeier/FTP-Move-Server-Files.svg?style=flat-square
[issues-url]: https://github.com/mhellmeier/FTP-Move-Server-Files/issues
[license-shield]: https://img.shields.io/github/license/mhellmeier/FTP-Move-Server-Files.svg?style=flat-square
[license-url]: https://github.com/mhellmeier/FTP-Move-Server-Files/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=flat-square&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/malte-hellmeier-91a64a17b/