pragma solidity ^0.8.0;

// Import IPFS library
import "./IPFS.sol";

contract TriviaQuiz {
    struct Question {
        string text;
        string[] choices;
        uint correctChoiceIndex;
        bool answered;
    }

    mapping(uint => bytes32) public questionHashes;
    mapping(address => uint) public scores;
    uint public currentQuestionIndex;
    IPFS ipfs;
    address public owner;
    mapping(address => bool) public gameMasters;
    bool public paused;
    uint public timeoutDuration; // in seconds

    event QuestionAdded(bytes32 questionHash);
    event AnswerSubmitted(address indexed player, uint questionIndex, uint choiceIndex, bool correct);
    event GameMasterAdded(address indexed gameMaster);
    event GameMasterRemoved(address indexed gameMaster);
    event Paused(bool paused);
    event EmergencyStopped();
    event LeaderboardUpdated(address indexed player, uint score);
    event QuestionTimeout(uint questionIndex);
    event QuestionRetrieved(uint indexed questionIndex, string text, string[] choices);
    event RewardEarned(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can perform this action");
        _;
    }

    modifier onlyGameMaster() {
        require(gameMasters[msg.sender] || msg.sender == owner, "Only game master or owner can perform this action");
        _;
    }

    modifier notPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    constructor(address _ipfsAddress) {
        ipfs = IPFS(_ipfsAddress);
        owner = msg.sender;
        gameMasters[msg.sender] = true;
        timeoutDuration = 60; // Default timeout duration is 60 seconds
    }

    function addGameMaster(address _gameMaster) public onlyOwner {
        require(!gameMasters[_gameMaster], "Address is already a game master");
        gameMasters[_gameMaster] = true;
        emit GameMasterAdded(_gameMaster);
    }

    function removeGameMaster(address _gameMaster) public onlyOwner {
        require(gameMasters[_gameMaster], "Address is not a game master");
        require(_gameMaster != owner, "Owner cannot be removed as game master");
        gameMasters[_gameMaster] = false;
        emit GameMasterRemoved(_gameMaster);
    }

    function addQuestion(bytes32 _questionHash) public onlyGameMaster {
        require(questionHashes[currentQuestionIndex] == 0, "Question already exists");
        questionHashes[currentQuestionIndex] = _questionHash;
        emit QuestionAdded(_questionHash);
        currentQuestionIndex++;
    }

    function submitAnswer(uint _questionIndex, uint _choiceIndex) public notPaused {
        bytes32 questionHash = questionHashes[_questionIndex];
        require(questionHash != 0, "Question not found");
        require(!questions[_questionIndex].answered, "Question already answered");
        require(_choiceIndex < questions[_questionIndex].choices.length, "Invalid choice index");

        (string memory questionText, string[] memory choices, uint correctChoiceIndex) = ipfs.getQuestion(questionHash);
        require(keccak256(abi.encodePacked(questionText, choices, correctChoiceIndex)) == questionHash, "Question hash mismatch");

        bool correct = (_choiceIndex == correctChoiceIndex);
        if (correct) {
            scores[msg.sender]++;
            emit RewardEarned(msg.sender, 1); // Reward 1 token for correct answer
        }

        questions[_questionIndex].answered = true;
        emit AnswerSubmitted(msg.sender, _questionIndex, _choiceIndex, correct);
        emit LeaderboardUpdated(msg.sender, scores[msg.sender]);
    }

    function pause() public onlyOwner {
        paused = true;
        emit Paused(true);
    }

    function resume() public onlyOwner {
        paused = false;
        emit Paused(false);
    }

    function emergencyStop() public onlyOwner {
        paused = true;
        emit EmergencyStopped();
    }

    function setTimeoutDuration(uint _duration) public onlyOwner {
        timeoutDuration = _duration;
    }

    function retrieveQuestion(uint _questionIndex) public view returns (string memory, string[] memory) {
        require(_questionIndex < currentQuestionIndex, "Invalid question index");
        bytes32 questionHash = questionHashes[_questionIndex];
        require(questionHash != 0, "Question not found");
        (string memory questionText, string[] memory choices, ) = ipfs.getQuestion(questionHash);
        emit QuestionRetrieved(_questionIndex, questionText, choices);
        return (questionText, choices);
    }

    function selectRandomQuestion() public view returns (string memory, string[] memory) {
        uint randomIndex = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % currentQuestionIndex;
        return retrieveQuestion(randomIndex);
    }

    function answerTimeout(uint _questionIndex) private {
        require(_questionIndex < currentQuestionIndex, "Invalid question index");
        require(!questions[_questionIndex].answered, "Question already answered");
        questions[_questionIndex].answered = true;
        emit QuestionTimeout(_questionIndex);
    }

}
