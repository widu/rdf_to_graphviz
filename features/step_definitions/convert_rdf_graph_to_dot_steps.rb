require 'rdf_to_graphviz'
Given(/^the rdf_graph: "([^"]*)"$/) do |arg1|
  @rdf_graph = RDF::Graph.load(arg1)
  @options = {}
end

When(/^the rdf_graph_to_dot is run$/) do
  konwerter = RdfToGraphviz.new
  @output = konwerter.rdf_graph_to_dot(@rdf_graph, @options)
end

Then(/^the output should contain "([^"]*)"$/) do |arg1|
  expect(@output).to include(arg1)
  puts @output
end

Given(/^the option :is_literal_object_uniq is true$/) do
   @options = {:is_literal_object_uniq => false}
end


When(/^the build_atr is run$/) do
  konwerter = RdfToGraphviz.new
  @output = konwerter.build_atr(@rdf_graph)
  puts @output
end

Then(/^the output is hash and should contain key "([^"]*)"$/) do |arg1|
  expect(@output).to have_key(arg1)
end

Given(/^the option :presentation_attr is "([^"]*)"$/) do |arg1|
	rdf_graph = RDF::Graph.load(arg1)
	@options = {:presentation_attr => rdf_graph}
end

When(/^the save_rdf_graph_as is run$/) do
	konwerter = RdfToGraphviz.new
	konwerter.save_rdf_graph_as(@rdf_graph, @options)
end

Then(/^the file "([^"]*)" is created$/) do |arg1|
  puts "OK"
end