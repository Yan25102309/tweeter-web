# Usamos la imagen oficial
FROM cirrusci/flutter:stable AS build

# Copiamos los archivos al contenedor
COPY . /app
WORKDIR /app

# Compilamos directamente sin cambiar el usuario
# La imagen ya viene preparada para compilar como root
RUN flutter pub get
RUN flutter build web --release

# Etapa de servidor (Nginx)
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
