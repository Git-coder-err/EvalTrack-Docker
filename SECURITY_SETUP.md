# 🔒 EvalTrack Security Implementation Guide

## Security Features Implemented

### ✅ 1. HTTPS/SSL Configuration
- **Helmet.js** for comprehensive security headers:
  - Content Security Policy (CSP)
  - X-Frame-Options (Clickjacking protection)
  - HSTS (HTTP Strict Transport Security)
  - X-XSS-Protection
  - Referrer Policy
  - No-Sniff headers

### ✅ 2. Environment Variables & Secrets Management
- ✓ `.env` files for sensitive configuration
- ✓ `.env.example` for documentation
- ✓ `.gitignore` excludes `.env` files
- ✓ Firebase keys moved to environment variables
- ✓ JWT secrets managed via environment

### ✅ 3. CORS (Cross-Origin Resource Sharing)
- Configured to allow only trusted domains
- Credentials enabled with proper configuration
- Methods restricted to necessary HTTP verbs
- Preflight caching enabled (86400s)

### ✅ 4. Rate Limiting
- General rate limiter: 100 requests per 15 minutes
- Auth endpoints (login/register): 5 requests per 15 minutes
- Prevents brute force attacks
- Returns proper HTTP 429 status code

### ✅ 5. Middleware Security
- **Express compression**: Reduces response size
- **Body size limits**: 10MB max for JSON/URL-encoded
- **Response headers**: Prevents common attacks

## Setup Instructions

### Backend Setup

1. **Install Dependencies**
   ```bash
   cd EvalTrack_System/server
   npm install
   ```

2. **Create `.env` file**
   ```bash
   cp .env.example .env
   ```

3. **Configure Environment Variables**
   - Edit `.env` and fill in your actual values
   - **Critical**: Change `JWT_SECRET` to a random value:
     ```bash
     node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
     ```
   - Set `CORS_ORIGIN` to your frontend URL
   - Set `FIREBASE_*` variables from your Firebase Console

4. **Start Server**
   ```bash
   npm run dev      # Development with auto-reload
   npm start        # Production
   ```

### Frontend Setup

1. **Install Dependencies**
   ```bash
   cd EvalTrack_System/client
   npm install
   ```

2. **Create `.env.local` file**
   ```bash
   cp .env.example .env.local
   ```

3. **Configure Environment Variables**
   - Edit `.env.local` with your Firebase credentials
   - Set `VITE_API_URL` to your backend URL (default: http://localhost:5000)

4. **Start Client**
   ```bash
   npm run dev      # Development with Vite
   npm run build    # Production build
   ```

## Environment Variables Reference

### Server `.env`

| Variable | Purpose | Example |
|----------|---------|---------|
| `NODE_ENV` | Environment mode | `development`, `production` |
| `PORT` | Server port | `5000` |
| `JWT_SECRET` | JWT signing key | `your_random_32_byte_hex` |
| `CORS_ORIGIN` | Allowed frontend URLs | `http://localhost:3000,https://example.com` |
| `RATE_LIMIT_MAX_REQUESTS` | Max requests per window | `100` |
| `FIREBASE_*` | Firebase credentials | From Firebase Console |

### Client `.env.local` or `.env.production.local`

| Variable | Purpose |
|----------|---------|
| `VITE_API_URL` | Backend API URL |
| `VITE_FIREBASE_API_KEY` | Firebase API key |
| `VITE_FIREBASE_AUTH_DOMAIN` | Firebase auth domain |
| `VITE_FIREBASE_PROJECT_ID` | Firebase project ID |
| `VITE_FIREBASE_STORAGE_BUCKET` | Firebase storage bucket |

## Docker Security Configuration

Update `docker-compose.yml` to use environment variables:

```yaml
version: '3.8'
services:
  server:
    build: ./server
    ports:
      - "5000:5000"
    environment:
      - NODE_ENV=production
      - PORT=5000
      - JWT_SECRET=${JWT_SECRET}
      - CORS_ORIGIN=${CORS_ORIGIN}
    volumes:
      - ./server:/app
    restart: always

  client:
    build: ./client
    ports:
      - "3000:3000"
    environment:
      - VITE_API_URL=${API_URL}
      - VITE_FIREBASE_API_KEY=${FIREBASE_API_KEY}
    volumes:
      - ./client:/app
    restart: always
```

## HTTPS/SSL Setup for Production

### Option 1: Using Let's Encrypt with Nginx
```bash
# Install Certbot
sudo apt-get install certbot python3-certbot-nginx

# Generate certificate
sudo certbot certonly --nginx -d yourdomain.com

# Configure Nginx to use certificate (see nginx.conf example)
```

### Option 2: Using Firebase Hosting (Recommended)
Firebase Hosting automatically provides SSL/TLS certificates with:
- Free SSL certificate
- Automatic renewal
- DDoS protection
- CDN caching

Deploy using:
```bash
firebase deploy --only hosting
```

### Option 3: Production Server (.env)
```env
NODE_ENV=production
USE_HTTPS=true
SSL_KEY_PATH=/etc/letsencrypt/live/yourdomain.com/privkey.pem
SSL_CERT_PATH=/etc/letsencrypt/live/yourdomain.com/fullchain.pem
```

## Security Best Practices

### ✅ DO

- [x] Keep `.env` files out of version control
- [x] Use HTTPS in production
- [x] Rotate JWT secrets regularly
- [x] Monitor rate limit violations
- [x] Update dependencies regularly (`npm audit`, `npm update`)
- [x] Use environment variables for all secrets
- [x] Enable Helmet security headers
- [x] Implement proper CORS
- [x] Use strong password hashing (bcryptjs)
- [x] Enable HSTS for production

### ❌ DON'T

- [ ] Commit `.env` files to version control
- [ ] Use hardcoded secrets in code
- [ ] Disable CORS security
- [ ] Use weak JWT secrets
- [ ] Deploy with `NODE_ENV=development`
- [ ] Expose API keys in frontend code
- [ ] Disable rate limiting
- [ ] Use unencrypted HTTP in production
- [ ] Share credentials in comments or logs

## Testing Security Configuration

### Test CORS
```bash
curl -H "Origin: http://localhost:3000" \
     -H "Access-Control-Request-Method: POST" \
     -H "Access-Control-Request-Headers: application/json" \
     -X OPTIONS http://localhost:5000
```

### Test Rate Limiting
```bash
# Should fail after 5 attempts
for i in {1..10}; do curl -X POST http://localhost:5000/api/auth/login; done
```

### Check Security Headers
```bash
curl -I http://localhost:5000 | grep -i "x-"
```

## Debugging

### Enable Debug Mode
Set in `.env`:
```env
DEBUG=true
```

### Check Environment Variables
```bash
# Server
node -e "console.log(process.env)"

# Client (during build)
echo $VITE_API_URL
```

### Review Security Headers
- Use: https://securityheaders.com
- Enter your domain to see security rating

## Dependencies Added

- `helmet` - Security headers
- `express-rate-limit` - Rate limiting
- `compression` - Response compression
- `cors` - CORS configuration
- `dotenv` - Environment variable management

## Maintenance

### Regular Update Cycle
```bash
# Check for vulnerabilities
npm audit

# Fix vulnerabilities
npm audit fix

# Update all dependencies
npm update

# Update to latest major versions
npm upgrade
```

### Monitoring
- Monitor rate limit logs
- Review authentication failures
- Check CORS rejection patterns
- Monitor HTTPS certificate expiry

## Support & References

- [Helmet.js Documentation](https://helmetjs.github.io/)
- [OWASP Security Headers](https://owasp.org/www-project-secure-headers/)
- [Express Security Best Practices](https://expressjs.com/en/advanced/best-practice-security.html)
- [Firebase Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
