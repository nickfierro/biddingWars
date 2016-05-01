function toggleModal() {
  $("#myModal").modal("toggle");
};

function bidPlace(ammount, accIndex){
  biddingWars.placeBid().sendTransaction(ammount, {from:web3.eth.accounts[accIndex]})
};

function watchContract(){
  alert(contract.address);
  console.log("I'm Watching for Incoming TX's");
  biddingWars.HighestBidIncreased().watch(function (error, result) {
   if (!error) {
     console.log("Event: " + result);
   }
  });
  biddingWars.AuctionEnded().watch(function (error, result) {
   if (!error) {
     console.log("Event: " + result);
   }
  })
}
