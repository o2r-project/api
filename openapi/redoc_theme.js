Redoc.init('./openapi.yaml',{
  theme:{
      colors:{
      main: '#004286'
    },
    sidebar:{
      backgroundColor: '#004286',
      textColor: 'white'
    },
    rightPanel:{
      backgroundColor: '#343131'
    }
  }
}, document.getElementById('redoc-container'), function(e){find_drafts();});


function find_drafts(){
  var all_drafts = document.getElementsByTagName("span");
  console.log(all_drafts);
  console.log(all_drafts.item(0));
  for (var i = 0; i < all_drafts.length; i++){
      if(/🚧/.test(all_drafts[i].innerHTML)){
        var previous_node = all_drafts[i].previousSibling;
        previous_node.className = "sc-fznBMq dUeKSG operation-type draft";
    }
  }
}
