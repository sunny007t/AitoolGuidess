# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

AIToolsHub is a full-stack AI tools discovery platform with a modern 3D frontend and AI-powered backend API. The platform features advanced search capabilities, AI chat assistance, and comprehensive tool discovery with containerized deployment.

## Architecture & Structure

### Full-Stack Architecture
- **Frontend**: Vanilla HTML/CSS/JS with 3D animations and PWA capabilities
- **Backend**: Node.js/Express API with Google Gemini AI integration
- **Database**: PostgreSQL with Redis caching (containerized)
- **AI Features**: Contextual chat, smart search, tool recommendations
- **Deployment**: Docker Compose with nginx, backend API, database, and Redis

### Key Components

#### Frontend (`/`)
- **`index.html`** - Main SPA with semantic structure and 3D hero sections
- **`css/style.css`** - Core 3D styling, animations, and responsive design
- **`css/search-filter.css`** - Advanced search and filter interface styling
- **`js/script.js`** - Main `AIToolsHub` class managing 3D effects, navigation, animations
- **`js/search-filter.js`** - Advanced search/filter system with real-time filtering
- **`js/ai-chat.js`** - AI chat widget with conversation history and context
- **`manifest.json`** - PWA configuration for app installation
- **`sw.js`** - Service Worker for offline functionality and caching

#### Backend (`/backend/`)
- **`server.js`** - Express API with AI integration, caching, and comprehensive endpoints
- **`package.json`** - Node.js dependencies including Gemini AI, security middleware
- **`Dockerfile`** - Container configuration with security optimizations

#### Infrastructure
- **`docker-compose.yml`** - Full-stack orchestration (frontend, API, DB, Redis, admin)
- **Database migrations** - PostgreSQL schema with tool data and user management

### JavaScript Architecture

#### Core Classes
1. **`AIToolsHub`** (script.js) - Main application controller:
   - 3D card animations with mouse tracking
   - Smooth scroll navigation with offset calculation
   - Mobile hamburger menu with animated transitions
   - Intersection Observer scroll animations
   - Form handling and newsletter integration
   - Performance monitoring and optimization

2. **`AIToolsSearchFilter`** (search-filter.js) - Advanced search system:
   - Real-time search across tool names, descriptions, features, tags
   - Multi-criteria filtering (category, price range, rating, tags)
   - Dynamic sorting (rating, price, name, reviews)
   - Responsive results grid with lazy loading
   - URL state management for bookmarkable searches

3. **AI Chat Widget** (ai-chat.js):
   - Floating chat interface with conversation history
   - Context-aware responses using conversation memory
   - Quick question buttons for common queries
   - Local storage for chat persistence
   - Mobile-responsive chat experience

### Backend API Architecture

The Express.js API (`/backend/server.js`) provides comprehensive endpoints:

#### Core Endpoints
- **`GET /api/tools`** - List all tools with filtering (category, search, sort)
- **`GET /api/tools/:id`** - Get specific tool details and insights
- **`GET /api/categories`** - List all categories with tool counts
- **`POST /api/chat`** - AI chat with conversation context and history
- **`POST /api/ai-search`** - Natural language search with AI understanding
- **`POST /api/newsletter`** - Newsletter subscription with validation
- **`GET /api/health`** - Server health check for monitoring

#### AI Integration
- **Google Gemini AI** integration for contextual responses
- **Response caching** for cost optimization and performance
- **Conversation memory** for multi-turn AI interactions
- **Smart search** that understands user intent and tool relationships

## Development Commands

### Quick Start (Frontend Only)
```powershell
# Serve static frontend (existing functionality)
python -m http.server 8000
# OR
npx http-server
# Visit: http://localhost:8000
```

### Full-Stack Development
```powershell
# 1. Setup backend dependencies
cd backend
npm install

# 2. Configure environment (required for AI features)
copy .env.example .env
# Edit .env to add GEMINI_API_KEY (get from https://makersuite.google.com)

# 3. Start backend API server
npm run dev          # Development with nodemon auto-restart
# OR
npm start           # Production mode
# Backend runs on: http://localhost:3001

# 4. In separate terminal, serve frontend
cd ..
python -m http.server 8000
# Frontend with AI features: http://localhost:8000
```

### Docker Development (Recommended)
```powershell
# Full-stack with database and Redis
docker-compose up -d

# Services available:
# - Frontend: http://localhost:8000
# - Backend API: http://localhost:3001
# - Database Admin: http://localhost:8080 (Adminer)
# - PostgreSQL: localhost:5432
# - Redis: localhost:6379

# View logs
docker-compose logs -f backend

# Stop all services
docker-compose down
```

### Testing & Development
```powershell
# Backend testing
cd backend
npm test              # Run Jest tests
npm run lint          # ESLint code checking
npm run format        # Prettier code formatting

# API health check
curl http://localhost:3001/api/health

# Test AI chat endpoint
curl -X POST http://localhost:3001/api/chat -H "Content-Type: application/json" -d '{"message":"What are the best AI tools for writing?"}'

# Frontend testing
# Use browser dev tools for responsive design
# Check console for JavaScript errors
# Test PWA installation (Chrome: address bar install button)
```

### Performance Testing
```powershell
# Lighthouse audit (targets 95+ score)
# Chrome DevTools > Lighthouse tab

# Core Web Vitals targets:
# - FCP < 1.5s (First Contentful Paint)
# - LCP < 2.5s (Largest Contentful Paint) 
# - CLS < 0.1 (Cumulative Layout Shift)
# - INP < 200ms (Interaction to Next Paint)

# Backend performance
curl -w "@curl-format.txt" -o /dev/null -s http://localhost:3001/api/tools
```

## Styling & Design System

### CSS Architecture
- **CSS Custom Properties** (`:root`) for all design tokens
- **BEM methodology** for class naming consistency
- **Mobile-first** responsive breakpoints
- **Hardware-accelerated** animations using `transform` and `opacity`

### Key Design Tokens
- **Colors**: Primary (#6366f1), Secondary (#ec4899), Accent (#06b6d4)
- **Typography**: Inter (body), Space Grotesk (headings)
- **Spacing**: Consistent spacing scale using custom properties
- **Shadows**: 3D shadow system for depth effects

### Animation Principles
- **60fps animations** using CSS transforms
- **Staggered animations** for grid items (0.1s delays)
- **3D perspective** effects on cards and interactive elements
- **Reduced motion support** (should be implemented for accessibility)

## Adding New Features

### Adding New AI Tools

#### Backend Data (Persistent)
1. **Database approach** (recommended for production):
   - Add tools to PostgreSQL database via Adminer (localhost:8080)
   - Tools table schema: id, name, category, description, pricing, features, tags, rating
   - Update `backend/server.js` database queries if needed

2. **In-memory approach** (development):
   - Update `toolsDatabase` array in `backend/server.js`
   - Follow existing object structure with all required fields
   - Include features array, tags, pricing model, rating, review_count

#### Frontend Integration
3. **Search system integration**:
   - Tools automatically appear in `AIToolsSearchFilter` via API calls
   - Update `js/search-filter.js` categories if adding new category
   - Logos use emoji format (no image files needed)

### Adding New Categories
1. **Backend**: Update `categories` array in `server.js` with icon, color, tool_count
2. **Frontend**: Add option to category select in `createSearchInterface()` method
3. **Styling**: Category cards auto-generate from API data
4. **Filtering**: Automatic integration with existing filter system

### AI Chat Customization
The AI chat widget (`js/ai-chat.js`) can be customized:
- **Context prompts**: Modify system prompt in `backend/server.js` chat endpoint
- **Quick questions**: Update `quickQuestions` array in ai-chat.js
- **Conversation memory**: Managed automatically with local storage
- **Styling**: Modify CSS classes matching existing design system

## Performance Considerations

### Frontend Optimizations
- **Intersection Observer** for scroll animations (better than scroll events)
- **Hardware-accelerated CSS** transforms and opacity changes
- **Service Worker** caching for offline functionality (`sw.js`)
- **PWA capabilities** with installable manifest
- **Lazy loading** ready for images and content
- **Throttled animations** with requestAnimationFrame

### Backend Performance
- **Response caching** with Map-based cache for AI responses
- **Redis caching** available in Docker setup for persistent cache
- **Connection pooling** for database connections
- **Rate limiting** middleware for API protection
- **CORS optimization** for cross-origin requests

### AI Cost Optimization
- **Response caching** prevents duplicate AI API calls
- **Conversation context** managed efficiently to reduce token usage
- **Smart prompting** with tool context for accurate responses
- **Free tier strategies** documented in cost-effective-ai-strategy.md

## Deployment Architecture

### Production Docker Deployment
```bash
# Full production stack
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Services:
# - Nginx (frontend + reverse proxy)
# - Node.js API (backend)
# - PostgreSQL (persistent data)
# - Redis (caching layer)
# - SSL termination (nginx)
```

### Environment Configuration
- **Development**: In-memory database, local AI API
- **Staging**: PostgreSQL, Redis, full AI features
- **Production**: Optimized containers, SSL, monitoring

### Scaling Considerations
- **Database**: PostgreSQL with read replicas
- **Caching**: Redis cluster for distributed caching
- **API**: Horizontal scaling with load balancer
- **CDN**: Static assets via CDN (frontend files)

## Browser Support
- **Modern browsers** with ES6+ support required
- **CSS Grid and Flexbox** for layouts
- **Intersection Observer API** for scroll animations
- **CSS custom properties** for theming
- **Transform3d** for hardware-accelerated animations

## Accessibility Notes
- Semantic HTML structure is already implemented
- Add **ARIA labels** for interactive elements
- Implement **keyboard navigation** (foundation exists in JavaScript)
- Add **focus management** for mobile menu
- Consider **reduced motion** media query support
- Ensure **color contrast** meets WCAG standards

## Common Development Patterns

### API Integration Pattern
```javascript
// Standard API call pattern used throughout
async function fetchToolData(endpoint, params = {}) {
    try {
        const url = new URL(`${API_BASE_URL}/api/${endpoint}`);
        Object.keys(params).forEach(key => 
            params[key] && url.searchParams.append(key, params[key])
        );
        
        const response = await fetch(url);
        if (!response.ok) throw new Error(`API Error: ${response.status}`);
        
        return await response.json();
    } catch (error) {
        console.error('API call failed:', error);
        return { success: false, error: error.message };
    }
}
```

### 3D Card Animation Pattern
```css
/* Standard 3D card hover effect */
.card-3d {
    transform-style: preserve-3d;
    transition: transform 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.card-3d:hover {
    transform: translateY(-10px) rotateX(5deg) rotateY(5deg) scale(1.02);
}
```

### Search Filter Integration
```javascript
// Adding new filter criteria
applyFilters() {
    this.filteredTools = this.tools.filter(tool => {
        // Search term matching
        const matchesSearch = !this.currentFilters.search || 
            this.searchInTool(tool, this.currentFilters.search);
        
        // Category matching
        const matchesCategory = this.currentFilters.category === 'all' ||
            tool.category === this.currentFilters.category;
            
        return matchesSearch && matchesCategory;
    });
    
    this.renderTools();
    this.updateResultsCount();
}
```

### AI Chat Message Pattern
```javascript
// Standard chat message handling
async sendMessage(message, conversationHistory = []) {
    const payload = {
        message,
        conversationHistory,
        context: this.getToolContext()
    };
    
    const response = await this.apiCall('/api/chat', 'POST', payload);
    return response.success ? response.reply : 'Sorry, I encountered an error.';
}
```

## Troubleshooting Common Issues

### AI Chat Not Working
1. **Check Gemini API key**: Ensure `GEMINI_API_KEY` is set in `backend/.env`
2. **Verify backend connection**: Check if `http://localhost:3001/api/health` returns success
3. **CORS errors**: Ensure backend is running and frontend is served via HTTP (not file://)
4. **API quotas**: Check Google AI Studio for usage limits

### Search/Filter Issues
1. **No results**: Check browser console for JavaScript errors
2. **API not loading**: Verify backend `/api/tools` endpoint returns data
3. **Filters not working**: Ensure `AIToolsSearchFilter` class is instantiated
4. **Category mismatch**: Check category values match between frontend and backend

### Docker/Database Issues
```bash
# Common Docker troubleshooting
docker-compose logs backend          # Check backend logs
docker-compose logs db              # Check database logs
docker-compose down -v              # Reset volumes
docker system prune                 # Clean up containers

# Database connection issues
docker exec -it ai-tools-database psql -U postgres -d ai_tools_hub
```

### Performance Issues
1. **Slow animations**: Check for JavaScript errors blocking main thread
2. **Memory leaks**: Remove event listeners in cleanup methods
3. **API timeouts**: Implement request timeout and retry logic
4. **Cache invalidation**: Clear browser cache and Redis cache

## Data Flow Architecture

### Frontend → Backend → AI Flow
```
1. User Interaction (search, chat, browse)
   ↓
2. Frontend JavaScript (script.js, search-filter.js, ai-chat.js)
   ↓
3. API Calls to Express Backend (/api/*)
   ↓
4. Backend Processing (caching, validation, AI integration)
   ↓
5. Google Gemini AI (for chat and smart search)
   ↓
6. Response Caching (Map/Redis)
   ↓
7. Frontend UI Updates (DOM manipulation, animations)
```

### State Management
- **Frontend**: DOM-based state with class toggles and data attributes
- **Search**: Real-time filtering with `AIToolsSearchFilter` class state
- **Chat**: Conversation history in localStorage and memory
- **Backend**: In-memory data structures (or PostgreSQL for persistence)
- **Caching**: Multi-layer caching (browser, API responses, database queries)

### Key Technical Decisions

#### Frontend Architecture
- **No build process**: Vanilla JS for simplicity and direct browser execution
- **Class-based structure**: `AIToolsHub` and `AIToolsSearchFilter` as main controllers
- **Progressive enhancement**: Works without JavaScript, enhanced with it
- **Mobile-first CSS**: Responsive design with custom properties for theming

#### Backend Architecture  
- **Express.js**: Lightweight, fast API development with middleware ecosystem
- **Google Gemini**: Cost-effective AI with good context understanding
- **Caching strategy**: Prevent duplicate AI calls, improve response times
- **CORS handling**: Frontend/backend on different ports during development

#### Database Strategy
- **Development**: In-memory arrays for rapid iteration
- **Production**: PostgreSQL for ACID compliance and complex queries
- **Caching**: Redis for session data and API response caching
- **Admin interface**: Adminer for database management and tool updates

## Security Considerations

### API Security
- **CORS configuration**: Restricted to frontend domain
- **Rate limiting**: Express middleware prevents API abuse
- **Input validation**: Sanitize search terms and chat messages
- **API key protection**: Environment variables, never in client code

### Frontend Security
- **XSS prevention**: Safe DOM manipulation, no innerHTML with user content
- **CSP headers**: Content Security Policy for script injection protection
- **HTTPS enforcement**: SSL/TLS for all production traffic
- **Secure headers**: Helmet.js middleware for security headers

## Future Development Considerations

### Immediate Enhancements (Low effort, high impact)
1. **User authentication**: Add login/signup with JWT tokens
2. **Tool bookmarking**: Personal favorites with localStorage/backend sync
3. **Advanced filtering**: More criteria (pricing models, integrations, company size)
4. **SEO optimization**: Server-side rendering for tool pages

### Medium-term Features (Moderate effort, high value)
1. **User reviews**: Rating and review system with moderation
2. **Tool comparison**: Side-by-side feature and pricing comparison
3. **API partnerships**: Real-time pricing and feature updates
4. **Analytics dashboard**: Usage metrics and tool performance tracking

### Advanced Features (High effort, strategic value)
1. **AI recommendations**: Personalized tool suggestions based on use case
2. **Integration marketplace**: Connect tools with webhooks and APIs
3. **Enterprise features**: Team management, usage analytics, bulk licensing
4. **Mobile applications**: Native iOS/Android apps with offline sync
