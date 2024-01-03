<?php
include 'connection.php';

error_reporting(E_ALL);

// Retrieve the raw POST data
$jsonData = file_get_contents('php://input');

// Decode the JSON data into a PHP associative array
$data = json_decode($jsonData, true);

// Check if decoding was successful and if email is present
if ($data !== null && isset($data['email'])) {
    $email = addslashes(strip_tags($data['email']));
    $password = addslashes(strip_tags($data['password'])); 

    

    // Fetch hashed password from the database
    $emailQuery = "SELECT password FROM users WHERE email = '$email'";
    $result = mysqli_query($conn, $emailQuery);

    if ($result && mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);
        $hashedPasswordFromDB = $row['password'];

        // Verify user-inputted password with the hashed password from the database
        if ($password == $hashedPasswordFromDB) {
            echo json_encode(['exists' => true]); // Email does not exist
        } else {
            echo json_encode(['exists' => false]); // Email does not exist
        }
    } else {
        echo json_encode(['exists' => false]); // Email does not exist
    }

    mysqli_close($conn);
} else {
    // JSON decoding failed or email not provided
    http_response_code(400); // Bad Request
    echo "Invalid data or email not provided";
}