# 阶段一
FROM node:20.5.1-buster as builder
WORKDIR /build

COPY . .
RUN yarn install && yarn build

# 阶段二
FROM node:20.5.1-buster-slim
WORKDIR /app

COPY --from=builder /build/assets ./assets
COPY --from=builder /build/.output ./.output
ENTRYPOINT ["node", "/app/.output/server/index.mjs"]
