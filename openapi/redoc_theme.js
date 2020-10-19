Redoc.init('./openapi.yaml',{
  theme:{
      colors:{
      main: '#004286'
    },
    menu:{
      backgroundColor: '#004286',
      textColor: 'white'
    },
    rightPanel:{
      backgroundColor: '#343131'
    }
  }
}, document.getElementById('redoc-container'));
