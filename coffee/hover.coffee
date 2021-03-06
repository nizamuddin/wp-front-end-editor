HOVER_BORDER = 2
HORIZONTAL_PADDING = 4
VERTICAL_PADDING = 2

class FrontEndEditor.hover

	lock: false,
	timeout: null,

	constructor: (@target, $content) ->
		# Webkit really doesn't like block elements inside inline elements
		if @target.width() > @target.parent().width()
			@target.css('display', 'block')

		@border = jQuery('<div>',
			'class': 'fee-hover-border',
			'css': { width: HOVER_BORDER }
		).hide().appendTo('body')

		@container = jQuery('<div>',
			'class': 'fee-hover-container'
			'html': $content
		).hide().appendTo('body')

		@container.click (ev) =>
			ev.preventDefault()
			@hide_immediately()

		@target.mousemove (ev) =>
			@position_vert(ev.pageY)

		@target.mouseover (ev) =>
			@position_vert(ev.pageY)
			@show()

	bind_autohide: ->
		@target.bind 'mouseout.autohide', (ev) =>
			@hide()

		@container.bind 'mouseover.autohide', =>
			@lock = true

		@container.bind 'mouseout.autohide', =>
			@lock = false
			@hide()

	unbind_autohide: ->
		@target.unbind '.autohide'
		@container.unbind '.autohide'

	position_vert: (mouse_vert_pos) ->
		normal_height = mouse_vert_pos - @container.outerHeight()/2

		@container.css('top', (normal_height - HOVER_BORDER) + 'px')

	hide_immediately: ->
		@container.hide()
		@border.hide()

	hide: ->
		@timeout = setTimeout =>
			if @lock
				return

			@hide_immediately()
		, 300

	show: ->
		offset = @target.offset()

		clearTimeout @timeout

		# Position container
		@container.css 'left', (offset.left - @container.outerWidth() - HORIZONTAL_PADDING) + 'px'
		@container.show()

		# Position border
		@border.css(
			'left'  : (offset.left - HORIZONTAL_PADDING) + 'px'
			'top'   : (offset.top  - VERTICAL_PADDING - HOVER_BORDER) + 'px'
			'height': (@target.height() + VERTICAL_PADDING * 2) + 'px'
		).show()
