# Usa la etiqueta 'latest' para asegurar que tenemos una versión moderna de Flutter
FROM ghcr.io/cirrusci/flutter:latest AS build

COPY . /app
WORKDIR /app

# Esto asegura que los permisos sean correctos
RUN chown -R flutter:flutter /app

USER flutter

# Construye la aplicación
RUN flutter build web --release

# Etapa de servidor (Nginx)
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
