### Requirements

  - Docker engine + Docker compose installed on your machine

### Setup

First thing to do is to clone the project inside the `source` folder and make sure it has a valid `.env` file.

Then you can start building your development environment by running this command:

```shell
sh development-start.sh --build
```

**OR**

```shell
docker-compose -f docker-compose.development.yml up -d --build
```

After the build process is finished, you will see at the end an output similar to this:

```
Creating {your-project}_redis   ... done
Creating {your-project}_db        ... done
Creating {your-project}_mailhog   ... done
Creating {your-project}_rediscmdr ... done
Creating {your-project}_php       ... done
Creating {your-project}_pma       ... done
Creating {your-project}_webserver ... done
```

> **Note:** Replace the {your-project} by what is defined in your docker-compose file.

In order to access one of the container, like `{your-project}_php` for example, you simply run this command:

```shell
docker exec -it {your-project}_php bash
```

### PORTS

| Name            |    Port |
|:----------------|--------:|
| Webserver       |  `8080` |
| Redis Commander |  `8081` |
| PhpMyAdmin      |  `8082` |
| Mailhog         |  `8083` |
| MySQL           | `33066` |
