pragma solidity >=0.4.22 <0.9.0;

/**
 * @dev Optional metadata extension for ERC-721 non-fungible token standard.
 * See https://goo.gl/pc9yoS.
 */
interface ERC721Metadata {

  /**
   * @dev Returns a descriptive name for a collection of NFTs in this contract.
   */
  function name()
    external
    view
    returns (string memory);

  /**
   * @dev Returns a abbreviated name for a collection of NFTs in this contract.
   */
  function symbol()
    external
    view
    returns (string memory);

  /**
   * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
   * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
   * that conforms to the "ERC721 Metadata JSON Schema".
   */
  function tokenURI(uint256 _tokenId)
    external
    view
    returns (string memory);

}