AtomTiqavView = require './atom-tiqav-view'

module.exports =
  atomTiqavView: null

  activate: (state) ->
    @atomTiqavView = new AtomTiqavView(state.atomTiqavViewState)

  deactivate: ->
    @atomTiqavView.destroy()

  serialize: ->
    atomTiqavViewState: @atomTiqavView.serialize()
