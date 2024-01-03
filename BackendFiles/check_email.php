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

    

    // Check if email exists in the database
    $emailQuery = "SELECT * FROM users WHERE email = '$email'";
    $emailResult = mysqli_query($conn, $emailQuery);

    if ($emailResult) {
        if (mysqli_num_rows($emailResult) > 0) {
            echo json_encode(['exists' => true]); // Email exists
        } else {
            echo json_encode(['exists' => false]); // Email does not exist
        }
    } else {
        echo "Query Error: " . mysqli_error($conn); // Print SQL query error, if any
    }

    mysqli_close($conn);
} else {
    // JSON decoding failed or email not provided
    http_response_code(400); // Bad Request
    echo "Invalid data or email not provided";
}


