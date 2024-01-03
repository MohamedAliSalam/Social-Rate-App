<?php
include 'connection.php';

header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");
header('Content-Type: application/json');

// Check if the email parameter exists and is not empty
if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['email']) && !empty($_GET['email'])) {
    $email = $_GET['email'];


    // Prepare and execute SQL statement with parameterized query to prevent SQL injection
    $sql = "SELECT username, rating, 
            (SELECT COUNT(*) FROM rating WHERE rateduser_email = ?) AS num_ratings 
            FROM users 
            WHERE email = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $email, $email);
    $stmt->execute();
    $result = $stmt->get_result();

    // Fetch user data
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $userData = array(
            'username' => $row['username'],
            'rating' => $row['rating'],
            'num_ratings' => $row['num_ratings']
        );
        // Return user data as JSON
        echo json_encode($userData);
    } else {
        // If user with the provided email doesn't exist
        http_response_code(404);
        echo json_encode(array('message' => 'User not found'));
    }

    // Close the database connection and statement
    $stmt->close();
    $conn->close();
} else {
    // If email parameter is not provided or empty
    http_response_code(400);
    echo json_encode(array('message' => 'Invalid request'));
}
?>
