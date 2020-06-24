
Gem::Specification.new do |s|
	s.name = 'rdf_to_graphviz'
	s.version = '0.0.5'
	s.date = '2017-08-02'
	s.summary = "Generate simple dot graph from RDF::Graph"
	s.description = "Gem translate RDF::Graph to Graphviz Dot format."
	s.authors = ["WiDu"]
	s.email = 'wdulek@gmail.com'
	s.files = ["lib/rdf_to_graphviz.rb"]
	s.homepage = 'https://github.com/widu/rdf_to_graphviz'
	s.license = 'MIT'
	s.add_runtime_dependency "linkeddata"
	s.add_runtime_dependency "sparql"
	s.add_runtime_dependency "ruby-graphviz"
end

