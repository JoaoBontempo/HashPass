# Welcome to HashPass! 🔒

### Project purpose 📝

I developed this project during my time at university with the primary goal of creating a simple, user-friendly, and secure password manager. With the increasing concern about trusting online password managers, the core principle of this project is to operate offline.

When considering secure passwords, several important guidelines come to mind:

- Never use the same password across different platforms;
- Always create long and complex passwords that include letters, numbers, symbols, etc.;
- Avoid storing your passwords on the internet;
- Don’t use common words or phrases (No, your dog's name is not a secure password).

Following these "rules" can seem impossible for most people. Remembering multiple long and complex passwords for various apps is unrealistic. The most significant feature of this app is that you only need to remember a single strong password, which serves as the master key for the app.

### App Features 📱

- Password Management
- Password Leak Verification (via https://haveibeenpwned.com/)
- Password Generation
- Biometric/Manual Unlock
- Desktop Module (https://github.com/JoaoBontempo/hashpass-desktop)
- Dark and Light Theme
- Avaliable in Portuguese (Brazil) and English (US)
- App Data Export/Import

### App Structure 🔧

The app uses a local database to store passwords, ensuring they remain on the user's device. The stored data is encrypted with the master key using the AES algorithm. Each time a password needs to be viewed or stored, the master key is required to encrypt or decrypt it.