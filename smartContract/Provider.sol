pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;

import "./Owner.sol";
import "./Medicine.sol";
import "./Author.sol";
import "./SafeMath.sol";
import "./Signature.sol";

contract Providers is Owner {
    using SafeMath for *;
    address  authorContractAddress;
    address  medicneContractAddrees;
    address signatureContractAddress;
    address[]  providerAddress;
    struct Provider {
        address addr;
        uint id;
        string name;
        string street;
        string phone;
        bytes imgHash;
        bool isActive;
    }

    mapping (address => Provider) public provider; // key address is msg.sender  
    mapping (address => Provider[]) public providerUpdating; 
        // waiiting for change value
    modifier onlyNotSignup(address _addr) {  // check acc  is 
        require(provider[_addr].addr == 0x0);
        _;
    }
    
    modifier onlySignup(address _addr) {  // check acc  is 
        require(provider[_addr].addr != 0x0);
        _;
    }
    
    modifier onlyAuthorised(address _addr) {  // check xem thằng gọi có phải author không
        Authorised _author = Authorised(authorContractAddress);
        require(_author.isAuthorised(_addr));
        _;
    }

    modifier onlyCallByAuthorContract(address _addr) {  // check only from author acc , check xem msg.sender duy nhat la thang author contract 
        require(_addr == authorContractAddress);
        _;
    }

    modifier onlyCallByMedicineContract(address _addr) {
        require(_addr == medicneContractAddrees);
        _;
    }

    modifier onlyActive(address _addr) {  // check acc is active
        require(provider[_addr].isActive == true);
        _;
    }

    function isSignUpAndActiveCallByMedicine(
        address _addr
    ) 
        public
        view
        onlyCallByMedicineContract(msg.sender)
        returns(bool)
    {
        if(provider[_addr].isActive == true && provider[_addr].addr != 0x0) {
            return true;  // neu da dang ky va acc da duoc kich hoat thi return true
        }
        return false;
    } 

    function setAuthorAndMedicneContractAddrees(  // for set author contract address
        address _author,
        address _medicine,
        address _signature
    )
        public
        onlyOwner
        returns(bool)
    {
        require(_author != 0x0);
        require(_medicine != 0x0);
        require(_signature != 0x0);
        signatureContractAddress = _signature;
        authorContractAddress = _author;
        medicneContractAddrees = _medicine;
        return true; 
    }
    function signUpProvider( // for Provider sign up 
        string _name,
        string _street,
        string _phone,
        bytes _imgHash,
        bytes32 _messageHash,
        bytes _signHash
    )
        public
        payable
        onlyNotSignup(msg.sender)
    {
        require(authorContractAddress != 0x0);
        require(bytes(_name).length != 0);
        require(bytes(_street).length != 0);
        require(bytes(_phone).length != 0);
        require(_imgHash.length != 0);
        require( msg.value >= 10 wei);
        if(msg.value > 10 wei) {
            msg.sender.transfer(msg.value.sub(10 wei));
        }
        uint id = randomID(_name, _street, _phone, _imgHash);
        setDataBeforeSignUp(_name, _street, _phone, _imgHash, _messageHash, _signHash, id);
        Authorised _author =  Authorised(authorContractAddress);
        authorContractAddress.transfer(10 wei); // send value to smart contract;
        _author.submitTransaction(id, msg.sender, msg.value, 0); // indentifier, from, value, ,, type  goi tu contract Author
    }
    
    function setDataBeforeSignUp(
        string _name,
        string _street,
        string _phone,
        bytes _imgHash,
        bytes32 _messageHash,
        bytes _signHash,
        uint _id
    )
        private
    {

        Provider memory _provider = Provider(msg.sender, _id, _name, _street, _phone, _imgHash, false); // set back to false
        provider[msg.sender] = _provider;
        providerAddress.push(msg.sender);
        Signature _sig = Signature(signatureContractAddress);
        _sig.setimageSignature(msg.sender, _imgHash, _messageHash, _signHash, _id);
    }
    
    function() public  payable  {
        revert();
    }


    function updateProvider(
        uint _id, // for provider update with address of
        string _name,
        string _street,
        string _phone,
        bytes _imgHash,
        bytes32 _messageHash,
        bytes _signHash
        
    )
        public
        onlyActive(msg.sender)
    {
        require(bytes(_name).length != 0);
        require(bytes(_street).length != 0);
        require(bytes(_phone).length != 0);
        require(_imgHash.length != 0);
        providerUpdating[msg.sender].push(Provider(provider[msg.sender].addr, _id, _name, _street, _phone,_imgHash, true)) ;
        Authorised _author = Authorised(authorContractAddress);
        _author.submitTransaction(_id, msg.sender, 0, 1);
        Signature  _sig = Signature(signatureContractAddress);
        _sig.setimageSignature(msg.sender, _imgHash, _messageHash, _signHash, _id);
    }
    

    function approveUpdateProvider(  // for manger  updte infor provider
        address _addr
    )
        external
        onlyCallByAuthorContract(msg.sender)
    {
        require(_addr != 0x0);
        uint _index;
        for(uint i = 0; i < providerUpdating[_addr].length; i++) {
            if(providerUpdating[_addr][i].isActive == true) {
                _index = i;
            }
        }
        provider[_addr] = providerUpdating[_addr][_index];
        providerUpdating[_addr][_index].isActive = false;
        Signature  _sig = Signature(signatureContractAddress);
        _sig.approveSetimageSignature(_addr,provider[_addr].imgHash, provider[_addr].id );
    }
    
    function setDataWhenRefundEth(
        address _addr
    )
        external
        onlyCallByAuthorContract(msg.sender)
    {
        Signature _sig = Signature(signatureContractAddress);
        _sig.imgRejected(_addr, provider[_addr].id);
        delete provider[_addr];
        delete providerUpdating[_addr];
    }
    
    function getUpdateProviderHistory(
        address _addr
    )
        public
        view
        returns(Provider[])
    {
        return providerUpdating[_addr];
    }
    
    function blockProvider( // for manger block account provider
        uint _id,
        address _addr
    )
        public
        onlyActive(_addr)
        onlyAuthorised(msg.sender)
        
    {
        Authorised _author =  Authorised(authorContractAddress);
        bool _isBlock = _author.isBlocked(_id);
        uint _idsTran = _author.getIdsTransactionBlock(_id);
        if(_isBlock) {
            _author.confirmedTransaction(_idsTran);
        } else {
             _author.submitTransaction(_id, _addr, 0, 2); 
        }
    }
    
    function unlockProvider(  // for manger unlock
        uint _id,
        address _addr
    )
        public
        onlyAuthorised(msg.sender)
    {
        Authorised _author = Authorised(authorContractAddress);
        uint _idsTran = _author.getIdsTransactionUnlock(_id);
        bool _isUnlocked = _author.isUnlocked(_id);
        if(_isUnlocked) {
            _author.confirmedTransaction(_idsTran);
        } else {
            _author.submitTransaction(_id, _addr, 0, 6);
        }
        
    }
    
    function approveUnlockProvider(
        address _addr
    )
        external
        onlyCallByAuthorContract(msg.sender)
    {
        provider[_addr].isActive = true;
    }
    
    function approverBlockProvider(
        address _addr
    )
        external
        onlyActive(_addr)
        onlyCallByAuthorContract(msg.sender)
    {
        provider[_addr].isActive = false;
    }
    
    
    
    function approveSignUpProvider( // for manger approver sigup account from provider;
        address _addr
    )
        external
        onlySignup(_addr)
        onlyCallByAuthorContract(msg.sender)
    {
        require(_addr != 0x0);
        provider[_addr].isActive = true;
        Signature  _sig = Signature(signatureContractAddress);
        _sig.approveSetimageSignature(_addr,provider[_addr].imgHash, provider[_addr].id );
    }
    
    function getProviderInfor(address _addr) 
        public
        view
        returns(Provider)
    {
        return provider[_addr];
    }
    
    function searchProviderById(
        uint _id
    )
        public
        view
        returns(Provider)
    {
        for(uint i = 0; i < providerAddress.length; i++) {
            if(provider[providerAddress[i]].id == _id) {
                return provider[providerAddress[i]];
            }
        }
    }
    
    
    function randomID(  // random ra id
        string _param1,
        string _param2,
        string _param3,
        bytes _param4
    ) 
        private
        view
        returns(uint) 
    {
        uint random = uint(keccak256(
                                    _param1, 
                                    _param2, 
                                    _param3, 
                                    _param4,
                                    now, 
                                    msg.sender)) % (10 ** 16);
        return random;
    }
}
