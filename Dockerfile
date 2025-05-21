# Build stage
FROM golang:latest

# Install build dependencies
RUN apt-get update && apt-get install -y make git ca-certificates tzdata

# Copy source code
COPY . .

# Build the application
RUN make && chmod +x oatproxy

# Expose the default port
EXPOSE 8080