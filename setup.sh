#!/bin/bash
# Installation script for Student GPA Manager

set -e

echo "🚀 Starting Student GPA Manager Setup..."

# Check if CocoaPods is installed
if ! command -v pod &> /dev/null; then
    echo "❌ CocoaPods not found. Installing..."
    sudo gem install cocoapods
fi

echo "📦 Installing Firebase dependencies via CocoaPods..."
cd "$(dirname "$0")"

# Install pods
pod install --repo-update

echo ""
echo "✅ Pod installation complete!"
echo ""
echo "🔑 Firebase Setup Instructions:"
echo "================================"
echo ""
echo "1. Go to Firebase Console: https://console.firebase.google.com/"
echo "2. Create a new project (or use existing)"
echo "3. Add iOS app with Bundle ID: com.studentgpamanager.app"
echo "4. Download GoogleService-Info.plist"
echo "5. Add it to Xcode:"
echo "   - Drag the file into Xcode"
echo "   - Select 'Copy items if needed'"
echo "   - Add to target 'StudentGPAManager'"
echo ""
echo "6. In Firebase Console, enable:"
echo "   - Authentication → Email/Password"
echo "   - Firestore Database (Development Mode)"
echo ""
echo "7. Update Firestore Security Rules to:"
echo "   rules_version = '2';"
echo "   service cloud.firestore {"
echo "     match /databases/{database}/documents {"
echo "       match /users/{userId} {"
echo "         allow read, write: if request.auth.uid == userId;"
echo "       }"
echo "     }"
echo "   }"
echo ""
echo "8. Open StudentGPAManager.xcworkspace (NOT .xcodeproj)"
echo "9. Build and Run!"
echo ""
echo "✨ Setup complete! Enjoy managing GPAs!"
