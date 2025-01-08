// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./tokens/NFToken.sol";

contract NFTDutchAuction {
    struct Auction{
        uint256 id;
        address seller;
        uint256 tokenId;
        uint128 startingPrice;
        uint128 endingPrice;
        uint64 duration;
        uint64 startedAt;
    }

    event AuctionFormed(uint256 auctionId, uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint64 duration);
    event AuctionCancelled(uint256 auctionId, uint256 tokenId);
    event AuctionSuccessful(uint256 auctionId, uint256 tokenId, uint256 totalPrice, address winner);

    ERC721 public NFTContract;

    uint64 public auctionId;

    mapping (uint256 => Auction) internal tokenIdAuction;
    mapping (uint256 => Auction) internal auctionIdAuction;


    constructor(address _NFTAddress) public {
        NFTContract = ERC721(_NFTAddress);
    }

    function createAuction(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) public {
        require(_startingPrice < 340282366920938463463374607431768211455); // 128 bits
      require(_endingPrice < 340282366920938463463374607431768211455); // 128 bits
      require(_duration <= 18446744073709551615); // 64 bits

      require(_duration >= 5 minutes);
      require(NFTContract.ownerOf(_tokenId) == msg.sender);
      Auction memory auction = Auction(
        uint256(auctionId),
        msg.sender,
        uint256(_tokenId),
        uint128(_startingPrice),
        uint128(_endingPrice),
        uint64(_duration),
        uint64(now)
      );

      tokenIdAuction[_tokenId] = auction;
      auctionIdAuction[auctionId] = auction;

      emit AuctionFormed(
        uint64(auctionId),
        uint256(_tokenId),
        uint256(auction.startingPrice),
        uint256(auction.endingPrice),
        uint64(auction.duration)
      );
      auctionId++;
    }

    function getAuctionByAuctionId(uint256 _auctionId) public view returns (
        uint256 id,
        address seller,
        uint256 tokenId,
        uint256 startingPrice,
        uint256 endingPrice,
            uint256 duration,
      uint256 startedAt
    ) {
        Auction storage auction = auctionIdAuction[_auctionId];
        require(auction.startedAt > 0);
        return(auction.id,auction.seller,auction.tokenId,auction.startingPrice,auction.endingPrice,auction.duration,auction.startedAt);
    }

    function getAuctionByTokenId(uint256 _tokenId) public view returns (
        uint256 id,
        address seller,
        uint256 tokenId,
        uint256 startingPrice,
        uint256 endingPrice,
        uint256 duration,
        uint256 startedAt
    ) {
        Auction storage auction = tokenIdAuction[_tokenId];
      require(auction.startedAt > 0);
      return (
          auction.id,
          auction.seller,
          auction.tokenId,
          auction.startingPrice,
          auction.endingPrice,
          auction.duration,
          auction.startedAt
      );
    }

    function cancelAuctionByAuctionId(uint256 _auctionId) public {
        Auction storage auction = auctionIdAuction[_auctionId];

        require(auction.startedAt > 0);
        require(msg.sender == auction.seller);

        delete auctionIdAuction[_auctionId];
        delete tokenIdAuction[auction.tokenId];

        emit AuctionCancelled(_auctionId, auction.tokenId);
    }

    function cancelAuctionByTokenId(uint256 _tokenId) public {
        Auction storage auction = tokenIdAuction[_tokenId];

        require(auction.startedAt > 0);
        require(msg.sender == auction.seller);

        delete auctionIdAuction[auction.id];
        delete tokenIdAuction[_tokenId];

        emit AuctionCancelled(auction.id, auction.tokenId);
  }

    function bid(uint256 _tokenId) public payable {
        Auction storage auction = tokenIdAuction[_tokenId];
        require(auction.startedAt > 0);

        uint256 price = getCurrentPrice(auction);
        require(msg.value >= price);

        address seller = auction.seller;
        uint256 auctionId_curr = auction.id;

        delete tokenIdAuction[_tokenId];
      delete auctionIdAuction[auction.id];

      if (price > 0) {
          uint256 sellerProceeds = price;
          seller.transfer(sellerProceeds);
      }

      NFTContract.transferFrom(seller, msg.sender, _tokenId);

      emit AuctionSuccessful(auctionId_curr, _tokenId, price, msg.sender);
    }

    function getCurrentPriceByAuctionId(uint64 _auctionId) public view returns (uint256) {
      Auction storage auction = auctionIdAuction[_auctionId];
      return getCurrentPrice(auction);
  }

  function getCurrentPriceByTokenId(uint256 _tokenId) public view returns (uint256) {
      Auction storage auction = tokenIdAuction[_tokenId];
      return getCurrentPrice(auction);
  }

    function getCurrentPrice(Auction storage _auction) internal view returns (uint256) {
      require(_auction.startedAt > 0);
      uint256 secondsPassed = 0;

      secondsPassed = now - _auction.startedAt;

      if (secondsPassed >= _auction.duration) {
          return _auction.endingPrice;
      } else {
          int256 totalPriceChange = int256(_auction.endingPrice) - int256(_auction.startingPrice);

          int256 currentPriceChange = totalPriceChange * int256(secondsPassed) / int256(_auction.duration);

          int256 currentPrice = int256(_auction.startingPrice) + currentPriceChange;

          return uint256(currentPrice);
      }
  }

  // return ether that is sent to this contract
  // fallback () public {}
}

