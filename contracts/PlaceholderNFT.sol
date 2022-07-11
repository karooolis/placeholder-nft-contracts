// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract PlaceholderNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string private _svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='11 11 50 50'><g><rect x='12' y='12' width='48' height='48' fill='#A57939' stroke='none' stroke-linecap='round' stroke-linejoin='round' stroke-miterlimit='10' stroke-width='2'></rect><rect x='18' y='18' width='36' height='36' fill='#92D3F5' stroke='none' stroke-linecap='round' stroke-linejoin='round' stroke-miterlimit='10' stroke-width='2'></rect><circle cx='26' cy='30' r='4' fill='#FCEA2B' stroke='none' stroke-linecap='round' stroke-linejoin='round' stroke-miterlimit='10' stroke-width='2'></circle><path fill='#5C9E31' stroke='#5C9E31' stroke-linecap='round' stroke-linejoin='round' stroke-miterlimit='10' stroke-width='2' d='M50,35c-2.8958-0.8542-6.2795-7.9886-8-8c-4.208-0.0278-6.254,5.836-11,9c-3,2-3.3745,2.8497-6,4c-2.2824,1-3,3-3.25,3.6406 c-0.3031,0.7766-1.4751,2.5214-0.9583,3.1094c1.2083,1.375,2.4583,1.5,5,0.7179c2.147-0.6606,4.9769-4.8074,6.875-6.2179 c2.2708-1.6875,4.6458-2.5,8.0833-2c2.4795,0.3606,6.66,3.1723,7.8125,3.0625c1.3125-0.125-1.5937-2.5625-0.5312-4.1875 c1.1327-1.7325,2.9102,0.1529,3.6354-1.0833C51.9844,36.5,50.632,35.1864,50,35z'></path></g><g><rect x='12' y='12' width='48' height='48' fill='none' stroke='#000000' stroke-linecap='round' stroke-linejoin='round' stroke-miterlimit='10' stroke-width='2'></rect><rect x='18' y='18' width='36' height='36' fill='none' stroke='#000000' stroke-linecap='round' stroke-linejoin='round' stroke-miterlimit='10' stroke-width='2'></rect><circle cx='26' cy='30' r='4' fill='none' stroke='#000000' stroke-linecap='round' stroke-linejoin='round' stroke-miterlimit='10' stroke-width='2'></circle><rect x='18' y='18' width='36' height='36' fill='none' stroke='#000000' stroke-linecap='round' stroke-linejoin='round' stroke-miterlimit='10' stroke-width='2'></rect><path fill='none' stroke='#000000' stroke-linecap='round' stroke-linejoin='round' stroke-miterlimit='10' stroke-width='2' d='M22,43c0.5259-1.0198,0.7275-1.9672,3-3c2.6096-1.1859,3-2,6-4c4.746-3.164,6.792-9.0278,11-9c1.7205,0.0114,5,7,8,8'></path></g></svg>";

    constructor() ERC721("Placeholder NFT", "PNFT") {}

    function mint(uint256 quantity) public {
        for (uint256 i; i < quantity; i++) {
            // Get the current tokenId, this starts at 0.
            uint256 newItemId = _tokenIds.current();

            // Get all the JSON metadata in place and base64 encode it.
            string memory json = Base64.encode(
                bytes(
                    string(
                        abi.encodePacked(
                            '{"name": "',
                            // We set the title of our NFT as the generated word.
                            string(abi.encodePacked("#", Strings.toString(newItemId))),
                            '", "description": "One out of many, not rare. ERC721.", "image": "data:image/svg+xml;base64,',
                            // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                            Base64.encode(bytes(_svg)),
                            '"}'
                        )
                    )
                )
            );

            // Just like before, we prepend data:application/json;base64, to our data.
            string memory finalTokenUri = string(
                abi.encodePacked("data:application/json;base64,", json)
            );

            // Mint the NFT to the sender using msg.sender.
            _safeMint(msg.sender, newItemId);

            // Set the NFTs data.
            _setTokenURI(newItemId, finalTokenUri);

            // Increment the counter for when the next NFT is minted.
            _tokenIds.increment();
        }
    }
}
