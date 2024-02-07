// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title An ERC20 Token contract
 * @author Kwame 4B
 * @notice Testing out basic functionality
 */
contract FourbToken {
    uint256 public totalSupply;
    // returns standard decimals for tokens
    uint8 public decimals;
    string public name;
    string public symbol;
    // to track balance of addresses
    mapping(address => uint256) public balanceOf;
    // tracking allowances
    mapping(address => mapping(address => uint256 _value)) public Allowance;

    // emits the specified details when there's a successful transfer
    event Transfer(address indexed from, address indexed to, uint256 amount);
    // emits when there's an approval
    event Approve(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    /**
     * Initializing necessary variables
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialAmount
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialAmount * (10 ** (decimals));
        balanceOf[msg.sender] = totalSupply;
    }

    /**
     * A function that transfers tokens to a valid receiver
     * @param receiver address of receiver
     * @param _amount amount sent to receiver
     */
    function TransferToken(
        address receiver,
        uint256 _amount
    ) external returns (bool) {
        require(_amount < balanceOf[msg.sender], "Insufficient balance");
        require(receiver != address(0), "Invalid receiver");
        balanceOf[msg.sender] -= _amount;
        balanceOf[receiver] += _amount;
        emit Transfer(msg.sender, receiver, _amount);
        return true;
    }

    /**
     * A function to allocate funds to users
     * @param amount Amount approved to spend
     * @param Spender Address of account spending approved funds
     */
    function ApproveSpender(
        uint256 amount,
        address Spender
    ) external returns (bool) {
        Allowance[msg.sender][Spender] = amount;
        emit Approve(msg.sender, Spender, amount);
        return true;
    }

    /**
     * A function to transfer tokens from one address to another
     * @param from Address of sender
     * @param to address of receiver
     * @param amount amount to be sent
     */
    function transferfrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        Allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    /**
     * A function that mints tokens
     * @param amount amount to be minted
     */
    function mint(uint256 amount) external returns (bool) {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
        return true;
    }

    /**
     * A function that burns existing tokens
     * @param amount amount to be burnt from pool
     */
    function burn(uint256 amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
        return true;
    }
}
