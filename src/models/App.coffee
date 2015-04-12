# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @get('playerHand').on('all', @playerEvents, @)
    @get('dealerHand').on('all', @dealerEvents, @)

  restart: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @get('playerHand').on('all', @playerEvents, @)
    @get('dealerHand').on('all', @dealerEvents, @)

  playerEvents: (event, arg)->
    if event is 'stand' then @get('dealerHand').startDealing.bind(@get('dealerHand'))()
    if event is 'bust' then @bust(arg)

  dealerEvents: (event)->
    if event is 'bust' then @bust(arg)
    if event is 'gameOver' then @gameOver()

  bust: (arg)->
    if arg
      arg = 'Dealer'
    else
      arg = 'Player'  
    alert("#{arg} busted")
    @restart()

  gameOver: ->
    playerScore = @get('playerHand').validScore('max')
    dealerScore = @get('dealerHand').validScore('max')

    if playerScore > dealerScore
      alert 'Player Wins'
    else if playerScore is dealerScore
      alert 'Push'
    else
      alert 'Dealer Wins'
    @restart()