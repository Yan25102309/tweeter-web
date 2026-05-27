# Usamos una base de Ubuntu moderna
FROM ubuntu:22.04

# Instalamos dependencias necesarias
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Descargamos e instalamos una versión específica de Flutter (3.19.0 o superior)
RUN curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.0-stable.tar.xz \
    && tar xf flutter.tar.xz -C /opt \
    && rm flutter.tar.xz

# Añadimos Flutter al PATH
ENV PATH="/opt/flutter/bin:${PATH}"

# Pre-descargamos el SDK web
RUN flutter doctor

# Copiamos el proyecto
COPY . /app
WORKDIR /app

# Construimos
RUN flutter pub get
RUN flutter build web --release

# Servimos con Nginx
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
