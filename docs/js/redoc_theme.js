Redoc.init('./o2r-openapi.yml',{
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
}, document.getElementById('redoc-container'), function(e){find_drafts();style_code();});


/**
 * find_drafts - A function which finds every <span> Element and if the cotain
 * the construction sign emoji it will change their HTTP button background-color to a
 * striped pattern to indicate that this is a draft.
 *
 * @return {type}  description
 */
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


/**
 * style_code - A function which finds every <code> HTML tag and changes its css class
 * to our custom 'pretty' which makes it more readable.
 */
function style_code(){
  var all_code = document.getElementsByTagName("code");
  for(var i = 0; i < all_code.length; i ++ ){
    all_code[i].setAttribute("style", "color: crimson;font-family: Courier, monospace;padding: 0px 5px;font-size: 13px;font-weight: 400;word-break:break-word;background-color:transparent;border: none");
  }
}
