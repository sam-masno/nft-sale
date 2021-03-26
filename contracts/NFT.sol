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
    mapping (address => mapping(address => bool)) FullApprovals;

    constructor(address payable _owner, string memory _name, string memory _version, uint256 _price) public {
      name = _name;
      version = _version;
      admin = _owner;
      price = _price;
    }

  /// @dev This emits when ownership of any NFT changes by any mechanism.
  ///  This event emits when NFTs are created (`from` == 0) and destroyed
  ///  (`to` == 0). Exception: during contract creation, any number of NFTs
  ///  may be created and assigned without emitting Transfer. At the time of
  ///  any transfer, the approved address for that NFT (if any) is reset to none.
  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

  /// @dev This emits when the approved address for an NFT is changed or
  ///  reaffirmed. The zero address indicates there is no approved address.
  ///  When a Transfer event emits, this also indicates that the approved
  ///  address for that NFT (if any) is reset to none.
  event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

  /// @dev This emits when an operator is enabled or disabled for an owner.
  ///  The operator can manage all NFTs of the owner.
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

  function isAdmin() public onlyAdmin returns(bool) {
    return true;
  }  

  function mintToken(string memory _name) public payable {
    require(msg.value >= price, "Insufficient payment to mint new Token");
    require(msg.value == price, "Exact payment required");
    require(Balances[address(msg.sender)] + 1 > Balances[address(msg.sender)], "Overflow error");
    uint256 id = count;
    count++;
    Balances[address(msg.sender)]++;
    Token memory newToken = Token(id, _name, address(msg.sender));
    Tokens[id] = newToken;
    emit TokenMinted(address(msg.sender), _name, id);
  }

  /// @notice Count all NFTs assigned to an owner
  /// @dev NFTs assigned to the zero address are considered invalid, and this
  ///  function throws for queries about the zero address.
  /// @param _owner An address for whom to query the balance
  /// @return The number of NFTs owned by `_owner`, possibly zero
  function balanceOf(address _owner) external view returns (uint256){
    require(_owner != address(0), "Invalid address");
    return Balances[_owner];
  }

  /// _tokenId The identifier for an NFT
  /// @return The address of the owner of the NFT
  function ownerOf(uint256 _tokenId) external view returns (address _owner) {
    return Tokens[_tokenId].owner;
  }

  /// @notice Transfers the ownership of an NFT from one address to another address
  /// @dev Throws unless `msg.sender` is the current owner, an authorized
  ///  operator, or the approved address for this NFT. Throws if `_from` is
  ///  not the current owner. Throws if `_to` is the zero address. Throws if
  ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
  ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
  ///  `onERC721Received` on `_to` and throws if the return value is not
  ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
  /// @param _from The current owner of the NFT
  /// @param _to The new owner
  /// @param _tokenId The NFT to transfer
  function safeTransferFrom(address _from, address _to, uint256 _tokenId) public payable onlyOwner(_tokenId) isValidToken(_tokenId) {
    Balances[_from]--;
    Balances[_to]++;
    Tokens[_tokenId].owner = _to;
    Approvals[_tokenId] = address(0);
    emit Transfer(_from, _to, _tokenId);
  }

  /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
  ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
  ///  THEY MAY BE PERMANENTLY LOST
  /// @dev Throws unless `msg.sender` is the current owner, an authorized
  ///  operator, or the approved address for this NFT. Throws if `_from` is
  ///  not the current owner. Throws if `_to` is the zero address. Throws if
  ///  `_tokenId` is not a valid NFT.
  /// @param _from The current owner of the NFT
  /// @param _to The new owner
  /// @param _tokenId The NFT to transfer
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {

  }

  /// @notice Change or reaffirm the approved address for an NFT
  /// @dev The zero address indicates there is no approved address.
  ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
  ///  operator of the current owner.
  /// @param _approved The new approved NFT controller
  /// @param _tokenId The NFT to approve
  function approve(address _approved, uint256 _tokenId) external payable {

  }

  /// @notice Enable or disable approval for a third party ("operator") to manage
  ///  all of `msg.sender`'s assets
  /// @dev Emits the ApprovalForAll event. The contract MUST allow
  ///  multiple operators per owner.
  /// @param _operator Address to add to the set of authorized operators
  /// @param _approved True if the operator is approved, false to revoke approval
  function setApprovalForAll(address _operator, bool _approved) external {

  }

  /// @notice Get the approved address for a single NFT
  /// @dev Throws if `_tokenId` is not a valid NFT.
  /// @param _tokenId The NFT to find the approved address for
  /// @return The approved address for this NFT, or the zero address if there is none
  function getApproved(uint256 _tokenId) external view returns (address) {

  }

  /// @notice Query if an address is an authorized operator for another address
  /// @param _owner The address that owns the NFTs
  /// @param _operator The address that acts on behalf of the owner
  /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
  function isApprovedForAll(address _owner, address _operator) external view returns (bool) {

  }

}