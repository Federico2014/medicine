pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;

import "./Owner.sol";
import "./Provider.sol";
import "./Medicine.sol";
import "./DigitalCertificate.sol";
import "./SafeMath.sol";
import "./Report.sol";
import "./Signature.sol";

contract Authorised is Owner {
    using SafeMath for *;
    
    address  providerContractAddress;
    address  medicineContractAddress;
    address  certificateContractAddress;
    address reportContractAddress;
    address signatureContractAddress;
    address[] public owners;
    mapping(address => bool) authorised;
    uint8 maxAuthorisedNumber = 10;
    uint8 totalRequired = 1;
    uint timeMaxWaitting = 1 seconds; // thoi gian cho` xu ly 3 thang

    struct Transaction {
        uint identifier;  // id của provider hoặc medicine hoặc id digitalcertificate
        address From; // address provider
        uint value;  // eth send
        uint8 numberOfComfirmed;  // so luong confirm
        uint8 numberReject; // so luong tu choi 
        uint8 Type;    // loai Transaction
        uint time;  // thoi gian send transaction 
        bool status; // trạng thái đã được exexxcute hay chưa 
        //0 is insert provider, 1 is update provider,2 is block provider, 3 is insert medicine, 4 is update medicine, 5 is block medicine
        //6 is unlock provider // 7 is unlock digital 
    }

    mapping(uint => Transaction) transactions;
    mapping(uint => mapping(address => bool)) confirmations; // check xem 1 address da confirmations transsaction
    mapping(uint => mapping(address => bool)) rejects; //  check xem 1 address da rejects transaction 
    mapping(address => uint[]) listRefund;
    mapping(uint => bool) blocked;
    mapping(uint => bool) unlocked;
    mapping(uint => uint) idsTransactionBlocked;
    mapping(uint => uint) idsTransactionUnlocked;
    
    
    uint public  transactionCount = 0;

    modifier onlyCallByProviderContract(address _addr) {
        require(_addr == providerContractAddress);
        _;
    }

    modifier onlyAuthorised() {
        require(authorised[msg.sender] || msg.sender == providerContractAddress || msg.sender == medicineContractAddress);
        _;
    }

    modifier validRequirement(
        uint8 _maxAuthoriseNumber, 
        uint8 _totalRequired
    ) 
    {
        require(_totalRequired < _maxAuthoriseNumber && _totalRequired != 0 && _maxAuthoriseNumber != 0);
        _;
    }

    modifier transactionExists(uint _identifier) {
        Transaction storage _trans = transactions[_identifier];
        require(_trans.From != 0x0);
        _;
    }

    modifier notConfirmedAndReject(uint _identifier, address _owner) {
        require(!confirmations[_identifier][_owner] && !rejects[_identifier][_owner]);
        _;
    }

    modifier notExecuted(uint _identifier) {
        Transaction storage _trans = transactions[_identifier];
        require(_trans.status == false);
        _;
    }

    constructor(
        address[] _owners,
        uint8 _maxAuthoriseNumber, 
        uint8 _totalRequired
    ) 
        validRequirement(_maxAuthoriseNumber, _totalRequired) 
        public
        payable
    {
        require(_owners.length <= _maxAuthoriseNumber);
        maxAuthorisedNumber = _maxAuthoriseNumber;
        totalRequired = _totalRequired;
        for(uint i = 0; i < _owners.length; i++) {
            authorised[_owners[i]] = true;
        }
        
        owners = _owners;
    }
    
    function() public payable {}
    
    function isBlocked(uint _id) public view returns(bool) {
        return blocked[_id]; // dung de call xem thang id nay co dang duoc blocked khong ;;
    }
    
    function isUnlocked(uint _id) public view returns(bool) {
        return unlocked[_id];
    }
    
    function getBalances() public view returns(uint) {
        return address(this).balance;
    }
    
    function setProviderAndMedicineAndCertificateContractAddress(
        address _provider,
        address _medecine,
        address _certificate,
        address _report,
        address _signature
    )
        public
        onlyOwner
    {
        require(_provider != 0x0);
        require(_medecine != 0x0);
        require(_certificate != 0x0);
        require(_report != 0x0);
        require(_signature != 0x0);
        providerContractAddress = _provider;
        medicineContractAddress = _medecine;
        certificateContractAddress = _certificate;
        reportContractAddress = _report;
        signatureContractAddress = _signature;
    }

    function authorisedAccount(
        address _owner
    ) 
        onlyOwner 
        public 
    {
        address[] memory _owners = getTotalAuthoried();
        require(_owners.length < maxAuthorisedNumber);
        require(!authorised[_owner]);
        authorised[_owner] = true;
        owners.push(_owner);
    }

    function authorisedManyAccount(
        address[] _owners
    ) 
        onlyOwner 
        public 
    {
        address[] memory _owners1 = getTotalAuthoried();
        require((_owners.length + _owners1.length) <= maxAuthorisedNumber);
        for(uint8 i = 0; i < _owners.length; i++) {
            owners.push(_owners[i]);
            authorised[_owners[i]] = true;
        } 
    }

    function setRequireAndMaxOwners(
        uint8 _require,
        uint8 _maxOwners
    )
        public
        onlyOwner
        validRequirement(_maxOwners, _require)
    {
        maxAuthorisedNumber = _maxOwners;
        totalRequired = _require;
    }



    function blockAccount(
        address _owner
    ) 
        onlyOwner 
        public {
        require(authorised[_owner]);
        authorised[_owner] = false;
    }

    function blockManyAccount(
        address[] _owners
    ) 
        onlyOwner 
        public 
    {
        for(uint8 i = 0; i < _owners.length; i++) {
            if(authorised[_owners[i]]) {
                authorised[_owners[i]] = false;
            }
        }
    }

    function getTotalAuthoried() 
        public 
        view 
        returns(address[]) 
    {
        address[] memory _tempOwners = new address[](owners.length);
        
        uint count = 0;
        uint i;
        
        for(i = 0; i < owners.length; i++) {
            if(authorised[owners[i]]) {
                _tempOwners[count] = owners[i];
                count += 1;
            }
        }
        
        address[] memory _owners = new address[](count);
        
        for(i = 0; i < count; i++) {
            _owners[i] = _tempOwners[i];
        }

        return _owners;
    }
    
    function submitTransaction(
        uint _identifier, 
        address _from, 
        uint _value,
        uint8 _type,
        address _author
    ) 
        public 
    {
        Transaction memory _trans = Transaction({
            identifier: _identifier,
            From: _from,
            value: _value,
            numberOfComfirmed: 0,
            numberReject: 0,
            Type: _type,
            time: now,
            status: false
        });


        
        if(_trans.Type == 4 || _trans.Type == 1  || _trans.Type == 2 || _trans.Type == 6 || _trans.Type == 7 || _trans.Type == 5) {
            for(uint i = 0; i < transactionCount; i++) {
                if(transactions[i].identifier == _identifier && transactions[i].Type == _trans.Type) {
                        require(isExecuted(i));
                }
            }                
        }
        if(_trans.Type == 2 || _trans.Type == 5) {
            idsTransactionBlocked[_trans.identifier] = transactionCount;   
            blocked[_trans.identifier] = true;
            confirmations[transactionCount][_author] = true;
            _trans.numberOfComfirmed += 1;
            
        }
        if(_trans.Type == 6 || _trans.Type == 7 ) {
            idsTransactionUnlocked[_trans.identifier] = transactionCount;
            unlocked[_trans.identifier] = true;
            confirmations[transactionCount][_author] = true;
            _trans.numberOfComfirmed += 1;
        }
        transactions[transactionCount] = _trans;
        transactionCount += 1;
    }
    
    function getIdsTransactionBlock(
        uint _id
    )   
        public
        view
        returns(uint)
    {
        return idsTransactionBlocked[_id];
    }
    
        
    function getIdsTransactionUnlock(
        uint _id
    )   
        public
        view
        returns(uint)
    {
        return idsTransactionUnlocked[_id];
    }

    function confirmedTransaction(
        uint _identifier
    ) 
        public
        transactionExists(_identifier)
        notConfirmedAndReject(_identifier, msg.sender) 
        notExecuted(_identifier)
        onlyAuthorised() 

    {
        require(medicineContractAddress != 0x0);
        require(providerContractAddress != 0x0);
        require(certificateContractAddress != 0x0);
        require(signatureContractAddress != 0x0);
        require(reportContractAddress != 0x0);
        Transaction storage _trans = transactions[_identifier];

        _trans.numberOfComfirmed += 1;
        confirmations[_identifier][msg.sender] = true;
         //0 is insert provider, 1 is update provider,2 is block provider, 3 is insert medicine, 4 is update medicine, 5 is delete medicine
        if(_trans.numberOfComfirmed >= totalRequired && _trans.numberReject < totalRequired) {
            _trans.status = true;
            Providers _provider = Providers(providerContractAddress);
            Medicines _medecine = Medicines(medicineContractAddress);
            DigitalCertificates _certifi = DigitalCertificates(certificateContractAddress);
            Reports _report = Reports(reportContractAddress);
            if(_trans.Type == 0  && _trans.value > 0) { 
                _provider.approveSignUpProvider(_trans.From); // chap nhan dang ky provider
            }else if(_trans.Type == 1) { 
                _provider.approveUpdateProvider(_trans.From); // chap nhan update provider
            }else if(_trans.Type == 2) { 
                _provider.approverBlockProvider(_trans.From); // chap nhan block provider
                _medecine.approveBlockAllMedicineOfProvider(_trans.From);
                _certifi.approveBlockAllDigitalCertificateOfProvider(_trans.From);
                blocked[_trans.identifier] = false;
            } else if(_trans.Type == 3  && _trans.value > 0 ) { // 3 is add medicine
                uint _digitalID = _certifi.addDigitalCertificate(_trans.From, _trans.identifier); // chap nhan add thuoc
                _medecine.approveAddMedicine(_trans.identifier, _trans.From, _digitalID);
            } else if(_trans.Type == 4) {
                _medecine.approveUpdateMedicine(_trans.identifier, _trans.From);  // chap nhan update thuoc
            } else if(_trans.Type == 5) {
                _medecine.approveBlockMedicine(_trans.identifier, _trans.From);
                _certifi.approveBlockDigitalCertificate(_trans.identifier , _trans.From);
                blocked[_trans.identifier] = false;// chap nhan block medicine
            } else if(_trans.Type == 6) {
                _provider.approveUnlockProvider(_trans.From);  // chap nhan unlock provider 
                _certifi.approveUnlockAllDigitalCertificatesOfProvider(_trans.From);
                _medecine.approveUnlockAllMedicines(_trans.From);
                unlocked[_trans.identifier] = false;
                // goi them thang medicine o day 
            } else if(_trans.Type == 7) {  // unlock 1 thang medicine
                _medecine.approveUnlockMedicine(_trans.identifier, _trans.From);
                _certifi.approveUnlockDigitalCertificate(_trans.identifier, _trans.From);
                unlocked[_trans.identifier] = false;
            } else if(_trans.Type == 8) {
                _report.approveReport(_trans.identifier, _trans.From,
                                      "Chúng tôi đã xác nhận việc report của bạn là chính xác, lạiChúng tôi sẽ sớm Liên hệ lại"  
                                    );
                
            }
        }
        
    }
    
    function changeTimeWaitting(
        uint _time
    )
        public
        onlyOwner
    {
        require(_time > 0);
        timeMaxWaitting = _time;
    }

    function getAllProviderAdressOfTransactionsIDs(
    )
        public
        view
        returns(uint[])
    {
        uint[] memory temp = new uint[](transactionCount);
        uint count;
        for(uint i = 0; i < transactionCount; i++) {
            if(transactions[i].From == msg.sender) {
                temp[count] = i;
                count++;
            }
        }

        uint[] memory _transactionsID = new uint[](count);
        for( i = 0; i < _transactionsID.length; i++) {
            _transactionsID[i] = temp[i];
        }
        return _transactionsID;
    }
    
    function getTransactionStatus(
        uint _id
    )
        public
        view
        returns(uint)
    {
        for(uint i = 0; i < transactionCount; i++) {
            if(transactions[i].identifier == _id) {
                if(transactions[i].numberOfComfirmed < totalRequired && 
                   transactions[i].numberReject < totalRequired &&
                   transactions[i].status == false
                ) 
                {
                    return 0; // waitting
                }
                
                if(transactions[i].numberReject < totalRequired  && transactions[i].status == true) {
                    return 1; // confirmed
                }
                
                if(transactions[i].numberOfComfirmed < totalRequired && transactions[i].status == true) {
                    return 2; // rejects
                }
                
            }
        }
    }
    
    

    
    function isAuthorised(address _addr)
        public
        view
        returns(bool)
    {
        return authorised[_addr];
    }
    
    function rejectTransaction(
        uint _id // id transactions
    )
        public
        transactionExists(_id)
        notConfirmedAndReject(_id, msg.sender) 
        notExecuted(_id)
        onlyAuthorised()
    {
        require(medicineContractAddress != 0x0);
        require(providerContractAddress != 0x0);
        require(certificateContractAddress != 0x0);
        Transaction storage _trans = transactions[_id];
        _trans.numberReject += 1;
        rejects[_id][msg.sender] = true;
        if(_trans.numberOfComfirmed < totalRequired && _trans.numberReject >= totalRequired) {
            _trans.status = true;
            Reports _report = Reports(reportContractAddress);
            Signature _sig = Signature(signatureContractAddress);
            Medicines _medecine = Medicines(medicineContractAddress);
            if(_trans.Type == 8) {
                _report.approveReport(_trans.identifier, _trans.From,
                                      "Chúng tôi đã xác nhận việc report của bạn là  vô căn cứ "
                                    );
            } else if(_trans.Type == 0 || _trans.Type == 1 || _trans.Type == 3 || _trans.Type == 4) {
                _sig.imgRejected(_trans.From, _trans.identifier);
                if(_trans.Type == 4) {
                   _medecine.approveRejectUpdateMedicine(_trans.identifier, _trans.From);
                }
            }
            
        }
        
    }
    
    
    
    function getTransactionsWaittingConfirm(
    )
        public
        view
        onlyAuthorised()
        returns(uint[])
    {

        uint count;
        uint[] memory _temp = new uint[](transactionCount);
        for(uint i = 0; i < transactionCount; i++) {
            if(!(rejects[i][msg.sender]) && !(confirmations[i][msg.sender])) {
                _temp[count] = i;
                count++;
            }
        }
        uint[] memory _transactionIds = new uint[](count);
        
        for( i = 0; i < _transactionIds.length; i++) {
            _transactionIds[i] = _temp[i];
        }
        return _transactionIds;
    }
    
    function getTransactionsRejectBy(
        address _from
    )
        public
        view
        onlyAuthorised()
        returns(uint[])
    {
        uint count = 0;
        uint[] memory _temp = new uint[](transactionCount);
        for(uint i = 0; i < transactionCount; i++) {
             if(rejects[i][_from]) {
                 _temp[count] = i;
                 count++;
             }
         }
         
         uint[] memory _transactionIds = new uint[](count);
        for( i = 0; i < _transactionIds.length; i++) {
             if(rejects[_temp[i]][_from]) {
                 _transactionIds[i] = _temp[i];
             }
        }
        return _transactionIds;
    }
        
    
    

    function refundEth(  // tra lai eth 
        uint _identifier
    )
        public    
    {

        for(uint i = 0; i < transactionCount ; i++) {
            if(transactions[i].identifier == _identifier) {
                require(!isExecuted(i));
                require(transactions[i].Type == 0 || transactions[i].Type == 3);
                require(transactions[i].From == msg.sender); // check xem thang transaction nay co dung duoc goi tu thang _from ko
                require(now >= transactions[i].time + timeMaxWaitting);
                require(msg.sender != 0x0);
                require(transactions[i].value >= 10);
                if(transactions[i].Type == 0) {
                    uint j;
                    Providers _provider = Providers(providerContractAddress);
                    _provider.setDataWhenRefundEth(transactions[i].From);
                    for( j = 0; j < owners.length; j++) {
                        rejects[i][owners[j]] = true;
                    }
                }
                
                if(transactions[i].Type == 3 ) {
                    Medicines _medecine = Medicines(medicineContractAddress);
                    _medecine.setDataWhenRefundEth(transactions[i].From, transactions[i].identifier);
                    for( j = 0; j < owners.length; j++) {
                        rejects[i][owners[j]] = true;
                    }
                }
                
                listRefund[msg.sender].push(i); 
                msg.sender.transfer(10);
                transactions[i].value = transactions[i].value.sub(10);
            }
        }
    }
    
    function getListRefund(
        address _addr
    )
        public
        view
        returns(uint[])
    {
        return listRefund[_addr];
    }


    function isExecuted(
        uint _identifier
    ) 
        public 
        view 
        returns(bool) 
    {
        Transaction storage _trans = transactions[_identifier];
        if(_trans.status == true) {
            return true;
        }

        return false;
    }
    
    function getTransactionInformation(
        uint _identifier
    ) 
        public 
        view 
        returns(Transaction _trans) 
    {
        _trans = transactions[_identifier];
        return _trans;
    }

    function getManyTransactionInformation(
        uint[] _identifier
    )
        public
        view
        returns(Transaction[])
    {
        Transaction[] memory _trans = new Transaction[](_identifier.length);
        for(uint i = 0; i < _identifier.length; i++) {
            _trans[i]  = transactions[_identifier[i]];
        }
        return _trans;

    }
    
 
    function getTransactionsConfirmedBy(  // get transaction được confirm bởi 1 manger
        address _from
    ) 
        public
        view
        onlyAuthorised() 
        returns(uint[]) 
    {
        uint count = 0;
        uint[] memory _temp = new uint[](transactionCount);
        for(uint i = 0; i < transactionCount; i++) {
             if(confirmations[i][_from]) {
                 _temp[count] = i;
                 count++;
             }
         }
         
         uint[] memory _transactionIds = new uint[](count);
        for( i = 0; i < _transactionIds.length; i++) {
             if(confirmations[_temp[i]][_from]) {
                 _transactionIds[i] = _temp[i];
             }
        }
        
        return _transactionIds;
    }

    function listAuthorConfirmTransactions(
        uint _id
    ) 
        public 
        view 
        returns(address[]) 
    {
        address[] memory _owners = new address[](owners.length);
        uint count = 0;
        uint i;
        for(i = 0; i < owners.length; i++) {
            if(confirmations[_id][owners[i]]) {
                _owners[count] = owners[i];
                count++;
            }
        }
        
        address[] memory _confirmations = new address[](count);

        for(i = 0; i < count; i++) {
            _confirmations[i] = _owners[i];
        }

        return _confirmations;
    }
    
    function listAuthorRejectTransactions(
        uint _id
    ) 
        public 
        view 
        returns(address[]) 
    {
        address[] memory _owners = new address[](owners.length);
        uint count = 0;
        uint i;
        for(i = 0; i < owners.length; i++) {
            if(rejects[_id][owners[i]]) {
                _owners[count] = owners[i];
                count++;
            }
        }
        
        address[] memory _rejects = new address[](count);

        for(i = 0; i < count; i++) {
            _rejects[i] = _owners[i];
        }

        return _rejects;
    }
    
    function getTransactionsById(
        uint _id
    ) 
        public
        view
        returns(uint[])
    {
        uint[] memory _p = new uint[](transactionCount);
        uint _index = 0;
        for(uint i = 0; i < transactionCount; i++) {
            if(transactions[i].identifier == _id) {
                _p[_index] = i;
                _index++;
            }
        }
        return _p;
    } 
}
