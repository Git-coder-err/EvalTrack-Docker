# 📋 Project System Deployment Initiation Log

## EvalTrack System - Student Evaluation Platform

**Course:** IT Elec 4 - System Integration and Architecture 2  
**Student:** [Your Name]  
**Deployment Date:** April 6, 2026  
**Service Provider:** Render (Cloud Application Hosting)

---

## 1. Service Provider Activity Log (Render)

### Deployment Details

| Field | Value |
|-------|-------|
| **Service Provider** | Render |
| **Deployment Status** | ✅ LIVE & OPERATIONAL |
| **Backend API URL** | `https://evaltrack-system.onrender.com` |
| **Frontend URL** | `https://evaltrack-system.netlify.app` |

### Deployment Timeline

- ✅ **Repository Setup** - GitHub repository configured with main branch protection
- ✅ **Backend Deployment** - Node.js server deployed to Render with SQLite database
- ✅ **Frontend Deployment** - Static HTML frontend deployed to Netlify CDN
- ✅ **Database Migration** - Migrated from MySQL to SQLite for cloud compatibility
- ✅ **API Integration** - Frontend API endpoints updated to use Render backend URL

---

## 2. Deployment Confirmation & Evidence

### Service Configuration

| Component | Provider/Technology |
|-----------|---------------------|
| Backend Service | Render Web Service |
| Frontend Hosting | Netlify (Static Site) |
| Database | SQLite (better-sqlite3) |
| Server Runtime | Node.js 18.x |

### Screenshots Required

📸 **RENDER DASHBOARD SCREENSHOT**  
*Insert screenshot of your Render dashboard showing:*
- Service Name: evaltrack-system
- Status: Live
- Last Deployed: [Date/Time]

📸 **DEPLOYED APPLICATION SCREENSHOT**  
*Insert screenshot of your live application showing:*
- Login page or dashboard
- URL bar showing evaltrack-system.netlify.app
- Successfully loaded interface

---

## 3. System Architecture & Configuration

### Technology Stack

`Node.js` `Express.js` `SQLite` `JWT Auth` `HTML5/CSS3` `JavaScript` `Firebase Auth`

### Environment Variables (Render)

```bash
PORT=5000
USE_SQLITE=true
JWT_SECRET=evaltrack-secret-key-2024
ALLOWED_ORIGINS=https://evaltrack-system.netlify.app
NODE_ENV=production
```

### Key Features Deployed

- ✅ Multi-role authentication (Admin, Instructor, Student, Program Head)
- ✅ Student evaluation and grading system
- ✅ Academic standing calculation
- ✅ Enrollment management
- ✅ AI-powered insights (Groq AI integration)
- ✅ Real-time chatbot assistant
- ✅ Report generation and export
- ✅ Responsive web interface

---

## 4. Verification Checklist

- ✅ Backend API responding at https://evaltrack-system.onrender.com
- ✅ Frontend accessible at https://evaltrack-system.netlify.app
- ✅ Database initialized with default data
- ✅ Authentication system functional
- ✅ CORS configured for cross-origin requests
- ✅ Environment variables properly set
- ✅ All API endpoints tested and working
- ✅ GitHub repository updated with latest code

---

## Footer

**EvalTrack System** - Student Evaluation & Academic Tracking Platform

*This document certifies that the system has been successfully deployed and is operational.*  
*Submitted as requirement for IT Elec 4 - System Integration and Architecture 2*

---

## Quick Links

- 🔗 **Render Dashboard:** https://dashboard.render.com
- 🔗 **Your App:** https://evaltrack-system.netlify.app
- 🔗 **GitHub Repo:** https://github.com/diazgenesisofficial-boop/EvalTrack-System
