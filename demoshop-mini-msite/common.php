<?php
function str_gettsv($line) {
  return str_getcsv($line, "\t");
}
$products_file = "products.tsv";
$products = array_map('str_gettsv', file($products_file));
array_walk($products, function(&$a) use ($products) {
  $a = array_combine($products[0], $a);
});
array_shift($products); # remove column header
?>
