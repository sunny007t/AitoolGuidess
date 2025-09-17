# AI Tools Hub - Docker Development Script
# Usage: ./docker-dev.ps1 [command]

param(
    [Parameter(Position=0)]
    [ValidateSet("start", "stop", "restart", "logs", "status", "clean", "build", "shell", "db")]
    [string]$Command = "start"
)

Write-Host "🐳 AI Tools Hub - Docker Management" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

switch ($Command) {
    "start" {
        Write-Host "🚀 Starting all services..." -ForegroundColor Green
        docker-compose up -d
        Write-Host ""
        Write-Host "✅ Services started! Access your app at:" -ForegroundColor Green
        Write-Host "   🌐 Frontend: http://localhost:8000" -ForegroundColor Yellow
        Write-Host "   🔧 API: http://localhost:3001" -ForegroundColor Yellow
        Write-Host "   💾 Adminer: http://localhost:8080 (run with --profile dev)" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "📊 Check status with: ./docker-dev.ps1 status" -ForegroundColor Cyan
    }
    
    "stop" {
        Write-Host "🛑 Stopping all services..." -ForegroundColor Red
        docker-compose down
        Write-Host "✅ All services stopped!" -ForegroundColor Green
    }
    
    "restart" {
        Write-Host "🔄 Restarting all services..." -ForegroundColor Yellow
        docker-compose down
        docker-compose up -d
        Write-Host "✅ Services restarted!" -ForegroundColor Green
    }
    
    "logs" {
        Write-Host "📋 Showing logs (Press Ctrl+C to exit)..." -ForegroundColor Blue
        docker-compose logs -f
    }
    
    "status" {
        Write-Host "📊 Service Status:" -ForegroundColor Blue
        docker-compose ps
        Write-Host ""
        Write-Host "🔍 Container Health:" -ForegroundColor Blue
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    }
    
    "clean" {
        Write-Host "🧹 Cleaning up Docker resources..." -ForegroundColor Yellow
        Write-Host "⚠️  This will remove containers, networks, and unused images" -ForegroundColor Red
        $confirm = Read-Host "Continue? (y/N)"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            docker-compose down -v --remove-orphans
            docker system prune -f
            Write-Host "✅ Cleanup completed!" -ForegroundColor Green
        } else {
            Write-Host "❌ Cleanup cancelled" -ForegroundColor Yellow
        }
    }
    
    "build" {
        Write-Host "🔨 Building services..." -ForegroundColor Blue
        docker-compose build --no-cache
        Write-Host "✅ Build completed!" -ForegroundColor Green
    }
    
    "shell" {
        Write-Host "🐚 Opening backend container shell..." -ForegroundColor Blue
        docker-compose exec backend /bin/sh
    }
    
    "db" {
        Write-Host "🗄️ Starting with database tools..." -ForegroundColor Blue
        docker-compose --profile dev up -d
        Write-Host ""
        Write-Host "✅ Services with database tools started!" -ForegroundColor Green
        Write-Host "   🌐 Frontend: http://localhost:8000" -ForegroundColor Yellow
        Write-Host "   🔧 API: http://localhost:3001" -ForegroundColor Yellow
        Write-Host "   💾 Adminer: http://localhost:8080" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "📋 Adminer Login Info:" -ForegroundColor Cyan
        Write-Host "   Server: db" -ForegroundColor White
        Write-Host "   Username: postgres" -ForegroundColor White
        Write-Host "   Password: ai_tools_password" -ForegroundColor White
        Write-Host "   Database: ai_tools_hub" -ForegroundColor White
    }
    
    default {
        Write-Host "❓ Unknown command: $Command" -ForegroundColor Red
        Write-Host ""
        Write-Host "Available commands:" -ForegroundColor Yellow
        Write-Host "  start    - Start all services" -ForegroundColor White
        Write-Host "  stop     - Stop all services" -ForegroundColor White
        Write-Host "  restart  - Restart all services" -ForegroundColor White
        Write-Host "  logs     - Show service logs" -ForegroundColor White
        Write-Host "  status   - Show service status" -ForegroundColor White
        Write-Host "  clean    - Clean up Docker resources" -ForegroundColor White
        Write-Host "  build    - Rebuild services" -ForegroundColor White
        Write-Host "  shell    - Open backend container shell" -ForegroundColor White
        Write-Host "  db       - Start with database tools" -ForegroundColor White
    }
}