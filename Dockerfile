# Creating an alias for the first stage
FROM golang:1.22.5 as base

# Setting the working directory inside the container
WORKDIR /app

# Copying go.mod file to the working directory to install dependencies
COPY go.mod .

# Downloading Go module dependencies
RUN go mod download

# Copying the entire project to the working directory
COPY . .

# Building the Go application
RUN go build -o main .

# Finale stage - distroless image
FROM gcr.io/distroless/base

COPY --from=base /app/main .

# Copy the static content
COPY --from=base /app/static ./static

# Exposing port 8080 for the application
EXPOSE 8080

# Command to run the application
CMD ["./main"]