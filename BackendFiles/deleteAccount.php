<?php
include 'connection.php';

header('Content-Type: application/json');



$userEmail = $conn->real_escape_string($_POST['email']); // Sanitize input to prevent SQL injection

$sqlRatings = "DELETE FROM rating WHERE rateduser_email = '$userEmail' OR ratinguser_email = '$userEmail'";
$conn->query($sqlRatings); // Execute query - handle errors if any

$sqlPosts = "DELETE FROM post WHERE user_email = '$userEmail'";
$conn->query($sqlPosts); // Execute query - handle errors if any

$sqlAccount = "DELETE FROM users WHERE email = '$userEmail'";
if ($conn->query($sqlAccount) === TRUE) {
    $response = array(
        'success' => true,
        'message' => 'User account and associated data deleted successfully'
    );
    echo json_encode($response);
} else {
    $response = array(
        'success' => false,
        'message' => 'Error deleting user account: ' . $conn->error
    );
    echo json_encode($response);
}

$conn->close();
?>
