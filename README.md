Dockerize with Multi-Arch Support

 docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t colbysawyer17/opennsa3:v3.1.0  -t colbysawyer17/opennsa3:latest --push  .