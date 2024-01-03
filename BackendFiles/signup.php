<?php
include 'connection.php';

// Retrieve the raw POST data

$jsonData= file_get_contents('php://input');

// Decode the JSON data into a PHP associative array

$data=json_decode($jsonData, true);

// Check if decoding was successful

if ($data !== null) {


        $username=addslashes(strip_tags($data['username'])); 
        
       $email=addslashes(strip_tags($data['email'])); 
       
       $password=addslashes(strip_tags($data['password'])); 



$sql="insert into users set username='$username', email = '$email', password ='$password'";

mysqli_query($con, $sql) or

    die ("can't add record");

echo "Account Created";

mysqli_close($con);

} else {

// JSON decoding failed

http_response_code(400); // Bad Request

echo "Invalid JSON data";
}