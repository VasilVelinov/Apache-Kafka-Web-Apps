resource "docker_image" "kafka-disc" {
  name = "shekeriev/kafka-discoverer"
}

resource "docker_image" "kafka-obs" {
  name = "shekeriev/kafka-observer"
}

resource "docker_container" "kafka-discoverer" {
  name = "kafka-discoverer"
  image = docker_image.kafka-disc.image_id
  env = ["BROKER=kafka:9092", "TOPIC=animal-facts", "METRICPORT=5000"]
  ports {
    internal = 5000
    external = 5000
  }
  networks_advanced {
    name = "appnet"
  }
  depends_on = [
    time_sleep.wait_for_kafka_to_start,
    ]
}

resource "docker_container" "kafka-observer" {
  name = "kafka-observer"
  image = docker_image.kafka-obs.image_id
  env = ["BROKER=kafka:9092", "TOPIC=animal-facts", "APPPORT=80"]
  ports {
    internal = 80
    external = 80
  }
  networks_advanced {
    name = "appnet"
  }
  depends_on = [
    docker_container.kafka-discoverer,
    ]
}

