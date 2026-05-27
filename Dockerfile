# Usamos la imagen oficial
FROM cirrusci/flutter:stable AS build

# Copiamos los archivos
COPY . /app
WORKDIR /app

# Ajustamos permisos y compilamos directamente
RUN chown -R flutter:flutter /app
USER flutter

# Esto instalará las dependencias necesarias y compilará
RUN flutter pub get
RUN flutter build web --release

# Etapa de servidor (Nginx)
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
