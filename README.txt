rdf_to_graphviz.rb:  It's abble to generate simple dot graph from RDF::Graph

____________________________________________________________________________

Example:

require 'ruby-graphviz'
require 'rdf_to_graphviz'

konwerter = RdfToGraphviz.new
queryable = RDF::Graph.load("http://ruby-rdf.github.com/rdf/etc/doap.nt")
str = konwerter.rdf_graph_to_dot(queryable, :is_literal_object_uniq => false)
GraphViz.parse_string(str).output( :png => "res_graph1.png" )


____________________________________________________________________________

Caution!

It's not compatible with ver. 0.0.0.2!