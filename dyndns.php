<?
// Simple custom dyndns script
//
// This script lets you run a similiar functionality to an own dns service.
// Once you hosted the script your router needs to access it with the right parameters. 
// The script then saves the ip of the router to a file, to which you are redirected if you make a normal request to the script.
//
// Setup
// 1. You need to host the script on your server just like any other php application.
// 2. Manually create the $ip_file.
// 3. You need to setup your router. For FritzBox! do the following:
//   1. Visit the DynDNS settings
//   2. Check "Custom" as DynDNS Provider
//   3. For "Update-URL", set the url to your service and append the relevant parameters with the values set to the FritzBox! variables. For example:
//      http://your.url/index.php?password=<pass>&ip=<ipaddr>
//   4. Setup "Domainname" and "Password". This script does not make use of the "Username", but you can easily add it yourself.
//   5. Edit the $password variable below to match the password that you have set in your router.
// 4. Your router now makes requests to the "Update-URL" as you have set. This will result in the file $ip_file beeing written on your server, 
//    containing the current IPv4 adress of your router.
// 5. When you visit your service in the browser (without passing the relevant parameters), the ip is read and you will be redirected to it.

    // Variables
    $password = 'SET_YOUR_PASSWORD_HERE';
    $ip_file = "saved_ip.txt";
    $sent_password = $_GET["password"];
    $ip = $_GET["ip"];

    // ip file exists
    if (file_exists($ip_file)) {
        // password and ip are sent as parameters -> we assume the router is making a request
        if (isset($sent_password) && isset($ip)) {
            if ($sent_password == $password) {
                // password is correct. Save the ip
                $file_handle = fopen("$ip_file", "w");
                fwrite($file_handle, $ip);
                fclose($file_handle);
            } else {
                // wrong password. respond with 401
                header("HTTP/1.1 401 Unauthorized");
                exit;
            }
        } else {
            // normal user request: we want to redirect
            //
            // open the ip_file
            $file_handle = fopen("$ip_file", "r+");
            // read the ip address
            $saved_ip = fread($file_handle, filesize($ip_file));
            fclose($file_handle);
            $url = "http://" . $saved_ip . "";
            // redirect to the ip
            header("Location: $url");
        }
    }
