<?php
include_once("common.php");
$pid = $_GET['pid'];
$p = null;
foreach($products as $product) {
  if ($product['id'] == $pid) {
    $p = $product;
    break;
  }
}
$pieces = explode(' ', $p['title']);
$last_word = array_pop($pieces);
$pcatalog = $last_word;

$pieces = explode(' ', $p['price']);
$pprice = str_replace(",", ".", $pieces[0]);

$cartstr = isset($_COOKIE['cart']) ? $_COOKIE['cart'] : '';
$pids = array_filter(array_unique(str_getcsv($cartstr)));
$cart_number = (count($pids) <= 0) ? '' : sprintf('(%d)', count($pids));
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
<div><img src="<?php echo $p['image_link']?>" width="100%"></div>
<h4><?php echo $p['title'] ?></h4>
<p><?php echo $p['description'] ?></p>
<p><b><?php echo $p['price'] ?></b></p>
<p><button id="addToCartBtn">Add To Cart</button></p>
<p><a href="cart.php">View Cart<?php echo $cart_number ?></a> | <a href="index.php">Back to products</a></p>
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
    // Read cookie
    function readCookie(name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for(var i=0;i < ca.length;i++) {
            var c = ca[i];
            while (c.charAt(0) === ' ') {
                c = c.substring(1,c.length);
            }
            if (c.indexOf(nameEQ) === 0) {
                return c.substring(nameEQ.length,c.length);
            }
        }
        return null;
    }


    // Insert Your Facebook Pixel ID below.
    fbq('init', '1430541610583592');
    fbq('track', 'PageView');

    fbq('track', 'ViewContent', {
        content_type: 'product',
        content_ids: ['<?php echo $p['id']?>'],
        content_name: '<?php echo $p['title']?>',
        content_category: '<?php echo $pcatalog ?>',
        value: <?php echo $pprice?>,
        currency: 'USD'
    });

    var clickevent = window.ontouchend ? 'touchend' : 'click';
    addToCartBtn.addEventListener(clickevent, function(evt) {
      evt.preventDefault();
      fbq('track', 'AddToCart', {
        content_type: 'product',
        content_ids: ['<?php echo $p['id']?>']
      });
      var cart = readCookie('cart');
      createCookie(
        'cart',
        (cart == null || cart == '') ? '<?php echo $p['id'] ?>' : cart + ',<?php echo $p['id'] ?>',
        1
      );
      setTimeout(function() { window.location.reload(); }, 1000);
      return false;
    });
})();
</script>
</html>
