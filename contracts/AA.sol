// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./IToken.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract AA is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    // Constants
    string public constant CONTRACT_NAME = "AA";
    string public constant CONTRACT_VERSION = "1"; // Bump for upgrades
    address public constant NATIVE_TOKEN = address(0);
    bytes32 public constant PERMIT_TYPEHASH = keccak256(
        "Permit(address token,address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
    );

    // Domain separator and chainId cache
    bytes32 public DOMAIN_SEPARATOR;
    uint256 private _CACHED_CHAIN_ID;

    // State
    mapping(address => uint256) public nonces;

    function initialize(address _owner) public initializer {
        __Ownable_init(_owner);
        __UUPSUpgradeable_init();

        _CACHED_CHAIN_ID = block.chainid;
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes(CONTRACT_NAME)),
                keccak256(bytes(CONTRACT_VERSION)),
                _CACHED_CHAIN_ID,
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
                        nonces[msg.sender]++,
                        deadline
                    )
                )
            )
        );

        address recovered = ecrecover(digest, v, r, s);
        require(recovered == owner(), "Invalid signature");
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    receive() external payable {}
}
