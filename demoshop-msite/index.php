<?php
include_once("common.php");
?>

<!DOCTYPE html>
<html>
<head>
<title>Demoshop msite</title>
<style>
body { font-family: sans-serif; background-color: #white; }
button { height: 40px; margin-top: 15px; }
</style>

<!-- Facebook Pixel Code -->
<script>
!function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?
n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;
n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;
t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,
document,'script','fbevents.js');
</script>
<!-- End Facebook Pixel Code -->
</head>
<body>
<h3>Demoshop msite</h3>
<table>
<?php foreach($products as $index => $product) { ?>
  <tr>
    <td><img src="<?php echo $product['image_link']?>" width="100" height="100"></td>
    <td>
      <?php echo $product['title'] ?>
      <br><small><b><?php echo $product['price'] ?></b></small>
    </td>
    <td><a href="view.php?pid=<?php echo $product['id'] ?>">View</a></td>
  </tr>
<?php } ?>
</table>
</body>
<script>
(function () {
    var viewContentBtn = document.getElementById('viewContentBtn');
    var addToCartBtn = document.getElementById('addToCartBtn');
    var purchaseBtn = document.getElementById('purchaseBtn');

    // Insert Your Facebook Pixel ID below.
    fbq('init', '1430541610583592');
    fbq('track', 'PageView');
})();
</script>
</html>
