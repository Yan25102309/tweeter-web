# Usamos la imagen oficial de CirrusCI que contiene la versión estable más reciente
FROM cirrusci/flutter:stable AS build

# Copiamos los archivos de tu proyecto al contenedor
COPY . /app
WORKDIR /app

# Configuramos git para que confíe en el repositorio de flutter (evita errores de permisos)
RUN git config --global --add safe.directory /sdks/flutter

# Instalamos las dependencias
RUN flutter pub get

# Compilamos la aplicación web
RUN flutter build web --release

# Etapa final: Servidor Nginx para servir los archivos
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
