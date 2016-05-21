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

	##
	# +rdf_graph_to_dot(options = {})+ generate simple dot graph from RDF::Graph
	#  @option options [RDF::Graph] :rdf_graph
	#  @option options [TrueClass]  :digraph - if true, graph has a direction - true is default
	#  @option options [String]     :subject_shape - default = doublecircle
	#  @option options [String]     :object_shape - default = circle
	#  @option options [String]     :literal_object_shape - default = rectangle
	#  @return [String] - contain representation of RDF::Graph in Graphviz dot 
    #
	def rdf_graph_to_dot(options = {})
		txt_dot = ""

		options[:rdf_graph] ||= @graph
		options[:digraph] ||= true
		options[:subject_shape] ||= "doublecircle"
		options[:object_shape] ||= "circle"
		options[:literal_object_shape] ||= "rectangle"

		if options[:digraph] == true
			txt_dot << "\ndigraph digraph_1 {"
		else
			txt_dot << "\ngraph graph_1 {"
		end

		options[:rdf_graph].each_statement do |statement|
			
			s = term_name(statement[0])
			o =  term_name(statement[2])

			txt_dot << "\n\"#{s}\"[color=red, shape=#{options[:subject_shape]}];"
			if statement[2].literal?
				txt_dot << "\n\"#{o}\"[shape=#{options[:literal_object_shape]}];"
			else
				txt_dot << "\n\"#{o}\"[color=blue, shape=#{options[:object_shape]}];"
			end
			txt_dot << "\n\"#{s}\" -> \"#{o}\" [label=\"#{statement[1].pname}\", color=red];"
			
		end
		txt_dot << "}"
	end

    private  :term_name

end