# TriviaQuiz Contract Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```

The TriviaQuiz contract is a Solidity smart contract designed to manage a trivia quiz game on the blockchain. It allows anyone to create and manage trivia questions, participate in the quiz game, and earn rewards for correct answers. The contract is built with security, modularity, and usability in mind, providing a transparent and rewarding gaming experience for all users.

Features
Question Management: Users can add new trivia questions to the contract using the addQuestion function. Each question consists of a text prompt, a set of answer choices, and an index indicating the correct choice.

Answer Submission: Participants can submit their answers to trivia questions using the submitAnswer function. The contract verifies the correctness of the answer and updates the player's score accordingly.

Access Control: The contract includes access control mechanisms to restrict certain functions to authorized users only. The contract owner and designated game masters have permission to add questions and manage the quiz.

Game Pausing: The contract provides functions to pause and resume the quiz game. This feature allows the contract owner to temporarily halt game activity in case of emergencies or maintenance.

Timeout Mechanism: To prevent participants from taking too long to answer questions, the contract includes a timeout mechanism. If a player fails to submit an answer within the specified time, the question is marked as unanswered.

Event Logging: Events are emitted for various contract actions, including question additions, answer submissions, leaderboard updates, and rewards earned. These events provide transparency and enable users to track contract state changes.

Token Rewards (Integration): While the contract emits events for token rewards, the actual token reward system is not implemented in this contract.  (e.g., ERC-20 or ERC-721) to manage token rewards for participants.



Initialization: Upon deployment, provide the contract with the address of an IPFS node to enable off-chain storage of trivia questions.

Question Management: Use the addQuestion function to add new trivia questions to the contract. Specify the question text, answer choices, and correct choice index as parameters.

Participant Interaction: Participants can interact with the contract by calling the submitAnswer function to submit their answers to trivia questions. The contract validates the answer and updates the participant's score accordingly.

Game Control: The contract owner can manage the quiz game by pausing, resuming, or emergency stopping game activity as needed. Additionally, the owner can add or remove game masters to delegate question management responsibilities.

Event Tracking: Users can listen for emitted events to track contract state changes, participant interactions, and rewards earned. These events provide valuable insights into contract activity and participant engagement.

Error Handling: Add comprehensive error handling to provide clear feedback to users when transactions fail. Ensure that error messages are informative and help users understand the reason for the failure.

Event Handling: Review event handling to ensure sensitive information is not exposed unintentionally. Make sure that emitted events do not include sensitive data or information that could compromise user privacy or security.
