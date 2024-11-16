// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "lib\framework\packages\0xcert-ethereum-erc721-contracts\src\contracts\nf-token-metadata.sol";
import "lib\framework\packages\0xcert-ethereum-erc721-contracts\src\contracts\nf-token-enumerable.sol";
import "lib\framework\packages\0xcert-ethereum-utils-contracts\src\contracts\permission\ownable.sol";

contract NumbersNFT is
  NFTokenMetadata,
  NFTokenEnumerable,
  Ownable
{

  constructor(
    string _name,
    string _symbol
  )
    public
  {
    nftName = _name;
    nftSymbol = _symbol;
  }

  function mint(
    address _owner,
    uint256 _id
  )
    onlyOwner
    external
  {
    super._mint(_owner, _id);
  }

  function burn(
    address _owner,
    uint256 _tokenId
  )
    onlyOwner
    external
  {
    super._burn(_owner, _tokenId);
  }

}