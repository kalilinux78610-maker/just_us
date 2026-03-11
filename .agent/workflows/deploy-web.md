---
description: how to deploy the flutter app to the web
---

This workflow guides you through building and deploying your Flutter app to the web.

1. **Build the Web App**
// turbo
Run the following command to build the production version of your app:
```bash
flutter build web --release
```

2. **Choose a Hosting Provider**
Recommended options:
- **Firebase Hosting**: Fast, global, and integrated with Flutter.
- **GitHub Pages**: Free and easy for simple hosting.
- **Google Cloud Run**: Flexible and scalable (requires a Dockerfile).

3. **Deploy to Firebase (Example)**
If using Firebase:
// turbo
Initialize and deploy:
```bash
firebase init hosting
firebase deploy --only hosting
```

4. **Verify Deployment**
After deployment, open the provided URL in your browser to verify the app is running correctly.
