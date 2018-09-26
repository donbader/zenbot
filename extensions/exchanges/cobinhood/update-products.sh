#!/usr/bin/env node
let client = require('node-cobinhood')
let cobinhood = new client()

cobinhood.listTradingPairs().then(function(markets) {
  var products = []
  markets.forEach(function (market) {

    let decimal = market.increment.decimalPlaces()
    var currStepSize = '0.'
    for (i = decimal ; i > 0; i--) {
      currStepSize = currStepSize + (i == 1 ? '1' : '0')
    }

    decimal = market.minSize.decimalPlaces()
    var assetStepSize = '0.'
    for (i = decimal ; i > 0; i--) {
      assetStepSize = assetStepSize + (i == 1 ? '1' : '0')
    }

    products.push({
      id: market.id,
      asset: market.base,
      currency: market.quote,
      min_size: market.minSize.toString(),
      max_size: market.maxSize.toString(),
      increment: currStepSize,
      asset_increment: assetStepSize,
      label: market.base + '/' + market.quote
    })
  })

  var target = require('path').resolve(__dirname, 'products.json')
  require('fs').writeFileSync(target, JSON.stringify(products, null, 2))
  console.log('wrote', target)
  process.exit()
})
