// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Tree {
    bytes32[] public hashes;
    string[4] transactions = [
        "TX1: John -> Ben",
        "TX2: Ben -> John",
        "TX3: Merry -> Tom",
        "TX4: Tom -> Barry"
    ];

//        ROOT(6)

//   H1-2(4)      H3-4(5)

// H1   H2   H3   H4

// TX1(0)  TX2(1)  TX3(2)  TX4(3)

// "TX2: Ben -> John"
// 1
// root: 0xe455bf8ea6e7463a1046a0b52804526e119b4bf5136279614e0b1e8e296a4e2d
// proof: ["0x044852b2a670ade5407e78fb2863c51de9fcb96542a07186fe3aeda6bb8a116d", "0xceebf77a833b30520287ddd9478ff51abbdffa30aa90a8d655dba0e8a79ce0c1"]


    constructor() {
        for(uint i = 0; i < transactions.length; i++) {
            hashes.push(makeHash(transactions[i]));
        }

        uint count = transactions.length;
        uint offset = 0;

        while(count > 0) {
            for(uint i = 0; i < count - 1; i += 2) {
                hashes.push(keccak256(abi.encodePacked(hashes[offset + i], hashes[offset + i + 1])));
            }

            offset += count;
            count /= 2;
        }
    }

    function verify(string memory transaction, uint index, bytes32 root, bytes32[] memory proof) public pure returns(bool) {
        bytes32 hash = makeHash(transaction);

        for(uint i = 0; i < proof.length; i++) {
            bytes32 element = proof[i];

            if(index % 2 == 0) {
                hash = keccak256(abi.encodePacked(hash, element));
            } else {
                hash = keccak256(abi.encodePacked(element, hash));
            }
            index /= 2;
        }

        return hash == root;
    } 

    function encode(string memory _input) public pure returns(bytes memory) {
        return abi.encodePacked(_input);
    }

    function makeHash(string memory _input) public pure returns(bytes32) {
        return keccak256(encode(_input));
    }

    function returnHash() public view returns(bytes32) {
        return hashes[hashes.length - 1];
    }
}