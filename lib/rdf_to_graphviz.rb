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
	# rdf_graph_to_dot(rdf_graph, options = {}) generate simple dot graph from RDF::Graph
	#  @param  [RDF::Graph]             rdf_graph                
	#  @param  [Hash{Symbol => Object}] options
	#  @option options [TrueClass]  :digraph                  - default = true - if true, graph has a direction
	#  @option options [String]     :subject_shape            - default = doublecircle
	#  @option options [String]     :object_shape             - default = circle
	#  @option options [String]     :literal_object_shape     - default = rectangle
	#  @option options [String]     :subject_color            - default = red
	#  @option options [String]     :object_color             - default = blue
	#  @option options [String]     :predicate_color          - default = black
	#  @option options [TrueClass]  :is_literal_object_uniq   - default = true
	#  @return [String] - contain representation of RDF::Graph in Graphviz dot 
    #
	def rdf_graph_to_dot(rdf_graph, options = {})
		txt_dot = ""

		#options[:rdf_graph] ||= @graph
		options[:digraph] = true if options[:digraph].nil?
		options[:subject_shape] ||= "doublecircle"
		options[:object_shape] ||= "circle"
		options[:literal_object_shape] ||= "rectangle"
		options[:subject_color] ||= "red"
		options[:object_color] ||= "blue"
		options[:predicate_color] ||= "black"
		options[:is_literal_object_uniq] = true if options[:is_literal_object_uniq].nil?


		n=0

		if options[:digraph] == true
			txt_dot << "\ndigraph digraph_1 {"
		else
			txt_dot << "\ngraph graph_1 {"
		end

		rdf_graph.each_statement do |statement|
			
			s = term_name(statement[0])
			o =  term_name(statement[2])

			txt_dot << "\n\"#{s}\"[label=\"#{s}\", color=#{options[:subject_color]}, shape=#{options[:subject_shape]}];"

			if statement[2].literal?
				if options[:is_literal_object_uniq] == true
				  txt_dot << "\n\"#{o}\"[label=\"#{o}\", shape=#{options[:literal_object_shape]}];"
				else

				  txt_dot << "\n#{"\"o"+n.to_s}\"[label=\"#{o}\", shape=#{options[:literal_object_shape]}];"
				  
				  o = "o"+n.to_s
				  n += 1
				end	
			else
				txt_dot << "\n\"#{o}\"[label=\"#{o}\", color=#{options[:object_color]}, shape=#{options[:object_shape]}];"
			end

			txt_dot << "\n\"#{s}\" -> \"#{o}\" [label=\"#{statement[1].pname}\", color=#{options[:predicate_color]}];"
			
		end
		txt_dot << "}"
	end

    private  :term_name

end