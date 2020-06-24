Feature: Build dot_graph attributes from rtf_graph

  Scenario: Test file 1 - run private method
    Given the rdf_graph: "./ttl/grvz.ttl"	
    When the build_atr is run
    Then the output is hash and should contain key "http://widu.pl/moje#hasCodeUnit"