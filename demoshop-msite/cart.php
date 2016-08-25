<?php
include_once("common.php");

$cartstr = isset($_COOKIE['cart']) ? $_COOKIE['cart'] : '';
$pids = array_filter(array_unique(str_getcsv($cartstr)));
setcookie('cart', implode(',', $pids), time() + (86400 * 30), "/"); // 86400 = 1 day

$pid_list_str = '';
$total_price = 0;
?>

<!DOCTYPE html>
<html>
<head>
<title>Demoshop msite</title>
<style>
body {
    font-family: sans-serif;
    background-color: #white;
}

button {
    height: 40px;
    margin-top: 15px;
}
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
My Cart
<?php echo $cartstr ?>
<table>
<?php
  if (count($pids) <= 0) {
?>
  <tr><td>Nothing in cart!</td></tr>
<?php
  } else {
    foreach($products as $index => $product) {
      if (in_array($product['id'], $pids)) {
        if ($pid_list_str == '') {
          $pid_list_str = sprintf("'%s'", $product['id']);
        } else {
          $pid_list_str = $pid_list_str.sprintf(",'%s'", $product['id']);
        }
        $pieces = explode(' ', $product['price']);
        $pprice = str_replace(",", ".", $pieces[0]);
        $total_price += floatval($pprice);
?>
  <tr>
    <td><img src="<?php echo $product['image_link']?>" width="100" height="100"></td>
    <td>
      <?php echo $product['title'] ?>
      <br><small><b><?php echo $product['price'] ?></b></small>
    </td>
  </tr>
<?php }
    }
  }
?>
</table>
<p><button id="purchaseBtn">Buy Buy Buy!</button></p>
<p><a href="index.php">Back to products</a></p>
</body>
<script>
(function () {
    var viewContentBtn = document.getElementById('viewContentBtn');
    var addToCartBtn = document.getElementById('addToCartBtn');
    var purchaseBtn = document.getElementById('purchaseBtn');
    // Create cookie
    function createCookie(name, value, days) {
        var expires;
        if (days) {
            var date = new Date();
            date.setTime(date.getTime()+(days*24*60*60*1000));
            expires = "; expires="+date.toGMTString();
        }
        else {
            expires = "";
        }
        document.cookie = name+"="+value+expires+"; path=/";
    }

    // Insert Your Facebook Pixel ID below.
    fbq('init', '1430541610583592');
    fbq('track', 'PageView');

    var clickevent = window.ontouchend ? 'touchend' : 'click';
    purchaseBtn.addEventListener(clickevent, function(evt) {
      evt.preventDefault();
      fbq('track', 'Purchase', {
          content_type: 'product',
          content_ids: [<?php echo $pid_list_str ?>],
          value: <?php echo $total_price ?>,
          currency: 'USD'
      });
      createCookie('cart', '', 1);
      setTimeout(function() { window.location.reload(); }, 1000);
      return false;
    });
})();
</script>
</html>
