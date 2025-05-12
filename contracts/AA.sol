// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import "./IToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AA is Ownable {
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

    function transferTokenPermit(
        address token,
        address to,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        _verifyTransfer(token, amount, deadline, v, r, s);
        IToken(token).transfer(to, amount);
    }

    function transferNativePermit(
        address payable to,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        _verifyTransfer(NATIVE_TOKEN, amount, deadline, v, r, s);
        to.transfer(amount);
    }

    function _verifyTransfer(
        address token,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        require(block.timestamp <= deadline, "Permit expired");
        require(owner() != address(0), "Invalid owner");

        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(
                        PERMIT_TYPEHASH,
                        token,
                        owner(),
                        msg.sender,
                        amount,
                        nonces[owner()]++,
                        deadline
                    )
                )
            )
        );

        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress == owner(), "Invalid signature");
    }

    receive() external payable {}
}
