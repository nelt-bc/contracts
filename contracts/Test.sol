// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import "./IToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Test is Ownable {
    bytes32 public immutable DOMAIN_SEPARATOR;
    bytes32 public constant PERMIT_TYPEHASH =
        keccak256(
            "Permit(address token,address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
        );

    uint256 private immutable _CACHED_CHAIN_ID;
    string public constant CONTRACT_NAME = "AA";
    string public constant CONTRACT_VERSION = "1"; // Can change if use proxy
    address public constant NATIVE_TOKEN = address(0);

    mapping(address => uint256) public nonces;

    constructor() Ownable(msg.sender) {
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes(CONTRACT_NAME)),
                keccak256(bytes(CONTRACT_VERSION)),
                block.chainid,
                address(this)
            )
        );
    }

    function getEncode() public view returns (bytes memory) {
        return
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes(CONTRACT_NAME)),
                keccak256(bytes(CONTRACT_VERSION)),
                block.chainid,
                0x88B7a65caBdaf204fC94d7a637A2c2BA12b8C503
            );
    }

    function getEncodeV2() public view returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    PERMIT_TYPEHASH,
                    0x882Da09D32BB5681439E0b097C420D426226F16e,
                    0x5c670b61ca861C59787B103FE517097544c12542,
                    0x20618a50F6E3E800A4F160F947bD002BA5f6AFe1,
                    1 * 10 ** 18,
                    1,
                    1746765566
                )
            );
    }

    function getEncodeV3() public view returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    "\x19\x01",
                    keccak256(getEncode()),
                    getEncodeV2()
                )
            );
    }
}
