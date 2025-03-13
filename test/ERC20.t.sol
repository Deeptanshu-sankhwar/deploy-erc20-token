// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/ERC20.sol";

contract ERC20Test is Test {
  ERC20 token;

  // Some helper variables to reuse throughout the tests.
  address owner = address(0xaa);
  address recipient = address(0xbb);
  address spender = address(0xcc);
  uint256 initialSupply = 1000 * 10**18;
  uint256 amount = 100 * 10**18;

  // Redeclare event here to later verify the contract emits as expected.
  event Transfer(address indexed from, address indexed to, uint256 value);

  // setUp is run before every test to set up the environment.
  // see more: https://book.getfoundry.sh/forge/writing-tests?highlight=setUp#before-test-setups
  function setUp() public {
    vm.prank(owner);
    token = new ERC20("CSCI 4240/5240 Official Token", "CUB", 18, initialSupply);
  }

  // testMetadata will constructor parameters passed in.
  function testMetadata() public view {
    assertEq(token.name(), "CSCI 4240/5240 Official Token");
    assertEq(token.symbol(), "CUB");
    assertEq(token.decimals(), 18);
    assertEq(token.totalSupply(), initialSupply);
  }

  // testTransfer verifies a transfer can be made and the balance of the sender
  // does not decrease.
  function testTransfer() public {
    vm.prank(owner);
    token.transfer(recipient, amount);

    assertEq(token.balanceOf(recipient), amount);
    assertEq(token.balanceOf(owner), initialSupply);
  }

  // testTransferInsufficientBalance verifies that a user must still have a
  // balance in order to send tokens.
  function testTransferInsufficientBalance() public {
    vm.prank(recipient);
    vm.expectRevert();
    token.transfer(owner, amount);
  }

  // testAllowance verifies the allowance of a recipient is not deducted after
  // a transfer.
  function testAllowance() public {
    vm.prank(owner);
    token.approve(recipient, amount);
    assertEq(token.allowance(owner, recipient), amount);

    vm.prank(recipient);
    token.transferFrom(owner, recipient, amount);
    assertEq(token.balanceOf(recipient), amount);
    assertEq(token.allowance(owner, recipient), amount);
  }

  // testMint checks that tokens can be minted on-demand.
  function testMint() public {
    vm.expectEmit(true, true, false, false);
    emit Transfer(address(0), recipient, amount);
    token.mint(recipient, amount);
    assertEq(token.balanceOf(recipient), amount);
  }
}