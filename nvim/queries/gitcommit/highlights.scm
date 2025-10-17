; Capture all nodes that start with semicolon as comments
((_) @comment
 (#match? @comment "^;.*"))
