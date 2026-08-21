# Frontend de TiendaGalaxia — nginx sirviendo HTML estático
FROM nginx:1.25-alpine

# Copiar el HTML estático al directorio que sirve nginx.
COPY index.html /usr/share/nginx/html/index.html

# Configuración mínima de nginx: servir el index.html y loguear accesos.
RUN cat > /etc/nginx/conf.d/default.conf <<'EOF'
server {
    listen 80;
    server_name _;

    root   /usr/share/nginx/html;
    index  index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

EXPOSE 80

# healthcheck del contenedor (coherente con las probes de K8s).
HEALTHCHECK --interval=10s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -q --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
