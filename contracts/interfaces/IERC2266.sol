// SPDX-License-Identifier: MIT

pragma solidity = 0.8.23;

/// @title ERC2266: Lockable Extension for ERC1155
/// @dev Interface for ERC2266
/// @author SeekersAlliance 

interface IERC2266 {
    error NotApprovedForLock(address from, address locker);
    error NotLocker(address account, uint256 id, address locker);
    error InvalidLockAccount(address account);
    error InvalidLocker(address account, address locker);
    error InvalidUnLocker(address unlocker);
    error InvalidLockNum(uint256 locknum);
    error InvalidUnLockNum(uint256 unlocknum);
    error InsufficientBalance(address account, uint256 id);
    error Locked(address account, uint256 id, address locker, uint256 lockednum, uint256 expired);
    error isNotLocked(address account, uint256 id);
    error InvalidExpired(uint256 expired);

    event ApprovalForLock(address indexed owner, address indexed locker, bool indexed approved);
    event Lock(address indexed locker, address indexed account, uint256 indexed tokenId, uint256 locknum, uint256 expired);
    event Unlock(address indexed unlocker, address indexed account, uint256 indexed tokenId, uint256 unlockNum);
    event LockBatch(address indexed locker, address indexed account, uint256[] ids, uint256[] locknums, uint256 expired);
    event UnLockBatch(address indexed locker, address indexed account, uint256[] indexed ids, uint256[] unlocknums);

    /**
     * @dev Only approvedLock can lock.
     */
    function lock(address account, uint256 id, uint256 locknum, uint256 expired) external;
    function unlock(address account, uint256 id, uint256 unlocknum) external;
    function lockBatch(address account, uint256[] memory ids, uint256[] memory locknums, uint256 expired) external;
    function unlockBatch(address account, uint256[] memory ids, uint256[] memory unlocknums) external;
    function setApprovalForLock(address locker, bool approved) external; 
    function isApprovedForLock(address account, address operator) external view returns (bool);
    function getLocker(address account, uint256 id) external view returns(address locker);
    function getLockedNum(address account, uint256 tokenId) external view returns(uint256 lockednum);
    function getExpired(address account, uint256 tokenId) external view returns(uint256 expired);
    function safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes memory data) external;
    function safeBatchTransferFrom(address from,address to,uint256[] memory ids,uint256[] memory values,bytes memory data) external;
    function unlockAndTransfer(address from, address to, uint256 id, uint256 unlockNum, uint256 transferNum, bytes memory data) external;
    function unlockAndTransferBatch(address from, address to, uint256[] memory ids, uint256[] memory unlockNums, uint256[] memory transferNums, bytes memory data) external;
}