# Используем официальный образ Node.js
FROM node:18-slim

# Устанавливаем curl и обновляем npm
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g npm@9.8.1

# Создаем директорию приложения
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install --omit=dev --no-audit

# Копируем исходный код
COPY . .

# Проверяем наличие необходимых директорий
RUN mkdir -p public/sounds public/assets

# Открываем порт
EXPOSE 3000

# Добавляем healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Запускаем приложение
CMD ["node", "server.js"] 