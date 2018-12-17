pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;

import "./Provider.sol";
import "./Author.sol";
import "./SafeMath.sol";
import "./Signature.sol";

contract Medicines {
    using SafeMath for *;
    address  providerContractAddress;
    address  authorContractAddress;
    address signatureContractAddress;
    address public owner;
    uint exchangeRate = 10; // ti gia
    Providers pv;

    
    struct Medicine {
        uint id;
        string name; // 
        string ingredient; // include ... 
        string benefit; // uses for, function for 
        string by;
        string detail;
        uint prices;
        bytes imgHash;
        uint digitalId;
        bool isAllowed; // id of digitalCertificateId default = 0;
    }
    
    mapping (address => Medicine[])  medicines;
            //address is msg.sender , la thang provider nao call
    mapping (address => Medicine[])  medicinesUpdating;  // thang nay de luu data khi 1 thang muon update medicine;
    mapping (uint => uint) indexOf;
    // uint la id cua thang medine, value la vi tri cua no 
    mapping (uint => address) idIsProviderOf;
    // uint is medicine id, address is provider address;\
    
    
    
   
    event TransferOwnerShip(address indexed from, address indexed to);
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    

    
    modifier onlyAuthorised(address _addr) {  // check xem thằng gọi có phải author không
        Authorised _author = Authorised(authorContractAddress);
        require(_author.isAuthorised(_addr));
        _;
    }
    
    
    modifier onlyCallByAuthorContract(address _addr) {  // check only from author acc , check xem msg.sender duy nhat la thang author contract 
        require(msg.sender == authorContractAddress);
        _;
    }

    modifier onlyIdProviderOf(uint _id) { // check xem id truyen vao co dung cua thang msg.sender
        require(idIsProviderOf[_id] == msg.sender);
        _;
    }


    modifier isSignUpAndActiveProvider(address _addr) {  // call from Provider, check xem thang provider da sign up va acc da duoc kich hoat hay chua
        Providers _pv = Providers(providerContractAddress);
        bool istrue = _pv.isSignUpAndActiveCallByMedicine(_addr);
        require(istrue);
        _;
    }
    


    
    constructor () public  {
        owner = msg.sender;
    }

    function setAuthorAndProviderContractAddress(  // set addres cho thang author contract address va provider
        address _author,
        address _provider,
        address _signature
    ) 
        public
        onlyOwner
    {
        require(_author != 0x0);
        require(_provider != 0x0);
        require(_signature != 0x0);
        providerContractAddress = _provider;
        authorContractAddress = _author;
        signatureContractAddress = _signature;
    }


    function transferOwnerShip(address newOwner) public onlyOwner {
        require(newOwner != 0x0);
        owner = newOwner;
        emit TransferOwnerShip(msg.sender, owner);
    }
    
    function searchMedicineByID(
        uint _id
    )
        public
        view
        returns(Medicine, address)
    {
        require(_id != 0);
        uint _index = indexOf[_id];
        address _addr = idIsProviderOf[_id];
        return (medicines[_addr][_index], _addr);

    }

    function addMedicine(  // add mot medicne vao 1 thang provider
        string _name,
        string _ingredient,
        string _benefit,
        string _by,
        string _detail,
        uint _prices,
        bytes _imgHash,
        bytes32 _messageHash,
        bytes _signHash
    )
        public
        payable
        isSignUpAndActiveProvider(msg.sender)
    {
        require( msg.value >= exchangeRate);
        require(bytes(_name).length != 0);
        require(bytes(_ingredient).length != 0);
        require(bytes(_benefit).length != 0);
        require(bytes(_by).length != 0);
        require(bytes(_detail).length != 0);
        require(_prices > 0);
        if(msg.value > exchangeRate) {
            msg.sender.transfer(msg.value.sub(exchangeRate));
        }
        uint id = setDataBeforeAddMedicine(_name, _ingredient, _benefit, _by, _detail, _prices, _imgHash);
        callAuthorSubmitAddMedicine(id, 3, exchangeRate);
        setSignImgHash(_imgHash, _messageHash, _signHash, id); // ky vao cai anh nay
    }
    
    function callAuthorSubmitUpdateMedicine(  // goi den contract author de update medicne
        uint _id,
        uint8 _type
    )
        private
    {
        Authorised _author =  Authorised(authorContractAddress);
        _author.submitTransaction(_id, msg.sender, 0, _type); 
    }
    
    function callAuthorSubmitAddMedicine(
        uint _id,
        uint8 _type,
        uint _value
    )
        private
    {
        Authorised _author =  Authorised(authorContractAddress);
        authorContractAddress.transfer(_value);
         // send ether to author contract addres
        _author.submitTransaction(_id, msg.sender, _value, _type); 
    }

    function setDataBeforeAddMedicine( // for call addMedicine function
        string _name,
        string _ingredient,
        string _benefit,
        string _by,
        string _detail,
        uint _prices,
        bytes _imgHash
    )
        private
        returns(uint)
    {
        uint id = randomID(_name, _ingredient, _benefit, _by, _detail, _prices, _imgHash);
        Medicine memory _medicine = Medicine(id, _name, _ingredient, _benefit, _by, _detail, _prices, _imgHash, 0, false);
        indexOf[id] =  medicines[msg.sender].push(_medicine) - 1; // maping thang nay voi vi tri cua no
        idIsProviderOf[id] = msg.sender;
        return id ;
    }
    
    function setSignImgHash( // llu thoong tin provider ky len san pham cua minh 
        bytes _imgHash,
        bytes32 _messageHash,
        bytes _signHash,
        uint _id
    ) 
      private  
    {
        Signature _sig = Signature(signatureContractAddress);
        _sig.setimageSignature(msg.sender, _imgHash, _messageHash, _signHash, _id);
    }
    
    function approveSetImgHash(
        address _addr,
        bytes _imgHash,
        uint _id
    )
        private
    {
        Signature  _sig = Signature(signatureContractAddress);
        _sig.approveSetimageSignature(_addr,_imgHash,_id);
    }
        
    
    function updateMedicine(  // update thong tin cua 1 loai mediicne
        uint _id,
        string _name,
        string _ingredient,
        string _benefit,
        string _by,
        string _detail,
        uint _prices,
        bytes _imgHash,
        bytes32 _messageHash,
        bytes _signHash
    )
        public
        onlyIdProviderOf(_id)
        isSignUpAndActiveProvider(msg.sender)
    {
        require(bytes(_name).length != 0);
        require(bytes(_ingredient).length != 0);
        require(bytes(_benefit).length != 0);
        require(bytes(_by).length != 0);
        require(bytes(_detail).length != 0);
        require(_prices > 0);
        setDataBeforeUpdateMedicine(_id, _name, _ingredient, _benefit, _by, _detail, _prices, _imgHash, _messageHash, _signHash);
        callAuthorSubmitUpdateMedicine(_id, 4);
    }
    
    function setexchangeRate(
        uint _exchangeRate // wei  set so tien
    )
        public
        onlyOwner
    {
        require(exchangeRate > 0);
        exchangeRate = _exchangeRate;
    }
    
    
    function setDataBeforeUpdateMedicine( // setdata truoc khi update medicine
        uint _id,
        string _name,
        string _ingredient,
        string _benefit,
        string _by,
        string _detail,
        uint _prices,
        bytes _imgHash,
        bytes32 _messageHash,
        bytes _signHash
        
    ) 
     private
    {
        Medicine memory _me = Medicine(_id, _name, _ingredient, _benefit, _by, _detail, _prices, _imgHash,0, true);
        medicinesUpdating[msg.sender].push(_me);
        setSignImgHash(_imgHash, _messageHash, _signHash, _id);
    }
    
    
    function() public  payable  {
        revert();
    }
    
    function blockMedicine(
        uint _id
    )
        public  
        onlyAuthorised(msg.sender)
    {
        address  _addr = idIsProviderOf[_id];
        Authorised _author =  Authorised(authorContractAddress);
        bool _isBlock = _author.isBlocked(_id);
        uint _idsTran = _author.getIdsTransactionBlock(_id);
        if(_isBlock) {
            _author.confirmedTransaction(_idsTran);
        } else {
            _author.submitTransaction(_id, _addr, 0, 5);
        }
    }
    


    function approveAddMedicine( // for manger chap nhan add thuoc voi  id thuoc , va duoc add boi thang provider nao
        uint _id,
        address _from,
        uint _digitalID // provider address
    )
        external
        onlyCallByAuthorContract(msg.sender)
        isSignUpAndActiveProvider(_from)
    {
        require(_id != 0);
        require(_from != 0x0);
        uint _index = indexOf[_id];
        bytes memory _imgHash = medicines[_from][_index].imgHash;
        medicines[_from][_index].isAllowed = true;
        medicines[_from][_index].digitalId = _digitalID;
        approveSetImgHash(_from, _imgHash, _id);
    }
    
    
    function approveUpdateMedicine(
        uint _id,
        address _from
    )
        external
        onlyCallByAuthorContract(msg.sender)
        isSignUpAndActiveProvider(_from)
    {
        require(_id != 0);
        require(_from != 0x0);
        
        uint _index = indexOf[_id];
        uint indexUpdate; // lay ra vi tri thang luu  data from tu medicinesUpdating
        bytes memory _imgHash;
        for(uint i = 0; i < medicinesUpdating[_from].length; i++) {
            if(medicinesUpdating[_from][i].id == _id && medicinesUpdating[_from][i].isAllowed == true) {
                indexUpdate = i;
                 _imgHash = medicinesUpdating[_from][i].imgHash;
            }
        }
        medicinesUpdating[_from][indexUpdate].digitalId = medicines[_from][_index].digitalId;
        medicines[_from][_index] = medicinesUpdating[_from][indexUpdate];
        medicinesUpdating[_from][indexUpdate].isAllowed == false;
        approveSetImgHash(_from, _imgHash, _id);
    }
    
    function setDataWhenRefundEth(
        address _addr,
        uint _id
    )
        external
        onlyCallByAuthorContract(msg.sender)
    {
        
        Signature _sig = Signature(signatureContractAddress);
        _sig.imgRejected(_addr, _id);
    }
    
    function approveRejectUpdateMedicine(
        uint _id,
        address _from
    )
        external
        onlyCallByAuthorContract(msg.sender)
        isSignUpAndActiveProvider(_from)
    {
        require(_id != 0);
        require(_from != 0x0);
        for(uint i = 0; i < medicinesUpdating[_from].length; i++) {
            if(medicinesUpdating[_from][i].id == _id && medicinesUpdating[_from][i].isAllowed == true) {
                medicinesUpdating[_from][i].isAllowed = false;
            }
        }
    }
    
    function approveBlockMedicine(  // chap nhan viec xoa thuoc
        uint _id,
        address _from
    ) 
        external
        onlyCallByAuthorContract(msg.sender)
        isSignUpAndActiveProvider(_from)
    {
        require(_id != 0);
        require(_from != 0x0);
        uint _index = indexOf[_id];
        medicines[_from][_index].isAllowed = false;
    }
    
    function approveBlockAllMedicineOfProvider( // xoa tat ca thuoc cua 1 dia chia
        address _from
    )
        external
        onlyCallByAuthorContract(msg.sender)
    {
        require(_from != 0x0);
        for(uint i = 0; i < medicines[_from].length; i++) {
            medicines[_from][i].isAllowed = false;
        }
    }
    
    function getMedicinesByProvider(address _addr)
        public
        view
        returns(Medicine[])
    {
        return medicines[_addr];
    }
    
    function getMedicinesUpdadingByProvider(address _addr) 
        public
        view
        returns(Medicine[])
    {
        Medicine[] memory _me = new Medicine[](medicinesUpdating[_addr].length);
        uint _index = 0;
        for(uint i = 0; i < medicinesUpdating[_addr].length; i++) {
            if(medicinesUpdating[_addr][i].isAllowed == true) {
                _me[_index] = medicinesUpdating[_addr][i];
                _index++;
            }
        }
        return _me;
    }
    
    function unlockMedicine(
        uint _id
    )
        public
        onlyAuthorised(msg.sender)
    {
        address _addr = idIsProviderOf[_id];
        Authorised _author = Authorised(authorContractAddress);
        uint _idsTran = _author.getIdsTransactionUnlock(_id);
        bool _isUnlocked = _author.isUnlocked(_id);
        if(_isUnlocked) {
            _author.confirmedTransaction(_idsTran);
        } else {
            _author.submitTransaction(_id, _addr, 0, 7); // 7 is unlockMedicine   
        }
    }
    
    function approveUnlockMedicine(
        uint _id,
        address _addr
    )
        external
        onlyCallByAuthorContract(msg.sender)
    {
        require(_id != 0);
        require(_addr != 0x0);
        uint _index  = indexOf[_id];
        medicines[_addr][_index].isAllowed = true;
    }
    
    function approveUnlockAllMedicines(
        address _addr
    )
        external
        onlyCallByAuthorContract(msg.sender)
    {
        require(_addr != 0x0);
        for(uint i = 0; i < medicines[_addr].length; i++) {
            medicines[_addr][i].isAllowed = true;
        }
    }
    
    function getHistoryUpdateMedicine(
        address _addr,
        uint _id
    ) 
        public
        view
        returns(Medicine[])
    {

        uint[] memory _temp = new uint[](medicinesUpdating[_addr].length);
        uint count;
        for(uint i = 0; i < medicinesUpdating[_addr].length; i++) {
            if(medicinesUpdating[_addr][i].id == _id) {
                _temp[count] = i;
                count++;
            }
        }
        Medicine[] memory _me = new Medicine[](count);
        for(i = 0; i < _me.length; i++) {
            _me[i] = medicinesUpdating[_addr][_temp[i]];
        }
        return _me;
    }
    
    function verifyMedicine(
        address _owner,
        bytes32 _hash, 
        bytes32 r, 
        bytes32 s,
        uint8 v
    ) 
        external 
        pure 
        returns(bool)
    {
        bytes32 _recoverHash = prefixed(_hash);
        address _temp = ecrecover(_recoverHash, v, r, s);
        return _temp == _owner;
    }
    
    
    function prefixed(bytes32 _hash) private pure returns (bytes32) {
        return keccak256("\x19Ethereum Signed Message:\n32", _hash);
    }
    
    
    function randomID(  // random ra id
        string _param1,
        string _param2,
        string _param3,
        string _param4,
        string _param5,
        uint _param6,
        bytes _param7 
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
                                    _param5,
                                     _param6,
                                     _param7,
                                     now,
                                    msg.sender)) % (10 ** 16);
        return random;
    }

}
