window.addEventListener('load', ->
  width = 500
  height = 500
  padding_left = 100
  padding_right = 300

  layout = d3.layout.cluster()
    .size([height, width-padding_right])

  proj = d3.svg.diagonal()
    .projection((d) -> [d.y, d.x])

  svg = d3.select('#graph')
    .append('svg')
      .attr('width', width)
      .attr('height', height)
    .append('g')
      .attr('transform', "translate(#{padding_left},0)")

  d3.json('/data.json', (error, root) ->
    nodes = layout.nodes(root)
    links = layout.links(nodes)
    link = svg.selectAll('.link')
      .data(links)
      .enter().append('path')
        .attr('class', 'link')
        .attr('d', proj)
    node = svg.selectAll('.node')
      .data(nodes)
      .enter().append('g')
        .attr('class', 'node')
        .attr('transform', (d) -> "translate(#{d.y},#{d.x})")
        .on('click', (d) ->
          window.open("http://rubydoc.info/gems/sinatra/frames/#{d.path}", '_blank')
        )
    node.append('circle')
      .attr('r', 4.5)
    node.append('text')
      .attr('dx', (d) -> if d.children then -15 else 15)
      .attr('dy', 4)
      .style('text-anchor', (d) -> if d.children then 'end' else 'start')
      .text((d) -> d.name)
  )
)
