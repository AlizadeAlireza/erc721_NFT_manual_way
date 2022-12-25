# ERC721 NFT

    are smart contract that live on a blockchain.

    in our case the contract stores the unique properties of the
    item and keeps track of current and previous owners.

NFT : Non-Fungible Token

means that something connot be exchanged for another item because it's unique like one piece of art.

how can we approve who's the original owner when everyone has an identical copy of file?

NFT represent our art contains a bit of information about it:

    - Unique fingerprint (hash)
    - Token name
    - Token symbol

    this will store on a blockchain and the creator become the owner.

allows us to trach who's the current owner of a token and for how much it has been sold in the past.

only the atributes: Unique fingerprint (hash), Token name, Token symbol and optionally a link to a file hosted
on IPFS.

we don't get a physical copy of it.

most of the time, everyone can download a copy for free.

## creator rights

    while the token owner owns the original artwork, the creator of the NFT retains the copyright
    and the reproduction rights.

    so an artist can sell his original artwork as an NFT, but he can still sell prints.

## Usages

    - Digital artwork
    - Consert tickets
    - Domain names
    - In-game items
    - Real-state
    - and anything that is unique and needs proof of ownership.

## NFT price

why are some NFTs worth millions?

well, their worth is determined by what people are willing to pay for it.

## Coding

we need IERC165, IERC721 and IERC721Receiver.

in IERC721Receiver we need to call this function onERC721Received() when we call function
save transferFrom inside erc721.

### state variables:

    - we need to store the owner of each NFT.
    - we need to keep check of the amount of NFT.
    - the owner of the address might approve another address to take control of his NFT.
    - maybe the owner have many NFTs.
        the second address that was given premission by the owner to spend the nft.

### functions:

    supportsInterface :
        we need to return to if the interface ID passed from the input matches the interface ID for
        IERC165 or IERC721.

    setApprovalForAll:
        if this is true this means that msg.sender has given permission to operator to be able to
        spend his nft.
        emit Approval.

    approve:
        gives permission to the two edges to take control of tokenId.
        tha caller must be owner of token or has permission to spend it.

        set the approval for the tokenId.

    getApproved:
        will return the address of the approval assigned to tokenId.
        the owner of token must be exist.

    isApprovedOrOwner:
        check whether spender is owner of token or whether the spender has permission to spend
        the token.

    transferFrom:
        transfer the ownership of the NFT.
        update the balanc to the new owner and set ownership.

    safeTransferFrom:

        difference with transferFrom:
            if (address to) is a contract then we'll need to call the function IERC721Received.

            - to.code.length == 0;
            this means that the length of the code that stored in address(to) is zero.
            so will means to address is not a contract or is the contract that deployes just now.

            if this is true so is not a contract and we wan't call recieved function.

            in this case the massage of operator is msg.sender and calldata is empty "".

    safeTransferFrom:

        is just like the previous function but this function pass some data.
