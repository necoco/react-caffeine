React = require 'react'
{DOM} = React

class Node
  constructor: (parent)->
    @content = []
    @$ = parent
    @props = parent?.props
    
  register: (tag, props, child)->
    @content.push {tag, props, child}
    @

  exec: ()->
    for op in @content
      op.tag op.props, op.child?.exec()

registerTag = (tagName, tagContent)->
  Node::[tagName] = ((tag, content) ->
    (props, fn)->
      #[props,fn] [fn] [props]
      if typeof props is 'function'
        fn = props
        props = null
      @register content, props || {}, fn?.call(new Node(@$))
  )(tagName, tagContent)

registerTag(tagName, tagContent.bind(DOM)) for tagName, tagContent of DOM
registerTag 'text', (props)->props

caffeine = (component, fn)->
  #[fn] [component,fn]
  (fn || component).call(new Node(fn && component)).exec()[0];

caffeine.register = (tags)->
  for tagName, tagBody of tags
    registerTag tagName, ((body)->
      (props, children)->
        React.createElement body, props, children
    )(tagBody)

module.exports = caffeine