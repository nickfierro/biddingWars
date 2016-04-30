contract BiddingWars
{
    // bid : address + value
    struct Bid 
    {
        address bidder;
        uint value;
        bytes hashId;
    }
    
    // seller's account
    address internal seller;      
    
    // All time are either intervals are absolute unix timestamps (seconds since 1970-01-01), time periods are in seconds.
    uint    internal auctionStart;
    uint    internal biddingPeriod;        
    uint    internal biddingEnd;

    // Current state of the auction.
    address public highestBidder;
    uint    public highestBid;

    // Set to true at the end, disallows any change
    bool ended;
    
    /// Just a struct holding our data.
    Bid[] internal bids;
    
    // dfsfdsfdsfdsfbjkkjhkjhjkhjkkj

    // Events that will be fired on changes.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);
    
    /// Modifiers are a convenient way to validate inputs to
    /// functions. `onlyBefore` is applied to `bid` below:
    /// The new function body is the modifier's body where
    /// `_` is replaced by the old function body.
    modifier onlyBefore(uint _time) { if (now >= _time) throw; _ }
    modifier onlyAfter(uint _time) { if (now <= _time) throw; _ }

    /// Constructor
    /// Seller's address `_seller`, _biddingPeriod (timespan)
    function BiddingWars(address _seller, uint _biddingPeriod) 
    {
        seller = _seller;
        auctionStart = now;
        biddingPeriod = _biddingPeriod;      // convert to seconds
        biddingEnd = auctionStart + _biddingPeriod;
    }

    // Place bid
    function placeBid() external onlyBefore(biddingEnd)
    {

       if (ended)
            throw; 
            
        bids.push(Bid( { bidder: msg.sender, value: msg.value, hashId: msg.data } ));
        
        if (msg.value >= highestBid)
        {
            highestBidder = msg.sender;
            highestBid = msg.value;
            HighestBidIncreased(msg.sender, msg.value);
        }
    }

    // Called to end the auction
    function auctionEnd() external onlyAfter(biddingEnd)
    {

       if (ended)
            throw; 
            
        // Fire the AuctionEnded event    
        AuctionEnded(highestBidder, highestBid);
        
        // refund all but the winner
        refundAll();
        
        // Send money to the seller
        seller.send(this.balance);
        ended = true;
    }

    /// Refund all bidders except the winner 
    function refundAll() internal 
    {
        
        for (var i = 0; i < bids.length; ++i)
        {
            if (bids[i].bidder != highestBidder)
            {
                // Some refunds may fail
                bids[i].bidder.send(bids[i].value);
            }
        }
    }

}
