// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.13;

/**
 * @title ERC20 Token Implementation
 * @dev Implementation of the ERC-20 token standard.
 */
contract ERC20 {
  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 public totalSupply;

  // Mappings
  mapping(address => uint256) private _balances;
  mapping(address => mapping(address => uint256)) private _allowances;

  // Events
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);

  /**
   * @dev Constructor to initialize the token.
   * @param name_ Name of the token.
   * @param symbol_ Symbol of the token.
   * @param decimals_ Number of decimal places the token uses.
   * @param totalSupply_ Initial total supply of the token.
   */
  constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) {
    name = name_;
    symbol = symbol_;
    decimals = decimals_;
    totalSupply = totalSupply_;
    _balances[msg.sender] = totalSupply_;
  }

  /**
   * @notice Returns the balance of a given account.
   * @param _owner The address of the account.
   * @return The balance of the specified account.
   */
  function balanceOf(address _owner) public view returns (uint256) {
    return _balances[_owner];
  }

  /**
   * @notice Approves a spender to spend a specified amount of tokens.
   * @param _spender The address of the spender.
   * @param _value The amount of tokens to approve.
   * @return True if the operation was successful.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    _allowances[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @notice Returns the remaining amount of tokens that the spender can spend.
   * @param _owner The address of the token owner.
   * @param _spender The address of the spender.
   * @return The remaining allowance for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return _allowances[_owner][_spender];
  }

  /**
   * @notice Transfers tokens to a specified address.
   * @param _to The address of the recipient.
   * @param _value The amount of tokens to transfer.
   * @return True if the operation was successful.
   */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_balances[msg.sender] >= _value, "Insufficient balance");
    _balances[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
   * @notice Transfers tokens from one address to another using an allowance.
   * @param _from The address of the sender.
   * @param _to The address of the recipient.
   * @param _value The amount of tokens to transfer.
   * @return True if the operation was successful.
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    uint256 allowance_ = _allowances[_from][msg.sender];
    require(_balances[_from] >= _value, "Insufficient balance");
    require(allowance_ >= _value, "Allowance exceeded");
    _balances[_to] += _value;
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @notice Mint tokens from zero address to recipient.
   * @param _recipient The address of the recipient.
   * @param _value The amount of tokens to transfer.
   * @return True if the operation was successful.
   */
  function mint(address _recipient, uint256 _value) public returns (bool) {
    _balances[_recipient] += _value;
    totalSupply += _value;
    emit Transfer(address(0), _recipient, _value);
    return true;
  }
}