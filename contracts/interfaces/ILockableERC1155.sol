// SPDX-License-Identifier: MIT

pragma solidity = 0.8.23;

/// @title Extension: Lockable ERC1155 
/// @dev Interface for Lockable ERC1155 
/// @author SeekersAlliance 

interface ILockableERC1155 {
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
     * @notice Only address who isApprovedForLock can call lock.
     * @notice Locked token can not transfer before unlock or expired.
     * @notice Can not call lock if the token is locked or unexpired.
     * @param account Target address.
     * @param id tokenID.
     * @param locknum lock amount of the id.
     * @param expired the expiration of the lock.
     */
    function lock(address account, uint256 id, uint256 locknum, uint256 expired) external;

    /**
     * @notice Only address who isApprovedForLock can call unlock.
     * @notice Token can not unlock if not locked or msg sender is not the token locker.
     * @param account Target address.
     * @param id tokenID.
     * @param unlocknum unlock amount of the id.
     */
    function unlock(address account, uint256 id, uint256 unlocknum) external;

    /**
     * @notice Lock in batch.
     */
    function lockBatch(address account, uint256[] memory ids, uint256[] memory locknums, uint256 expired) external;
    
    /**
     * @notice Unlock in batch.
     */
    function unlockBatch(address account, uint256[] memory ids, uint256[] memory unlocknums) external;
    
    /**
     * @notice Enable or disable approval of lock to manage all of the caller's tokens.
     * @param locker the address who get approval.
     * @param approved True if the locker is approved, false to revoke approval
     */
    function setApprovalForLock(address locker, bool approved) external; 
    
    /**
        @notice Queries the lock approval status of an operator for a given account.
        @param account The owner of the tokens
        @param operator Address of authorized operator
        @return True if the operator is approved, false if not
    */
    function isApprovedForLock(address account, address operator) external view returns (bool);

    /**
        @notice Get the locker of an account's token id.
        @param account The address of the token holder.
        @param id ID of the token.
        @return locker Return the locker address if locked, address(0) if not locked.
     */
    function getLocker(address account, uint256 id) external view returns(address locker);
    
    /**
        @notice Get the locked amount of an account's token id.
        @param account The address of the token holder.
        @param id ID of the token.
        @return lockednum return the locked amount of an account's token id.
     */
    function getLockedNum(address account, uint256 id) external view returns(uint256 lockednum);
    
    /**
        @notice Get the expiration time of an account's token id.
        @param account The address of the token holder.
        @param id ID of the token.
        @return expired return the expiration time of an account's token id.
     */
    function getExpired(address account, uint256 id) external view returns(uint256 expired);

    /**
        @notice Transfers `value` amount of an `id` from the `_from` address to the `_to` address specified (with safety call).
        @notice Transfer amount can not more than the non-locked amount.
        @notice Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
        @param from    Source address
        @param to      Target address
        @param id      ID of the token type
        @param value   Transfer amount
        @param data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `to`
     */
    function safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes memory data) external;
    
    /** 
     * @notice Transfer in batch.
     */
    function safeBatchTransferFrom(address from,address to,uint256[] memory ids,uint256[] memory values,bytes memory data) external;
    
    /** 
     * @notice Unlock and transfer.
     * @notice Can not call this function if the token is not locked or msg sender is not the token locker.
     * @param from Source address
     * @param to Target address
     * @param id token ID
     * @param unlockNum unlock amount of the id
     * @param transferNum transfer amount of the id
     * @param data Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `to`
     */
    function unlockAndTransfer(address from, address to, uint256 id, uint256 unlockNum, uint256 transferNum, bytes memory data) external;
    
    /** 
     * @notice Unlock and transfer in batch.
     */
    function unlockAndTransferBatch(address from, address to, uint256[] memory ids, uint256[] memory unlockNums, uint256[] memory transferNums, bytes memory data) external;
}