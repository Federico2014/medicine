pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;

import "./Provider.sol";
import "./Medicine.sol";

contract Signature {
    
    struct Signatures {
        bytes32 messageHash;
        bytes signHash;
        bool isActive;
        uint id;
    }
    
    address medicineContractAddress;
    address providerContractAddress;
    address authorContractAddress;
    address public owner;
    event TransferOwnerShip(address indexed from, address indexed to);
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    
    function transferOwnerShip(address newOwner) public onlyOwner {
        require(newOwner != 0x0);
        owner = newOwner;
        emit TransferOwnerShip(msg.sender, owner);
    }
    
    constructor () public  {
        owner = msg.sender;
    }
    
    function() public payable{
        revert();
    }
    mapping(address => mapping(bytes32 => Signatures)) signaturesByAddrress;
    mapping(bytes32 => Signatures) signatures;
    mapping(uint => bytes32) isIdsOf;
    
    modifier notExist(bytes _imgHash, uint _id) {
        require(signatures[keccak256(_imgHash)].isActive == false || signatures[keccak256(_imgHash)].id == _id ); // chek xem cai anh nay co trong he thong chua
        _;
    }
    
    modifier imgYourSelfSign(address _addr, bytes _imgHash, uint _id) {
        require(signaturesByAddrress[_addr][keccak256(_imgHash)].isActive == false || signaturesByAddrress[_addr][keccak256(_imgHash)].id == _id ); // chek xem thang nay da send cai anh nay len transaction chua
        _;
    }
    
    modifier onlyCallFromMP(address _addr) {
        require(_addr == medicineContractAddress || _addr == providerContractAddress);
        _;
    }
    
    modifier onlyCallByAuthor(address _addr) {
        require(_addr == authorContractAddress || _addr == providerContractAddress || _addr == medicineContractAddress );
        _;
    }
    

    
    function setMedicineAndProviderContractAddress(
        address _medicine,
        address _provider,
        address _author
    )
        public
        onlyOwner()
    {
        medicineContractAddress = _medicine;
        providerContractAddress = _provider;
        authorContractAddress = _author;
    }
        
    
    function isImgYourSelfSign(address _addr, bytes _imgHash)  // kiem tra xem 1 thang provider no da gui cai anh nay chua
        public
        view
        returns(bool)
    {
        return signaturesByAddrress[_addr][keccak256(_imgHash)].isActive;  // true  tuc la da gui roi, fale tuc la chua gui
    }
    function setimageSignature( // push vao 1 hang cho
        address _addr,
        bytes _imgHash,
        bytes32 _messageHash,
        bytes _signHash,
        uint _id
    )
        external
        onlyCallFromMP(msg.sender)
        notExist(_imgHash, _id)
    {
        require(_imgHash.length > 0);
        require(_messageHash.length > 0);
        require(_signHash.length > 0);
        require(_id > 0);
        require(signaturesByAddrress[_addr][keccak256(_imgHash)].isActive == false || signatures[keccak256(_imgHash)].id == _id  );
        Signatures memory _sig = Signatures(_messageHash, _signHash, true, _id);
        signaturesByAddrress[_addr][keccak256(_imgHash)] = _sig;
        isIdsOf[_id] = keccak256(_imgHash);
    }
    
    function approveSetimageSignature(
        address _addr,
        bytes _imgHash,
        uint _id
    )
        onlyCallFromMP(msg.sender)
        notExist(_imgHash, _id)
        external
    {
        require(_addr != 0x0);
        require(_imgHash.length > 0);
        signatures[keccak256(_imgHash)] = signaturesByAddrress[_addr][keccak256(_imgHash)];
        signaturesByAddrress[_addr][keccak256(_imgHash)].isActive = false;
    }
    
    function imgRejected(
        address _addr, 
        uint _id
    )
        external
        onlyCallByAuthor(msg.sender) 
    {
        require(_addr != 0x0);
        require(_id > 0);
        signaturesByAddrress[_addr][isIdsOf[_id]].isActive = false;
    }
    
    function imgNotExist(bytes _imgHash, uint _id) 
        public
        view
        returns(bool)
    {
        if(signatures[keccak256(_imgHash)].isActive == false||signatures[keccak256(_imgHash)].id == _id) {
            return true;
        }
        return false;
    }
    
    function getimgSignatureInfor(bytes _imgHash) 
        public 
        view
        returns(Signatures)
    {
        return signatures[keccak256(_imgHash)];
    }
     
}
