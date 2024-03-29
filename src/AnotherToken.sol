//SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

// importing erc20 interface
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

/**
 * @title A base contract for ERC20 contract implementation
 * @author Kwame 4B
 * @notice I am just trying to understand how this erc20 thing works with the interface
 */

// i can make it a base contract like => Base contract to be implemented by other contracts so it has to abstract to save loads of gas by ethereum standards
contract AnotherToken is IERC20 {
    ////-------------------------------------------------------------------------------////
    // Declaring all neccesary variables
    event Status(string);

    error Invalid_Inputs(address);
    error Insufficient_Funds(uint256);

    mapping(address account => uint256) _balances;
    mapping(address account => mapping(address spender => uint256)) _allowances;

    string private _name;
    string private _symbol;

    uint256 private _totalSupply;
    uint8 private immutable DECIMAL = 18;

    ////------------------------------------------------------------------------------////

    /**
     * These are required by EIP standards
     * @param name_ name of ERC20 token
     * @param symbol_ symbol of the token
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * Returns the name of the token
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * Returns the symbol of the token
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * Returns the number of decimals for precision
     */
    function decimals() public pure returns (uint8) {
        return DECIMAL;
    }

    /**
     * Returns the total supply of tokens
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * Checks balance of the account provided
     * @param _account Address of account you want to check
     */
    function balanceOf(address _account) public view returns (uint256) {
        return _balances[_account];
    }

    /**
     * Checks the amount approved for spender
     * @param _account address of the owner of the account
     * @param spender address you approved to spend
     */
    function allowance(
        address _account,
        address spender
    ) public view returns (uint256) {
        return _allowances[_account][spender];
    }

    /**
     * Transfers an amount of tokens to a receiving address
     * @param to address receiving tokens
     * @param value amount of tokens
     */
    function transfer(address to, uint256 value) public returns (bool) {
        address owner = msg.sender;
        if (owner == address(0) && to == address(0)) {
            revert Invalid_Inputs(address(0));
        }
        if (value <= 1e18) {
            revert Insufficient_Funds(value);
        }
        uint256 OwnerBalance = _balances[owner];
        if (OwnerBalance < value) {
            revert Insufficient_Funds(OwnerBalance);
        }
        _balances[owner] = OwnerBalance - value;
        _totalSupply -= value;
        _balances[to] += value;

        emit Transfer(owner, to, value);

        return true;
    }

    /**
     * To allow spenders to function with limits
     * @param spender Address to be approved
     * @param value amount of tokens to be approved for spender
     */
    function approve(address spender, uint256 value) public returns (bool) {
        address owner = msg.sender;
        if (spender == address(0)) {
            revert Invalid_Inputs(spender);
        }
        if (owner == address(0)) {
            revert Invalid_Inputs(owner);
        }
        if (value < 1e18) {
            revert Insufficient_Funds(value);
        }
        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
        return true;
    }

    /**
     *A func to help you increase the allowance you set for your spender
     * @param owner owner account address
     * @param spender spender's address
     * @param value amount you want to increase by
     * I am aware require statements consume lots of gas as compared to custom errors
     * But i miss them that's why i am using them
     */
    function IncreaseAllowance(
        address owner,
        address spender,
        uint256 value
    ) public returns (bool) {
        require(owner == msg.sender, "MF you aren't authorised");
        require(value > 0, "Invalid value cannot Increase allowance");
        require(
            _allowances[owner][spender] > 0,
            "You have to approve your spender"
        );
        _allowances[owner][spender] += value;
        return true;
    }

    /**
     * This function decreases the allowance of spenders
     * @param owner address of owner account
     * @param spender address of spender account
     * @param value Amount of allowance to be decreased
     * i miss require statements that why i am using them
     * i am aware it cost alot of gas
     * but this is only for practice purposes
     */
    function DecreaseAllowance(
        address owner,
        address spender,
        uint256 value
    ) public returns (bool) {
        require(owner == msg.sender, "MF you aren't authorised");
        require(value > 0, "Invalid value cannot decrease allowance");
        require(
            _allowances[owner][spender] > value,
            "You have to approve your spender"
        );
        _allowances[owner][spender] -= value;
        return true;
    }

    /**
     * Transfers tokens from one address to another
     * @param from sender of tokens
     * @param to receiver of tokens
     * @param value amount of tokens being sent
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {
        address spender = msg.sender;
        uint256 FromBal = _balances[from];
        uint256 spenderAllowance = allowance(from, spender);
        if (from == address(0)) {
            revert Invalid_Inputs(from);
        }
        if (to == address(0)) {
            revert Invalid_Inputs(to);
        }
        if (value < 1e18) {
            revert Insufficient_Funds(value);
        }
        if (FromBal < value) {
            revert Insufficient_Funds(FromBal);
        }
        if (spenderAllowance != type(uint256).max) {
            revert Insufficient_Funds(value);
        }
        if (spenderAllowance < value) {
            revert Insufficient_Funds(spenderAllowance);
        }

        approve(spender, spenderAllowance - value);
        _allowances[from][spender] = spenderAllowance - value;
        _balances[from] = FromBal - value;
        _balances[to] += value;
        emit Transfer(from, to, value);

        return true;
    }

    /**
     * Call to mint some tokens
     * @param account account tokens are minted to
     * @param amount amount of tokens minted
     */
    function mint(address account, uint256 amount) external {
        if (account == address(0)) {
            revert Invalid_Inputs(account);
        }
        if (amount < 1) {
            revert Insufficient_Funds(amount);
        }
        _totalSupply += amount;
        _balances[account] += amount;
        emit Status("Some tokens have been minted");
    }

    /**
     * Call to burn some nasty tokens
     * @param account account to burn tokens from
     * @param amount amount of tokens to be burnt
     */
    function burn(address account, uint256 amount) external {
        if (account != address(0)) {
            revert Invalid_Inputs(account);
        }
        if (amount < 1) {
            revert Insufficient_Funds(amount);
        }
        _totalSupply -= amount;
        emit Status("You have burned some tokens");
    }
}
