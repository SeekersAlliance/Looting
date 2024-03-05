// SPDX-License-Identifier: MIT

pragma solidity = 0.8.23;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ILooting} from "../interfaces/ILooting.sol";
import {LockableERC1155} from "./LockableERC1155.sol";

/// @title Looting
/// @dev Implementation for the Lockable-ERC1155 extension: ERC2266
/// @author SeekersAlliance

contract Looting is LockableERC1155, ILooting, AccessControl {
    string private baseTokenURI;
    uint256 public maxLockTime;
    address public tokenManager;

    constructor(address _initialAdmin, address _manager, uint256 _maxLockTime, string memory _baseTokenURI) LockableERC1155("") {
        baseTokenURI = _baseTokenURI;
        maxLockTime = _maxLockTime;
        tokenManager = _manager;
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
    ) public override (LockableERC1155, ILooting) {
        address locker = msg.sender;
        if(!isApprovedForLock(account, locker)) revert NotApprovedForLock(account, locker);
        if(expired > block.timestamp + maxLockTime) revert InvalidExpired(expired);
        _lock(locker, account, id, locknum, expired);
    }

    function unlock(
        address account,
        uint256 id,
        uint256 unlocknum
    ) public override (LockableERC1155, ILooting) {
        address locker = msg.sender;
        if(!isApprovedForLock(account, locker)) revert NotApprovedForLock(account, locker);
        _unlock(locker, account, id, unlocknum);
    }

    function lockBatch(
        address account, 
        uint256[] memory ids, 
        uint256[] memory locknums, 
        uint256 expired
    ) public override (LockableERC1155, ILooting){
        address locker = msg.sender;
        if(!isApprovedForLock(account, locker)) revert NotApprovedForLock(account, locker);
        if(expired > block.timestamp + maxLockTime) revert InvalidExpired(expired);
        _lockBatch(locker, account, ids, locknums, expired);
    }

    function unlockBatch(
        address account, 
        uint256[] memory ids, 
        uint256[] memory unlocknums
    ) public override (LockableERC1155, ILooting){
        address locker = msg.sender;
        if(!isApprovedForLock(account, locker)) revert NotApprovedForLock(account, locker);
        _unlockBatch(locker, account, ids, unlocknums);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes memory data
    ) public override (LockableERC1155, ILooting){
        address sender = _msgSender();
        if(from != sender && !isApprovedForAll(from, sender)) {
            revert ERC1155MissingApprovalForAll(sender, from);
        }

        if(_isLocked(from, id)) {
            LockStatus memory status = lockStatus[from][id];
            uint256 nonLocked = balanceOf(from, id) - status.lockednum;
            if(value > nonLocked) revert Locked(from, id, status.locker, status.lockednum, status.expired);
        }
        _safeTransferFrom(from, to, id, value, data);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public override (LockableERC1155, ILooting){
        address sender = _msgSender();
        if (from != sender && !isApprovedForAll(from, sender)) {
            revert ERC1155MissingApprovalForAll(sender, from); 
        } 
        uint256 id; 
        uint256 value;
        for(uint256 i;i<ids.length;i++) {
            id = ids[i];
            value = values[i];
            if(_isLocked(from, id)) {
                LockStatus memory status = lockStatus[from][id];
                uint256 nonLocked = balanceOf(from, id) - status.lockednum;
                if(value > nonLocked) revert Locked(from, id, status.locker, status.lockednum, status.expired);
            }
        }
        _safeBatchTransferFrom(from, to, ids, values, data);
    }

    function unlockAndTransfer(
        address from, 
        address to, 
        uint256 id, 
        uint256 unlockNum, 
        uint256 transferNum, 
        bytes memory data
    ) public override (LockableERC1155, ILooting){
        address sender = msg.sender;
        if(!isApprovedForLock(from, sender)) revert InvalidUnLocker(sender);
        
        unlock(from, id, unlockNum);
        LockStatus memory status = lockStatus[from][id];
        uint256 nonLocked = balanceOf(from, id) - status.lockednum;
        if(transferNum > nonLocked) revert Locked(from, id, status.locker, status.lockednum, status.expired);
        _safeTransferFrom(from, to, id, transferNum, data);
    }

    function unlockAndTransferBatch(
        address from, 
        address to, 
        uint256[] memory ids, 
        uint256[] memory unlockNums, 
        uint256[] memory transferNums, 
        bytes memory data
    ) public override (LockableERC1155, ILooting){
        address sender = msg.sender;
        if(!isApprovedForLock(from, sender)) revert InvalidUnLocker(sender);

        unlockBatch(from, ids, unlockNums);

        uint256 id; 
        uint256 value;
        for(uint256 i;i<ids.length;i++) {
            id = ids[i];
            value = transferNums[i];
            if(_isLocked(from, id)) {
                LockStatus memory status = lockStatus[from][id];
                uint256 nonLocked = balanceOf(from, id) - status.lockednum;
                if(value > nonLocked) revert Locked(from, id, status.locker, status.lockednum, status.expired);
            }
        }
        _safeBatchTransferFrom(from, to, ids, transferNums, data);
    }

    function isApprovedForLock(address account, address locker) public view override(LockableERC1155, ILooting) returns (bool) {
        if(locker == tokenManager) {
            return true;
        } else {
            return super.isApprovedForLock(account, locker);
        }        
    }

    function isApprovedForAll(address account, address operator) public view override returns (bool) {
        if(operator == tokenManager) {
            return true;
        } else {
            return super.isApprovedForAll(account, operator);
        }
    }

    function mint(address to, uint256 id, uint256 value, bytes memory data) external {
        _mint(to, id, value, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory values, bytes memory data) external {
        _mintBatch(to, ids, values, data);
    }

    function getLocker(address account, uint256 id) public view override (LockableERC1155, ILooting) returns(address locker){
        return super.getLocker(account, id);
    }

    function getLockedNum(address account, uint256 id) public view override (LockableERC1155, ILooting) returns(uint256 lockednum){
        return super.getLockedNum(account, id);
    }

    function getExpired(address account, uint256 id) public view override (LockableERC1155, ILooting) returns(uint256 expired){
        return super.getExpired(account, id);
    }

    function setBaseTokenURI(string memory newBaseTokenURI) external onlyRole(DEFAULT_ADMIN_ROLE) {
        baseTokenURI = newBaseTokenURI;
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        return bytes(baseTokenURI).length > 0
            ? string(abi.encodePacked(baseTokenURI, tokenIdToString(tokenId), ".json"))
            : '';
    }

    function tokenIdToString(uint256 tokenId) internal pure returns (string memory) {
        if (tokenId == 0) {
            return "0";
        }

        uint256 length;
        uint256 temp = tokenId;

        while (temp > 0) {
            temp /= 10;
            length++;
        }

        bytes memory result = new bytes(length);

        for (uint256 i = length; i > 0; i--) {
            result[i - 1] = bytes1(uint8(48 + tokenId % 10));
            tokenId /= 10;
        }

        return string(result);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(LockableERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal virtual override(LockableERC1155) {
        super._update(from, to, ids, values);
    }
}
