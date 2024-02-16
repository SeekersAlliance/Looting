// SPDX-License-Identifier: MIT

pragma solidity = 0.8.23;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "../interfaces/IERC2266.sol";

/// @title ERC2266: Lockable Extension for ERC1155
/// @dev Implementation for the Lockable extension ERC2266 for ERC1155
/// @author SeekersAlliance 

contract ERC2266 is ERC1155, IERC2266{

    mapping(address account => mapping(address locker => bool)) private lockerApprovals;
    mapping(address account => mapping(uint256 id => LockStatus)) internal lockStatus;

    struct LockStatus {
        address locker;
        uint256 lockednum;
        uint256 expired;
    }

    constructor(string memory _baseTokenURI) ERC1155(_baseTokenURI) {
        _setURI(_baseTokenURI);
    }

    function setApprovalForLock(address locker, bool approved) external virtual {
        _setApprovalForLock(msg.sender, locker, approved);
        _setApprovalForAll(msg.sender, locker, approved);
    }

    function isApprovedForLock(address account, address locker) public view virtual returns (bool) {
        return lockerApprovals[account][locker];
    }

    function lock(
        address account, 
        uint256 id,
        uint256 locknum, 
        uint256 expired
    ) public virtual {
        address locker = msg.sender;
        if(!isApprovedForLock(account, locker)) revert NotApprovedForLock(account, locker);
        _lock(locker, account, id, locknum, expired);
    }

    function unlock(
        address account, 
        uint256 id, 
        uint256 unlocknum
    ) public virtual {
        address locker = msg.sender;
        if(!isApprovedForLock(account, locker)) revert NotApprovedForLock(account, locker);
        _unlock(locker, account, id, unlocknum);
    }

    function lockBatch(
        address account, 
        uint256[] memory ids, 
        uint256[] memory locknums, 
        uint256 expired
    ) public virtual {
        address locker = msg.sender;
        if(!isApprovedForLock(account, locker)) revert NotApprovedForLock(account, locker);
        _lockBatch(locker, account, ids, locknums, expired);
    }

    function unlockBatch(
        address account, 
        uint256[] memory ids, 
        uint256[] memory unlocknums
    ) public virtual {
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
    ) public virtual override(ERC1155, IERC2266) {
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
    ) public virtual override(ERC1155, IERC2266) {
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
    ) public virtual {
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
    ) public virtual {
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

    function getLocker(address account, uint256 id) public view virtual returns(address locker){
        if(!_isLocked(account, id)) return address(0);
        return lockStatus[account][id].locker;
    }

    function getLockedNum(address account, uint256 id) public view virtual returns(uint256 lockednum){
        if(!_isLocked(account, id)) return 0;
        return lockStatus[account][id].lockednum;
    }

    function getExpired(address account, uint256 id) public view virtual returns(uint256 expired){
        if(!_isLocked(account, id)) return 0;
        return lockStatus[account][id].expired;
    }

    function _lock(
        address locker, 
        address account,
        uint256 id,
        uint256 locknum, 
        uint256 expired
    ) internal virtual{
        (uint256[] memory ids, uint256[] memory values) = _buildSingletonArrays(id, locknum);
        _updateLockStatus(locker, account, ids, values, expired);
        emit Lock(locker, account, id, locknum, expired);
    }

    function _unlock(
        address locker, 
        address account, 
        uint256 id, 
        uint256 unlocknum
    ) internal virtual{
        (uint256[] memory ids, uint256[] memory values) = _buildSingletonArrays(id, unlocknum);
        _updateUnlockStatus(locker, account, ids, values);
        emit Unlock(locker, account, id, unlocknum);
    }

    function _lockBatch(
        address locker, 
        address account, 
        uint256[] memory ids, 
        uint256[] memory locknums, 
        uint256 expired
    ) internal virtual {
        _updateLockStatus(locker, account, ids, locknums, expired);
        emit LockBatch(locker, account, ids, locknums, expired);
    }

    function _unlockBatch(
        address locker, 
        address account, 
        uint256[] memory ids, 
        uint256[] memory unlocknums
    ) internal virtual {
        _updateUnlockStatus(locker, account, ids, unlocknums);
        emit UnLockBatch(locker, account, ids, unlocknums);
    }

    function _updateLockStatus(
        address locker, 
        address account, 
        uint256[] memory ids, 
        uint256[] memory values,
        uint256 expired
    ) internal virtual {   
        if(account == address(0)) revert InvalidLockAccount(address(0));
        uint256 id;
        uint256 value;
        for(uint256 i;i<ids.length;i++) {
            id = ids[i];
            value = values[i];
            LockStatus storage status = lockStatus[account][id];

            if(value == 0) revert InvalidLockNum(value);
            if(_isLocked(account, id)) revert Locked(account, id, status.locker, status.lockednum, status.expired);
            if(value > balanceOf(account, id)) revert InvalidLockNum(value);
            if(expired <= block.timestamp) revert InvalidExpired(expired);

            status.locker = locker;
            status.expired = expired;
            status.lockednum = value;
        }
    }

    function _updateUnlockStatus(
        address locker,
        address account,
        uint256[] memory ids, 
        uint256[] memory values
    ) internal virtual {
        if(account == address(0)) revert InvalidLockAccount(address(0));
        uint256 id;
        uint256 value;
        for(uint256 i;i<ids.length;i++) {
            id = ids[i];
            value = values[i];
            LockStatus storage status = lockStatus[account][id];
            if(value == 0) revert InvalidLockNum(value); 
            if(!_isLocked(account, id)) revert isNotLocked(account, id);
            if(_isLocked(account, id) && status.locker != locker) revert NotLocker(account, id, locker);
            if(value > status.lockednum) revert InvalidUnLockNum(value); 
            if(value == status.lockednum) {
                _resetLockStatus(account, id);
            } else {
                status.lockednum -= value;
            }
        }
    }

    function _resetLockStatus(address account, uint256 id) internal virtual {
        LockStatus storage status = lockStatus[account][id];
        delete status.locker;
        delete status.lockednum;
        delete status.expired;
    }

    function _setApprovalForLock(address owner, address locker, bool approved) internal virtual {
        if (locker == address(0)) {
            revert InvalidLocker(owner, address(0));
        }
        lockerApprovals[owner][locker] = approved;
        emit ApprovalForLock(owner, locker, approved);
    }

    function _buildSingletonArrays(
        uint256 element1, 
        uint256 element2
    ) internal pure returns(uint256[] memory array1, uint256[] memory array2) {
        /// @solidity memory-safe-assembly
        assembly {
            // Load the free memory pointer
            array1 := mload(0x40)
            // Set array length to 1
            mstore(array1, 1)
            // Store the single element at the next word after the length (where content starts)
            mstore(add(array1, 0x20), element1)

            // Repeat for next array locating it right after the first array
            array2 := add(array1, 0x40)
            mstore(array2, 1)
            mstore(add(array2, 0x20), element2)

            // Update the free memory pointer by pointing after the second array
            mstore(0x40, add(array2, 0x40))
        }
    }

    function _isLocked(address account, uint256 id) internal view virtual returns(bool) {
        if(lockStatus[account][id].expired <= block.timestamp) {
            return false;
        }
        return true;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal virtual override(ERC1155) {
        super._update(from, to, ids, values);
    }
}
