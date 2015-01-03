React = require 'react'
caffeine = require 'react-caffeine'

onClick = (ev)->
  console.log ev
  
#register custom component
caffeine.register
  CustomCircle:
    render: ->
      #build DOM tag, passing @ as first argument
      caffeine @, ->
        @circle
          cx: 10
          cy: 50
          #refence @props
          r: @props.radius
          fill: "yellow"
          onClick: onClick

window.onload = ->
  vdom = caffeine ->
    @svg ->
      #CustomCircle is registered so you can use it
      @CustomCircle radius: 10
      @circle
        cx: 10
        cy: -50
        r: 100
        fill: "red"
        onClick: onClick
      @circle
        cx: 100
        cy: 100
        r: 100
        fill: "black"
  
  React.render vdom, document.body