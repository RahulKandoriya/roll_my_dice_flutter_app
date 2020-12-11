# RollMyDice

The application is a game, where the Player can press a button to "Roll a dice", and get a Random result anywhere between 1 and 6, the Player gets 10 chances to play, and every time the result of the dice roll should get added to the Player's score. After 10 attempts the player's results should be logged into the leaderboard.

Medium article describing the experience while building it. 

##Steps

1. Add required libraries from pub.dev
2. Connect project in firebase console.
3. We will follow Stream based architecture using the package flutter_riverpod from pub.dev and with reference to https://codewithandrea.com/videos/2020-02-10-starter-architecture-flutter-firebase/.
4. We are using the auth with the phone number so first step of verifying the mobile number would be the same for sign up or sign in. Afterwards if the user has not 
entered the details then the screen "Add user details" will pop otherwise not. User can edit his/her details anytime.
5. We will follow bottom navigation so there will be three tabs namely "RollDice", "LeaderBoard" and "Account".
6. We are using this(https://stackoverflow.com/questions/60461109/dice-roll-animation-flutter) reference for creating the dice animation.
7. While using the dice animation we will not use provider package but instead we will use flutter_riverpod as it will be easier.
8. While using the firestore we will make the simple file structure so that it can be easier to maintain and scale. There are three files 
8a. firestore_service: this file contains the boilerplate code for CRUD operation on collection or documents.
8b. firesbase_path: different paths for leaderboard and user details.
8c. firestore_database: Different methods for specific CRUD operations in firestores.
9. Rules for the firestore are: "allow read, write: if request.auth != null;" read and write data only if the user is authenticated. 
10. The StreamCollection of the leaderboard firestore will require ordering in descending order according to the score so that the highest score appears at first.

