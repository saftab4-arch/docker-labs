# Builder Stage
FROM node:24 AS builder

WORKDIR /app

COPY index.html .

# Runner Stage
FROM nginx:alpine

COPY --from=builder /app/index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
