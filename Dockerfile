# 1. Usamos una base de Ubuntu moderna
FROM ubuntu:22.04

# 2. Instalamos las dependencias necesarias para Flutter y Git
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# 3. Descargamos e instalamos Flutter SDK (Versión 3.19.0)
# Cambia la línea 9 (aprox) por esta:
RUN curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz \
    && tar xf flutter.tar.xz -C /opt \
    && rm flutter.tar.xz

# 4. Configuramos los permisos de Git para evitar el error 'dubious ownership'
RUN git config --global --add safe.directory /opt/flutter

# 5. Añadimos Flutter al PATH del sistema
ENV PATH="/opt/flutter/bin:${PATH}"

# 6. Ejecutamos doctor para preparar el SDK
RUN flutter doctor

# 7. Copiamos tu proyecto al contenedor
COPY . /app
WORKDIR /app

# 8. Descargamos dependencias y compilamos la versión web
RUN flutter pub get
RUN flutter build web --release

# 9. Etapa final: Servidor Nginx para exponer la web
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
