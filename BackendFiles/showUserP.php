<?php
include 'connection.php';


// Fetch photos based on the provided email
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST['email'];

    // Prepared statement to prevent SQL injection
    $stmt = $conn->prepare("SELECT image FROM post WHERE user_email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $photos = array();

        // Fetch each row and store photo URLs in an array
        while ($row = $result->fetch_assoc()) {
            $photos[] = $row['image']; // Assuming 'image' is the column name for photo URLs
        }

        // Return the array of photo URLs as a JSON response
        header('Content-Type: application/json');
        echo json_encode($photos);
    } else {
        echo json_encode(["message" => "No photos found for the provided email."]);
    }
} else {
    echo json_encode(["message" => "Invalid request method."]);
}

$conn->close();
?>
