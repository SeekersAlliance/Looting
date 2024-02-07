// SPDX-License-Identifier: MIT

pragma solidity = 0.8.23;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ILockableNFT} from "../interfaces/ILockableNFT.sol";
import {ERC2266} from "./ERC2266.sol";

/// @title Looting
/// @dev Implementation for the Lockable extension ERC2266
/// @author SeekersAlliance

contract Looting is ERC2266, ILockableNFT, AccessControl {
    string private baseTokenURI;
    uint256 public maxLockTime;
    address tokenManager;

    constructor(address _initialAdmin, uint256 _maxLockTime, string memory _baseTokenURI) ERC2266(_baseTokenURI) {
        baseTokenURI = _baseTokenURI;
        maxLockTime = _maxLockTime;
        tokenManager = _initialAdmin;
        _grantRole(DEFAULT_ADMIN_ROLE, _initialAdmin);
    }

    function setTokenManager(address _manager) external onlyRole(DEFAULT_ADMIN_ROLE){
        tokenManager = _manager;
        emit SetTokenManager(_manager);
    }

    function setMaxLockTime(uint256 _time) external onlyRole(DEFAULT_ADMIN_ROLE){
        maxLockTime = _time;
        emit SetMaxLockTime(_time);
    }

    function lock(
        address account, 
        uint256 id,
        uint256 locknum, 
        uint256 expired
    ) public override (ERC2266, ILockableNFT) {
        address locker = msg.sender;
        if(!isApprovedForLock(account, locker) && locker != tokenManager) revert NotApprovedForLock(account, locker);
        if(expired > block.timestamp + maxLockTime) revert InvalidExpired(expired);
        _lock(locker, account, id, locknum, expired);
    }

    function unlock(
        address account, 
        uint256 id, 
        uint256 unlocknum
    ) public override (ERC2266, ILockableNFT) {
        address locker = msg.sender;
        if(!isApprovedForLock(account, locker) && locker != tokenManager) revert NotApprovedForLock(account, locker);
        _unlock(locker, account, id, unlocknum);
    }

    function lockBatch(
        address account, 
        uint256[] memory ids, 
        uint256[] memory locknums, 
        uint256 expired
    ) public override (ERC2266, ILockableNFT){
        address locker = msg.sender;
        if(!isApprovedForLock(account, locker) && locker != tokenManager) revert NotApprovedForLock(account, locker);
        if(expired > block.timestamp + maxLockTime) revert InvalidExpired(expired);
        _lockBatch(locker, account, ids, locknums, expired);
    }

    function unlockBatch(
        address account, 
        uint256[] memory ids, 
        uint256[] memory unlocknums
    ) public override (ERC2266, ILockableNFT){
        address locker = msg.sender;
        if(!isApprovedForLock(account, locker) && locker != tokenManager) revert NotApprovedForLock(account, locker);
        _unlockBatch(locker, account, ids, unlocknums);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes memory data
    ) public override (ERC2266, ILockableNFT){
        super.safeTransferFrom(from, to, id, value, data);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public override (ERC2266, ILockableNFT){
        super.safeBatchTransferFrom(from, to, ids, values, data);
    }

    function unlockAndTransfer(
        address from, 
        address to, 
        uint256 id, 
        uint256 unlockNum, 
        uint256 transferNum, 
        bytes memory data
    ) public override (ERC2266, ILockableNFT){
        super.unlockAndTransfer(from, to, id , unlockNum, transferNum, data);
    }

    function unlockAndTransferBatch(
        address from, 
        address to, 
        uint256[] memory ids, 
        uint256[] memory unlockNums, 
        uint256[] memory transferNums, 
        bytes memory data
    ) public override (ERC2266, ILockableNFT){
        super.unlockAndTransferBatch(from, to, ids, unlockNums, transferNums, data);
    }

    function mint(address to, uint256 id, uint256 value, bytes memory data) external {
        _mint(to, id, value, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory values, bytes memory data) external {
        _mintBatch(to, ids, values, data);
    }

    function getLocker(address account, uint256 id) public view override (ERC2266, ILockableNFT) returns(address locker){
        return super.getLocker(account, id);
    }

    function getLockedNum(address account, uint256 id) public view override (ERC2266, ILockableNFT) returns(uint256 lockednum){
        return super.getLockedNum(account, id);
    }

    function getExpired(address account, uint256 id) public view override (ERC2266, ILockableNFT) returns(uint256 expired){
        return super.getExpired(account, id);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC2266, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal virtual override(ERC2266) {
        super._update(from, to, ids, values);
    }
}
