React = require 'react'
{DOM} = React

class Node
  constructor: (parent)->
    @content = []
    @$ = parent
    @props = parent?.props
    
  register: (tag, props, child)->
    @content.push {tag, props, child}

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
      if fn?
        newNode = new Node(@$)
        fn.call(newNode)
        @register content, props || {}, newNode
      else
        @register content, props || {}, null
  )(tagName, tagContent)

registerTag(tagName, tagContent.bind(DOM)) for tagName, tagContent of DOM
registerTag 'text', (props)->props

caffeine = (component, fn)->
  #[fn] [component,fn]
  node = new Node(fn && component)
  (fn || component).call(node)
  node.exec()[0]

caffeine.register = (tags)->
  for tagName, tagBody of tags
    registerTag tagName, ((body)->
      (props, children)->
        React.createElement body, props, children
    )(React.createClass(tagBody))

caffeine.registerClass = (tags)->
  for tagName, tagBody of tags
    registerTag tagName, ((body)->
      (props, children)->
        React.createElement body, props, children
    )(tagBody)
    
module.exports = caffeine