// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface IERC721 is IERC165 {
    function balanceOf(address owner) external view returns (uint balance);

    function ownerOf(uint tokenId) external view returns (address owner);

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes calldata data
    ) external;

    function transferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function approve(address to, uint tokenId) external;

    function getApproved(uint tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);
}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract ERC721 is IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed id);
    event Approval(address indexed owner, address indexed spender, uint indexed id);
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    // state variables
    mapping(uint => address) internal _ownerOf;
    mapping(address => uint) internal _balanceOf;
    mapping(uint => address) internal _approvals;
    mapping(address => mapping(address => bool)) public isApprovedForAll;
    
    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return interfaceID == type(IERC721).interfaceID ||
        interfaceID = type(IERC165).interfaceID;
    }
    function balanceOf(address owner) external view returns (uint balance){
        // owner can not be equal to zero
        require(owner != address(0), "owner = zero address");
        return _balanceOf[owner];
    }

    function ownerOf(uint tokenId) external view returns (address owner){
        owner = _ownerOf[tokenId];
        require(owner != address(0), "owner = zero address");
    }
    // operator for all we are setting the premission
    function setApprovalForAll(address operator, bool _approved) external {
        isApprovedForAll[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender, operator, _approved);
    }   

    function approve(address to, uint tokenId) external {
        address owner = _ownerOf[tokenId];
        require(msg.sender == owner || isApprovedForAll[owner][msg.sender],
        "not authorized!");
        // to address has the permission to spend tokenId
        _approvals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function getApproved(uint tokenId) external view returns (address operator) {
        require(_ownerOf[tokenId] != address(0), "token dosen't exist");
        return _approvals[tokenId];
    }

    function _isApprovedOrOwner(
        address owner,
        address spender,
        uint tokenId
    ) internal view returns (bool) {
        return (
            spender == owner || 
            isApprovedForAll[owner][spender] ||
            spender == _approvals[tokenId]
        );
    }

    function transferFrom(
        address from,
        address to,
        uint tokenId
    ) public {
        require(from == _ownerOf[tokenId], "from != _ownerOf[tokenId]");
        require(to != address(0), "to = zero address");
        require(_isApprovedOrOwner(from, msg.sender, tokenId), "not authorized");

        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[tokenId] = to;

        delete _approvals[tokenId];

        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external {
        transferFrom(from, to, tokenId);

        require(
            to.code.length == 0 || 
                IERC721Receiver(to).onERC721Recieved(msg.sender, from, to, tokenId, "") == 
                IERC721Receiver.onERC721Received.selector,"unsafe recipient"
        );
    }

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes calldata data
    ) external {
        transferFrom(from, to, tokenId);

        require(
            to.code.length == 0 || 
                IERC721Receiver(to).onERC721Recieved(msg.sender, from, to, tokenId, data) == 
                IERC721Receiver.onERC721Received.selector,"unsafe recipient"
        );
    }
}
