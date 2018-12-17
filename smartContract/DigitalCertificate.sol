pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;
import "./Medicine.sol";

contract DigitalCertificates {
    address public owner;
    address  authorContractAddress;
    struct DigitalCertificate {
        uint idCertificate;
        string contents;  // contents
        uint dateOf;
        string by;
        address addr;
        uint medicineId;
        bool isActive;
    }
    
    mapping(address => DigitalCertificate[])  digitalcertificates; // 1 address của provider sẽ có 1 list các digitalcertificates  // luu trữ tạm khi muốn block 1 digitalcertificate

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyCallByAuthorContract(address _addr) { // chỉ có thế gọi bởi contract Author
        require(_addr == authorContractAddress);
        _;
    }

    event TransferOwnerShip(address indexed from, address indexed to);
    
    constructor () public {
        owner = msg.sender;
    }
    
    function transferOwnerShip(address newOwner) public onlyOwner {  // chuyển quyền owner
        require(newOwner != 0x0);
        owner = newOwner;
        emit TransferOwnerShip(msg.sender, owner);
    }
    
    function setAuthorContractAddress(  // set author contract address 
        address _author
    ) 
        public
        onlyOwner
    {
        require(_author != 0x0);
        authorContractAddress = _author;
    }
    
    function getDigitalCertificateByProviderAddress(address _addr)  // get ra thông tin digital của 1 adrsss provider
        public
        view
        returns(DigitalCertificate[])
    {
        return digitalcertificates[_addr];
    }

    function addDigitalCertificate(  // add thêm 1 digitalcertificates khi nó dã được approve 
        address _from, // address của provider
        uint _id  // id cua medicine
    )
        external
        onlyCallByAuthorContract(msg.sender)
        returns(uint)
    {
        uint id = randomID("param1", now, "param3", _from, _id, now);
        DigitalCertificate memory _certificate = DigitalCertificate(id, "Chứng chỉ đủ khả năng bán thuốc", now, "Care of Heath", _from, _id, true);
        digitalcertificates[_from].push(_certificate);
        return id;
    }
    
    function getDigitalCertifiCateByMedicineId(  // get ra thông tin của 1 chứng chỉ  của 1 medicineId 
        uint _id, 
        address _from
    ) 
        public
        view
        returns(DigitalCertificate)
    {
        for(uint i = 0; i < digitalcertificates[_from].length; i++) {
            if(digitalcertificates[_from][i].medicineId == _id) {
                return digitalcertificates[_from][i];
            }
        }
    }
    
    function approveBlockDigitalCertificate( // manger approve block digitalcertificates;
        uint _id,  // id medicineId
        address _from  // provider address
    )
        external
        onlyCallByAuthorContract(msg.sender)
    {
        require(_id != 0);
        require(_from != 0x0);
        for(uint i = 0; i < digitalcertificates[_from].length; i++) {
            if(digitalcertificates[_from][i].medicineId == _id) {
                digitalcertificates[_from][i].isActive = false;
            }
        }
    }
    
    function approveBlockAllDigitalCertificateOfProvider( // khoa tat ca cac chung chi cua 1 provider 
        address _from
    )
        external
        onlyCallByAuthorContract(msg.sender)
    {
        require(_from != 0x0);
        for(uint i = 0; i < digitalcertificates[_from].length; i++) {
            digitalcertificates[_from][i].isActive = false;
        }
    }
    
    function approveUnlockDigitalCertificate(  // mo lai chung chi 
        uint _id,
        address _from
    )
        external
        onlyCallByAuthorContract(msg.sender)
    {
        require(_id != 0);
        require(_from != 0x0);
        for(uint i = 0; i < digitalcertificates[_from].length; i++) {
            if(digitalcertificates[_from][i].medicineId == _id) {
                digitalcertificates[_from][i].isActive = true;
            }
        }
    }
    
    function approveUnlockAllDigitalCertificatesOfProvider(  // mo lai chung chi cho 1 thang provider
        address _from
    )
        external
        onlyCallByAuthorContract(msg.sender)
    {
        require(_from != 0x0);
        for(uint i = 0; i < digitalcertificates[_from].length; i++) {
            digitalcertificates[_from][i].isActive = true;
        }
    }
    
    
    
    
    
    
    function() public payable {
        revert();
    }
    
    
    
    function randomID(  // random ra id
        string _param1,
        uint _param2,
        string _param3,
        address _param4,
        uint _param5,
        uint _param6
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
                                    now, 
                                    msg.sender)) % (10 ** 16);
        return random;
    }
}
