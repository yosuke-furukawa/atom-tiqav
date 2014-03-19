{$, BufferedProcess, EditorView, View} = require 'atom'
tiqav = require 'tiqav.js'

module.exports =
class AtomTiqavView extends View
  @content: ->
    @div class: 'atom-tiqav overlay from-top', =>
      @subview 'miniEditor', new EditorView(mini: true)
      @div class: 'error', outlet: 'error'
      @div class: 'message', outlet: 'message'

  initialize: (serializeState) ->
    atom.workspaceView.command "atom-tiqav:search", => @search()
    atom.workspaceView.command "atom-tiqav:close", => @destroy()
    @miniEditor.hiddenInput.on 'focusout', => @detach() unless @detaching
    @on 'core:confirm', => @confirm()
    @on 'core:cancel', => @detach()

  detach: ->
    return unless @hasParent()
    @detaching = true
    @miniEditor.setText('')
    super
    @detaching = false

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  searchCallback: (err, res) ->
    imageNum = parseInt(Math.random() * res.length)
    imageUrl = tiqav.createImageUrl(res[imageNum].id, res[imageNum].ext)
    tiqavUrl = "http://tiqav.com/#{res[imageNum].id}"
    editor = atom.workspace.getActiveEditor()
    markdownSnippet = "[![tiqav](#{imageUrl})](#{tiqavUrl})"
    editor.setText(editor.getText() + markdownSnippet)

  confirm: ->
    query = @miniEditor.getText()
    tiqav.search.search(query, @searchCallback);
    @detach()

  search: ->
    console.log "AtomTiqavView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
      @miniEditor.focus()
