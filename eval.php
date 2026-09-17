<?php
/**
 * Server Dynamic Execution Capability Tester
 * Tests all possible methods for dynamic PHP execution from external sources
 */

class DynamicExecutionTester {
    private $test_url = "https://raw.githubusercontent.com/sustance/configs/refs/heads/main/php/iii.html";
    private $available_methods = [];
    
    public function __construct() {
        // Create a simple test PHP content
        $this->test_content = '<?php echo "DYNAMIC_SUCCESS_" . md5("test"); ?>';
        $this->expected_output = "DYNAMIC_SUCCESS_" . md5("test");
    }
    
    public function testAllMethods() {
        $methods = [
            'file_get_contents_direct' => [$this, 'testFileGetContentsDirect'],
            'file_get_contents_eval' => [$this, 'testFileGetContentsEval'],
            'file_get_contents_tempfile' => [$this, 'testFileGetContentsTempFile'],
            'curl_direct' => [$this, 'testCurlDirect'],
            'curl_eval' => [$this, 'testCurlEval'],
            'curl_tempfile' => [$this, 'testCurlTempFile'],
            'include_http' => [$this, 'testIncludeHttp'],
            'fopen_remote' => [$this, 'testFopenRemote'],
            'allow_url_fopen' => [$this, 'testAllowUrlFopen'],
            'allow_url_include' => [$this, 'testAllowUrlInclude'],
            'curl_extension' => [$this, 'testCurlExtension'],
            'write_permissions' => [$this, 'testWritePermissions']
        ];
        
        foreach ($methods as $name => $method) {
            $this->testMethod($name, $method);
        }
        
        return $this->available_methods;
    }
    
    private function testMethod($name, $method) {
        try {
            $result = call_user_func($method);
            if ($result) {
                $this->available_methods[$name] = $result;
            }
        } catch (Exception $e) {
            // Method failed, skip it
        }
    }
    
    // Test direct file_get_contents with eval
    private function testFileGetContentsDirect() {
        if (!ini_get('allow_url_fopen')) return false;
        
        $content = @file_get_contents($this->test_url);
        if ($content === false) return false;
        
        ob_start();
        eval('?>' . $content);
        $output = ob_get_clean();
        
        return $output === $this->expected_output ? 'SUCCESS' : 'FAILED_WRONG_OUTPUT';
    }
    
    // Test file_get_contents with eval on code
    private function testFileGetContentsEval() {
        if (!ini_get('allow_url_fopen')) return false;
        
        $content = @file_get_contents($this->test_url);
        if ($content === false) return false;
        
        // Extract PHP code between tags
        if (preg_match('/<\?php(.*?)\?>/s', $content, $matches)) {
            $code = $matches[1];
        } else {
            $code = $content;
        }
        
        ob_start();
        eval($code);
        $output = ob_get_clean();
        
        return $output === $this->expected_output ? 'SUCCESS' : 'FAILED_WRONG_OUTPUT';
    }
    
    // Test file_get_contents with temp file execution
    private function testFileGetContentsTempFile() {
        if (!ini_get('allow_url_fopen')) return false;
        
        $content = @file_get_contents($this->test_url);
        if ($content === false) return false;
        
        $temp_file = tempnam(sys_get_temp_dir(), 'dynamic_') . '.php';
        if (file_put_contents($temp_file, $content) === false) return false;
        
        ob_start();
        include $temp_file;
        $output = ob_get_clean();
        
        @unlink($temp_file);
        
        return $output === $this->expected_output ? 'SUCCESS' : 'FAILED_WRONG_OUTPUT';
    }
    
    // Test cURL with direct execution
    private function testCurlDirect() {
        if (!function_exists('curl_init')) return false;
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $this->test_url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        $content = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        if ($http_code !== 200 || !$content) return false;
        
        ob_start();
        eval('?>' . $content);
        $output = ob_get_clean();
        
        return $output === $this->expected_output ? 'SUCCESS' : 'FAILED_WRONG_OUTPUT';
    }
    
    // Test cURL with eval
    private function testCurlEval() {
        if (!function_exists('curl_init')) return false;
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $this->test_url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        $content = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        if ($http_code !== 200 || !$content) return false;
        
        if (preg_match('/<\?php(.*?)\?>/s', $content, $matches)) {
            $code = $matches[1];
        } else {
            $code = $content;
        }
        
        ob_start();
        eval($code);
        $output = ob_get_clean();
        
        return $output === $this->expected_output ? 'SUCCESS' : 'FAILED_WRONG_OUTPUT';
    }
    
    // Test cURL with temp file
    private function testCurlTempFile() {
        if (!function_exists('curl_init')) return false;
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $this->test_url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        $content = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        if ($http_code !== 200 || !$content) return false;
        
        $temp_file = tempnam(sys_get_temp_dir(), 'curl_') . '.php';
        if (file_put_contents($temp_file, $content) === false) return false;
        
        ob_start();
        include $temp_file;
        $output = ob_get_clean();
        
        @unlink($temp_file);
        
        return $output === $this->expected_output ? 'SUCCESS' : 'FAILED_WRONG_OUTPUT';
    }
    
    // Test direct HTTP include (rarely works)
    private function testIncludeHttp() {
        if (!ini_get('allow_url_include')) return false;
        
        ob_start();
        $success = @include $this->test_url;
        $output = ob_get_clean();
        
        return ($success && $output === $this->expected_output) ? 'SUCCESS' : 'FAILED';
    }
    
    // Test remote fopen
    private function testFopenRemote() {
        if (!ini_get('allow_url_fopen')) return false;
        
        $handle = @fopen($this->test_url, 'r');
        if (!$handle) return false;
        
        fclose($handle);
        return 'SUCCESS';
    }
    
    // Test allow_url_fopen setting
    private function testAllowUrlFopen() {
        return ini_get('allow_url_fopen') ? 'ENABLED' : 'DISABLED';
    }
    
    // Test allow_url_include setting
    private function testAllowUrlInclude() {
        return ini_get('allow_url_include') ? 'ENABLED' : 'DISABLED';
    }
    
    // Test cURL extension
    private function testCurlExtension() {
        return function_exists('curl_init') ? 'AVAILABLE' : 'MISSING';
    }
    
    // Test write permissions
    private function testWritePermissions() {
        $temp_dir = sys_get_temp_dir();
        $test_file = $temp_dir . '/write_test_' . uniqid() . '.txt';
        
        if (file_put_contents($test_file, 'test') !== false) {
            unlink($test_file);
            return 'WRITABLE';
        }
        
        return 'NOT_WRITABLE';
    }
    
    public function getSummary() {
        $working_methods = array_filter($this->available_methods, function($status) {
            return $status === 'SUCCESS';
        });
        
        if (empty($working_methods)) {
            return 'all_fail';
        }
        
        return [
            'working_methods' => array_keys($working_methods),
            'all_details' => $this->available_methods,
            'recommendation' => $this->getRecommendation($working_methods)
        ];
    }
    
    private function getRecommendation($working_methods) {
        $preference_order = [
            'file_get_contents_tempfile',
            'curl_tempfile', 
            'file_get_contents_direct',
            'curl_direct',
            'file_get_contents_eval',
            'curl_eval',
            'include_http'
        ];
        
        foreach ($preference_order as $method) {
            if (isset($working_methods[$method])) {
                return "Use method: $method";
            }
        }
        
        return "No dynamic methods available - use cron fallback";
    }
}

// Create test file content for GitHub
function generateTestFile() {
    return '<?php echo "DYNAMIC_SUCCESS_" . md5("test"); ?>';
}

// Execute tests
header('Content-Type: text/plain; charset=utf-8');
echo "Dynamic Execution Capability Test\n";
echo "=================================\n\n";

$tester = new DynamicExecutionTester();
$methods = $tester->testAllMethods();
$summary = $tester->getSummary();

echo "Test Results:\n";
echo "-------------\n";
foreach ($methods as $method => $status) {
    echo str_pad($method, 25) . ": " . $status . "\n";
}

echo "\nSummary:\n";
echo "--------\n";
if ($summary === 'all_fail') {
    echo "ALL_DYNAMIC_METHODS_FAIL - Use cron fallback\n";
} else {
    echo "Working methods: " . implode(', ', $summary['working_methods']) . "\n";
    echo "Recommendation: " . $summary['recommendation'] . "\n";
    
    echo "\nSample code for recommended method:\n";
    echo generateSampleCode($summary['working_methods'][0]);
}

function generateSampleCode($method) {
    $github_url = "https://raw.githubusercontent.com/yourusername/yourrepo/main/yourfile.php";
    
    switch ($method) {
        case 'file_get_contents_tempfile':
            return <<<CODE
<?php
// file_get_contents + temp file method
\$code = file_get_contents('$github_url');
if (\$code !== false) {
    \$temp_file = tempnam(sys_get_temp_dir(), 'dynamic_') . '.php';
    file_put_contents(\$temp_file, \$code);
    include \$temp_file;
    unlink(\$temp_file);
}
?>
CODE;

        case 'curl_tempfile':
            return <<<CODE
<?php
// cURL + temp file method  
\$ch = curl_init();
curl_setopt(\$ch, CURLOPT_URL, '$github_url');
curl_setopt(\$ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt(\$ch, CURLOPT_FOLLOWLOCATION, true);
\$code = curl_exec(\$ch);
curl_close(\$ch);

if (\$code) {
    \$temp_file = tempnam(sys_get_temp_dir(), 'curl_') . '.php';
    file_put_contents(\$temp_file, \$code);
    include \$temp_file;
    unlink(\$temp_file);
}
?>
CODE;

        case 'file_get_contents_direct':
            return <<<CODE
<?php
// file_get_contents + direct eval
\$code = file_get_contents('$github_url');
if (\$code !== false) {
    eval('?>' . \$code);
}
?>
CODE;

        default:
            return "Method code template not available for: $method";
    }
}
?>
