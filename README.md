# orderBy operator

##### Description

Order data according to row- or column-wise metrics.

##### Usage

Input projection|.
---|---
`row`        | rows to order 
`column`        | columns to order
`y-axis`        | numeric, input data, per cell 

Input parameters|.
---|---
`decreasing`   | boolean, whether the order is ascending (default) or descending
`function`  | character, function to apply to each row/column

Output relations|.
---|---
`rorder`        | numeric, row order (rank)
`corder`        | numeric, column order (rank)

