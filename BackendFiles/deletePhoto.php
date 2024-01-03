<?php
include 'connection.php';


// Fetch the URL parameter sent from the Flutter app
$photoUrl = $_POST['photoUrl']; // Assuming the URL is passed via POST

// Prepare a SQL query to delete the photo based on the URL
$sql = "DELETE FROM post WHERE image = '$photoUrl'";

// Execute the query
if ($conn->query($sql) === TRUE) {
    // If deletion was successful, return a success message
    echo "Photo deleted successfully";
} else {
    // If there was an error during deletion, return an error message
    echo "Error deleting photo: " . $conn->error;
}

// Close the database connection
$conn->close();
?>