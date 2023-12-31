// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CertificateNFT {
    address public owner;

    struct Certificate {
        string name;
        string degreeName;
        string subject;
        address recipient;
        uint256 timestamp;
        bool isIssued;
    }

    mapping(bytes32 => Certificate) public certificates;

    event CertificateIssued(bytes32 indexed certificateHash,address indexed recipient);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
   } 
 
    function issueCertificate(string memory name,string memory degreeName,string memory subject,address recipient,uint256 timestamp) 
    public onlyOwner {
        require(recipient != address(0), "Invalid recipient address");
        bytes32 certificateHash = keccak256(abi.encodePacked(recipient) );
        require(!certificates[certificateHash].isIssued,"Certificate already issued");

        certificates[certificateHash] = Certificate(name,degreeName,subject,recipient,timestamp,true);
        emit CertificateIssued(certificateHash, recipient);
    }

    function verifyCertificate( string memory name,string memory degreeName,string memory subject, address recipient,uint256 timestamp) 
    public view returns (bool) {
        bytes32 certificateHash = keccak256(abi.encodePacked(name, degreeName, subject, recipient, timestamp) );
        return certificates[certificateHash].isIssued;
     }

    function viewCertificate(address studentAddress)
        public
        view
        returns (string memory name,string memory degreeName, string memory subject,uint256 timestamp)
    {
        bytes32 certificateHash = keccak256(abi.encodePacked(studentAddress));
        require(certificates[certificateHash].recipient == studentAddress,"No certificate found for this student");
        return (
            certificates[certificateHash].name,
            certificates[certificateHash].degreeName,
            certificates[certificateHash].subject,
            certificates[certificateHash].timestamp
        );
    }
}
