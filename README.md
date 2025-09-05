# 📱 CLASS Frontend (Flutter App)

Welcome to the **CLASS (Content Listening Assessment Scoring and Statistics)** frontend repository.  
This mobile app transforms lectures into interactive quizzes, helping students and lecturers improve engagement and understanding.

👉 [Download on Google Play](https://play.google.com/store/apps/details?id=com.huaru.class_app)

---

## ✨ Features
- 🎙️ **Record Lectures** – Capture and store lecture audio in-app  
- 📝 **Transcription** – Convert audio into clean, searchable text  
- ❓ **Quiz Generation** – Automatically create quizzes from lecture content  
- 👥 **Collaboration** – Share quizzes with friends and classmates  
- 📊 **Analytics Dashboard** – Track performance per question, attempts, and scores  
- 📤 **Export Results** – Save results for further review or reporting  

---

## 🛠️ Tech Stack
- **Framework**: [Flutter](https://flutter.dev/) (Dart)  
- **State Management**: [BLoC](https://bloclibrary.dev/)  
- **Backend API**: [CLASS API](https://github.com/your-username/class-api) (Node.js + Express)  
- **Authentication**: JWT, Google OAuth  
- **Storage**: Cloudinary for media uploads  
- **Design**: [Figma Prototype](https://www.figma.com/design/q2U1HMPccKB4o5nybUQbuc/Untitled?node-id=0-1&t=xaSKyRQoph9d3ZkR-1)  

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x+ recommended)  
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)  
- A running instance of the [CLASS API](https://github.com/your-username/class-api)  

### Installation
1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/class-frontend.git
   cd class-frontend
2. Install dependencies:
    ```bash
    flutter pub get
3. Create a app_secret file in the constants folder under the core folder (lib\core\constants):
    ```bash
    baseUrl=https:your_backend_url
    googleClientId=your_google_client_id
    googleWebClientId=your_google_web_client_id
    policyDocument=link_to_your_privacy_policy_document
4. Run the app:
    ```bash
    flutter run

### 🙏 Acknowledgments
Special thanks to Dr. Kwabena Owusu-Agyemang (Supervisor),
Adu Frank (Mentor), and all classmates who tested and provided feedback.

### 📬 Contact
👤 Developer: Hafiz Huaru

💼 LinkedIn : https://www.linkedin.com/in/hafiz-huaru-/

✉️ Email : hafizhuaru123@gmail.com



