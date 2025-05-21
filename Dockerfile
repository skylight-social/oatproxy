# Build stage
FROM golang:latest AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y make git && rm -rf /var/lib/apt/lists/*

# Copy go mod files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN make

# Final stage
FROM alpine:latest

WORKDIR /app

ARG HOST
ARG METADATA

# Install runtime dependencies
RUN apk add --no-cache ca-certificates tzdata

# Copy the binary from builder
COPY --from=builder /app/oatproxy /app/oatproxy

# Expose the default port
EXPOSE 8080

# Run the application
ENTRYPOINT ["/app/oatproxy"]
CMD ["--host=${HOST}", "--client-metadata=${METADATA}"] 