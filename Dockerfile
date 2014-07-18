# My first attempt at a DockerFile
FROM ubuntu:latest
MAINTAINER DFHack_Dockerfile@JasonGreen.Name

# Install Dwarf Fortress dependencies
# 64 bit linux, but DF requires 32 bit libraries
RUN dpkg --add-architecture i386 && apt-get update -y && apt-get install -y \
    libsdl-image1.2:i386 \
    libsdl-ttf2.0-0:i386 \
    libgtk2.0-0:i386 \
    libglu1-mesa:i386

# Setup en_US.UTF-8 locale (so we can see _all_ DF's ASCII)
ENV LANG en_US.UTF-8
RUN apt-get -y install locales && locale-gen en_US.UTF-8

# Install wget (to download DF and DFHack)
RUN apt-get install -y wget && mkdir /opt/df

# Download & Unpack Dwarf Fortress
RUN wget --no-check-certificate -qO- http://www.bay12games.com/dwarves/df_34_11_linux.tar.bz2 | tar -xj -C /opt/df

# Download & Unpack DFHack
RUN wget --no-check-certificate -qO- https://github.com/downloads/DFHack/dfhack/dfhack-0.34.11-r2-Linux.tar.gz | tar -xz -C /opt/df/df_linux

# Include a VPS-friendly DF init file (disable sounds/graphics/mouse/windowing/etc)
ADD init.txt /opt/df/df_linux/data/init/init.txt

# Include a (default) DFHack init file
ADD dfhack.init /opt/df/df_linux/dfhack.init

# Include a rotato world
ADD rotato_region /opt/df/df_linux/data/save/region1

# Run DFHack (which also starts Dwarf Fortress)
CMD /opt/df/df_linux/dfhack
