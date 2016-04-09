class Memoree
  constructor: (container, @opts={}) ->
    @opts = _.extend(
      shuffle: true
      @opts
    )
    
    @container = $ container
    @setup()
    @render()

  setup: ->
    @uncovered_cards = 0
    @matched_cards = 0
    @card_zone = @container.find ".card_zone"
    @load_deck()
    @setup_events()

  setup_events: ->
    @container.on "click", (e) =>
      prevent = true
      propagate = true
      $target = $(e.target)
      $currentTarget = $(e.currentTarget)

      if $target.is ".card"
        @click_card $target, e

      e.preventDefault() if prevent
      e.stopPropagation() unless propagate

  load_deck: ->
    @words = ["red", "yellow", "orange", "blue"]

  render: ->
    @cards = []
    for word, idx in @words
      card = "<div class='card' data-id='#{idx}'><span>#{word}</span></div>"
      @cards.push card

      match = "<div class='card' data-id='#{idx}m'><span>#{word} match</span></div>"
      @cards.push match

    cards = if @opts.shuffle then _.shuffle(@cards) else @cards
    @card_zone.append(card) for card in cards


  click_card: ($el, e) ->
    # currently waiting to check uncovered cards
    return if @check_cards_to

    if @uncovered_cards < 2
      @uncover $el

    if @uncovered_cards == 2
      @check_cards_to = setTimeout =>
        @check_cards_to = null
        @check_uncovered_cards()

        if @matched_cards == @words.length
          @finished()
      , 500

  uncover: ($card) ->
    $card.addClass "uncover"
    @uncovered_cards++

  check_uncovered_cards: ->
    $uncovered = @container.find(".card.uncover")
    return console.log('not enough uncovered cards') unless $uncovered.length == 2
    ids = for c in $uncovered
      id = $(c).data("id") 
      id

    matched = @is_match ids[0], ids[1]
    new_classes = if matched
      @matched_cards++
      "matched"
    else
      setTimeout =>
        @container.find(".miss").removeClass("miss")
      , 800
      "miss"

    $uncovered.addClass(new_classes).removeClass("uncover")

    @uncovered_cards = 0
    matched

  is_match: (id1, id2) ->
    id2 == "#{id1}m" || id1 == "#{id2}m"

  finished: ->
    console.log "all cards matched!"
    @container.addClass("complete")

  reset: ->
    @uncovered_cards = 0
    @matched_cards = 0
    @card_zone.html ""
    @container.removeClass("complete")
    @render()


$ ->
  document.memoree = new Memoree "#memoree"


