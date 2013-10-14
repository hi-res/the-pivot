class PivotItem

  event: null

  funk: null

  value: null

  # When true, will automatically call "off" after being triggered
  # in short: will be triggered only once
  once: off

  constructor: ( parent ) ->
    @parent = parent

  # Forces an "event" to be "dispatched" passing the given value as argument
  trigger: ( value ) ->
    @set value

    @funk?( value )

    if @once then @off()

    return @

  # Calls "set" method at the parent Pivot passing value as argument, thus
  # propagating this value to all other listeners that might be listening
  # to the same "event"
  set: ( value ) ->
    if value == @value then return

    @parent.set @event, value

    return @value = value

  # Return last set ( or propagated ) value for this event
  get: ->
    return @value


  # "Removes a listener" from its parent listener list
  off: ->
    @parent.off @event, @funk

  # "Adds a listener" to the parent using the previously set event
  # ATTENTION: it will be added as last on the queue, if you want
  # to keep the same place in the list, you should "deactivate" /
  # "activate" logic in your side or in this class
  on: ->
    @parent.on @event, @funk


if exports? and module and module.exports
  module.exports = PivotItem
else if define? and define.amd
  define -> PivotItem