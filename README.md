> This repository is archived. If you would like to continue using the image, build it rather than pulling from Dockerhub.

---

# Docker - Dotnet and NVM

[![Publish](https://github.com/cathalnoonan/docker-dotnet-nvm/actions/workflows/publish.yml/badge.svg)](https://github.com/cathalnoonan/docker-dotnet-nvm/actions/workflows/publish.yml)

Development image containing dotnet-sdk-6.0 and nvm.

- Source: https://github.com/cathalnoonan/docker-dotnet-nvm
- Dockerhub: https://hub.docker.com/r/cathalnoonandev/dotnet-nvm

## Running the image
```bash
docker pull cathalnoonandev/dotnet-nvm:latest
docker run --rm -it cathalnoonandev/dotnet-nvm:latest
```

To mount folders into the container, refer to docker's docs here: https://docs.docker.com/storage/bind-mounts/

## Docker included in the image
To use docker within the container, you must mount `/var/run/docker.sock` to the container.

```bash
docker pull cathalnoonandev/dotnet-nvm:latest
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock cathalnoonandev/dotnet-nvm:latest
```

**Note**: This will use the docker socket from the host machine. This is not docker-in-docker.
