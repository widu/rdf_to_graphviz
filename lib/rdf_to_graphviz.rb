# Require 'linkeddata' gem
require 'linkeddata'

# Require 'sparql' gem
require 'sparql'

# Require 'ruby-graphviz' gem
require 'ruby-graphviz'


# @note  The most advance example is show in scenrio 3. The most advance example is shown in scenario 3. The different gem (project) will address the question: how automatically generate graphviz attr file by rules.
# @example scenario 1: Generates Graphviz graph from rdf_graph and save to png files (default files name: "res_graph.png")
#    require 'rdf_to_graphviz'
#    konwerter = RdfToGraphviz.new
#    queryable = RDF::Graph.load("http://ruby-rdf.github.com/rdf/etc/doap.nt")  
#    konwerter.save_rdf_graph_as(queryable, :is_literal_object_uniq => false) # literal objcects aren't unig
# @example scenario 2: Generates dot string from rdf_graph (default options). The same result like in 1 scenario.  
#    require 'rdf_to_graphviz'
#    konwerter = RdfToGraphviz.new
#    queryable = RDF::Graph.load("http://ruby-rdf.github.com/rdf/etc/doap.nt")  
#    str = konwerter.rdf_graph_to_dot(queryable)
#    GraphViz.parse_string(str).output( :png => "res_graph.png" )
# @example scenario 3: Generate Graphviz graph from rdf graph and save to png files using attributes defining in another rdf file
#    require 'rdf_to_graphviz'
#    konwerter = RdfToGraphviz.new
#    queryable = RDF::Graph.load("./ttl/test1.ttl") 
#    rdf_presentation_attr = = RDF::Graph.load("./ttl/grvz.ttl") # reads rdf which contain attr definitions from turtle file
#    options = {:presentation_attr => rdf_presentation_attr}
#    konwerter.save_rdf_graph_as(queryable, options)

class RdfToGraphviz

	def initialize
		
		@atr = {}
	end

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
	# Build graph object from rdf_graph
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
	def build_graph(rdf_graph, options = {})
		options[:graph_type] ||= :digraph
		options[:subject_shape] ||= "doublecircle"
		options[:object_shape] ||= "circle"
		options[:literal_object_shape] ||= "rectangle"
		options[:subject_color] ||= "red"
		options[:object_color] ||= "blue"
		options[:predicate_color] ||= "black"
		options[:is_literal_object_uniq] = true if options[:is_literal_object_uniq].nil?
		nodes = []
		n=0
		graph = GraphViz.new( :G, :type => options[:graph_type] )
		rdf_graph.each_statement do |statement|
			if @atr[term_name(statement[0])]
				s = graph.add_nodes( term_name(statement[0]), @atr[term_name(statement[0])])
			else
				s = graph.add_nodes( term_name(statement[0]), {:shape => options[:subject_shape], :color => options[:subject_color] })
			end
			nodes << term_name(statement[0])
			
			if statement[2].literal? then
				if options[:is_literal_object_uniq] == true
  				  o = graph.add_nodes( statement[2].to_s, {:shape => options[:literal_object_shape]})
  				else
  				  o = graph.add_nodes( "o"+n.to_s, {:label => statement[2].to_s, :shape => options[:literal_object_shape]})
  				  n += 1
  				end  
  			else
  				if @atr[term_name(statement[2])]
  					o = graph.add_nodes( term_name(statement[2]), @atr[term_name(statement[2])])
  				else
  					o = graph.add_nodes( term_name(statement[2]), {:shape => options[:object_shape], :color => options[:object_color]}) 
  				end
  			end	
  			# Create an edge between the two nodes
  			if @atr[statement[1].pname]
  				graph.add_edges( s, o, @atr[statement[1].pname] )
  			else
				graph.add_edges( s, o, {:label => statement[1].pname, :color => options[:predicate_color] } )
			end
		end
		nodes.each do |nd|
			if @atr[nd]
				graph.add_nodes( nd, @atr[nd])
			else
				graph.add_nodes( nd, {:shape => options[:subject_shape], :color => options[:subject_color] })
			end	
		end
		# graph.output( :png => "res_graph.png" )
		graph
	end

	def build_atr(rdf_graph)
		
		atr_lok = {}
		rdf_graph.each_statement do |statement|
			p = statement[1].pname
			# puts p
			indx = p.index("grvz#")

			if indx
			  p1 = p[indx+5..-1].downcase
			
			  obj = term_name(statement[0])
			# puts obj
			# puts p
			  st= statement[2].to_s
			  atr_lok = @atr[obj]
			  if atr_lok == nil then
				atr_lok = {p1 => st}
			  else
				atr_lok[p1] = st
			  end
			#puts atr_lok
			  @atr[obj] = atr_lok	
			end
		end
		@atr
		
	end




	# Generates string containing definition of graph in dot format from RDF::Graph
	# @note This method should only be used in outer space.
	# @param  [RDF::Graph]             rdf_graph                
	# @param  [Hash{Symbol => Object}] options
	# @option options [TrueClass]  :digraph                  (true)- if true, graph has a direction
	# @option options [String]     :subject_shape            ("doublecircle")
	# @option options [String]     :object_shape             ("circle")
	# @option options [String]     :literal_object_shape     ("rectangle")
	# @option options [String]     :subject_color            ("red")
	# @option options [String]     :object_color             ("blue")
	# @option options [String]     :predicate_color          ("black")
	# @option options [TrueClass]  :is_literal_object_uniq   (true)
	# @option options [RDF::Graph] :presentation_attr
	# @return [String] - contain representation of RDF::Graph in Graphviz dot 
	def rdf_graph_to_dot(rdf_graph, options = {})
		if options[:presentation_attr]
			build_atr(options[:presentation_attr])
		end
		build_graph(rdf_graph, options).to_s
	end


	
	# Saves RDF::Graph as png file or different format
	#
	# @param  [RDF::Graph]             rdf_graph                
	# @param  [Hash{Symbol => Object}] options
	# @option options [TrueClass]  :digraph                  (true)- if true, graph has a direction
	# @option options [String]     :subject_shape            ("doublecircle")
	# @option options [String]     :object_shape             ("circle")
	# @option options [String]     :literal_object_shape     ("rectangle")
	# @option options [String]     :subject_color            ("red")
	# @option options [String]     :object_color             ("blue")
	# @option options [String]     :predicate_color          ("black")
	# @option options [TrueClass]  :is_literal_object_uniq   (true)
	# @option options [RDF::Graph] :presentation_attr
	# @option options [String]     :format                   (:png)
	# @option options [String]     :file_name                ("res_graph.png")
	# @return [nil]
    #
	def save_rdf_graph_as(rdf_graph, options = {})
		options[:format] ||= :png
		options[:file_name] ||= "res_graph.png"
		if options[:presentation_attr]
			build_atr(options[:presentation_attr])
		end
		g = build_graph(rdf_graph, options)
		g.output( options[:format] => options[:file_name] )
	end



    private  :term_name, :build_graph, :build_atr

end