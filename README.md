# ChatChat

![ChatChat](https://github.com/AniArka/ChatChat/assets/128679176/8ebe4dbd-4934-494f-a273-510c8eed7bcf)

ChatChat is a  Group Chat App which is a mobile application built using the Flutter framework. It provides a platform for users to create groups and engage in real-time conversations with other group members. This README.md file provides an overview of the app, its features, and instructions on how to set it up and run on your local machine.

## Features

- **Group Creation:** Users can create new groups by providing a group name and optional description.
- **Real-time Messaging:** Users can send and receive messages in real-time within their groups.
- **Group Invitations:** Users can invite others to join their groups using unique invitation codes.
- **Member Management:** Group admins have the ability to manage group members, including adding or removing members.
- **Message Notifications:** Users receive notifications for new messages even when the app is in the background.

## Installation

To run the Group Chat App on your local machine, follow these steps:

1. Ensure you have Flutter installed on your system. If not, refer to the official [Flutter installation guide](https://flutter.dev/docs/get-started/install) for detailed instructions.

2. Clone this repository using the following command:
   ```
   git clone https://github.com/AniArka/ChatChat.git
   ```

3. Navigate to the project directory:
   ```
   cd group-chat-app
   ```

4. Retrieve the app dependencies by running:
   ```
   flutter pub get
   ```

5. Connect your physical device or start an emulator.

6. Run the app on your device/emulator:
   ```
   flutter run
   ```

## Configuration

Before running the app, you need to configure the necessary backend services and APIs. Follow the steps below:

1. Open the `lib/shared/constants.dart` file.

2. Update the `firebaseConfig` constant with your Firebase project configuration. You can obtain this information from the Firebase Console.

3. If you are using a different backend service for real-time messaging, update the relevant configuration constants in the `lib/shared/constants.dart` file as required.

## Contributing

We welcome contributions to the ChatChat App! To contribute, please follow these guidelines:

1. Fork the repository and create your own branch.

2. Make your changes or add new features.

3. Test your changes thoroughly.

4. Commit your changes and push them to your forked repository.

5. Open a pull request, providing a detailed description of the changes you made.

## Reporting Issues

If you encounter any issues or have suggestions for improvements, please open an issue on the GitHub repository. Provide as much detail as possible, including steps to reproduce the issue.

## License

The Group Chat App is open source and released under the [MIT License](LICENSE). You are free to modify and distribute the app in accordance with the terms of the license.

## Contact

For any additional questions or inquiries, please contact me at arkaghosh0115@gmail.com
