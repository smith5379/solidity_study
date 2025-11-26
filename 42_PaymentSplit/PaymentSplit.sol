// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * 分账合约
 * 这个合约会把收到的ETH按事先定好的份额分给几个账户, 收到ETH会存在分账合约中, 需要每个受益人调用release()函数来领取
 *
 */
contract PaymentSplit{

    // 事件
    event PayeeAdded(address account, uint256 shares); // 增加受益人事件
    event PaymentReleased(address to, uint256 amount); // 受益人提款事件
    event PaymentReceived(address from, uint256 amount); // 合约收款事件

    uint256 public totalShares;//总份额
    uint256 public totalReleased;//总支付

    mapping(address => uint256) public shares;//每个受益人的份额
    mapping(address => uint256) public released;// 已支付给每个受益人的金额

    address[] public payees;//受益人数组

    //初始化受益人数组_payees和分账份额数组_shares
    //数组长度不能为0, 两个数组长度要相等, _shares中元素要大于0, _payees中地址不能为0地址,且不能重复
    constructor(address[] memory _payees, uint256[] memory _shares) payable {
        require(_payees.length == _shares.length && _payees.length > 0, "payees and shares length mismatch and length can not eqausl zero");
        // 调用_addPayee，更新受益人地址payees、受益人份额shares和总份额totalShares
        for (uint256 i = 0; i < _payees.length; i++) {
            _addPayee(_payees[i], _shares[i]);
        }
    }
    
    //回调函数,收到ETH释放PaymentReceived事件
    receive() external payable {
        emit PaymentReceived(msg.sender, msg.value);
    }

    //为有效受益人地址payee分账, 相应的ETH直接发送到受益人地址, 任何人都可以触发这个函数, 但ETH会转给受益人
    function release(address payable account) public virtual{
        require(shares[account] > 0, "account has no shares");

        //计算本次account应分多少ETH
        uint256 payment = releasable(account);
        require(payment != 0, "account is not due payment");

        //更新总支付totalReleased和支付给每个受益人的金额released
        totalReleased += payment;
        released[account] += payment;

        account.transfer(payment);

        emit PaymentReleased(account, payment);

        
    }

   /**
     * @dev 计算一个账户能够领取的eth。
     * 调用了pendingPayment()函数。
     */
    function releasable(address _account) public view returns (uint256) {
        // 计算分账合约总收入totalReceived
        uint256 totalReceived = address(this).balance + totalReleased;
        // 调用_pendingPayment计算account应得的ETH
        return pendingPayment(_account, totalReceived, released[_account]);
    }

    /**
     * @dev 根据受益人地址`_account`, 分账合约总收入`_totalReceived`和该地址已领取的钱`_alreadyReleased`，计算该受益人现在应分的`ETH`。
     */
    function pendingPayment(
        address _account,
        uint256 _totalReceived,
        uint256 _alreadyReleased
    ) public view returns (uint256) {
        // account应得的ETH = 总应得ETH - 已领到的ETH
        return (_totalReceived * shares[_account]) / totalShares - _alreadyReleased;
    }


    //新增受益人以及份额
    function _addPayee(address payee, uint256 share) private{
        require(payee != address(0), "payee is the zero address");
        require(share != 0, "share is the zero");
        //检查payee是否重复
        require(shares[payee] == 0, "payee already added");

        payees.push(payee);
        shares[payee] = share;
        totalShares += share;

        emit PayeeAdded(payee, share);
    }


}