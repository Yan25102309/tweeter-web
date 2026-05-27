# Usa una imagen base con Flutter instalado
FROM cirrusci/flutter:stable AS build

# Copia los archivos del proyecto al contenedor
COPY . /app
WORKDIR /app

# Construye la aplicación
RUN flutter build web --release

# Usa una imagen ligera de Nginx para servir los archivos
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
