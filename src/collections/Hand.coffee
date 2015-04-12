class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop())
    @checkScore()

  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]

  validScore: (arg)->
    score = @scores()
    if (score[1] < 22) and arg is 'max'
      score[1]
    else
      score[0]

  checkScore: ->
    if(@validScore('min') > 21)
      @trigger 'bust', @isDealer

  stand: ->
    @trigger 'stand'

  startDealing: ->
    @.at(0).flip()
    while @validScore('max') < 17
      @.hit()
    if @validScore('min') < 22
      @trigger 'gameOver'
