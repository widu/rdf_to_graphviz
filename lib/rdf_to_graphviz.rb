# Require 'linkeddata' gem
require 'linkeddata'

# Require 'sparql' gem
require 'sparql'

class RdfToGraphviz

	def term_name(statement)
		if statement.literal?
			statement.to_s
		elsif statement.node?
			statement.to_s
		else
			statement.pname
		end
			 
	end

	# =Example:
	# +require 'ruby-graphviz'+
    # require 'rdf_to_graphviz'

    # konwerter = RdfToGraphviz.new
    # queryable = RDF::Graph.load("http://ruby-rdf.github.com/rdf/etc/doap.nt")
    # str = konwerter.rdf_graph_to_dot({:rdf_graph => queryable})
    # puts str
    # GraphViz.parse_string(str).output( :png => "res_graph1.png" )

	def rdf_graph_to_dot(options = {})
		txt_dot = ""
		options[:rdf_graph] ||= @graph
		options[:digraph] ||= true
		if options[:digraph] == true
			txt_dot << "\ndigraph digraph_1 {"
		else
			txt_dot << "\ngraph graph_1 {"
		end

		options[:rdf_graph].each_statement do |statement|
			
			s = term_name(statement[0])
			o =  term_name(statement[2])

			txt_dot << "\n\"#{s}\"[color=red, shape=doublecircle];"
			if statement[2].literal?
				txt_dot << "\n\"#{o}\"[shape=rectangle];"
			else
				txt_dot << "\n\"#{o}\"[color=blue, shape=circle];"
			end
			txt_dot << "\n\"#{s}\" -> \"#{o}\" [label=\"#{statement[1].pname}\", color=red];"
			
		end
		txt_dot << "}"
	end

    private  :term_name

end