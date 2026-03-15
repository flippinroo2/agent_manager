.PHONY: all install install-deps install-concurrently build dev web db-studio db-generate docker-up docker-down docker-build clean help

# Default: install everything and start all services
all: install dev

# ──────────────────────────────────────────────
# Installation
# ──────────────────────────────────────────────

install: install-deps install-concurrently build
	@echo "✅ All dependencies installed and project built"

install-deps:
	@echo "📦 Installing npm dependencies..."
	@npm install

install-concurrently:
	@if ! npx --no concurrently --version > /dev/null 2>&1; then \
		echo "📦 Installing concurrently..."; \
		npm install --save-dev concurrently; \
	else \
		echo "✅ concurrently already installed"; \
	fi

# ──────────────────────────────────────────────
# Build
# ──────────────────────────────────────────────

build:
	@echo "🔨 Building JSX components..."
	@npm run build

db-generate:
	@echo "🗄️  Generating database migrations..."
	@npm run db:generate

# ──────────────────────────────────────────────
# Development — run everything concurrently
# ──────────────────────────────────────────────

dev: install
	@echo "🚀 Starting all services with concurrently..."
	@npx concurrently \
		--names "next,db-studio" \
		--prefix-colors "blue,magenta" \
		--kill-others-on-fail \
		"cd web && npx next dev --port 3000" \
		"npm run db:studio"

# Individual services (for running standalone)
web:
	@echo "🌐 Starting Next.js dev server..."
	@cd web && npx next dev --port 3000

db-studio:
	@echo "🗄️  Starting Drizzle Studio..."
	@npm run db:studio

# ──────────────────────────────────────────────
# Docker (production)
# ──────────────────────────────────────────────

docker-up:
	@echo "🐳 Starting Docker services..."
	@docker compose up -d

docker-down:
	@echo "🐳 Stopping Docker services..."
	@docker compose down

docker-build:
	@echo "🐳 Building Docker images..."
	@npm run docker:build

# ──────────────────────────────────────────────
# Utilities
# ──────────────────────────────────────────────

clean:
	@echo "🧹 Cleaning build artifacts..."
	@rm -rf web/.next
	@rm -rf node_modules/.cache
	@echo "✅ Clean complete"

help:
	@echo ""
	@echo "  thepopebot — Makefile Commands"
	@echo "  ══════════════════════════════════════"
	@echo ""
	@echo "  make              Start everything (install + dev)"
	@echo "  make dev          Install deps & run Next.js + Drizzle Studio"
	@echo "  make install      Install all dependencies and build"
	@echo "  make build        Build JSX components with esbuild"
	@echo "  make web          Start Next.js dev server only (port 3000)"
	@echo "  make db-studio    Start Drizzle Studio only"
	@echo "  make db-generate  Generate Drizzle migrations from schema"
	@echo "  make docker-up    Start production Docker services"
	@echo "  make docker-down  Stop Docker services"
	@echo "  make docker-build Build Docker images"
	@echo "  make clean        Remove build artifacts"
	@echo "  make help         Show this help"
	@echo ""
