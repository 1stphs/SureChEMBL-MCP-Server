# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install all dependencies, skip prepare script (we'll build manually after copying source)
RUN npm ci --ignore-scripts

# Copy source files
COPY tsconfig.json ./
COPY src ./src

# Build the project manually
RUN npm run build

# Production stage
FROM node:20-alpine AS production

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies only, skip prepare script
RUN npm ci --omit=dev --ignore-scripts

# Copy built files from builder stage
COPY --from=builder /app/build ./build

# Set environment variables
ENV NODE_ENV=production
ENV SSE_PORT=8106
ENV MCP_TRANSPORT=sse

# Expose the SSE port
EXPOSE 8106

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8106/health || exit 1

# Run the server in SSE mode
CMD ["node", "build/index.js", "--sse"]
