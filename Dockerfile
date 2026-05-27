# Usamos la imagen oficial de CirrusCI desde Docker Hub
FROM cirrusci/flutter:stable AS build

# Aseguramos que flutter esté actualizado a la última versión estable
RUN flutter channel stable && flutter upgrade

COPY . /app
WORKDIR /app

# Ajuste de permisos
RUN chown -R flutter:flutter /app
USER flutter

# Construye la aplicación
RUN flutter pub get && flutter build web --release

# Etapa de servidor (Nginx)
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
