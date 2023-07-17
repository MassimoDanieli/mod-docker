# MOD Software 2023 Version

This code is a fork of the excellent work done by Alexis Boni in his [mod-docker](https://github.com/ajboni/mod-docker) implementation. His code utilized an older version of the mod-ui interface. I've updated it to incorporate the latest MOD software, sourced from the [MOD GitHub](https://github.com/moddevices).

My motivation for these changes stemmed from the release of Mike Oliphant's [Neural Amp Modeler LV2 plugin](https://github.com/mikeoliphant/neural-amp-modeler-lv2). I wanted a robust and feature-rich LV2 host for Linux. While MOD Devices does offer a mod-live-usb ISO for booting an x86 PC with their software, it's not the most user-friendly and booting from USB isn't ideal.

I've also incorporated all the current MOD Plugins available in the [mod-plugin-builder repo](https://github.com/moddevices/mod-plugin-builder). As a result, you not only get the free LV2 plugins included in Alexis's version of mod-docker, but the host will also offer nearly 1000 LV2 plugins.

As a bonus, I've integrated the [browsepy File manager](https://github.com/moddevices/browsepy), enabling you to upload files directly from the MOD UI web interface. 

This repository provides all the code needed to build the Docker containers yourself. However, given the time this process can take, I've also made a prebuilt Docker image available here: ADD LINK TO THE IMAGE.

# mod-docker

MOD-DOCKER is an open-source [MOD Software](https://www.moddevices.com/) emulator for Linux, built on Docker. It allows you to experiment with hundreds of LV2 audio plugins with ease. The goal of this project is to deliver a Docker container facilitating the usage of mod-host and mod-ui on your Linux machine.

The MOD team has made significant contributions to the Linux audio open-source community. If you enjoy this emulator, I encourage you to support the real thing!

This project draws heavy inspiration from [MODEP](https://github.com/BlokasLabs/modep).

# Requirements

You need Docker and Docker-compose installed and running JACK, and you also need to be part of the audio group.

The run scripts available in this repo create three directories in your $HOME folder. Docker Compose then binds these local directories in the container. This setup is required for the browsepy file manager and to store your files permanently in your home folder.

The directories created are:
- $HOME/mod-user-files
- $HOME/mod-data
- $HOME/mod-pedalboards

# Usage for Building

- Clone the repo: `git clone git@github.com:raidolo/mod-docker.git`
- Give execution permissions: `chmod +x run_build.sh`
- Run the build script: `./run_build.sh`
- Go to `http://localhost:8888` and start playing!

# Usage for Downloading the Prebuilt Docker Image

- Give execution permissions: `chmod +x run_docker.sh`
- Run the Docker script: `./run_docker.sh`
- Go to `http://localhost:8888` and start playing!

# TODO / Gotchas

Currently, the builder uses the kxrepos plugins and the mod-plugin-builder plugins. 

Please note, some plugins don't provide modguis, resulting in a less visually appealing interface. Also, some plugins might not work as expected.

For now, the system consists of one container that contains everything necessary to run the software. I haven't had the opportunity to understand why Alexis Boni's original version couldn't run mod-host in a separate container. If there's a need, I'll investigate this issue.
