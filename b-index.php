<?php 
//$head = file_get_contents('https://raw.githubusercontent.com/sustance/configs/refs/heads/main/php/head-tilde.php');
//echo $head;
?>
<style>
<?php 
//$head = file_get_contents('https://raw.githubusercontent.com/sustance/configs/refs/heads/main/php/style-pubnix.css');
echo $head;
?>
</style>
    <div class="box">
        <nav>
            <ul>
                <?php
                $files = glob('*.{php,htm}', GLOB_BRACE);
                foreach($files as $file) {
                    $name = pathinfo($file, PATHINFO_FILENAME);
                    echo "<li><a href='$file'>$name</a></li>";
                }
                ?>
            </ul>
        </nav>
   </div>
   
  <div class="content bsd"> 
<?php
$user = 'identity2';
//$os = 'freebsd';

?>
<?php
$code = file_get_contents('https://raw.githubusercontent.com/sustance/configs/refs/heads/main/php/banner.php');
//$code = file_get_contents('banner.php');

if ($code === false) {
    die('Cannot load banners');
}

// Execute the code in isolation and capture the returned value
$banners = eval('?>' . $code); 

if (!is_array($banners)) {
    die('Banner file did not return an array');
}

echo "<pre>" . htmlspecialchars($banners[$user]) . "</pre>";
?>
<p>I travel a lot and often to countries with various limits on internet access. 
I discuss here my digital arrangement and invite helpful enhancement suggestions.</p>         
<p>Philosophy is maximum power with minimal overhead and impact. SMOL web / SMOL internet.</p>
</div>
<br><br><br>
<pre>
# Define ANSI escape codes for various colors and styles
RESET = "\033[0m"
BOLD = "\033[1m"
UNDERLINE = "\033[4m"
BLINK = "\033[5m" # May not work on all terminals

# Foreground colors
BLACK = "\033[30m"
RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
MAGENTA = "\033[35m"
CYAN = "\033[36m"
WHITE = "\033[37m"

# Light foreground colors (often supported as "bright" colors)
LIGHT_RED = "\033[91m"
LIGHT_GREEN = "\033[92m"
LIGHT_YELLOW = "\033[93m"
LIGHT_BLUE = "\033[94m"
LIGHT_MAGENTA = "\033[95m"
LIGHT_CYAN = "\033[96m"
LIGHT_WHITE = "\033[97m"

# Background colors
BG_BLACK = "\033[40m"
BG_RED = "\033[41m"
BG_GREEN = "\033[42m"
BG_YELLOW = "\033[43m"
BG_BLUE = "\033[44m"
BG_MAGENTA = "\033[45m"
BG_CYAN = "\033[46m"
BG_WHITE = "\033[47m"
</pre>
</body>
</html>
