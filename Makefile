.PHONY: all install install-deps install-concurrently build dev ensure-data ensure-web-links web db-studio db-generate docker-up docker-down docker-build kill clean help

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
	@if ! node -e "require('concurrently')" 2>/dev/null; then \
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

dev: install ensure-data ensure-web-links
	@echo "🚀 Starting all services with concurrently..."
	@npx concurrently \
		--names "next,db-studio" \
		--prefix-colors "blue,magenta" \
		--kill-others-on-fail \
		"cd web && npx next dev --port 3000" \
		"npx drizzle-kit studio"

# Symlink project root files into web/ so Next.js dev server
# (which runs from web/ with cwd=web/) can resolve .env, data/, config/ etc.
ensure-web-links:
	@for item in .env data config skills logs cron triggers node_modules prototype CLAUDE.md; do \
		if [ -e "$$item" ] && [ ! -e "web/$$item" ]; then \
			ln -sf "../$$item" "web/$$item"; \
			echo "  🔗 web/$$item → ../$$item"; \
		fi; \
	done
	@if [ ! -e "node_modules/thepopebot" ]; then \
		ln -sf .. "node_modules/thepopebot"; \
		echo "  🔗 node_modules/thepopebot → .. (self-reference for dev)"; \
	fi

ensure-data:
	@mkdir -p data prototype
	@if [ ! -f .env ]; then \
		echo "⚠️  No .env file found — creating from template..."; \
		cp templates/.env.example .env; \
		AUTH_SECRET=$$(openssl rand -base64 32); \
		sed -i '' "s|^AUTH_SECRET=$$|AUTH_SECRET=$$AUTH_SECRET|" .env; \
		echo "✅ .env created with generated AUTH_SECRET"; \
		echo "   Edit .env to add your API keys (ANTHROPIC_API_KEY, GH_TOKEN, etc.)"; \
	fi

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

kill:
	@echo "🛑 Stopping all thepopebot services..."
	@-pkill -f "next dev --port 3000" 2>/dev/null && echo "  Stopped Next.js dev server" || true
	@-pkill -f "drizzle-kit studio" 2>/dev/null && echo "  Stopped Drizzle Studio" || true
	@-pkill -f "concurrently.*next.*drizzle" 2>/dev/null && echo "  Stopped concurrently" || true
	@echo "✅ All services stopped"

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
	@echo "  make kill         Stop all running thepopebot services"
	@echo "  make clean        Remove build artifacts"
	@echo "  make help         Show this help"
	@echo ""
