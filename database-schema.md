# Database Schema Design - AI Tools Hub

## Core Tables

### 1. **ai_tools**
```sql
CREATE TABLE ai_tools (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  website_url VARCHAR(500),
  logo_url VARCHAR(500),
  category_id INTEGER REFERENCES categories(id),
  pricing_model VARCHAR(100), -- 'free', 'freemium', 'paid', 'enterprise'
  min_price DECIMAL(10,2),
  max_price DECIMAL(10,2),
  pricing_details JSONB, -- Flexible pricing info
  features JSONB, -- Array of features
  rating DECIMAL(3,2) DEFAULT 0,
  review_count INTEGER DEFAULT 0,
  status VARCHAR(50) DEFAULT 'active', -- 'active', 'inactive', 'pending'
  api_available BOOLEAN DEFAULT false,
  integration_difficulty VARCHAR(50), -- 'easy', 'medium', 'hard'
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  
  -- SEO fields
  slug VARCHAR(255) UNIQUE,
  meta_title VARCHAR(255),
  meta_description TEXT,
  
  -- AI-powered fields (auto-generated)
  ai_generated_summary TEXT,
  ai_tags JSONB, -- Auto-generated tags
  similarity_vector VECTOR(1536) -- For AI-powered recommendations
);
```

### 2. **categories**
```sql
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE,
  description TEXT,
  icon VARCHAR(100), -- FontAwesome class
  color VARCHAR(7), -- Hex color
  parent_id INTEGER REFERENCES categories(id),
  sort_order INTEGER DEFAULT 0,
  is_featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### 3. **reviews**
```sql
CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  tool_id INTEGER REFERENCES ai_tools(id),
  user_id INTEGER REFERENCES users(id),
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  title VARCHAR(255),
  content TEXT,
  pros JSONB, -- Array of pros
  cons JSONB, -- Array of cons
  use_case VARCHAR(255),
  experience_level VARCHAR(50), -- 'beginner', 'intermediate', 'expert'
  verified_purchase BOOLEAN DEFAULT false,
  helpful_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### 4. **users**
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  username VARCHAR(100) UNIQUE,
  full_name VARCHAR(255),
  avatar_url VARCHAR(500),
  bio TEXT,
  role VARCHAR(50) DEFAULT 'user', -- 'user', 'reviewer', 'admin'
  email_verified BOOLEAN DEFAULT false,
  preferences JSONB, -- User preferences
  created_at TIMESTAMP DEFAULT NOW(),
  last_login TIMESTAMP
);
```

### 5. **user_toolboxes**
```sql
CREATE TABLE user_toolboxes (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  tool_id INTEGER REFERENCES ai_tools(id),
  status VARCHAR(50) DEFAULT 'saved', -- 'saved', 'using', 'tried', 'recommended'
  notes TEXT,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  added_at TIMESTAMP DEFAULT NOW(),
  
  UNIQUE(user_id, tool_id)
);
```

## Advanced Features Tables

### 6. **ai_integrations**
```sql
CREATE TABLE ai_integrations (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL, -- 'openai', 'gemini', 'claude'
  api_key_encrypted TEXT,
  base_url VARCHAR(500),
  model_name VARCHAR(255),
  is_active BOOLEAN DEFAULT true,
  rate_limit_per_minute INTEGER DEFAULT 60,
  cost_per_request DECIMAL(10,6),
  created_at TIMESTAMP DEFAULT NOW()
);
```

### 7. **ai_analysis_jobs**
```sql
CREATE TABLE ai_analysis_jobs (
  id SERIAL PRIMARY KEY,
  tool_id INTEGER REFERENCES ai_tools(id),
  job_type VARCHAR(100), -- 'summary_generation', 'feature_extraction', 'review_analysis'
  status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'processing', 'completed', 'failed'
  input_data JSONB,
  output_data JSONB,
  ai_provider VARCHAR(50), -- 'openai', 'gemini'
  cost DECIMAL(10,6),
  processing_time INTEGER, -- in milliseconds
  created_at TIMESTAMP DEFAULT NOW(),
  completed_at TIMESTAMP
);
```

### 8. **newsletter_subscribers**
```sql
CREATE TABLE newsletter_subscribers (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  status VARCHAR(50) DEFAULT 'active', -- 'active', 'unsubscribed'
  preferences JSONB, -- What content they want
  subscribed_at TIMESTAMP DEFAULT NOW(),
  unsubscribed_at TIMESTAMP,
  verification_token VARCHAR(255)
);
```

## Indexes for Performance

```sql
-- Search and filtering indexes
CREATE INDEX idx_ai_tools_category ON ai_tools(category_id);
CREATE INDEX idx_ai_tools_rating ON ai_tools(rating DESC);
CREATE INDEX idx_ai_tools_pricing ON ai_tools(pricing_model);
CREATE INDEX idx_ai_tools_status ON ai_tools(status);
CREATE INDEX idx_ai_tools_name_search ON ai_tools USING gin(to_tsvector('english', name || ' ' || description));

-- User activity indexes
CREATE INDEX idx_reviews_tool ON reviews(tool_id);
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_user_toolboxes_user ON user_toolboxes(user_id);

-- AI processing indexes
CREATE INDEX idx_ai_jobs_status ON ai_analysis_jobs(status);
CREATE INDEX idx_ai_jobs_tool ON ai_analysis_jobs(tool_id);
```

## Views for Common Queries

```sql
-- Popular tools view
CREATE VIEW popular_tools AS
SELECT 
  t.*,
  c.name as category_name,
  c.icon as category_icon
FROM ai_tools t
JOIN categories c ON t.category_id = c.id
WHERE t.status = 'active'
ORDER BY t.rating DESC, t.review_count DESC;

-- User dashboard view
CREATE VIEW user_dashboard AS
SELECT 
  ut.user_id,
  t.name as tool_name,
  t.logo_url,
  ut.status,
  ut.notes,
  ut.added_at,
  c.name as category_name
FROM user_toolboxes ut
JOIN ai_tools t ON ut.tool_id = t.id
JOIN categories c ON t.category_id = c.id
ORDER BY ut.added_at DESC;
```