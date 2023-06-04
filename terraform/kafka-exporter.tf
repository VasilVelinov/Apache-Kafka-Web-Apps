resource "docker_image" "kafka-exporter" {
  name = "danielqsj/kafka-exporter"
}

resource "docker_container" "exporter" {
  name = "exporter"
  image = docker_image.kafka-exporter.image_id
  env = ["kafka.server=kafka:9092"]
  ports {
    internal = 9308
    external = 9308
  }
  networks_advanced {
    name = "appnet"
  }
  depends_on = [
    docker_container.kafka-observer,
    ]
}