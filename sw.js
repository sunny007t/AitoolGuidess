// AI Tools Hub Service Worker
const CACHE_NAME = 'ai-tools-hub-v1';
const STATIC_CACHE_URLS = [
  '/',
  '/index.html',
  '/css/style.css',
  '/js/script.js',
  '/manifest.json',
  // Add external resources that are essential
  'https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Space+Grotesk:wght@300;400;500;600;700&display=swap',
  'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css'
];

// Install event - cache static assets
self.addEventListener('install', event => {
  console.log('🚀 Service Worker installing...');
  
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('📦 Caching static assets');
        // Cache core files, but don't fail if external resources fail
        return cache.addAll(STATIC_CACHE_URLS.slice(0, 4)) // Only cache local files initially
          .then(() => {
            // Try to cache external resources, but don't fail if they're not available
            return Promise.allSettled(
              STATIC_CACHE_URLS.slice(4).map(url => 
                cache.add(url).catch(err => console.log(`Failed to cache ${url}:`, err))
              )
            );
          });
      })
      .then(() => self.skipWaiting())
  );
});

// Activate event - clean up old caches
self.addEventListener('activate', event => {
  console.log('✅ Service Worker activated');
  
  event.waitUntil(
    caches.keys()
      .then(cacheNames => {
        return Promise.all(
          cacheNames
            .filter(cacheName => cacheName !== CACHE_NAME)
            .map(cacheName => {
              console.log('🗑️ Deleting old cache:', cacheName);
              return caches.delete(cacheName);
            })
        );
      })
      .then(() => self.clients.claim())
  );
});

// Fetch event - serve from cache, fallback to network
self.addEventListener('fetch', event => {
  // Skip non-GET requests
  if (event.request.method !== 'GET') return;
  
  // Skip chrome-extension and other non-http requests
  if (!event.request.url.startsWith('http')) return;
  
  event.respondWith(
    caches.match(event.request)
      .then(cachedResponse => {
        if (cachedResponse) {
          console.log('📦 Serving from cache:', event.request.url);
          return cachedResponse;
        }
        
        console.log('🌐 Fetching from network:', event.request.url);
        return fetch(event.request)
          .then(response => {
            // Don't cache non-successful responses
            if (!response || response.status !== 200 || response.type !== 'basic') {
              return response;
            }
            
            // Cache the response for future use
            const responseToCache = response.clone();
            caches.open(CACHE_NAME)
              .then(cache => {
                cache.put(event.request, responseToCache);
              });
            
            return response;
          })
          .catch(error => {
            console.log('❌ Network request failed:', error);
            
            // Return offline page for navigation requests
            if (event.request.mode === 'navigate') {
              return caches.match('/index.html');
            }
            
            // Return empty response for other requests
            return new Response('Offline', { 
              status: 408, 
              statusText: 'Request Timeout' 
            });
          });
      })
  );
});

// Background sync for when connection is restored
self.addEventListener('sync', event => {
  if (event.tag === 'background-sync') {
    console.log('🔄 Background sync triggered');
    // You could sync any offline actions here
  }
});

// Push notification handler (for future use)
self.addEventListener('push', event => {
  if (event.data) {
    const data = event.data.json();
    console.log('📩 Push notification received:', data);
    
    const options = {
      body: data.body || 'New AI tools available!',
      icon: '/icon-192.png',
      badge: '/badge-72.png',
      tag: 'ai-tools-notification',
      requireInteraction: true,
      actions: [
        {
          action: 'view',
          title: 'View Tools',
          icon: '/action-view.png'
        },
        {
          action: 'close',
          title: 'Close',
          icon: '/action-close.png'
        }
      ]
    };
    
    event.waitUntil(
      self.registration.showNotification(data.title || 'AI Tools Hub', options)
    );
  }
});

// Notification click handler
self.addEventListener('notificationclick', event => {
  console.log('🔔 Notification clicked:', event.action);
  
  event.notification.close();
  
  if (event.action === 'view') {
    event.waitUntil(
      clients.openWindow('/')
    );
  }
});