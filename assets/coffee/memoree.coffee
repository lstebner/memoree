Memoree =
  init: ->
    @toolbar = new Memoree.Toolbar "#toolbar"
    @memoree = new Memoree.Main "#memoree"

    $(document.body).on "memoree:request", (e, evnt) =>
      @request evnt

  # expose allowed memoree events
  request: (evnt) ->
    unless _.indexOf(["reset"], evnt) > -1
      return console.log("requested action is not available") 

    switch evnt
      when "reset" then @memoree.reset()

class Memoree.Main
  constructor: (container, @opts={}) ->
    @opts = _.extend(
      shuffle: true
      mode: "echo" #bad name
      @opts
    )

    @container = $ container
    @setup()
    @render()

  setup: ->
    @uncovered_cards = 0
    @matched_cards = 0
    @stats =
      clicks: 0
      matched: 0
      remaining: 0
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
    @words = dictionary_words
    @stats.remaining = @words.length
    @stats_updated()

  stats_updated: ->
    @container.trigger "memoree:stats:update", @stats

  render: ->
    @cards = []
    for w, idx in @words
      word = w[0]
      # in echo mode, the same word is shown on two cards to be matched
      match = if @opts.mode == "echo"
        w[0]
      # otherwise, we use a second index for the match card
      else
        w[1]

      card = "<div class='card' data-id='#{idx}'><span>#{word}</span></div>"
      @cards.push card

      match = "<div class='card' data-id='#{idx}m'><span>#{match}</span></div>"
      @cards.push match

    cards = if @opts.shuffle then _.shuffle(@cards) else @cards
    @card_zone.append(card) for card in cards


  click_card: ($el, e) ->
    # currently waiting to check uncovered cards
    return if @check_cards_to || !_.isEmpty(_.intersection($el[0].classList, ["match", "miss", "uncover"])) 

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
    @stats.clicks++
    @stats_updated()
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
      @stats.matched++
      @stats.remaining--
      @stats_updated()
      "match"
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


# TODO: organize into separate file
class Memoree.Toolbar
  constructor: (container, @opts={}) ->
    @container = $ container
    @setup()

  setup: ->
    @setup_events()

  setup_events: ->
    @container.on "click", (e) =>
      prevent = true
      propagate = true
      $target = $(e.target)
      $currentTarget = $(e.currentTarget)

      if $target.is ".reset_btn"
        if confirm "Are you sure?"
          @container.trigger "memoree:request", "reset"

      e.preventDefault() if prevent
      e.stopPropagation() unless propagate

    $(document.body).on "memoree:stats:update", (e, @stats) =>
      @render_stats()

  render_stats: ->
    $stats = @container.find(".stats").html("")
    content = "clicks: #{@stats.clicks}  matched: #{@stats.matched}  remaining: #{@stats.remaining}"
    $stats.text content
    console.log @stats

$ ->
  document.Memoree = Memoree
  document.Memoree.init()



