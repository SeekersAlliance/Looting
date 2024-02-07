// SPDX-License-Identifier: MIT

pragma solidity = 0.8.23;

/// @title ERC2266: Lockable Extension for ERC1155
/// @dev Interface for ERC2266
/// @author SeekersAlliance 

interface ILockableNFT {

    event SetMaxLockTime(uint256 time);
    event SetTokenManager(address manager);

    function setTokenManager(address manager) external;
    function setMaxLockTime(uint256 expired) external;
    function lock(address account, uint256 id, uint256 locknum, uint256 expired) external;
    function unlock(address account, uint256 id, uint256 unlocknum) external;
    function lockBatch(address account, uint256[] memory ids, uint256[] memory locknums, uint256 expired) external;
    function unlockBatch(address account, uint256[] memory ids, uint256[] memory unlocknums) external;
    function getLocker(address account, uint256 id) external view returns(address locker);
    function getLockedNum(address account, uint256 tokenId) external view returns(uint256 lockednum);
    function getExpired(address account, uint256 tokenId) external view returns(uint256 expired);
    function safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes memory data) external;
    function safeBatchTransferFrom(address from,address to,uint256[] memory ids,uint256[] memory values,bytes memory data) external;
    function unlockAndTransfer(address from, address to, uint256 id, uint256 unlockNum, uint256 transferNum, bytes memory data) external;
    function unlockAndTransferBatch(address from, address to, uint256[] memory ids, uint256[] memory unlockNums, uint256[] memory transferNums, bytes memory data) external;
}