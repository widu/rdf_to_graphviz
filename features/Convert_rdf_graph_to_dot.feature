Feature: Convert rdf_graph to dot

  Scenario: Default options
    Given the rdf_graph: "./ttl/RulesToGraphviz.ttl"	
    When the rdf_graph_to_dot is run
    Then the output should contain "http://widu.pl/moje#BMMGraphvizEdgeAtr"

  Scenario: Option :is_literal_object_uniq set to true
  	Given the rdf_graph: "./ttl/RulesToGraphviz.ttl"
  	And the option :is_literal_object_uniq is true
  	When the rdf_graph_to_dot is run
  	Then the output should contain "o1"

  Scenario: :presentation_attr option is set
  	Given the rdf_graph: "./ttl/test1.ttl"
  	And the option :presentation_attr is "./ttl/grvz.ttl"
  	When the rdf_graph_to_dot is run
  	Then the output should contain "yellow"

  Scenario: Convert and save to png files
    Given the rdf_graph: "./ttl/test1.ttl"
    And the option :presentation_attr is "./ttl/grvz.ttl"
    When the save_rdf_graph_as is run
    Then the file "x" is created