<!doctype html>
<html>
<head>
  <title></title>

  <script type="text/javascript" src="vis.js"></script>
  <link href="vis.css" rel="stylesheet" type="text/css" />
  <style type="text/css">
    #mynetwork {
      width: 700px;
      height: 500px;
      border: 1px solid lightgray;
    }
  </style>
</head>
<body>

<div id="mynetwork"></div>

<script type="text/javascript">
  // create an array with nodes
  var nodes = new vis.DataSet(

<?php
$dbname = 'mint';
$host = 'localhost';
$dbuser = 'mint';
$dbpass = 'test';

$pdo = new PDO("pgsql:dbname=$dbname;host=$host", $dbuser, $dbpass); 

$stmt = $pdo->query("
	SELECT 
		oid AS id, 
		object_name AS label,
		'box' AS shape,
		CASE schema 
			WHEN 'blue' THEN 'blue' 
			WHEN 'master' THEN 'grey'
		END AS color
	FROM public.entitylist 
	WHERE object_type IN ('VIEW', 'TABLE'); 
");

$row = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($row, JSON_PRETTY_PRINT);

?>
);

  // create an array with edges
  var edges = new vis.DataSet(
<?php

$stmt = $pdo->query('
	SELECT 
		parent_oid AS "from", 
		child_oid AS "to", 
		\'to\' AS arrows
	FROM public.entityrelations; 
');

$row = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($row, JSON_PRETTY_PRINT);

?>
  	);

  // create a network
  var container = document.getElementById('mynetwork');
  var data = {
    nodes: nodes,
    edges: edges
  };
	var options = {
	  height: '90%',
	  layout: {
	    hierarchical: {
	      enabled: true,
	      levelSeparation: 100
	    }
	  },
	  physics: {
	    hierarchicalRepulsion: {
	      nodeDistance: 150
	    }
	  }
	};
  var network = new vis.Network(container, data, options);
</script>


</body>
</html>
