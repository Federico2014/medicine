pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;
import "./Author.sol";
contract Reports {
    
    struct Report {
        uint id;
        address _from;
        address _reportAddress;
        string email;
        string street;
        string phone;
        string content;
        string reply;
        uint time;
        bool status;
    }
    
    address public owner;
    address authorContractAddress;
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyAuthorised(address _addr) {  // check xem thằng gọi có phải author không
        Authorised _author = Authorised(authorContractAddress);
        require(_author.isAuthorised(_addr));
        _;
    }
    event TransferOwnerShip(address indexed from, address indexed to);
    
    constructor () public {
        owner = msg.sender;
    }
    
    function transferOwnerShip(address newOwner) public onlyOwner {
        require(newOwner != 0x0);
        owner = newOwner;
        emit TransferOwnerShip(msg.sender, owner);
    }
    
    mapping(uint => mapping(address => bool))  reported;
    mapping(uint => Report[])  reports;
    
    modifier isReported(
        uint _id,
        address _addr
    ) 
    {
        require(!reported[_id][_addr]);
        _;
    }
    
    modifier onlyCallByAuthor(address _addr) {
        require(_addr != 0x0);
        require(_addr == authorContractAddress);
        _;
    }
    
    function accIsReported(uint _id, address _addr) public view returns(bool) {
        return reported[_id][_addr];
    }
    
    function viewReportInformation(
        uint _id  // id medicne or provider 
    )
        public
        view
        onlyAuthorised(msg.sender)
        returns(Report[])
    {
        return reports[_id];
    }
    
    function reportMedicine(
        uint _id, // id medicne or provider 
        address _addr, //provider address
        string _email, 
        string _street,
        string _phone,
        string _content
    )
        public
        isReported(_id, msg.sender)
    {
        require(_id != 0);
        require(_addr != 0x0);
        require(bytes(_email).length >0);
        require(bytes(_street).length >0);
        require(bytes(_phone).length >0);
        require(bytes(_content).length >0);
        callAuthorContractSendSubmitTransactions(_id, _addr);
        setDataBeforeReported(_id, _addr, _email, _street, _phone, _content);

 // Type 8 is Reported
        
    }
    
    function callAuthorContractSendSubmitTransactions(
        uint _id,
        address _addr
    )
        private
    {
        Authorised _author =  Authorised(authorContractAddress);
        if(reports[_id].length == 0) {
            _author.submitTransaction(_id, _addr, 0, 8);
        } else {
            if(reports[_id].length > 0 && reports[_id][reports[_id].length - 1].status == true) {
                _author.submitTransaction(_id, _addr, 0, 8);
            }
        }

    }
    
    function approveReport(
        uint _id,
        address _from,
        string _reply
    )
        external
        onlyCallByAuthor(msg.sender)
    {
        require(_id != 0);
        require(_from != 0);
        for(uint i = 0; i < reports[_id].length; i++) {
            if(reports[_id][i].status == false) {
                reports[_id][i].status = true;
                reports[_id][i].reply = _reply;
                address  _rpAddress = reports[_id][i]._reportAddress;
                reported[_id][_rpAddress] = false;
            } 
        }
    }
    
    function setDataBeforeReported(
        uint _id, // id medicne or provider 
        address _addr, //provider address
        string _email, 
        string _street,
        string _phone,
        string _content
    )
        private
    {
        reported[_id][msg.sender] = true;
        Report memory _report = Report({
                                    id: _id,
                                    _from: _addr,
                                    _reportAddress: msg.sender,
                                    email: _email,
                                    street: _street,
                                    phone: _phone,
                                    content: _content,
                                    reply:"",
                                    time: now,
                                    status: false
                                    });
        reports[_id].push(_report);
    }
    
    function setAuthorContract(address _author) public onlyOwner  {
        require(_author != 0x0);
        authorContractAddress = _author;
    }
    
    function viewReportDetail(
        uint _id
    )
        public
        view
        returns(Report[])
    {
        uint[] memory _temp = new uint[](reports[_id].length);
        uint count;
        for(uint i = 0; i < reports[_id].length; i++) {
            if(reports[_id][i]._reportAddress == msg.sender) {
                _temp[count] = i;
                count++;
            }
        }
        Report[] memory _report = new Report[](count);
        for(i = 0; i < count; i++) {
            _report[i]= reports[_id][_temp[i]];
        }
        
        return _report;
    }
    
    function viewReportNotExcute(
        uint _id,
        address _addr
    )
        public
        view
        onlyAuthorised(msg.sender)
        returns(Report[])
    {
        uint[] memory _temp = new uint[](reports[_id].length);
        uint count;
        for(uint i = 0; i < reports[_id].length; i++) {
            if(reports[_id][i].status == false) {
                _temp[count] = i;
                count++;
            }
        }
        Report[] memory _report = new Report[](count);
        for(i = 0; i < count; i++) {
            _report[i]= reports[_id][_temp[i]];
        }
        
        return _report;
    }
    
}
