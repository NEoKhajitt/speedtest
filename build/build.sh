#!/bin/bash

DOCKER_IMAGE_TAG="latest"

usage() {
  echo "Usage: $0 [-t tag]"
  echo "  -t tag     Set the Docker image tag (default: latest)"
  echo "  -h         Show this help message"
}

while getopts "t:h" opt; do
  case $opt in
    t)
      DOCKER_IMAGE_TAG="$OPTARG"
      ;;
    h)
      usage
      exit 0
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

# Build the Docker image

docker build -t neokhajitt/speedtest:"$DOCKER_IMAGE_TAG" .

if command -v trivy >/dev/null 2>&1; then
    echo "Trivy is installed. Running image scan..."
    trivy image -f sarif -o trivy-report.sarif neokhajitt/speedtest:"$DOCKER_IMAGE_TAG"
else
    echo "Trivy is not installed. Skipping image scan."
fi
