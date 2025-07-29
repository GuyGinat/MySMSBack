# MySMS Backend Deployment Guide

## Deployment Options

### Option 1: Railway (Recommended - Easy & Free)
1. **Sign up** at [railway.app](https://railway.app)
2. **Connect your GitHub** repository
3. **Deploy** the MySMSBack folder
4. **Set environment variables**:
   - `TWILIO_ACCOUNT_SID`
   - `TWILIO_AUTH_TOKEN`
   - `TWILIO_PHONE_NUMBER`
   - `APP_URL` (will be provided by Railway)
   - `FRONTEND_URL` (your frontend domain)
   - `MONGODB_URI` (your MongoDB Atlas URI)

### Option 2: Render
1. **Sign up** at [render.com](https://render.com)
2. **Create a new Web Service**
3. **Connect your GitHub** repository
4. **Set build command**: `bundle install`
5. **Set start command**: `bundle exec rails server -p $PORT -e production`
6. **Set environment variables** (same as above)

### Option 3: Heroku
1. **Install Heroku CLI**
2. **Create app**: `heroku create your-app-name`
3. **Add MongoDB**: `heroku addons:create mongolab`
4. **Set environment variables**:
   ```bash
   heroku config:set TWILIO_ACCOUNT_SID=your_sid
   heroku config:set TWILIO_AUTH_TOKEN=your_token
   heroku config:set TWILIO_PHONE_NUMBER=your_number
   heroku config:set APP_URL=https://your-app-name.herokuapp.com
   ```
5. **Deploy**: `git push heroku main`

## Environment Variables Required

```bash
# Twilio Configuration
TWILIO_ACCOUNT_SID=your_twilio_account_sid
TWILIO_AUTH_TOKEN=your_twilio_auth_token
TWILIO_PHONE_NUMBER=your_twilio_phone_number

# App Configuration
APP_URL=https://your-backend-domain.com
FRONTEND_URL=https://your-frontend-domain.com

# Database
MONGODB_URI=your_mongodb_atlas_uri
```

## Post-Deployment Steps

1. **Update frontend** API URL to point to your deployed backend
2. **Test webhooks** by sending a message
3. **Monitor logs** for any issues
4. **Update Twilio webhook URL** in your Twilio console if needed

## Troubleshooting

- **CORS errors**: Ensure `FRONTEND_URL` is set correctly
- **Database connection**: Check `MONGODB_URI` format
- **Twilio errors**: Verify credentials and phone number
- **Webhook issues**: Ensure `APP_URL` is publicly accessible 