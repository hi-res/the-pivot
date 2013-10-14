###
Couple of lines from:
https://github.com/jeromeetienne/microevent.js
###

if exports? and module and module.exports
  PivotItem = require './pivot_item'

class Pivot


  _events: null

  _do_init: ( event ) ->
    @_events          ?= {}
    @_events[ event ] ?= { listeners: [], value: null }

  # "Adds a listener" to a given event
  # 
  # Returns a PivotItem ( listener )
  on: ( event, funk, bind = off ) ->
    @_do_init event

    listener       = new PivotItem @
    listener.event = event
    listener.funk  = funk

    @_events[ event ].listeners.push listener

    if bind
      if @get( event ) != null
        listener.trigger @get( event )

    return listener

  # Same as "on" but will be triggered only once.
  once: ( event, funk ) ->
    listener = @on event, funk
    listener.once = true
    return listener

  # Same as "on", but
  # - Will trigger once instantly after binding
  # - Will propagate again only when the value for this event changes
  bind: ( event, funk, bind = on ) ->
    return @on event, funk, bind

  # "Removes a listener" for a given event
  off: ( event, funk ) ->
    return if not @_events[ event ]?

    for item, index in @_events[ event ].listeners
      if item.funk == funk
        @_events[ event ].listeners.splice( index, 1 )

        return on

    console.log "function wasnt bined to event #{event}"

    return off

  # Saves a value for a key ( event )
  # 
  # If the value is different from previously set value, trigger method
  # will be called
  set: ( event, value ) ->
    @_do_init event

    if @_events[ event ]?
      return value if @_events[ event ].value == value

    @trigger event, value

    return value
    
  # Retrieves a value for a key ( event )
  get: ( event, value ) ->
    return null if not @_events[ event ]?

    return @_events[ event ].value

  # "Dispatch" the event to all listeners
  trigger: ( event, value ) ->
    @_do_init event

    @_events[ event ].value = value

    # clone the array otherwise if a listener calls off when triggered
    # the loop would be broke due to the "slice" that happens
    listeners = @_events[ event ].listeners.slice(0)

    for item, index in listeners
      item.trigger value

    return value

  # Alias for trigger function
  emit: ( event, value ) ->
    @trigger event, value

  #
  # handy methods
  #
  
  @include = ( target ) -> 
    target::[property] = @::[property] for property of @::

    return null

  @extend: ( object ) ->
    for property, value of object
      @[property] = value
    return @

# exporting
if exports? and module and module.exports
  module.exports = Pivot
else if define? and define.amd
  define -> Pivot
else if window
  (window.the or= {}).pivot = Pivot
