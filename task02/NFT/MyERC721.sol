// SPDX-License-Identifier: MIT
pragma solidity ~0.8;
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract MyERC721 {


    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    //address到持有数量的映射
    mapping(address => uint256) _balances;

    //tokenId到owner address的持有人映射
    mapping(uint256 => address) _tokenIdOwners;

    //tokenId到授权地址的授权映射
    mapping(uint256 => address) _tokenApprovals;

    //owner 全部授权到operator地址的关系映射
    mapping(address => mapping(address => bool)) private _operatorApprovalsForAll;

    //错误  无效的接收者
    error ERC721InvalidReceiver(address receiver);

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    constructor(string memory name_, string memory symbol_){
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     * 返回owner的代币数量
     */
    function balanceOf(address owner) external view returns (uint256 balance){
        require(owner != address(0), "owner is zero address");
        return _balances[owner];
    }

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.

     * 返回某个tokenId的拥有者
     */
    function ownerOf(uint256 tokenId) external view returns (address owner){
        owner = _tokenIdOwners[tokenId];
        require(owner != address(0), "token doesn't exist");
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     * 
     * 安全转出 from -> to
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external{
        address owner = this.ownerOf(tokenId);
        require(from == owner || _tokenApprovals[tokenId] == msg.sender || _operatorApprovalsForAll[owner][msg.sender]
        , "not owner nor approved");

        _safeTransfer(owner, from, to, tokenId, data);
    }

    function _safeTransfer(
        address owner,
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private {
        _transfer(owner, from, to, tokenId);
        _checkOnERCReceived(from, to, tokenId, _data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC-721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or
     *   {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external{
        this.safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC-721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external{
        address owner = _tokenIdOwners[tokenId];
        require(from == owner || _tokenApprovals[tokenId] == msg.sender || _operatorApprovalsForAll[owner][msg.sender]
        , "not owner nor approved");
        
        _transfer(owner, from, to, tokenId);
    }

    function _transfer(address owner, address from , address to, uint256 tokenId) internal{
        require(from == owner, "not owner");
        require(to != address(0), "transfer to the zero address");

        //取消owner的所有授权
        _approve(owner, address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _tokenIdOwners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }


    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external{
        address owner = _tokenIdOwners[tokenId];
        require(msg.sender == owner || _operatorApprovalsForAll[owner][msg.sender],
            "not owner nor approved for all"
        );

        _approve(owner, to, tokenId);
    }

   function _approve(address owner, address to, uint256 tokenId) private{
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the address zero.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external{
         require(address(operator) != address(0), "operator address cannot be zero");
        _operatorApprovalsForAll[msg.sender][operator] = approved;
    }

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *  获取某个tokenId的被授权人
     */
    function getApproved(uint256 tokenId) external view returns (address operator){
        
        return _tokenApprovals[tokenId];
    }

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool){
        return _operatorApprovalsForAll[owner][operator];
    }


    function _checkOnERCReceived(address from, address to, uint256 tokenId, bytes memory data) private {
        if(to.code.length > 0){
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns(bytes4 retval){
                if(retval != IERC721Receiver.onERC721Received.selector){
                    revert ERC721InvalidReceiver(to);
                }
            }catch (bytes memory reason){
                if(reason.length ==0){
                    revert ERC721InvalidReceiver(to);
                }else{
                    assembly{
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        }

    }

    //铸造函数
    function _mint(address to, uint tokenId) internal virtual{
        require(to != address(0), "mint to zero address");
        require(_tokenIdOwners[tokenId] == address(0), "token already minted");

        _balances[to] += 1;
        _tokenIdOwners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    //铸造函数
    function _burn(uint tokenId) internal virtual{
        address owner = _tokenIdOwners[tokenId];
        require(msg.sender == owner, "only owner can burn");

        _approve(owner, address(0), tokenId);

        _balances[owner] -= 1;
        delete _tokenIdOwners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }




}