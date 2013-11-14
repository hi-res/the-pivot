should = do (require 'chai').should
coffee = require 'coffee-script'

exports.test = ( pivot ) ->

  foofunk  = ->
  listener = {}

  describe '[key-> value storage]', ->

    it 'it should store a value', (done)->

        pivot.set 'key', 'value'
        done()

    it 'it should retrieve a value', (done)->

        (pivot.get 'key').should.equal 'value'

        done()

    it 'it should bind to a key', (done)->

        pivot.bind 'test', -> done()

        pivot.set 'test', 5

  describe '[event system]', ->

    it 'it should register an event', (done) ->

        pivot.on 'event', ->
        done()

    it 'it should trigger an event', (done)->

        pivot.on 'test:trigger', foofunk
        pivot.on 'test:trigger', -> done()

        pivot.trigger 'test:trigger', 'foo'

    it 'it should unregister event', (done)->

        pivot.off( 'test:trigger', foofunk ).should.equal true

        done()

    it 'it should emit an event', (done)->

        pivot.on 'test:emit', foofunk
        pivot.on 'test:emit', -> done()

        pivot.emit 'test:emit', 'foo'



    it 'it should listen to an event only once', (done)->

        counter = 0;

        funk = -> counter++

        pivot.once 'test:once', funk

        pivot.trigger 'test:once'
        pivot.trigger 'test:once'

        counter.should.equal 1

        done()

    it 'should know if a function is subscribed to an event', ( done ) ->
        funk = -> 

        pivot.on 'test:will_call', funk

        pivot.will_call( 'test:will_call', funk ).should.equal true

        done()

  # describe '[include/extend]', ->

  #   it 'i should write this test', (done)->
  #       # should.not.exist err
  #       done()