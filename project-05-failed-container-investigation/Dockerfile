# Stage 1 - Builder

FROM node:24 AS builder

WORKDIR /app

COPY index.html .

# Stage 2 - Runtime

FROM nginx:latest

COPY --from=builder /app/index.html /usr/share/nginx/html/index.html

# Fixing command
CMD ["nginx", "-g", "daemon off;"]
