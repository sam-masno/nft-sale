pragma solidity >=0.4.22 <0.9.0;

contract NFT {
    string public name;
    string public version;
    uint256 private count = 1;
    uint256 public price;
    address private admin;
    bool public paused = false;

    struct Token {
      uint256 id;
      string tokenName;
      address owner;
    }

    mapping (uint256 => Token) Tokens;
    mapping (address => uint256) Balances;
    mapping (uint256 => address) Approvals;
    mapping (address => mapping(address => bool)) Operators;

    constructor(address payable _owner, string memory _name, string memory _version, uint256 _price) public {
      name = _name;
      version = _version;
      admin = _owner;
      price = _price;
    }

  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
  event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
  event TokenMinted(address indexed _owner, string _name, uint256 _tokenId);
  modifier onlyAdmin {
    require(msg.sender == admin, "Unathorized");
    _;
  }
  modifier onlyOwner (uint256 _tokenId) {
    require(Tokens[_tokenId].owner == address(msg.sender), "This is not your Token");
    _;
  }
  modifier isValidToken (uint256 _tokenId) {
    require(Tokens[_tokenId].id != 0, "Invalid Token");
    _;
  }
  modifier isAuthorized (uint256 _tokenId) {
    require(Tokens[_tokenId].owner == msg.sender || Approvals[_tokenId] == msg.sender || Operators[Tokens[_tokenId].owner][msg.sender] == true, "You are not authorized to transfer this NFT");
    _;
  }
  function isAdmin() public onlyAdmin returns(bool) {
    return true;
  }  

  function mintToken(string memory _name) public payable {
    require(msg.value >= price, "Insufficient payment to mint new Token");
    require(msg.value == price, "Exact payment required");
    require(Balances[msg.sender] + 1 > Balances[msg.sender], "Overflow error");
    uint256 id = count;
    count++;
    Balances[msg.sender]++;
    Token memory newToken = Token(id, _name, msg.sender);
    Tokens[id] = newToken;
    emit TokenMinted(address(msg.sender), _name, id);
  }

  // check number of nfts belonging to _owner
  function balanceOf(address _owner) external view returns (uint256){
    require(_owner != address(0), "Invalid address");
    return Balances[_owner];
  }

  // check owner of _tokenId
  function ownerOf(uint256 _tokenId) external view returns (address _owner) {
    return Tokens[_tokenId].owner;
  }

  // allow only owner to transfer an NFT
  function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable onlyOwner(_tokenId) isValidToken(_tokenId) {
    Balances[_from]--;
    Balances[_to]++;
    Tokens[_tokenId].owner = _to;
    Approvals[_tokenId] = address(0);
    emit Transfer(_from, _to, _tokenId);
  }

  // allow an authorized user to transfer a coin
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable isAuthorized(_tokenId) isValidToken(_tokenId) {
    Approvals[_tokenId] = address(0);
    Balances[_from]--;
    Balances[_to]++;
    Tokens[_tokenId].owner = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  // allows any authorized person to set the approved user of a token
  function approve(address _approved, uint256 _tokenId) external payable isAuthorized(_tokenId) isValidToken(_tokenId) {
    Approvals[_tokenId] = _approved;
    emit Approval(Tokens[_tokenId].owner, _approved, _tokenId);
  }

  // set sender's _operator status to true or false in Operators
  function setApprovalForAll(address _operator, bool _approved) external {
    Operators[msg.sender][_operator] = _approved;
    emit ApprovalForAll(msg.sender, _operator, _approved);
  }

  // get approved operator of _tokenId
  function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address)  {
    return Approvals[_tokenId];
  }
  // check if _operator is operator for _owner
  function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
    return Operators[_owner][_operator];
  }

}