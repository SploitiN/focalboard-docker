# ========================
# BUILD STAGE
# ========================
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy source code
COPY . .

# Build the backend
WORKDIR /app/server
RUN go build -o focalboard

# ========================
# RUN STAGE
# ========================
FROM alpine:latest

# Install needed tools (optional if you want shell or other utils)
RUN apk add --no-cache ca-certificates bash

WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/server/focalboard .

# Expose port (adjust if needed)
EXPOSE 8000

# Run the binary
CMD ["./focalboard"]
