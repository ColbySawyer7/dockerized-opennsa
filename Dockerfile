# OpenNSA docker image

FROM debian:stable-slim

MAINTAINER Colby Sawyer <sawyerco21@ecu.edu>


# -- Environment --
ENV GIT_REPO https://gitlab.geant.org/hazlinsky/opennsa3.git
ENV USER opennsa


# --- Base image ---
# Update and install dependencies
# pip to install twistar service-identity pyasn1
# pyasn1 and crypto is needed for ssh backends
RUN apt-get update && apt-get install -y git-core python3 python3-twisted-bin python3-openssl python3-psycopg2 python3-pip python3-cryptography python3-dateutil python3-bcrypt python3-lxml
RUN pip3 install twistar service-identity pyasn1 python-dotenv junos-eznc


# -- User setup --
RUN adduser --disabled-password --gecos 'OpenNSA user' $USER


# -- Install OpenNSA --
USER $USER
WORKDIR /home/$USER

RUN echo git clone $GIT_REPO
RUN git clone $GIT_REPO

# -- Cleanup --
# With --squash this makes the image go from 476 to 164 mb
USER root
RUN apt-get remove -y python3-pip git
RUN apt-get -y clean
RUN apt-get -y autoclean
RUN apt-get -y autoremove


# -- Switch to OpenNSA directory --

USER $USER
WORKDIR /home/$USER/opennsa3/

ENV PYTHONPATH .


# -- Entrypoint --

EXPOSE 9080
EXPOSE 9443

ENTRYPOINT twistd --pidfile= -y /home/opennsa/opennsa3/opennsa-docker3.tac
