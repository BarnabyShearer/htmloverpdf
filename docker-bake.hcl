target "docker-metadata-action" {
  context = "./"
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}

group "default" {
  targets = ["python", "alpine", "debian", "python-alpine", "python-slim"]
}

target "python" {
  inherits = ["docker-metadata-action"]
  target = "python"
}

target "alpine" {
  inherits = ["docker-metadata-action"]
  target = "alpine"
}

target "debian" {
  inherits = ["docker-metadata-action"]
  target = "debian"
}

target "python-alpine" {
  inherits = ["docker-metadata-action"]
  target = "python-alpine"
}

target "python-slim" {
  inherits = ["docker-metadata-action"]
  target = "python-slim"
}

