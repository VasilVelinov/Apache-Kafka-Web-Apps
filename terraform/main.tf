terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_network" "private_network" {
  name = "appnet"
}

resource "docker_image" "zookeeper" {
  name = "bitnami/zookeeper"
}

resource "docker_image" "kafka" {
  name = "bitnami/kafka"
}

resource "docker_container" "zookeeper" {
  name = "zookeeper"
  image = docker_image.zookeeper.image_id
  env = ["ALLOW_ANONYMOUS_LOGIN=yes"]
  ports {
    internal = 2181
    external = 2181
  }
  networks_advanced {
    name = "appnet"
  }
}

resource "docker_container" "kafka" {
  name = "kafka"
  image = docker_image.kafka.image_id
  env = ["KAFKA_BROKER_ID=1",
         "KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181",
         "ALLOW_PLAINTEXT_LISTENER=yes"]
  ports {
    internal = 9092
    external = 9092
  }
  networks_advanced {
    name = "appnet"
  }
  depends_on = [
    docker_container.zookeeper,
    ]
}

resource "time_sleep" "wait_for_kafka_to_start" {   
    create_duration = "30s"
    depends_on = [ docker_container.kafka ]
  
}