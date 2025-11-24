// SPDX-License-Identifier: MIT
pragma solidity ~0.8;

import "./IERC20.sol";
contract ERC20 is IERC20{

    mapping(address => mapping(address => uint256)) _approves;

    mapping(address => uint256) _balances;

    uint256 _totalSupply;

    /**
     * @dev 返回代币总供给.
     */
    function totalSupply() external view returns(uint256){
        return _totalSupply;
    }

    /**
     * @dev 返回账户`account`所持有的代币数.
     */
    function balanceOf(address account) external view returns (uint256){
        return _balances[account];
    }

    /**
     * @dev 转账 `amount` 单位代币，从调用者账户到另一账户 `to`.
     *
     * 如果成功，返回 `true`.
     *
     * 释放 {Transfer} 事件.
     */
    function transfer(address to, uint256 amount) external returns (bool){
        _transfer(msg.sender, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(address(from) != address(0), "ERC20: transfer from the zero address");
        require(address(to) != address(0), "ERC20: transfer to the zero address");
        require(_balances[msg.sender] >= amount, "Balance is Not Enough");
        _balances[to] += amount;
        _balances[from] -= amount;
        emit Transfer(from, to, amount);
    }

    /**
     * @dev 返回`owner`账户授权给`spender`账户的额度，默认为0。
     *
     * 当{approve} 或 {transferFrom} 被调用时，`allowance`会改变.
     */
    function allowance(address owner, address spender) external view returns (uint256){
        return _approves[owner][spender];
    }

    /**
     * @dev 调用者账户给`spender`账户授权 `amount`数量代币。
     *
     * 如果成功，返回 `true`.
     *
     * 释放 {Approval} 事件.
     */
    function approve(address spender, uint256 amount) external returns (bool){
        require(address(spender) != address(0), "ERC20: approve to the zero address");
        require(_balances[msg.sender] >= amount, "msg.sender balance not enough");
        _approves[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev 通过授权机制，从`from`账户向`to`账户转账`amount`数量代币。转账的部分会从调用者的`allowance`中扣除。
     *
     * 如果成功，返回 `true`.
     *  
     * 该方法调用者是spender
     * 释放 {Transfer} 事件.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool){
        require(address(from) != address(0), "ERC20: transferFrom from is the zero address");
        require(address(to) != address(0), "ERC20: transferFrom to is the zero address");
        require(_balances[from] >= amount, "ERC20: transferFrom from balance not enough");
        require(_approves[from][msg.sender] >= amount, "ERC20: transferFrom approves[from][msg.sender] balance not enough");
        _approves[from][msg.sender] -= amount;
        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }


    // 铸造代币， 从`0` 地址转账给 调用者地址
    function mint(uint amount) external {
        _balances[msg.sender] += amount;
        _totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    //销毁代币 从调用者地址转账给`0` 地址
    function burn(uint amount) external {
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

}